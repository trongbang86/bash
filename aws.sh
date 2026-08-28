aws.generate.alias() {
 [ "$((${#AWS_PROFILES[@]} % 5))" -eq 0 ] || { echo 'AWS_PROFILES must contain groups of five fields.' >&2; return 2; }
}
