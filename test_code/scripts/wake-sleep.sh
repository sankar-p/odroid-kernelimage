# util values
utils=( 25 50 )
#utils=( 10 20 )

#leave it in default policy - ondemand

#enable sensors
echo 1 > /sys/bus/i2c/drivers/INA231/4-0045/enable
echo 1 > /sys/bus/i2c/drivers/INA231/4-0040/enable
echo 1 > /sys/bus/i2c/drivers/INA231/4-0041/enable
echo 1 > /sys/bus/i2c/drivers/INA231/4-0044/enable

iter=2
piter=50
tutil=200
longsleep=5
shortsleep=0.4

cpu_frequency(){
	if [ -e /sys/devices/system/cpu/cpu0/cpufreq ]                       
        then                                                                 
        	CPU0_FREQ=$((`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`/1000))
        else                                          
                CPU0_FREQ="0"                                                
        fi                                                                   
                                                                                             
        if [ -e /sys/devices/system/cpu/cpu1/cpufreq ]                       
        then                                                                 
                CPU1_FREQ=$((`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq`/1000))
        else                                          
                CPU1_FREQ="0"                                                
        fi                                                                   
                                                                                             
        if [ -e /sys/devices/system/cpu/cpu2/cpufreq ]                       
        then                                                                 
                CPU2_FREQ=$((`cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq`/1000))
        else                                          
                CPU2_FREQ="0"                                                
        fi                                                                   
                                                                                             
        if [ -e /sys/devices/system/cpu/cpu3/cpufreq ]                       
        then                                                                 
                CPU3_FREQ=$((`cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq`/1000))
        else                                                         
                CPU3_FREQ="0"                                        
        fi                       

	CPU_FREQ="$CPU0_FREQ $CPU1_FREQ $CPU2_FREQ $CPU3_FREQ"
	echo $CPU_FREQ
}

for util in ${utils[@]}
do

	./hotplug-up.sh 0
	./hotplug-up.sh 1
	./hotplug-up.sh 2
	./hotplug-up.sh 3

	cores=4

	instances=`echo $tutil $util | awk '{printf "%d", $1/$2 }'`

	SUM_A7=0
	SUM_A15=0
	SUM_WORK=0
	for i in `seq 1 $iter`;
	do

		for j in `seq 1 $instances`
		do
			affinity=`echo $j $cores | awk '{printf "%d", ($1-1)%$2}'`
			#../test_code/sleep-wake.o $util $affinity >> /dev/null &
			../test_code/sleep-wake.o $util $affinity normal-$util-$i-$j &
			#echo $j $affinity
		done

		sleep $longsleep

		for j in `seq 1 $piter`
		do
			sleep $shortsleep 

			# A7 Nodes                
                        A7_W=$(cat /sys/bus/i2c/drivers/INA231/4-0045/sensor_W)
                        SUM_A7=`echo $A7_W $SUM_A7 | awk '{printf "%f", $1+$2 }'`
                                                  
                        # A15 Nodes
                        A15_W=$(cat /sys/bus/i2c/drivers/INA231/4-0040/sensor_W)
                        SUM_A15=`echo $A15_W $SUM_A15 | awk '{printf "%f", $1+$2 }'`	

			#echo $A7_W $A15_W $(cpu_frequency) 
		done

		killall -2 sleep-wake.o

		work=`./workdone.sh $util $tutil $i 0`
		SUM_WORK=`echo $SUM_WORK $work | awk '{printf "%d", $1+$2}'`
	done

	AVG_A7=`echo $SUM_A7 $piter $iter | awk '{printf "%f", $1/($2*$3) }'`                   
        AVG_A15=`echo $SUM_A15 $piter $iter | awk '{printf "%f", $1/($2*$3) }'`          
        AVG_WORK=`echo $SUM_WORK $iter | awk '{printf "%d", $1/$2 }'`          
                                                                                      
        echo $AVG_A7 $AVG_A15 $AVG_WORK 

	echo "***"

	./hotplug-down.sh 2
	./hotplug-down.sh 3

	cores=2

	SUM_A7=0                                                            
        SUM_A15=0  
	SUM_WORK=0

	for i in `seq 1 $iter`;
	do

		for j in `seq 1 $instances`
		do
			affinity=`echo $j $cores | awk '{printf "%d", ($1-1)%$2}'`
			#../test_code/sleep-wake.o $util $affinity >> /dev/null &
			../test_code/sleep-wake.o $util $affinity shrunk-$util-$i-$j &
			#echo $j $affinity
		done

		sleep $longsleep

		for j in `seq 1 $piter`
		do
			sleep $shortsleep

			# A7 Nodes                
                        A7_W=$(cat /sys/bus/i2c/drivers/INA231/4-0045/sensor_W)
                        SUM_A7=`echo $A7_W $SUM_A7 | awk '{printf "%f", $1+$2 }'`
                                                  
                        # A15 Nodes
                        A15_W=$(cat /sys/bus/i2c/drivers/INA231/4-0040/sensor_W)
                        #SUM_A15=`echo $A15_W $SUM_A15 | awk '{printf "%f", $1+$2 }'`		for j in `seq 1 $piter`
                        SUM_A15=`echo $A15_W $SUM_A15 | awk '{printf "%f", $1+$2 }'`	

			#echo $A7_W $A15_W
		done

		killall -2 sleep-wake.o

		work=`./workdone.sh $util $tutil $i 1`
		SUM_WORK=`echo $SUM_WORK $work | awk '{printf "%d", $1+$2}'`
	done

	AVG_A7=`echo $SUM_A7 $piter $iter | awk '{printf "%f", $1/($2*$3) }'`         
        AVG_A15=`echo $SUM_A15 $piter $iter | awk '{printf "%f", $1/($2*$3) }'`       
        AVG_WORK=`echo $SUM_WORK $iter | awk '{printf "%d", $1/$2 }'`                       
                                                                                      
        echo $AVG_A7 $AVG_A15 $AVG_WORK    
 
	echo "***"
done


./hotplug-up.sh 0
./hotplug-up.sh 1
./hotplug-up.sh 2
./hotplug-up.sh 3
