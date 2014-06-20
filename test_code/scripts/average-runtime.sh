if test $# -lt 4 ; then
	echo "normal/shrunk util iter instances"
        exit
fi

filehead=$1
util=$2
iter=$3
instances=$4

for i in `seq 1 $instances`
do
	SUM_RT=0
	counter=0

	while read line;
	do
		w1=`echo $line | cut -d' ' -f1`
		w2=`echo $line | cut -d' ' -f2`

		runtime=`echo $w2 $w1 | awk '{printf "%d", $1-$2 }'`
		SUM_RT=`echo $SUM_RT $runtime | awk '{printf "%d", $1+$2 }'`
		counter=$((counter+1))
	done <$filehead-$util-$iter-$i

	AVG_RT=`echo $SUM_RT $counter | awk '{printf "%f", $1/$2 }'`
	echo $AVG_RT

done

