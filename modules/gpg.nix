{ pkgs, ... }: {
  home.packages = [ pkgs.pinentry ];
  programs.gpg.enable = true;

  # might require reloading the agent:
  #  gpg-connect-agent reloadagent /bye
  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry}/bin/pinentry
    default-cache-ttl 432000
    max-cache-ttl 432000
  '';
}
