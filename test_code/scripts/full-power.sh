# table of frequencies
freqs=( 250000 300000 350000 400000 450000 500000 550000 600000 800000 900000 1000000 1100000 1200000 1300000 1400000 1500000 1600000 )

cores=4
powertrials=5

./change-policy.sh userspace
echo 1 > /sys/bus/i2c/drivers/INA231/4-0045/enable
echo 1 > /sys/bus/i2c/drivers/INA231/4-0040/enable
echo 1 > /sys/bus/i2c/drivers/INA231/4-0041/enable
echo 1 > /sys/bus/i2c/drivers/INA231/4-0044/enable

for freq in ${freqs[@]}
do
	./change-freq.sh $freq

	for i in `seq 1 $cores`;
	do
		for j in `seq 1 $i`
		do
			../test_code/n-queen.o 14 &
		done

		SUM_A7=0
		SUM_A15=0	
		for j in `seq 1 $powertrials`
		do
			sleep 5	

			# A7 Nodes
			A7_W=$(cat /sys/bus/i2c/drivers/INA231/4-0045/sensor_W)
			SUM_A7=`echo $A7_W $SUM_A7 | awk '{printf "%f", $1+$2 }'` 
                                                                                             
			# A15 Nodes
			A15_W=$(cat /sys/bus/i2c/drivers/INA231/4-0040/sensor_W)
			SUM_A15=`echo $A15_W $SUM_A15 | awk '{printf "%f", $1+$2 }'` 
		done
		
		AVG_A7=`echo $SUM_A7 $powertrials | awk '{printf "%f", $1/$2 }'` 
		AVG_A15=`echo $SUM_A15 $powertrials | awk '{printf "%f", $1/$2 }'` 

		#print power measure A15 A7
		echo $freq $i $AVG_A7 $AVG_A15

		#echo $'\n'	
		killall n-queen.o
	done
done
