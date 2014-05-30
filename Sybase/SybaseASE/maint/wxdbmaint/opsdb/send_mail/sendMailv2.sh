#!/bin/ksh
####################################################################################
# this ksh scripts is created for processing data from raw file to Sybase Table    #
# Revised History: Feb 21 2002 													   #
# Author: Jason     
# Revised  History: Dec 08 2003   Erick Sanchez  #
################################################## 
( 
echo "From:erick.sanchez@lavalife.com" 
echo "To:erick.sanchez@lavalife.com" 
echo "MIME-Version: 1.0" 
echo "Content-Type: multipart/mixed;" 
echo ' boundary="PAA08673.1018277622/server.domain.com"' 
echo "Subject: Test Message" 
echo "" 
echo "This is a MIME-encapsulated message" 
echo "" 
echo "--PAA08673.1018277622/server.domain.com" 
echo "Content-Type: text/html" 
echo "" 
echo "<HTML> 
<BODY bgcolor=gray> 
<blockquote><font color=red>Test</font> <font color=white>Message</font> <font color=blue>Body</font></blockquote> 
</body> 
</html>" 
echo "--PAA08673.1018277622/server.domain.com" 
) | /usr/sbin/sendmail -t
