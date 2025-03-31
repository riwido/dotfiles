# from geirha in #bash, in response to someone who wanted to insert git root
# into current line with ^G

_readline_gitroot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return 0

  # output to variable root, escape characters if needed
  printf -v root %q "$root"

  # options are same as declare, -n makes it a namereference (man bash, builtins)
  local -n s=READLINE_LINE i=READLINE_POINT

  # set up named pipe to debug
  # mkfifo outputs
  # while :; do cat outputs; done
  # printf "READLINE_POINT=%d READLINE_LINE=%s\n" $i $s > outputs

  # modify READLINE_LINE in place
  s=${s:0:i}$root/${s:i}

  # modify READLINE_POINT to be at end of input
  (( i += 1 + ${#root} ))
}

bind -x '"\C-g": _readline_gitroot'
