#for (( i=0; i<4; i++ ))
#do
#	echo $1 >> /sys/devices/system/cpu/cpu$i/cpufreq/scaling_setspeed
#done

echo $1 >> /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
echo $1 >> /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
echo $1 >> /sys/devices/system/cpu/cpu2/cpufreq/scaling_setspeed
echo $1 >> /sys/devices/system/cpu/cpu3/cpufreq/scaling_setspeed
