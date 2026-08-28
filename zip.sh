unzip._command() {
    local archive_type="$1" file="$2" current folder
    [ -n "$archive_type" ] || { echo 'Archive type is required.' >&2; return 2; }
    [ -n "$file" ] || read -rp 'Enter an archive: ' file
    [ -f "$file" ] || { echo "File does not exist: $file" >&2; return 1; }
    [ -n "${TMP:-}" ] && [ "$TMP" != / ] && [ "$TMP" != "$HOME" ] ||
        { echo 'Set $TMP to a safe temporary directory.' >&2; return 1; }
    current=$PWD
    folder="$TMP/unzip"
    mkdir -p "$TMP" || return
    if [ -e "$folder" ]; then
        folder=$(mktemp -d "$TMP/unzip.XXXXXX") || return
    else
        mkdir "$folder" || return
    fi
    cp -- "$file" "$folder/" || return
    cd "$folder" || return
    file=$(basename "$file")
    case "$archive_type" in
        tar) tar -xzf "$file" ;;
        zip) unzip -q "$file" ;;
        jar) jar -xf "$file" ;;
        *) echo "Unsupported archive type: $archive_type" >&2; cd "$current"; return 2 ;;
    esac
    local status=$?
    [ "$status" -eq 0 ] && rm -f -- "$file" && bopen .
    cd "$current" || return
    return "$status"
}
unzip.tar() { unzip._command tar "$1"; }
unzip.zip() { unzip._command zip "$1"; }
unzip.jar() { unzip._command jar "$1"; }
