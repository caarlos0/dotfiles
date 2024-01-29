vim.cmd([[
  command! -range -nargs=0 ModsExplain :'<,'>w !mods explain this, be very succint
  command! -range -nargs=* ModsRefactor :'<,'>!mods refactor this to improve its readability
  command! -range -nargs=+ Mods :'<,'>w !mods <q-args>
]])
