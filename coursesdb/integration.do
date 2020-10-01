# Make sure everything has been built before we start
redo-ifchange all

# Ensure that the hello program, when run, says
# hello like we expect.
if ./main | grep -i 'failed' >/dev/null; then
    echo "something broke" >&2
    exit 1
else
    echo "success" >&2
fi

if leaks -atExit -- ./main | grep LEAK:; then
    echo "there's a memory leak" >&2
    exit 1
else
    echo "no memory leak" >&2
    exit 0
fi