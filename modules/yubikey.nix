{ pkgs, ... }:
{
  # TODO: set things up
  home.packages = with pkgs; [
    yubikey-agent
    yubikey-manager
    # yubico-yubikey-manager
  ];

  # TODO: path?
  home.sessionVariables = {
    SSH_AUTH_SOCK = "/tmp/yubikey-agent.sock";
  };
}
