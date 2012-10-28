#!/bin/tcsh

set wdir = [YOUR WORK DIR, WHERE ALL THE SCRIPTS RESIDE]
set dir = [WHATEVER DIR YOU USE]/KNBC_v1.0_090925/corpus1
set dest = $wdir/preproced

rm -rf loggetans
touch  loggetans
mkdir $dest
mkdir $dest/nogood

cd $dir
foreach xxx ( `ls -1` )
  cd $dir/$xxx
  set files = ( `ls -1 | grep KN` )
  foreach yyy ( $files )
    mkdir $dest/$yyy
    cd $dir/$xxx
    iconv -f EUCJP $yyy > $dest/$yyy/knp.out
    cd $wdir
    ./getorg.pl < $dest/$yyy/knp.out > $dest/$yyy/inp.txt
    cabocha -f1 < $dest/$yyy/inp.txt | grep -v WARNING > $dest/$yyy/cab.out
    cd $dest/$yyy
    echo "#### $yyy" >> $wdir/loggetans
    $wdir/getans.pl >> $wdir/loggetans
    if ( $status ) mv $dest/$yyy $dest/nogood
  end
  cd $dir
end
