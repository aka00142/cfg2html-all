#!/usr/bin/ksh

# make_index.sh - make an HTML index for the cfg2html output files
#
# Run this shell script in the directory where your cfg2html files 
# are stored. After running this script, load the allhosts.htm
# file in your browser. This is part of the cfg2html package.
#
# Original version 2.8 by Ralph Roth, 2005/05/09
# Hacked beyond recognition by S^2, Aug-Sep 2008
# (most changes were to make this work for cfg2html_solaris)


OUT=index.htm

echo "make_index for cfg2html" 
echo 
echo "Creating an HTML Index of your cfg2html configuration files..."

cat > $OUT <<_EOF_
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>

   <style type=text/css>

   PRE             {font-family: Lucidia-Console, Courier-New, Courier; font-size: 10pt}
   BODY            {font-family: Arial, Verdana, Helvetica, Sans-serif; font-size: 12pt}
   A               {font-familY: Arial, Verdana, Helvetica, Sans-serif}
   A:link          {text-decoration: none}
   A:visited       {text-decoration: none}
   A:hover         {text-decoration: underline}
   A:active        {color: red; text-decoration: none}

   H1              {font-family: Arial, Verdana, Helvetica, Sans-serif; font-size: 20pt}
   H2              {font-family: Arial, Verdana, Helvetica, Sans-serif; font-size: 14pt}
   H3              {font-family: Arial, Verdana, Helvetica, Sans-serif; font-size: 12pt}
   DIV, P, OL, UL, SPAN, TD
                   {font-family: Arial, Verdana, Helvetica, Sans-serif; font-size: 11pt}
   </style>

</HEAD>
<BODY>
<B>Host List</B>
<HR>
<B>
<pre>
_EOF_


for filename in `(find . -name "*_cfg.html" | sed 's|\./||' | sort -d )`; do

   host=`echo $filename | perl -pe 's|_cfg||; s|\..*$||'`

   echo "Creating Host $host"
   echo "<A HREF=\"$filename\" TARGET=\"info\">$host</A>"  >> $OUT
done

#echo "<p><HR><p>Created: `date +%x-%X`" >>$OUT
echo "<HR>Created: `date +%x-%X`" >>$OUT

cat >> $OUT <<_EOF_
</pre>
</B>
<br>
</BODY>
</HTML>
_EOF_

echo "Hosts collected! Now load $OUT in your browser!"

# end
