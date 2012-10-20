#!/usr/bin/perl
# usage: sum.pl < cntall.out

$ok = $ng = 0;

while (<>) {
 if (/ok\s+(\d+)\s+ng\s+(\d+)/) { $ok += $1; $ng += $2 }
} #  while

print "total ok $ok  ng $ng\n";

