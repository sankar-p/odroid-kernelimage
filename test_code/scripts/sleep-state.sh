# Main infinite loop
while true; do

# ----------- CPU DATA ----------- #

# Node Configuration for CPU Frequency

if [ -e /sys/devices/system/cpu/cpu0/cpuidle ] 
then
	CPU0_ITIME_STATE0=$(cat /sys/devices/system/cpu/cpu0/cpuidle/state0/time)
	CPU0_USAGE_STATE0=$(cat /sys/devices/system/cpu/cpu0/cpuidle/state0/usage)
	#CPU0_OCCUPANCY_STATE0=$((CPU0_ITIME_STATE0/CPU0_USAGE_STATE0))
	CPU0_OCCUPANCY_STATE0=`expr $CPU0_ITIME_STATE0 / $CPU0_USAGE_STATE0`
	#echo $CPU0_OCCUPANCY_STATE0

	CPU0_ITIME_STATE1=$(cat /sys/devices/system/cpu/cpu0/cpuidle/state1/time)
	CPU0_USAGE_STATE1=$(cat /sys/devices/system/cpu/cpu0/cpuidle/state1/usage)
	#CPU0_OCCUPANCY_STATE1=$((CPU0_ITIME_STATE1/CPU0_USAGE_STATE1))
	CPU0_OCCUPANCY_STATE1=`expr $CPU0_ITIME_STATE1 / $CPU0_USAGE_STATE1`
	#echo $CPU0_OCCUPANCY_STATE1 $CPU0_ITIME_STATE1 $CPU0_USAGE_STATE1 

	CPU0_ITIME_STATE2=$(cat /sys/devices/system/cpu/cpu0/cpuidle/state2/time)
	CPU0_USAGE_STATE2=$(cat /sys/devices/system/cpu/cpu0/cpuidle/state2/usage)
	if [ $CPU0_USAGE_STATE2 != 0 ] 
	then
		CPU0_OCCUPANCY_STATE2=$(($CPU0_ITIME_STATE2/$CPU0_USAGE_STATE2))
	fi
	#echo $CPU0_OCCUPANCY_STATE2
fi

if [ -e /sys/devices/system/cpu/cpu1/cpuidle ] 
then
	CPU1_ITIME_STATE0=$(cat /sys/devices/system/cpu/cpu1/cpuidle/state0/time)
	CPU1_USAGE_STATE0=$(cat /sys/devices/system/cpu/cpu1/cpuidle/state0/usage)
	#CPU1_OCCUPANCY_STATE0=$(($CPU1_ITIME_STATE0/$CPU1_USAGE_STATE0))
	CPU1_OCCUPANCY_STATE0=`expr $CPU1_ITIME_STATE0 / $CPU1_USAGE_STATE0`
	#echo $CPU1_OCCUPANCY_STATE0

	CPU1_ITIME_STATE1=$(cat /sys/devices/system/cpu/cpu1/cpuidle/state1/time)
	CPU1_USAGE_STATE1=$(cat /sys/devices/system/cpu/cpu1/cpuidle/state1/usage)
	#CPU1_OCCUPANCY_STATE1=$(($CPU1_ITIME_STATE1/$CPU1_USAGE_STATE1))
	CPU1_OCCUPANCY_STATE1=`expr $CPU1_ITIME_STATE1 / $CPU1_USAGE_STATE1`
	#echo $CPU1_OCCUPANCY_STATE1

	CPU1_ITIME_STATE2=$(cat /sys/devices/system/cpu/cpu1/cpuidle/state2/time)
	CPU1_USAGE_STATE2=$(cat /sys/devices/system/cpu/cpu1/cpuidle/state2/usage)
	if [ $CPU1_USAGE_STATE2 != 0 ] 
	then
		CPU1_OCCUPANCY_STATE2=$(($CPU1_ITIME_STATE2/$CPU1_USAGE_STATE2))
	fi
	#echo $CPU1_OCCUPANCY_STATE2
fi

if [ -e /sys/devices/system/cpu/cpu2/cpuidle ] 
then
	CPU2_ITIME_STATE0=$(cat /sys/devices/system/cpu/cpu2/cpuidle/state0/time)
	CPU2_USAGE_STATE0=$(cat /sys/devices/system/cpu/cpu2/cpuidle/state0/usage)
	#CPU2_OCCUPANCY_STATE0=$(($CPU2_ITIME_STATE0/$CPU2_USAGE_STATE0))
	CPU2_OCCUPANCY_STATE0=`expr $CPU2_ITIME_STATE0 / $CPU2_USAGE_STATE0`
	#echo $CPU2_OCCUPANCY_STATE0

	CPU2_ITIME_STATE1=$(cat /sys/devices/system/cpu/cpu2/cpuidle/state1/time)
	CPU2_USAGE_STATE1=$(cat /sys/devices/system/cpu/cpu2/cpuidle/state1/usage)
	#CPU2_OCCUPANCY_STATE1=$(($CPU2_ITIME_STATE1/$CPU2_USAGE_STATE1))
	CPU2_OCCUPANCY_STATE1=`expr $CPU2_ITIME_STATE1 / $CPU2_USAGE_STATE1`
	#echo $CPU2_OCCUPANCY_STATE1

	CPU2_ITIME_STATE2=$(cat /sys/devices/system/cpu/cpu2/cpuidle/state2/time)
	CPU2_USAGE_STATE2=$(cat /sys/devices/system/cpu/cpu2/cpuidle/state2/usage)
	if [ $CPU2_USAGE_STATE2 != 0 ] 
	then
		CPU2_OCCUPANCY_STATE2=$(($CPU2_ITIME_STATE2/$CPU2_USAGE_STATE2))
	fi
	#echo $CPU2_OCCUPANCY_STATE2
fi

if [ -e /sys/devices/system/cpu/cpu3/cpuidle ] 
then
	CPU3_ITIME_STATE0=$(cat /sys/devices/system/cpu/cpu3/cpuidle/state0/time)
	CPU3_USAGE_STATE0=$(cat /sys/devices/system/cpu/cpu3/cpuidle/state0/usage)
	#CPU3_OCCUPANCY_STATE0=$(($CPU3_ITIME_STATE0/$CPU3_USAGE_STATE0))
	CPU3_OCCUPANCY_STATE0=`expr $CPU3_ITIME_STATE0 / $CPU3_USAGE_STATE0`
	#echo $CPU3_OCCUPANCY_STATE0

	CPU3_ITIME_STATE1=$(cat /sys/devices/system/cpu/cpu3/cpuidle/state1/time)
	CPU3_USAGE_STATE1=$(cat /sys/devices/system/cpu/cpu3/cpuidle/state1/usage)
	#CPU3_OCCUPANCY_STATE1=$(($CPU3_ITIME_STATE1/$CPU3_USAGE_STATE1))
	CPU3_OCCUPANCY_STATE1=`expr $CPU3_ITIME_STATE1 / $CPU3_USAGE_STATE1`
	#echo $CPU3_OCCUPANCY_STATE1

	CPU3_ITIME_STATE2=$(cat /sys/devices/system/cpu/cpu3/cpuidle/state2/time)
	CPU3_USAGE_STATE2=$(cat /sys/devices/system/cpu/cpu3/cpuidle/state2/usage)
	if [ $CPU3_USAGE_STATE2 != 0 ] 
	then
		CPU3_OCCUPANCY_STATE2=$(($CPU3_ITIME_STATE2/$CPU3_USAGE_STATE2))
	fi
	#echo $CPU3_OCCUPANCY_STATE2
fi

# ---------- DRAW Screen ----------- #

echo "CPU0: STATE0: $CPU0_ITIME_STATE0 $CPU0_USAGE_STATE0 $CPU0_OCCUPANCY_STATE0"
echo "CPU0: STATE1: $CPU0_ITIME_STATE1 $CPU0_USAGE_STATE1 $CPU0_OCCUPANCY_STATE1"
echo "CPU0: STATE2: $CPU0_ITIME_STATE2 $CPU0_USAGE_STATE2 $CPU0_OCCUPANCY_STATE2"

echo "CPU1: STATE0: $CPU1_ITIME_STATE0 $CPU1_USAGE_STATE0 $CPU1_OCCUPANCY_STATE0"
echo "CPU1: STATE1: $CPU1_ITIME_STATE1 $CPU1_USAGE_STATE1 $CPU1_OCCUPANCY_STATE1"
echo "CPU1: STATE2: $CPU1_ITIME_STATE2 $CPU1_USAGE_STATE2 $CPU1_OCCUPANCY_STATE2"

echo "CPU2: STATE0: $CPU2_ITIME_STATE0 $CPU2_USAGE_STATE0 $CPU2_OCCUPANCY_STATE0"
echo "CPU2: STATE1: $CPU2_ITIME_STATE1 $CPU2_USAGE_STATE1 $CPU2_OCCUPANCY_STATE1"
echo "CPU2: STATE2: $CPU2_ITIME_STATE2 $CPU2_USAGE_STATE2 $CPU2_OCCUPANCY_STATE2"

echo "CPU3: STATE0: $CPU3_ITIME_STATE0 $CPU3_USAGE_STATE0 $CPU3_OCCUPANCY_STATE0"
echo "CPU3: STATE1: $CPU3_ITIME_STATE1 $CPU3_USAGE_STATE1 $CPU3_OCCUPANCY_STATE1"
echo "CPU3: STATE2: $CPU3_ITIME_STATE2 $CPU3_USAGE_STATE2 $CPU3_OCCUPANCY_STATE2"

sleep 3
clear
done
