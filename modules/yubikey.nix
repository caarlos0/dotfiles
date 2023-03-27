{ pkgs, ... }: {
  home.packages = with pkgs; [
    yubikey-agent
    yubikey-manager
    # yubico-yubikey-manager
  ];
}
