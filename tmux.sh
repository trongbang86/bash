# tmxsync: bring all windows as panes into one window and activate the "synchronize-panes" option
# tmxunsync: split all panes into different windows and deactivate the "synchronize-panes" option.

# Licence:
# To the extent possible under law I, Konstantinos Koukopoulos, have waived all copyright and related or neighboring rights to tmxsync.sh, as describe by the CC0 document:
# http://creativecommons.org/publicdomain/zero/1.0/
# This work is published from: Greece.

tm.sync () {
   export _TMUX_SYNC=1;
   for w in $(tmux lsw -F '#{window_index}#{window_active}'|sed -ne 's/0$//p'); do
      tmux joinp -d -b -s $w -v -t $(tmux lsp -F '#{pane_index}'|tail -n 1)
   done
   tmux setw synchronize-panes
}
tm.unsync () {
   [ -z "$_TMUX_SYNC" ] && return
   for p in $(tmux lsp -F '#{pane_index}#{pane_active}' | sed -ne 's/0$//p'); do
      tmux breakp -d -t 1
   done
   unset _TMUX_SYNC
   tmux setw synchronize-panes
}
