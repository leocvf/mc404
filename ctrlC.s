source /home/specg12-2/mc404/simulador/set_path.sh
arm-eabi-as -g ra158319.s -o ra158319.o
arm-eabi-ld ra158319.o -o ra158319 -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0
mksd.sh --so ra158319 --user faz_nada
arm-sim --rom=/home/specg12-1/mc404/simulador/simulador_player/bin/dumboot.bin --sd=disk.img -g

arm-eabi-as -g faz_nada.s -o faz_nada.o
arm-eabi-ld faz_nada.o -o faz_nada -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0

source /home/specg12-2/mc404/simulador/set_path.sh
arm-eabi-gdb ra158319

target remote localhost:5000
b ra158319.s:105
command
p * (int) 0x77801800
c
end
c

http://www.programminglogic.com/a-simple-multi-tasking-operating-system-in-arm-assembly/
