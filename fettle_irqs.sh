#!/bin/bash

# move non-rt irqs to core 0
# doesn't seem to work on norns for the interesting interrupts..

# for i in 16 17 23 24 48 50 51 54 59 62 83 84 86 87 169 170 171 172 173 174 175 176 177
# do
#   echo 1 >/proc/irq/$i/smp_affinity
# done

echo 2 >/proc/irq/55/smp_affinity
echo 2 >/proc/irq/56/smp_affinity

#disable rt throttling
echo -1 >/proc/sys/kernel/sched_rt_runtime_us

echo setting all interrupts to prio 40
for ps  in `ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "\[irq/"| awk '{print $1}'`; do sudo chrt -f -p 40 $ps; done
ps=`ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "\[irq/55-DMA IRQ\]"| grep -v grep | awk '{print $1}'`
echo "raising irq 55 ($ps)"
echo sudo chrt -f -p 90 $ps
sudo chrt -f -p 90 $ps
ps=`ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "\[irq/56-DMA IRQ\]"| grep -v grep | awk '{print $1}'`
echo "raising irq 56 ($ps)"
echo sudo chrt -f -p 90 $ps
sudo chrt -f -p 90 $ps

echo "ps -eLo pid,cls,rtprio,pri,nice,cmd| grep irq "

