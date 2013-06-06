#!/usr/bin/ksh
############################################################################
# Cluster SUN / Oracle Collector for cfg2html
############################################################################
# $Header: /home/CVS/cfg2html_sun/plugins/ClusterSun.sh,v 1.0 2012/04/04 10:02:17 jerome ROBERT Exp $
############################################################################
# $Log: ClusterSun.sh,v $
# Revision 1.0  2012/04/04 10:02:17  jerome ROBERT 
# Initial CVS import
# Initial Cluster collector
############################################################################
# (C)opyright 04.04.2012 by jerome ROBERT (http://www.admin-sys.com)
############################################################################



print 'Cluster\c' ; pkginfo -l SUNWscr |grep VERSION
echo " "
echo "                          --------------------------------------"
echo " "
echo "Gestion du Quorum:"
scstat -q
echo " "
echo "                          --------------------------------------"
echo " "
echo "Information Cluster" 
/usr/cluster/bin/scstat -vvv
echo " "
echo "                          --------------------------------------"
echo " "
echo "Configuration cluster:"
echo " "
if [[ -x /usr/cluster/bin/cluster ]]
then
   /usr/cluster/bin/cluster show -vvv
else
	 [[ -x /usr/cluster/bin/scrgadm ]] && scrgadm -pvvv
fi
