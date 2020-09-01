#!/usr/bin/env ruby

def test(cmd)
    system(cmd)
end

def commit(cmd="git commit -am 'working'")
    system(cmd)
end

def revert(cmd="git reset HEAD --hard")
    system(cmd)
end

(test("zig build-exe wordcount.zig") && commit()) || revert()