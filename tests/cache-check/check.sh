main () {
    echo "script check"
    echo "commit: ${CI_COMMIT_REF_SLUG}\n$(date)" > cached_file
}

main "$@"
