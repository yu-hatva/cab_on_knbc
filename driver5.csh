#!/bin/tcsh

set kakev = [PATH TO kakeval.txt]
set CABBIN = [COMMAND PATH TO KAKAROT]

setenv KAKAROT_EVAL_INIT_FILE $kakev
set CABOPT = "-f1 -g12"
set MAXFILECNT = 9999
set ANS = ans.out

if ( ! -f $kakev ) then
  echo "$kakev not found"
  exit
endif

rm -rf inpall.txt $ANS parser.out
touch  inpall.txt $ANS
@ filecnt = 0

set dirs = ( `ls -1 preproced | grep -v nogood` )
foreach xxx ( $dirs )
  cat preproced/$xxx/inp.txt >> inpall.txt
  cat preproced/$xxx/ans.out >> $ANS
  @ filecnt += 1
  if ($filecnt == $MAXFILECNT) goto lbl
end

lbl:

$CABBIN $CABOPT < inpall.txt > parser.out

set PLCMD = /tmp/cntokng.pl
rm -rf $PLCMD
echo '$nok = $nng = 0;' >  $PLCMD
echo 'while(<>) {     ' >> $PLCMD
echo '  if(/summary: line \d+ ok (\d+) ng (\d+)/) {     ' >> $PLCMD
echo '    $nok += $1; $nng += $2;         }}   ' >> $PLCMD
echo '$nok2 = $nok + 364;                      ' >> $PLCMD
echo 'print "ok $nok(+364=$nok2) ng $nng \n";  ' >> $PLCMD
perl $PLCMD < parser.out

set PLCMD2 = /tmp/chkdif2.pl
rm -rf $PLCMD2
rm -rf diff.out

echo '@dirs = `ls -1 preproced | grep -v nogood`; '  > $PLCMD2
echo 'while(<>) {                                 ' >> $PLCMD2
echo '  if (/diff (\d+\.\d+) line (\d+)/) {       ' >> $PLCMD2
echo '    $x = $dirs[$2]; chop $x; print "$x $1\n"; }}' >> $PLCMD2
perl $PLCMD2 < parser.out > diff.out

