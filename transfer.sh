transfer() { 
    # check arguments
    if [ $# -ne 1 ]; 
    then 
        echo -e "Wrong arguments specified. Usage:\ntransfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporary filename, output is written to this file so show progress can be showed
    tmpfile="$( mktemp -t transferXXX )"
    
    # upload stdin or file
    file="$1"

    if tty -s; 
    then 
        basefile="$( basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g' )"

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi
        
        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile="$( mktemp -t transferXXX.zip )"
            cd "$(dirname "$file")" && zip -r -q - "$(basename "$file")" >> "$zipfile"
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> "$tmpfile"
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> "$tmpfile"
        fi
    else 
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> "$tmpfile"
    fi
   
    # cat output link
    cat "$tmpfile"
    echo

    # cleanup
    rm -f "$tmpfile"
}
