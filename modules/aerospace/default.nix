{ config, pkgs, ... }:
let
  aerospaceConfigPath = "${config.xdg.configHome}/aerospace/aerospace.toml";
  toml = pkgs.formats.toml { };

  open = app: "exec-and-forget open -a " + app;
in
{
  home.file."${aerospaceConfigPath}".source = toml.generate "aerospace.toml" {
    start-at-login = true;
    default-root-container-layout = "tiles";

    accordion-padding = 0;
    gaps = {
      inner.horizontal = 0;
      inner.vertical = 0;
      outer.left = 0;
      outer.bottom = 0;
      outer.top = 0;
      outer.right = 0;
    };

    mode.main.binding = {
      ctrl-alt-cmd-shift-y = open "Music.app";
      ctrl-alt-cmd-shift-u = open "Ghostty.app";
      ctrl-alt-cmd-shift-i = open "Safari.app";
      ctrl-alt-cmd-shift-o = open "Notes.app";
      ctrl-alt-cmd-shift-p = open "Discord.app";

      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";

      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";

      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      alt-shift-minus = "resize smart -50";
      alt-shift-equal = "resize smart +50";

      alt-1 = "workspace 1";
      alt-2 = "workspace 2";
      alt-3 = "workspace 3";
      alt-4 = "workspace 4";
      alt-5 = "workspace 5";

      alt-shift-1 = "move-node-to-workspace 1";
      alt-shift-2 = "move-node-to-workspace 2";
      alt-shift-3 = "move-node-to-workspace 3";
      alt-shift-4 = "move-node-to-workspace 4";
      alt-shift-5 = "move-node-to-workspace 5";

      alt-tab = "workspace-back-and-forth";
      alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
      alt-shift-semicolon = "mode service";
    };

    mode.service.binding = {
      esc = [ "reload-config" "mode main" ];
      r = [ "flatten-workspace-tree" "mode main" ]; # reset layout
      #s = ["layout sticky tiling", "mode main"] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
      f = [ "layout floating tiling" "mode main" ]; # Toggle between floating and tiling layout
      backspace = [ "close-all-windows-but-current" "mode main" ];

      alt-shift-h = [ "join-with left" "mode main" ];
      alt-shift-j = [ "join-with down" "mode main" ];
      alt-shift-k = [ "join-with up" "mode main" ];
      alt-shift-l = [ "join-with right" "mode main" ];
    };
  };
}
