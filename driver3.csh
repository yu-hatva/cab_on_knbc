#!/bin/tcsh

setenv KAKAROT_EVAL_INIT_FILE [WHERE kakeval.txt RESIDES]
set CABBIN = [cabocha, or COMMAND PATH TO KAKAROT]
set wdir = [YOUR WORK DIR, WHERE ALL THE SCRIPTS RESIDE]
set dir = $wdir/preproced
rm -rf cntall.out
touch cntall.out

cd $dir
foreach xxx ( `ls -1 | grep -v nogood` )
    cd $dir/$xxx
    rm -rf parser.out
    echo -n "$xxx  " >> $wdir/cntall.out
    $CABBIN -f1 < inp.txt | grep -v WARNING > parser.out
    $wdir/cmp3.pl | grep summary >> $wdir/cntall.out
end

cd $wdir
./sum.pl  < cntall.out

