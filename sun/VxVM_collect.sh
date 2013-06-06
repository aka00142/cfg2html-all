############################################################################
# Veritas Volume Manager (VxVM) Collector for cfg2html
############################################################################
# $Header: /home/CVS/cfg2html_sun/plugins/VxVM_collect.sh,v 1.2 2004/06/02 13:52:17 ralproth Exp $
############################################################################
# $Log: VxVM_collect.sh,v $
# Revision 1.2  2004/06/02 13:52:17  ralproth
# Checked in new version from MVL, send back for testing
#
# Revision 1.2  2004/06/02 13:48:42  ralproth
# I tested it to work fine on Solaris 7 and 8 and got good output with VxVM 3.2 and 4.0 (3.5 is alike 4.0 so I expect no hickups there). The bulk of the work went into rearranging the VxVM stuff. In may cases we got double the information, guess that's fixed now.
#
# Revision 1.1  2004/04/26 15:31:40  ralproth
# + ripped and added the plugisn from the HPUX stream
#
# Revision 1.1  2004/04/24 20:22:47  ralproth
# + added plugins from cfg2html form the HPUX package
#
# Revision 2.1.1.1  2003/01/21 10:33:32  ralproth
# Import from HPUX to cygwin
#
# Revision 1.2  2002/02/06 09:10:17  ralproth
# VxVM collector added
#
# Revision 1.1  2002/02/05 12:41:33  ralproth
# Initial CVS import
# Initial VxVM collector
############################################################################
# (C)opyright 04.02.2002 by ROSE SWE, Ralph Roth (rose_swe@hotmail.com)
############################################################################


#for i in `vxdg list |awk '{print ($1)}'|grep -v DEVICE`
#  do
#	echo "Volumegroup $i\n"
#	vxdg list $i
#	done

echo "VxPrint\n"
vxprint -rth

echo "\n"
echo "VxStat"

	vxstat -d 2>&1 | tail +3 | awk '
	    BEGIN { 
		printf ("                                OPERATIONS             BLOCKS       AVG TIME(ms)\n");
		printf ("TYP NAME                      READ     WRITE       READ      WRITE  READ  WRITE\n");
	     }
    		{
		    v  = $1
		    n  = $2
		    or = $3
		    ow = $4
		    br = $5
		    bw = $6
		    ar = $7
		    aw = $8
		    printf ("%s %-20s %9s %9s %10s %10s %5.1f  %5.1f\n", v,n,or,ow,br,bw,ar,aw)

		}'                             

