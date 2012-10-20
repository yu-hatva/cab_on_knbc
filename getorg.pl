#!/usr/bin/perl
# usage: getorg.pl < knp.out > cabinp.txt

$sent = "";

while (<>) {
   # skip comments and chunk lines
 if (/^[#*+]/) { next; }

   # get surface, add to sentence
 if (/^([^ ]*)\s/) {
   if ($1 ne "EOS") { $sent .= $1; }
 }

} #  while

$sent .= "\n";
print $sent;

