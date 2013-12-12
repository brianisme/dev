
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias chef-roles='for file in `find roles/ -path "*\.json"`; do knife role from file $file; done'

alias chef-environments='for file in `find environments/ -path "*\.json"`; do knife environment from file $file; done'

function chef-sync () { 
    knife cookbook upload -a
    chef-roles
    chef-environments
    GIT_BRANCH=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    curl -X POST -d "room_id=136881&from=The+Chef&message_format=text&notify=1&color=gray&message=Chef+is+synced+to+$GIT_BRANCH" https://api.hipchat.com/v1/rooms/message?format=json\&auth_token=9cb483964bdc749886f5eca085afcf
}

function deploy_test () {
     knife ssh -x ubuntu "name:*test*" "sudo chef-client" -a ec2.public_hostname
    curl -X POST -d "room_id=136881&from=The+Chef&message_format=text&notify=1&color=gray&message=Test+is+deployed" https://api.hipchat.com/v1/rooms/message?format=json\&auth_token=9cb483964bdc749886f5eca085afcf
	curl -X POST -d "room_id=147063&from=The+Chef&message_format=text&notify=1&color=gray&message=Test+is+deployed" https://api.hipchat.com/v1/rooms/message?format=json\&auth_token=9cb483964bdc749886f5eca085afcf
}

[[ -s /home/ubuntu/.nvm/nvm.sh ]] && . /home/ubuntu/.nvm/nvm.sh # This loads NVM

kssh() {
    IP=`knife node show $1 | grep "IP" | sed 's/IP:          //g'`
    ssh ubuntu@$IP
}

_kssh() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$(knife node list | tr '\n' ' ')
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F _kssh kssh


hubpr() {
     if [ $# -eq 2 ]
	then
     		hub pull-request "$1" -b updtr/frontend:master -h updtr/frontend:$2
	else
		echo 'ERR: need message and branch number'
     fi
}

source ~/.bashrc
export API_ENV=testing
export EDITOR=vim
