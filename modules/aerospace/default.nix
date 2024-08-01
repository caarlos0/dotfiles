{ config, pkgs, ... }:
let
  aerospaceConfigPath = "${config.xdg.configHome}/aerospace/aerospace.toml";
  toml = pkgs.formats.toml { };

  open = app: "exec-and-forget open -a " + app;
in
{
  home.file."${aerospaceConfigPath}".source = toml.generate "aerospace.toml" {
    # Place a copy of this config to ~/.aerospace.toml
    # After that, you can edit ~/.aerospace.toml to your liking

    # It's not necessary to copy all keys to your config.
    # If the key is missing in your config, "default-config.toml" will serve as a fallback

    # You can use it to add commands that run after login to macOS user session.
    # 'start-at-login' needs to be 'true' for 'after-login-command' to work
    # Available commands: https://nikitabobko.github.io/AeroSpace/commands
    after-login-command = [ ];

    # You can use it to add commands that run after AeroSpace startup.
    # 'after-startup-command' is run after 'after-login-command'
    # Available commands : https://nikitabobko.github.io/AeroSpace/commands
    after-startup-command = [ ];

    # Start AeroSpace at login
    start-at-login = true;

    # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
    enable-normalization-flatten-containers = true;
    enable-normalization-opposite-orientation-for-nested-containers = true;

    # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
    # The 'accordion-padding' specifies the size of accordion padding
    # You can set 0 to disable the padding feature
    accordion-padding = 30;

    # Possible values: tiles|accordion
    default-root-container-layout = "tiles";

    # Possible values: horizontal|vertical|auto
    # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
    #               tall monitor (anything higher than wide) gets vertical orientation
    default-root-container-orientation = "auto";

    # Possible values: (qwerty|dvorak)
    # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
    key-mapping.preset = "qwerty";

    # Mouse follows focus when focused monitor changes
    # Drop it from your config, if you don't like this behavior
    # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
    # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
    on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

    # Gaps between windows (inner-*) and between monitor edges (outer-*).
    # Possible values:
    # - Constant:     gaps.outer.top = 8
    # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
    #                 In this example, 24 is a default value when there is no match.
    #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
    #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
    gaps = {
      inner.horizontal = 0;
      inner.vertical = 0;
      outer.left = 0;
      outer.bottom = 0;
      outer.top = 0;
      outer.right = 0;
    };

    # 'main' binding mode declaration
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    # 'main' binding mode must be always presented
    mode.main.binding = {
      # All possible keys:
      # - Letters.        a, b, c, ..., z
      # - Numbers.        0, 1, 2, ..., 9
      # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
      # - F-keys.         f1, f2, ..., f20
      # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
      #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
      # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
      #                   keypadMinus, keypadMultiply, keypadPlus
      # - Arrows.         left, down, up, right

      # All possible modifiers: cmd, alt, ctrl, shift

      # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

      # You can uncomment this line to open up terminal with alt + enter shortcut
      # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
      # alt-enter = 'exec-and-forget open -n /System/Applications/Utilities/Terminal.app'

      alt-u = open "Ghostty.app";
      alt-i = open "Safari.app";
      alt-o = open "Notes.app";
      alt-p = open "Discord.app";

      # See: https://nikitabobko.github.io/AeroSpace/commands#layout
      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";

      # See: https://nikitabobko.github.io/AeroSpace/commands#focus
      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";

      # See: https://nikitabobko.github.io/AeroSpace/commands#move
      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      # See: https://nikitabobko.github.io/AeroSpace/commands#resize
      alt-shift-minus = "resize smart -50";
      alt-shift-equal = "resize smart +50";

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
      alt-1 = "workspace 1";
      alt-2 = "workspace 2";
      alt-3 = "workspace 3";
      alt-4 = "workspace 4";
      alt-5 = "workspace 5";

      # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
      alt-shift-1 = "move-node-to-workspace 1";
      alt-shift-2 = "move-node-to-workspace 2";
      alt-shift-3 = "move-node-to-workspace 3";
      alt-shift-4 = "move-node-to-workspace 4";
      alt-shift-5 = "move-node-to-workspace 5";

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
      alt-tab = "workspace-back-and-forth";
      # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
      alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      alt-shift-semicolon = "mode service";
    };

    # 'service' binding mode declaration.
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
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
