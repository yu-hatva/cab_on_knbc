#!/usr/bin/perl
# usage: cmp3.pl

open(FCAB, "parser.out");
open(FANS, "ans.out");
$chno = 0;

while(<FCAB>) {
 if (/^\*\s+(\d+)\s+(-?\d+)D/) {
   if ($1 != $chno) { die("chunk no mismatch"); }
   $cans[$chno++] = $2;
 }
}

while(<FANS>) {
 @rightAns = split;
 last;
}

$sz = $#rightAns;
$ok = $ng = 0;

for($i=0; $i<$sz; $i++) {
 if ($rightAns[$i] == 99) { next; }
 if ($rightAns[$i] == $cans[$i]) { $ok++; }
 else                            { $ng++; }
}

print "summary: ok $ok  ng $ng\n";

