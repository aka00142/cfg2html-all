#!/bin/ksh

# Silly little script to collect system (OS and hardware) data
#
# For Solaris and Red Hat only.  
#
# S^2 30 Jul 2008

OS=`uname -s`;

if [ $OS = "Linux" ]; then

     #                     /--------------------\
     #                    < Get CPU info (Linux) >
     #                     \--------------------/

     qty=`grep "^physical id" /proc/cpuinfo | sort -u | grep -c physical`
     num_cores=`grep -c "core id" /proc/cpuinfo`

     tmp=/tmp/foo.$$
     dmidecode |\
     sed -n '/^Handle 0x04/,/^Handle 0x07/p' > $tmp
     type=`awk -F': ' '/Manufacturer:/  {mfg = $2} /Family:/ {fam = $2} END {printf "%s-%s\n", mfg, fam}' $tmp`
     spd=`cat $tmp | egrep "Current Speed:" | head -1 | awk -F": " '{print $2}' | awk '{print $1}'`
     tot_threads=$num_cores
     rm -f $tmp

     #                    /-------------------\
     #                   < Get HW Make n Model >
     #                    \-------------------/

     dmidecode |\
     sed -n '/Handle 0x0100/,/^Handle/p' > $tmp
     mfg=`  awk -F': ' '/Manufacturer/ {print $2}' $tmp`;
     model=`awk -F': ' '/Product Name/ {print $2}' $tmp`;
     rm -f $tmp
     #printf "%s\t%s\n" mfg model

     #                    /-------------------\
     #                   < Get OS Version Info >
     #                    \-------------------/

     os_release=`cat /etc/redhat-release | tr -d '(' | tr -d ')' | sed -e 's|Red Hat Enterprise Linux .. |RHEL|' -e 's|release ||' -e 's|Update |u|' | awk '{print $1$3}'`


     #                    /--------------------\
     #                   < Get RAM info (Linux) >
     #                    \--------------------/

     ram_avail=`awk '/MemTotal:/ {printf "%3.0f\n", $2/1015.879}' /proc/meminfo`
     # trim leading spaces
     ram_avail=`echo $ram_avail | awk '{print $1}'`

elif [ $OS = "SunOS" ]; then

     #                       /--------\
     #                      < Solaris! >
     #                       \--------/

     #                     /------------\
     #                    < Get CPU info >
     #                     \------------/

     plat=`uname -p`;
     if   [ $plat = "i386"  ]; then

          #type=`psrinfo -pv | egrep -v 'MHz| virtual ' | awk '{print $1,$(NF-1), $(NF)}' | tr -d \) | uniq -c`;
          qty=` psrinfo -pv | egrep '^The physical processor' | grep -c '^' `

          type=`psrinfo -pv | egrep -v 'x86|virtual' | tail -1 | sed -e 's|     ||' `;
          type=`echo $type | sed -e 's|(tm) Processor||'`
          type=`echo $type | sed -e 's|Dual Core ||'`

          spd=` psrinfo -pv | egrep MHz | tail -1 | awk '{print $(NF-1)}' | tr -d \)`;

          tot_threads=`uname -X | awk '/NumCPU/ {print $3}'`;
          num_cores=$tot_threads;

     elif [ $plat = "sparc" ]; then

          cpu_info=`psrinfo -pv | egrep 'SPARC' | awk '{print $1,$(NF-1), $(NF)}' | tr -d \) | uniq -c`;

          qty=` printf "$cpu_info\n" | awk '{print $1}'`;

          type=`printf "$cpu_info\n" | awk '{print $2}'`;
          spd=` printf "$cpu_info\n" | awk '{print $3}'`;

          # Determine total number of threads for all CPUs on this host
          tot_threads=`uname -X | awk '/NumCPU/ {print $3}'`;
          threads_per_core=1;
          [ $type = 'UltraSPARC-T1'   ] && threads_per_core=4
          [ $type = 'UltraSPARC-T2'   ] && threads_per_core=8

          # Calculate number of cores
          num_cores=$(( tot_threads / threads_per_core ));
     else
          printf "Unrecognized platform, uname -p is neither i386 nor sparc\n";
          exit 1;
     fi

     #                    /----------------------\
     #                   < Get RAM info (Solaris) >
     #                    \----------------------/

     ram_avail=`prtconf | head -2 | nawk -F": " '/Megab/ {print $2}' | nawk '{printf "%3.0f\n", $1}'`
     # trim leading spaces
     ram_avail=`echo $ram_avail | awk '{print $1}'`

     #                    /-------------------\
     #                   < Get OS Version Info >
     #                    \-------------------/

     host_os=`uname -s`
     host_os=`echo $host_os | sed 's/SunOS/Solaris/' `

     host_os_rev=`uname -r`
     host_os_rev=`echo $host_os_rev | sed 's|5\.||' `

     os_ver="$host_os $host_os_rev";
     os_release=`cat /etc/release | grep Solaris | head -1 | sed 's|^ *||g' `;


     #                    /-------------------\
     #                   < Get HW Make n Model >
     #                    \-------------------/

     class=`uname -m`;
     model=`prtdiag | head -1 | cut -c40-99 | perl -pe "s/^\s+//g"| cut -c7-99`;
     [ $plat = "i386" ] && model=`prtdiag | head -1 | cut -c40-99 | perl -pe "s/^\s+//g"`;
     mfg='Sun';
     [ $class = "sun4us" ] && mfg='Fujitsu';
     #printf "%s\t%s\n" "$mfg" "$model";
     [ "$model" = 'Sun Fire T200' ] && model='Sun Fire T2000';
     [ "$model" = 'Sun Fire(TM) T1000' ] && model='Sun Fire T1000';
     #model=`echo $model | sed 's/Sun Fire /SF /' `


else
     printf "Unhandled OS >$OS<, aborting...\n";
     printf "(only know how to deal with Solaris and Linux)\n";

fi

printf "Manufacturer:     %s\n"    "$mfg"; 
printf "Model:            %s\n"    "$model";
printf "Operating System: %s\n"    "$os_release";
printf "CPU(s):           %dx %-15s @%4d MHz; %2d Cores %2d Threads\n" $qty "$type" $spd $num_cores $tot_threads;
printf "Memory:           %s MB\n" "$ram_avail";

# fini
