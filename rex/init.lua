rex.action {
  name = "project_picker",
  title = "Switch Project",
  run = function(ctx)
    if not ctx.client_id then error("No Rex client for project picker", 0) end
    local _, err = rex.session.new_layer {
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      focus = true,
      layout = rex.layout.block {
        flavor = "com.superlogical.terminal.shell",
        options = {
          command = { "fish", os.getenv("HOME") .. "/.bin/rex-sessionizer.fish", ctx.client_id },
        },
      },
    }
    if err then error(err, 0) end
  end,
}

rex.bind("cmd+p", "project_picker")
