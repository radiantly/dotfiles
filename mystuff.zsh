#!/usr/bin/zsh
# ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

# printf "$(hostname) up since $(date -d "$(</proc/uptime awk '{print $1}') seconds ago" "+%A, %b %d %I:%M%p.")\n"

# Enclosing functions in { } vs ( ). The latter runs the function in a subshell (which is not really needed).
# More info at: https://stackoverflow.com/questions/27801932/bash-functions-enclosing-the-body-in-braces-vs-parentheses
transfer() {
    if [[ "$#" == 0 ]]; then
        if ! tty -s; then
            curl -F 'file=@-' https://0x0.st
        else
            echo "No arguments specified. Usage:\ntransfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
            return 1
        fi
    elif [[ ! -f "$1" ]]; then
        echo "Cannot find file."
        return 1
    else
        curl -F 'file=@'"$1" https://0x0.st
    fi
}

# A few aliases for tmux ^_^
alias tmux='tmux -u'
alias ta='tmux attach-session -t'
alias tl='tmux list-sessions'

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
        subl3 .
    elif [[ "$1" == *".c" ]]; then
        inFile="$1"
        outFile="./out/""${1:0:-2}"
        shift
        echo "$inFile" | entr /usr/bin/zsh -c 'gcc "$1" -g -o "$2" -lm -pthread && echo "\nRunning $1:" && "$2" "${@:3}"' -- "$inFile" "$outFile" "$@"
    elif [[ "$1" == *".kt" ]]; then
        inFile="$1"
        outFile="./out/""${1:0:-3}.jar"
        shift
        echo "$inFile" | entr /usr/bin/zsh -c 'kotlinc "$1" -include-runtime -d "$2" && echo "\nRunning $1:" && java -jar "$2" "${@:3}"' -- "$inFile" "$outFile" "$@"
    elif [[ "$1" == *".cpp" ]]; then
        inFile="$1"
        outFile="./out/""${1:0:-4}"
        shift
        echo "$inFile" | entr /usr/bin/zsh -c 'g++ "$1" -g -o "$2" && echo "\nRunning $1:" && "$2" "${@:3}"' -- "$inFile" "$outFile" "$@"
    elif [[ "$1" == *".py" ]]; then
        echo "$1" | entr python3 "$1"
    fi
}

chef() {
    chefFolder="$HOME"/Documents/c/chef
    # If chef is run without any commands, 
    if [[ "$#" == 0 ]]; then
        # cd into the chef directory,
        cd "$chefFolder"
        # allow the user to choose an existing file, or type in a new file name
        chefFile=$(ls code *.cpp | fzf --print-query --preview 'bat --color=always {}' | tail -n 1)
        if [[ "$chefFile" == "code" ]]; then
            code "$chefFolder"
            return 0
        elif [[ -z "$chefFile" ]]; then
            return 0
        # If the file exists, just open it
        elif [[ -f "$chefFile" ]]; then
            echo "Opening $chefFile"
            subl3 -a "$chefFolder" "$chefFile"
            chef "$chefFile"
        else
            # If filename ends with .k, then copy kickstart template instead
            [[ "$chefFile" == *".k" ]]
            kickstart=$?
            # Get the file name without extensions
            chefFile=$(echo "$chefFile" | cut -f 1 -d '.')
            chefFile+=".cpp"
            # Prompt for confirmation - Ctrl C to cancel
            read -r "?Create $chefFile? [ENTER]"
            if (( kickstart == 0 )); then
                cp template.k.cpp "$chefFile"
            else
                cp template.cpp "$chefFile"
            fi
            subl3 -a "$chefFolder" "$chefFile"
            chef "$chefFile"
        fi
    elif [[ "$1" == *".cpp" ]]; then
        inFile="$1"
        outFile="./out/""${1:0:-4}"

        # We start reading the file from the end. We remove */ and start
        # printing. When /* is encountered, we quit reading the file. Finally,
        # we reverse the reversed comment.
        lastComment='tac "$1" | sed -n -e "s/\*\///" -e "/\/\*/q" -e "p" | tac'

        # This might be the longest line in this file .. This command watches
        # the input cpp file and runs it when it's saved. Apart from that it
        # also pipes input from the last comment to the built exe
        echo "$inFile" | entr /usr/bin/zsh -c 'g++ "$1" -g -o "$2" && echo "\nRunning $1:" && echo $('$lastComment') | "$2" "${@:3}"' -- "$inFile" "$outFile" "$@"
    fi
}

getcolorundercursor() {
    gnome-screenshot -f /tmp/screenie.png
    eval $(xdotool getmouselocation --shell | head -n2)
    convert /tmp/screenie.png -depth 8 -alpha off -crop 1x1+$X+$Y txt:- | tee /dev/tty | grep -om1 '#\w\+' | xclip -selection c
}

# A helper command for quickly getting started with Advent of Code challenges
# Usage: aoc <num>
aoc() {
    # Do not allow accidental overwrites
    set -o noclobber

    # Navigate to the AoC directory
    cd ~/Documents/c/chef/AoC
    if [[ "$#" == 1 ]]; then
        p1="puzzle$1""-p1.py"
        p2="puzzle$1""-p2.py"
        inp="puzzle$1""-input.txt"
        
        # Create puzzle files if they don't exist
        # cp -n template.py "puzzle$1"'-p1.py'
        [[ ! -f "$p1" ]] && sed "s/NUM/$1/" template.py > "$p1"
        touch "$p2"

        # Open with sublime text
        subl3 -a . "$p2" "$p1"

        # If puzzle input file does not exist yet, download it
        if [[ ! -f "$inp" ]]; then
            echo "Downloading input .."
            source session.sh
            curl -fsSL --cookie "session=$AOC_SESSION_COOKIE" -o "$inp" "https://adventofcode.com/2020/day/$1/input" 
        fi
    fi
}

alias p=python
