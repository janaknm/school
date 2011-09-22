#!/bin/bash
IN_FILE=${1-sample}
OUT_FILE="${IN_FILE}.out"
ERL=erl
MODULES="as3 paramap"
KEY=${2-VICTORY}
ENC_CMD="io:format(\"~s\", [as3:encrypt(\"${IN_FILE}\", \"${KEY}\")])"

# compile
$ERL -compile $MODULES

#no SMP
echo no smp:
$ERL -noshell -smp disable -eval "${ENC_CMD}" -s erlang halt  > $OUT_FILE


for i in 1 2 3 4
do
    echo
    echo -----------------------------------
    echo $i schedulers:
    time $ERL -noshell -smp +S $i -eval "${ENC_CMD}" -s erlang halt > $OUT_FILE
done


