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
transfer() (
    # check arguments
    if [ $# -eq 0 ];
    then
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    sendFile() {
    	# get temporarily filename, output is written to this file show progress can be showed
    	tmpfile=$( mktemp -t transferXXX )

	# -w https://stackoverflow.com/questions/29497038/why-does-a-curl-request-return-a-percent-sign-with-every-request-in-zsh
    	curl --progress-bar -w '\n' --upload-file $1 "https://transfer.sh/"$2 >> $tmpfile

        # cat output link
        cat $tmpfile 

        # cleanup
        rm -f $tmpfile
    }


    # upload stdin or file
    file=$1

    if tty -s;
    then
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
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
)

alias tmux='tmux -u'
alias ta='tmux attach-session -t' 
