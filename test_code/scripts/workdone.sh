if test $# -lt 4 ; then
        echo "util totalutil iterations type (normal-0/shrunk-1)";
        exit
fi

util=$1
tutil=$2
iter=$3

if [ "$4" == "0" ];
then
	file="normal"
else
	file="shrunk"
fi

instances=`echo $tutil $util | awk '{printf "%d", $1/$2 }'`
#for i in `seq 1 $iter`
#do
	SUM_WORK=0
	for j in `seq 1 $instances` 
	do
		#echo $file-$util-$iter-$j
		work=$(wc -l $file-$util-$iter-$j)
		#rm $file-$util-$iter-$j
		work=`echo $work | cut -d' ' -f1`
		SUM_WORK=`echo $work $SUM_WORK | awk '{printf "%d", $1+$2 }'`
	done
	echo $SUM_WORK
#done

