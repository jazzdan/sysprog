# Make sure everything has been built before we start
redo-ifchange all

# Ensure that the hello program, when run, says
# hello like we expect.
if ./main| grep -i 'successfully initialized database' && grep -i 'successfully saved tables' >/dev/null; then
    echo "success" >&2
    exit 0
else
    echo "something broke" >&2
    exit 1
fi