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

function oc.logs.pod.last() {
    pod=$1
    if [ -z "$pod" ]; then
        printf "Please enter pod name:"
        read pod
    fi
    continue_flag=r
    while [ "$continue_flag" == "r" ]
    do
        last_pod=$(oc.pods.find.last $pod)
        if [ -z "$last_pod" ]; then
            printf "There is nothing to show."
        else
            time=$(oc.pods.last.time $last_pod)
            status=$(oc.pods.last.status $last_pod)
            printf "Last Pod is $last_pod($time)($status)." 
        fi
        printf " Do you want to continue or recheck(c=continue, r=recheck, q=quit)?"
        read continue_flag
        if [ "$continue_flag" == "q" ]; then
            return
        fi
    done
    oc.logs $last_pod
    unset continue_flag
    unset last_pod
    unset pod
    unset time
    unset status
}
