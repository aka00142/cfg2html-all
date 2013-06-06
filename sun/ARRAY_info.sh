#!/bin/ksh
# Small script to examine disk arrays and build a nice HTML page
# showing the array name & the status of the disks a happy disk is green
# a sad disk is red an empty slot is shown as cyan 
# written by Gary Staples Feb 2004 inspired by cfg2html
# please remember to test it befor eyou place onto a LIVE system
# tested on solaris 2.6 with A5000 and D1000
# email grjstaples@clara.net
#
GREEN="#00ff00#"
SYS=$(uname -n)
TIME=$(date '+%D  %H:%M')
rm /tmp/Array_info*
rm /tmp/Array_STATUS.html
ARRAY_LIST=$(/usr/sbin/luxadm probe | grep "WWN:" | cut -d':' -f2|awk '{print  $1}')
for ARRAY_NAME in ${ARRAY_LIST}
do 
FRONT="<tr bgcolor=yellow><td><B>FRONT</B></td>"
REAR="<tr bgcolor=yellow><td><B>REAR</B></td>"
echo "<table border=1 valign=top bordercolor=black width=100%>" >> /tmp/Array_STATUS.html
echo "<tr bgcolor=yellow><td width=30%><B>ARRAY status...${SYS}...${TIME}</B></td><td><B>Array name ${ARRAY_NAME}</B></td></tr>" >> /tmp/Array_STATUS.html
echo "</table>" >> /tmp/Array_STATUS.html
echo "<table border=1 valign=top bordercolor=black width=100%>" >> /tmp/Array_STATUS.html
ENCLOSURE_TYPE=$(/usr/sbin/luxadm display ${ARRAY_NAME} | grep -n SUBSYSTEM | cut -d ':' -f 1)
  if [[ ${ENCLOSURE_TYPE} -eq 12 ]] ; then
     /usr/sbin/luxadm display ${ARRAY_NAME} | head -11 | tail -7 > /tmp/Array_info.out
  elif [[ ${ENCLOSURE_TYPE} -eq 16 ]] ; then
     /usr/sbin/luxadm display ${ARRAY_NAME} | head -15 | tail -11 > /tmp/Array_info.out
  fi
cat /tmp/Array_info.out | sed 's/Not Installed/Empty Array Slot/g' > /tmp/Array_info.wrk
cat /tmp/Array_info.wrk | while read W1 W2 W3 W4 W5 W6 W7 
do
BGCOLOR=red
if [[ ${W3} == "(O.K.)" ]]
then
BGCOLOR=${GREEN}
fi
if [[ ${W2} == "Empty" ]]
then
BGCOLOR=cyan
fi
FRONT=${FRONT}"<td bgcolor=${BGCOLOR}><B>${W2}</B></td>" >> /tmp/Array_STATUS.html
BGCOLOR=red
if [[ ${W6} == "(O.K.)" ]]
then
BGCOLOR=${GREEN}
fi
if [[ ${W5} == "Empty" ]]
then
BGCOLOR=cyan
fi
REAR=${REAR}"<td bgcolor=${BGCOLOR}><B>${W5}</B></td>" >> /tmp/Array_STATUS.html
done
echo ${REAR} >> /tmp/Array_STATUS.html
echo ${FRONT} >> /tmp/Array_STATUS.html
echo "</table>" >> /tmp/Array_STATUS.html
done
