source /home/specg12-2/mc404/simulador/set_path.sh
arm-eabi-as -g soul.s -o soul.o
arm-eabi-ld soul.o -o soul -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0


arm-eabi-as -g faz_nada.s -o faz_nada.o
arm-eabi-ld faz_nada.o -o faz_nada -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0

mksd.sh --so soul --user faz_nada
arm-sim --rom=/home/specg12-1/mc404/simulador/simulador_player/bin/dumboot.bin --sd=disk.img -g

source /home/specg12-2/mc404/simulador/set_path.sh
arm-eabi-gdb soul

target remote localhost:5000
b soul.s:209
command
p * (int) 0x77801800
c
end
c
