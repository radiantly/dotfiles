# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr
#

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

printf "$(hostname) up since $(date -d "$(</proc/uptime awk '{print $1}') seconds ago" "+%A, %b %d %I:%M%p.")\n"

# Snippet taken from https://gist.github.com/nl5887/a511f172d3fb3cd0e42d
# Enclosing functions in { } vs ( ). The latter runs the function in a subshell (which is not really needed).
# More info at: https://stackoverflow.com/questions/27801932/bash-functions-enclosing-the-body-in-braces-vs-parentheses
transfer() {
    if [[ "$#" == 0 ]]
    then
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    sendFile() {
        # -w https://stackoverflow.com/questions/29497038/why-does-a-curl-request-return-a-percent-sign-with-every-request-in-zsh
        curl --progress-bar -w '\n' --upload-file "$1" "https://transfer.sh/$2" 
    }


    # upload stdin or file
    file=$1

    if tty -s;
    then
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

        if [ ! -e $file ];
        then
            echo "File $file does not exist."
            return 1
        fi

        if [ -d $file ];
        then
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
        sendFile $zipfile "$basefile.zip"
            rm -f $zipfile
        else
        sendFile $file $basefile
        fi
    else
    sendFile "-" $file
    fi
}

# A few aliases for tmux ^_^
alias tmux='tmux -u'
alias ta='tmux attach-session -t' 

# Makes `ip a` more colorful!
ip() {
    if [[ "$@" == "a" ]]; then
        command ip -c a
    else
        command ip "$@"
    fi
}

# Let's make git more keyboard-friendly
alias ga='git add'
alias gst='git status'
alias gss='git status -s'
alias gp='git push'
alias gcl='git clone'
alias gcm='git checkout master'
alias gl='git log'
alias glo='git log --oneline'

# gc: Intellegent support for git commit/checkout
# Supported commit flags: -a, -m. Checkout: -b
gc() {
    args=("$@")
    commit=false
    checkout=false

    while getopts ":am:b" opt; do
        case $opt in
            a|m)
                commit=true
                ;;
            b)
                checkout=true
                ;;
            \?)
                echo "Unknown flags passed."
                return 1
                ;;
        esac
    done

    shift "$((OPTIND-1))"

    # = vs == -> They're synonymous!
    if [[ "$#" == 0 ]]; then
        commit=true
    elif [[ "$#" == 1 ]]; then
        checkout=true
    else
        echo "Too many arguments"
        return 1
    fi

    if [[ $commit == true && $checkout == true ]]; then
        echo "Unable to ascertain which operation you would like to perform."
        return 1
    elif [[ $commit == true ]]; then
        git commit "${args[@]}"
    elif [[ $checkout == true ]]; then
        git checkout "${args[@]}"
    else
        echo "Undefined behavior"
        return 1
    fi
}

c() {
    if [[ "$#" == 0 ]]; then
        if [[ "$PWD" == "$HOME/Documents/c" ]]; then
            c "$(ls *.* | fzf --preview 'bat --color=always {}' )"
        else
            cd ~/Documents/c
        fi
    elif [[ "$1" == "c" ]]; then
        cd ~/Documents/c
        code .
    elif [[ "$1" == "s" ]]; then
        cd ~/Documents/c
        subl .
    elif [[ "$1" == *".c" ]]; then
        inFile="$1"
        outFile="${1:0:-2}"
        shift
        echo "$inFile" | entr /usr/bin/zsh -c 'gcc "$1" -g -o "$2" -lm && echo "\nRunning $1:" && ./"$2" "${@:3}"' -- "$inFile" "$outFile" "$@"
    elif [[ "$1" == *".cpp" ]]; then
        inFile="$1"
        outFile="${1:0:-4}"
        shift
        echo "$inFile" | entr /usr/bin/zsh -c 'g++ "$1" -g -o "$2" && echo "\nRunning $1:" && ./"$2" "${@:3}"' -- "$inFile" "$outFile" "$@"
    elif [[ "$1" == *".py" ]]; then
        echo "$1" | entr python3 "$1"
    fi
}

getcolorundercursor() {
    gnome-screenshot -f /tmp/screenie.png
    eval $(xdotool getmouselocation --shell | head -n2)
    convert /tmp/screenie.png -depth 8 -alpha off -crop 1x1+$X+$Y txt:- | tee /dev/tty | grep -om1 '#\w\+' | xclip -selection c
}
