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
      ctrl-alt-cmd-shift-h = open "Todoist.app";
      ctrl-alt-cmd-shift-j = open "Mail.app";
      ctrl-alt-cmd-shift-k = open "Calendar.app";

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

      # more ergonomic, alt is on the left
      alt-6 = "workspace 1";
      alt-7 = "workspace 2";
      alt-8 = "workspace 3";
      alt-9 = "workspace 4";
      alt-0 = "workspace 5";

      alt-shift-6 = "move-node-to-workspace 1";
      alt-shift-7 = "move-node-to-workspace 2";
      alt-shift-8 = "move-node-to-workspace 3";
      alt-shift-9 = "move-node-to-workspace 4";
      alt-shift-0 = "move-node-to-workspace 5";

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

    # $ aerospace list-apps
    on-window-detected = [
      {
        run = "move-node-to-workspace 2";
        check-further-callbacks = true;
      }
      {
        "if".app-id = "com.apple.Safari";
        run = "move-node-to-workspace 1";
      }
      {
        "if".app-id = "com.mitchellh.ghostty";
        run = "move-node-to-workspace 1";
      }
      {
        "if".app-id = "com.apple.Notes";
        run = "move-node-to-workspace 2";
      }
      {
        "if".app-id = "com.apple.mail";
        run = "move-node-to-workspace 3";
      }
      {
        "if".app-id = "com.apple.iCal";
        run = "move-node-to-workspace 3";
      }
      {
        "if".app-id = "com.apple.MobileSMS";
        run = "move-node-to-workspace 4";
      }
      {
        "if".app-id = "ru.keepcoder.Telegram";
        run = "move-node-to-workspace 4";
      }
      {
        "if".app-id = "com.hnc.Discord";
        run = "move-node-to-workspace 4";
      }
      {
        "if".app-id = "net.whatsapp.WhatsApp";
        run = "move-node-to-workspace 4";
      }
      {
        "if".app-id = "com.apple.Music";
        run = "move-node-to-workspace 5";
      }
    ];
  };
}
