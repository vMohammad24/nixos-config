{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
}:

rustPlatform.buildRustPackage {
  pname = "linux-trackpad-driver";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "aaronroquefonseca";
    repo = "linux-trackpad-driver";
    rev = "v0.1.4";
    hash = "sha256-+HkA2a2inXEP3yqFzgzFi8pV4304hGgo++hnF06KMGw=";
  };

  cargoHash = "sha256-J1ed5gZ39KqKnDrG0ecljSXqXEazThzNKyGqMAIAzuk=";

  nativeCheckInputs = [git];

  checkFlags = [
    "--skip=worktree_revision_dirty_and_clean_transitions"
    "--skip=archive_does_not_borrow_parent_repository"
    "--skip=archives_channels_overrides_and_validation"
  ];

  postInstall = ''
    install -Dm644 config/default.toml $out/etc/linux-trackpad-driver/config.toml
    install -Dm644 udev/99-linux-trackpad-driver.rules $out/lib/udev/rules.d/99-linux-trackpad-driver.rules
    install -Dm644 systemd/linux-trackpad-driver.service $out/lib/systemd/system/linux-trackpad-driver.service
    install -Dm644 systemd/linux-trackpad-driver-reconnect@.service $out/lib/systemd/system/linux-trackpad-driver-reconnect@.service
    install -Dm644 systemd/linux-trackpad-driver-resume.service $out/lib/systemd/system/linux-trackpad-driver-resume.service
    install -Dm755 systemd/system-sleep/ltd-resume $out/lib/systemd/system-sleep/ltd-resume
  '';

  meta = {
    description = "Userspace driver for the Apple Magic Trackpad 2";
    homepage = "https://github.com/aaronroquefonseca/linux-trackpad-driver";
    license = with lib.licenses; [mit asl20];
    mainProgram = "ltd";
    platforms = lib.platforms.linux;
  };
}
