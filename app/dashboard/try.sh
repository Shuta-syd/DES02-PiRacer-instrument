export PATH=~/rpi/tools/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf/bin:$PATH
export SYSROOT=~/rpo/sysroot
qmake -spec /home/seame-workstation01/Documents/Qt-CrossCompile-RaspberryPi/raspberrypi4/qt5.15/mkspecs/linux-arm-gnueabihf-g++ "QMAKE_LINK=arm-linux-gnueabihf-ld" dashboard.pro 
