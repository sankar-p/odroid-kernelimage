ARMEABIGCC=/newscratch/android-4.4.2/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.7/bin/arm-linux-androideabi-gcc
ARMEABILIB=/newscratch/android-4.4.2/prebuilts/ndk/9/platforms/android-18/arch-arm/usr/lib
ARMEABIINC=/newscratch/android-4.4.2/prebuilts/ndk/9/platforms/android-18/arch-arm/usr/include
ARMEABICRT=/newscratch/android-4.4.2/prebuilts/ndk/9/platforms/android-18/arch-arm/usr/lib/crtbegin_dynamic.o

LINKER=/system/bin/linker

echo "GCC:"$ARMEABIGCC "LIB:"$ARMEABILIB "LINKER":$LINKER "PARAMS:"$@
 
$ARMEABIGCC $@ -Wl,-rpath-link=$ARMEABILIB,-dynamic-linker=$LINKER -L$ARMEABILIB $ARMEABICRT -I$ARMEABIINC -nostdlib -lc -lgcc
