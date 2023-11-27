{ pkgs, ... }:
let
  sockPath = "/tmp/yubikey-agent.sock";
in
{
  home.packages = with pkgs; [ yubikey-manager ];
  home.sessionVariables.SSH_AUTH_SOCK = sockPath;
  home.activation.yubikey = ''
    $DRY_RUN_CMD ln -sf ${sockPath} $HOME/.ssh/ssh_auth_sock
  '';

  launchd.agents = {
    yubikey-agent = {
      enable = true;
      config = {
        Label = "localhost.yubikey-agent";
        ProgramArguments = [ "${pkgs.yubikey-agent}/bin/yubikey-agent" "-l" sockPath ];
        RunAtLoad = true;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
        EnvironmentVariables = { "LC_CTYPE" = "UTF-8"; };
        inetdCompatibility = { Wait = false; };
      };
    };
  };
}
