function is.debug() {
    [[ "$DEBUG" == "true" ]] && return 0
    return 1
}

function debug.enable() {
    export DEBUG=true
}

function debug.disable() {
    export DEBUG=false
}

