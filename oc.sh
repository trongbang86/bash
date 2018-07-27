function oc.login() {
    if [ -z "$OS_USERNAME" ]; then
        echo Please set environment variable OS_USERNAME
        return
    fi
    if [ -z "$OS_SERVER" ]; then
        echo Please set environment variable OS_SERVER
        return
    fi
    oc login -u $OS_USERNAME $OS_SERVER
}

# This is to search for pods with a certain name
function oc.pods.grep() {
    oc get pods | grep -i $1
}

# This is to follow the logs of a pod
function oc.logs() {
    oc logs $1 -f=true
}

function oc.pods.find.last() {
    pod=$1
    if [ -z "$pod" ]; then
        printf "Please enter pod name:"
        read pod
    fi
    echo $(oc.pods.grep $pod | grep -v deploy | tail -1 | awk '{print $1}')
    unset pod
}

function oc.pods.last.status() {
    if [ -z "$1" ]; then
        echo Please enter a pod name for oc.pods.last.status
        return
    fi
    echo $(oc get pods | grep $(oc.pods.find.last $1) \
        | awk '{print $3}')
}

function oc.pods.last.time() {
    if [ -z "$1" ]; then
        echo Please enter a pod name for oc.pods.last.time
        return
    fi
    echo $(oc get pods | grep $(oc.pods.find.last $1) \
        | awk '{print $5}')
}

function oc.pods.find.last.with.loop() {
    local pod=$1
    if [ -z "$pod" ]; then
        printf "Please enter pod name:"
        read pod
    fi
    local continue_flag=r
    while [ "$continue_flag" == "r" ]
    do
        local last_pod=$(oc.pods.find.last $pod)
        if [ -z "$last_pod" ]; then
            printf "There is nothing to show."
        else
            local time=$(oc.pods.last.time $last_pod)
            local status=$(oc.pods.last.status $last_pod)
            printf "Last Pod is $last_pod($time)($status)." 
        fi
        printf " Do you want to continue or recheck(c=continue, r=recheck, q=quit)?"
        read continue_flag
        if [ "$continue_flag" == "q" ]; then
            break
        fi
    done
    if [ "$continue_flag" == "q" ]; then
        GLOBAL_OS_LAST_POD='FLAG_QUIT'
    else
        GLOBAL_OS_LAST_POD=$last_pod
    fi
}

function oc.logs.pod.last() {
    oc.pods.find.last.with.loop $1
    if [ "$GLOBAL_OS_LAST_POD" == "FLAG_QUIT" ]; then
        echo Quitting
        return
    fi
    oc.logs $GLOBAL_OS_LAST_POD
}

function oc.rsh.pod.last() {
    oc.pods.find.last.with.loop $1
    if [ "$GLOBAL_OS_LAST_POD" == "FLAG_QUIT" ]; then
        echo Quitting
        return
    fi
    oc rsh $GLOBAL_OS_LAST_POD
}
