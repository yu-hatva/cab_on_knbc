#!/usr/bin/perl
# usage: getans.pl

$errmax = 99;  # FIXME increase later

sub getChunkC {
 my $chk = "";
 while(<FCAB>) {
   if (/^\*\s+(\d+)\s+(-?\d+)D/) {
     if (int($1) != $cchno + 1)
       { print "WARNING: cchno mismatch seq $cchno line $1\n"; }
     #$cans[$cchno + 1] = $2;
     last;
   }
   if (/EOS/) { $eosFound = 1; last; }
   /^([^ \t]*)\s/;
   $chk .= $1;
 }
 if ($cchno >= 0) { $cchnk[$cchno] = $chk; }
 return $chk;
}

sub getChunkK {  # copied from getChunkC, then modified
 my $chk = "";
 while(<FKNP>) {
   if (/^#/) { next; }
   if (/^[\*\+]\s+(-?\d+)[DP]/) {
     $kans[$kchno + 1] = $1;
     last;
   }
   if (/EOS/) { $eosFound = 1; last; }
   /^([^ ]*)\s/;
   $chk .= $1;
 }
 if ($kchno >= 0) { $kchnk[$kchno] = $chk; }
 return $chk;
}

######## main start ########

open(FCAB, "cab.out");
open(FKNP, "knp.out");

   # skip to the first chunk lines, both cab and knp

$eosFound = 0; 
$cchno = -1;
$kchno = -1;
getChunkC();
getChunkK();
$cchno = 0;
$kchno = 0;

$lpmax = 0;

while(1) {

 $cchk = getChunkC();
 $kchk = getChunkK();
print "point 2\n";   #############
 $clen = length($cchk);
 $klen = length($kchk);
 $cacc = $cchk;
 $kacc = $kchk;
 if ($kchk =~ /EOS/) { last; }
 $chkAlgn[$cchno] = $kchno;
 $chkSpan[$cchno] = 1;

print "cchk $cchk, kchk $kchk, clen $clen, klen $klen, cchno $cchno, kchno $kchno\n";   #############
if ($kchno > $errmax) { die("too long sent"); }
if ($lpmax++ > $errmax) { die("too long loop"); }
$lpmax2 = 0;

 if ($klen < $clen) {
   while($klen < $clen) {
print "point 3: klen $klen  clen $clen\n";
if ($lpmax2++ > $errmax) { last; }
     $cchk = substr($cchk, $klen, $clen - $klen);
     $clen = $clen - $klen;
     $kchno++;
     $chkSpan[$cchno]++;
     $kchk = getChunkK();
     $klen = length($kchk);
     $kacc .= $kchk;
   }
 }
 elsif ($clen < $klen) {
   while($clen < $klen) {
print "point 4: klen $klen  clen $clen\n";
     $kchk = substr($kchk, $clen, $klen - $clen);
     $klen = $klen - $clen;
     $cchno++;
     $cchk = getChunkC();
     $chkAlgn[$cchno] = $kchno;
     $chkSpan[$cchno] = 1;
     $clen = length($cchk);
     $cacc .= $cchk;
   }
 }

 if ($klen != $clen || $kacc ne $cacc) {
   die("one chunk not subset of the other");
 }

 $cchno++;
 $kchno++;
 if ($eosFound) { last; }
}

for($c=0; $c<$cchno; $c++) {
 printf "algn=%2d span=%2d cans=%2d chnk=%s\n",
        $chkAlgn[$c], $chkSpan[$c], $cans[$c], $cchnk[$c];
}

for($k=0; $k<$kchno; $k++) {
 printf "kans=%2d kchnk=%s\n",
         $kans[$k], $kchnk[$k];
}

 # compare answers

$okcnt = $ngcnt = 0;

for($c=0; $c<$cchno; $c++) {
 $k = $chkAlgn[$c];
 if ($c < $cchno - 1 && $chkAlgn[$c + 1] == $k) {
   $cans[$c] = 99;   # N/A
   next;
 } else {

   $span = $chkSpan[$c];

   $kansNow = $kans[$k + $span - 1];
print "c $c k $k span $span cans $cans[$c] kansNow $kansNow\n";
   $cansNow = 99;
   for($d=0; $d<$cchno; $d++) {
     if ($chkAlgn[$d] <= $kansNow && $kansNow < $chkAlgn[$d] + $chkSpan[$d]) {
       $cansNow = $d;
       last;
     }
   }
   if ($cansNow == 99)
     { print "WARNING: cans not found for $d\n"; }

   $rightAns[$c] = $cansNow;
 }
}


open(FANS, "> ans.out");
for($c=0; $c<$cchno; $c++) {
 print FANS "$rightAns[$c] ";
}
print FANS "\n";
