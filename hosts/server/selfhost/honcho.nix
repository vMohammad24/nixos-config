{
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.honcho;

  openrouterBase = "https://openrouter.ai/api/v1";
  model = "anthropic/claude-haiku-5.5";

  commonEnv = {
    LOG_LEVEL = "INFO";
    AUTH_USE_AUTH = "true";
    CACHE_ENABLED = "false";
    DB_CONNECTION_URI = "postgresql+psycopg://honcho@127.0.0.1:5432/honcho";
    LLM_OPENAI_BASE_URL = openrouterBase;
    EMBEDDING_MODEL_CONFIG__TRANSPORT = "openai";
    EMBEDDING_MODEL_CONFIG__MODEL = "openai/text-embedding-3-small";
    EMBEDDING_MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    EMBEDDING_MODEL_CONFIG__MAX_BATCH_SIZE = "100";
    DERIVER_MODEL_CONFIG__TRANSPORT = "openai";
    DERIVER_MODEL_CONFIG__MODEL = model;
    DERIVER_MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    SUMMARY_MODEL_CONFIG__TRANSPORT = "openai";
    SUMMARY_MODEL_CONFIG__MODEL = model;
    SUMMARY_MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    DIALECTIC_LEVELS__minimal__MODEL_CONFIG__TRANSPORT = "openai";
    DIALECTIC_LEVELS__minimal__MODEL_CONFIG__MODEL = model;
    DIALECTIC_LEVELS__minimal__MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    DIALECTIC_LEVELS__low__MODEL_CONFIG__TRANSPORT = "openai";
    DIALECTIC_LEVELS__low__MODEL_CONFIG__MODEL = model;
    DIALECTIC_LEVELS__low__MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    DIALECTIC_LEVELS__medium__MODEL_CONFIG__TRANSPORT = "openai";
    DIALECTIC_LEVELS__medium__MODEL_CONFIG__MODEL = model;
    DIALECTIC_LEVELS__medium__MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    DIALECTIC_LEVELS__high__MODEL_CONFIG__TRANSPORT = "openai";
    DIALECTIC_LEVELS__high__MODEL_CONFIG__MODEL = model;
    DIALECTIC_LEVELS__high__MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    DIALECTIC_LEVELS__max__MODEL_CONFIG__TRANSPORT = "openai";
    DIALECTIC_LEVELS__max__MODEL_CONFIG__MODEL = model;
    DIALECTIC_LEVELS__max__MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    DREAM_DEDUCTION_MODEL_CONFIG__TRANSPORT = "openai";
    DREAM_DEDUCTION_MODEL_CONFIG__MODEL = model;
    DREAM_DEDUCTION_MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
    DREAM_INDUCTION_MODEL_CONFIG__TRANSPORT = "openai";
    DREAM_INDUCTION_MODEL_CONFIG__MODEL = model;
    DREAM_INDUCTION_MODEL_CONFIG__OVERRIDES__BASE_URL = openrouterBase;
  };
in {
  options.myConfig.honcho.enable = lib.mkEnableOption "Honcho memory server";

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      extensions = ps: [ps.pgvector];
      authentication = lib.mkBefore ''
        host honcho honcho 127.0.0.1/32 trust
        host honcho honcho ::1/128 trust
      '';
    };

    systemd.services.honcho-db-init = {
      description = "Honcho database init (role, db, pgvector extensions)";
      wantedBy = ["multi-user.target"];
      after = ["postgresql.service"];
      requires = ["postgresql.service"];
      before = ["podman-honcho-api.service" "postgresql-setup.service"];
      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
        RemainAfterExit = true;
      };
      script = let
        psql = "${config.services.postgresql.package}/bin/psql";
      in ''
        set -e
        ${psql} -v ON_ERROR_STOP=1 -d postgres \
          -c "ALTER DATABASE template1 REFRESH COLLATION VERSION" \
          -c "ALTER DATABASE postgres REFRESH COLLATION VERSION"
        ${psql} -v ON_ERROR_STOP=1 -d postgres -tAc \
          "SELECT 1 FROM pg_roles WHERE rolname = 'honcho'" | grep -q 1 ||
          ${psql} -v ON_ERROR_STOP=1 -d postgres -c "CREATE ROLE honcho LOGIN"
        ${psql} -v ON_ERROR_STOP=1 -d postgres -tAc \
          "SELECT 1 FROM pg_database WHERE datname = 'honcho'" | grep -q 1 ||
          ${psql} -v ON_ERROR_STOP=1 -d postgres -c "CREATE DATABASE honcho OWNER honcho"
        ${psql} -v ON_ERROR_STOP=1 -d honcho \
          -c "CREATE EXTENSION IF NOT EXISTS vector" \
          -c "CREATE EXTENSION IF NOT EXISTS pg_trgm" \
          -c "CREATE EXTENSION IF NOT EXISTS btree_gin"
      '';
    };

    virtualisation.podman.enable = true;
    virtualisation.oci-containers = {
      backend = "podman";
      containers.honcho-api = {
        # renovate: docker
        image = "ghcr.io/plastic-labs/honcho@sha256:4c124ffbd6a67d55cb677ecb513bd49bb8f791c6b0a227958b7dfef79f584a5d";
        autoStart = true;
        entrypoint = "/bin/sh";
        cmd = ["/app/docker/entrypoint.sh"];
        environmentFiles = [config.age.secrets.honcho-env.path];
        environment =
          commonEnv
          // {
            API_WORKERS = "1";
          };
        extraOptions = [
          "--network=host"
          "--no-healthcheck"
        ];
      };
      containers.honcho-deriver = {
        # renovate: docker
        image = "ghcr.io/plastic-labs/honcho@sha256:4c124ffbd6a67d55cb677ecb513bd49bb8f791c6b0a227958b7dfef79f584a5d";
        autoStart = true;
        entrypoint = "/app/.venv/bin/python";
        cmd = ["-m" "src.deriver"];
        environmentFiles = [config.age.secrets.honcho-env.path];
        environment =
          commonEnv
          // {
            DERIVER_WORKERS = "2";
            DERIVER_FLUSH_ENABLED = "true";
          };
        extraOptions = [
          "--network=host"
          "--no-healthcheck"
        ];
      };
    };

    systemd.services.podman-honcho-api = {
      after = ["honcho-db-init.service" "postgresql.service"];
      requires = ["honcho-db-init.service" "postgresql.service"];
    };

    systemd.services.podman-honcho-deriver = {
      after = ["podman-honcho-api.service" "honcho-db-init.service"];
      wants = ["podman-honcho-api.service"];
      requires = ["honcho-db-init.service"];
    };
  };
}
