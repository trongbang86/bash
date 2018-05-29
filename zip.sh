# this unzips a tar file and opens the extracted folder for checking
# 1) read the file name
# 2) check if it exists
# 3) check if $TMP exists
# 4) unzip
# 5) open folder
# 6) go back to the previous folder
function unzip._command() {
    unzipCommand=$1
    if [ -z "$unzipCommand" ]; then
        echo Please enter unzipCommand
        return 1
    fi

    if [ -f "$unzipCommand" ]; then
        echo Usage: unzip.command 'tar -xzf' 'file.tar.gz'
        return 1
    fi
    # 1)
    echo 'Reading file name'
    file=$2
    CURR=`pwd`
    if [ -z "$file" ]; then
        read -p "Enter a file :" file
    fi
    # 2)
    echo 'Checking file existence'
    if [ ! -f "$file" ]; then
        echo File $file does not exist
        return 1
    fi
    # 3)
    echo 'Checking if $TMP exists'
    if [ -z "$TMP" ]; then
        echo 'Please set $TMP'
        return 1
    fi
    # 4)
    echo 'unzipping'
    fileName=$(basename "$file")
    folder=$TMP/unzip
    if [ -f "$folder" ]; then
        echo "$folder should be a folder"
        return 1
    fi
    rm -rf $folder
    mkdir $folder
    cp $file $folder
    cd $folder
    eval "$unzipCommand $fileName"
    rm $fileName
    # 5)
    echo 'Openning zipped folder'
    open .
    # 6)
    cd $CURR
    unset fileName
    unset folder
    unset CURR
    unset file
    unset unzipCommand
}

# this unzips a tar file
function unzip.tar() {
    unzip._command 'tar -xzf' $1
}

# this unzips a zipped file
function unzip.zip() {
    unzip._command 'unzip -q' $1
}

# this unzips a jar file
function unzip.jar() {
    unzip._command 'jar -xf' $1
}
