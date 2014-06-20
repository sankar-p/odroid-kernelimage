# table of frequencies
freqs=( 250000 300000 350000 400000 450000 500000 550000 600000 800000 900000 1000000 1100000 1200000 1300000 1400000 1500000 1600000 )

./change-policy.sh userspace
./hotplug-up.sh 1
./hotplug-up.sh 2
./hotplug-up.sh 3

for freq in ${freqs[@]}
do
	./change-freq.sh $freq
	echo ***$freq***
	./wake-sleep.sh	
done

