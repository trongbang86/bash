# Load the shared profile in interactive non-login shells such as Ubuntu Terminal.
case $- in
    *i*) ;;
    *) return ;;
esac

[ -f "$HOME/.bash_profile" ] && . "$HOME/.bash_profile"
