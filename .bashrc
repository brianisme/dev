YELLOW="\[\e[0;33m\]"
GREEN="\[\e[0;32m\]"
WHITE="\[\e[0;37m\]"
RED="\[\e[0;31m\]"

alias l='ls -lhaG'

function ref(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[\1\]/' || return
}

function sha(){
  git rev-parse --short HEAD 2> /dev/null | sed -e 's/\(.*\)/\[\1\]/' || return
}

function dateOut() {
  date +%H:%M || return
}


PS1="[\$(dateOut)]$YELLOW\$(ref)\$(sha)\[\e[0m\][\w]\$ "

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
