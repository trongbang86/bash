java.add.cert() {
    server=$1
    port=$2
    cert_alias=$3
    [ ! -n "$server" ] && read -p "Enter server(google.com):" server
    [ ! -n "$port" ] && read -p "Enter port:" port
    [ ! -n "$cert_alias" ] && read -p "Enter alias name to be saved in cacert:" cert_alias
    cert_file="/tmp/java.cer"

    echo '1. Setting JAVA_HOME'
    if [ "$JAVA_HOME" == "" ]; then
        export JAVA_HOME=$(/usr/libexec/java_home)
    fi
    echo "JAVA_HOME=$JAVA_HOME"
    echo 2. Getting cert from $server
    openssl s_client -showcerts -connect $server:$port -servername $server </dev/null 2>/dev/null|openssl x509 -outform PEM > $cert_file
    echo 3. Deleting Alias $cert_alias
    ca_file="$JAVA_HOME/jre/lib/security/cacerts"
    sudo keytool -delete -alias $cert_alias -keystore $ca_file -keypass changeit -storepass changeit
    echo '4. Adding Nexus Alias'
    sudo keytool -import -keystore $ca_file -file $cert_file -alias $cert_alias -keypass changeit -storepass changeit -trustcacerts -noprompt
    rm $cert_file
    unset server
    unset port
    unset cert_alias
    unset cert_file
    unset ca_file
}
