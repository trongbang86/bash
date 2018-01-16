
#This simulates one line command to download a file
#from server
function sftp.get() {
    args=( "$@" )
    server="${args[0]}"
    file="${args[1]}"
    sftp $server <<< "get $file"
    #sftp $server
    unset server
    unset file
}

#This simulates one line command to upload a file
#to server
function sftp.put() {
    args=( "$@" )
    server="${args[0]}"
    file="${args[1]}"
    folder="${args[2]}"
    sftp $server:$folder <<< "put $file"
    #sftp $server
    unset folder
    unset server
    unset file
}
