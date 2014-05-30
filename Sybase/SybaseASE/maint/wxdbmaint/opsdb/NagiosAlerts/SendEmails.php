#!/usr/local/bin/php -q
<?php

$userName = "cron_sa";
$userPassword = "63vette";
$passfile = "$HOME/.sybpwd";
$array = file("$passfile"); 
echo "FLE : $passfile\n";
//foreach($array as $row){
//	$line = explode(" ",$row);
//	if(preg_match("/opsdb1p/i", $line[0])){
//		print "USR : $userName\n";	
//		$userPassword=$line[1];
//		print "PAS : $userPassword\n";
//	}
//}

//DB Connection information
$cnn = @sybase_connect("opsdb1p","$userName","$userPassword") or die("Could not connect to opsdb1p,$userName,$userPassword !\n\n\n");

echo "cnn =$cnn\n";
echo "$userName $userPassword";

//Select Database...
@sybase_select_db("MonitorBackupP");

//Execute Procedure
$execProc= @sybase_query("exec bsp_getEmailToSend",$cnn);
//echo "execProc : $execProc\n";

$subject = "Job Scheduler System Notification";

while($execProc2=sybase_fetch_array($execProc))
{
echo "$execProc2[jobName]\n";
echo "$execProc2[condition]\n";
echo "$execProc2[executionId]\n";


$headers = "";
$emailBody = "
<html>
<head>
<body bgcolor = \"990000\">

<u><b>Rerport on job:</b></u><br><br>
<table border = 0>
<tr>
    <td>Job Name              </td><td> $execProc2[jobName]</td> 
</tr>
<tr>
    <td>Reported on condition </td><td> $execProc2[condition]</td> 
</tr>
<tr>
    <td>Execution Id          </td><td> $execProc2[executionId]</td> 
</tr>
<tr>
    <td>Execution Status      </td><td> $execProc2[executionStatusName]</td> 
</tr>
<tr>
    <td>Execution Note        </td><td> $execProc2[executionNote]</td> 
</tr>
</table>
</body>
</html>
	      ";
	      
$headers  = "MIME-Version: 1.0\r\n";
$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";
$headers .= "To: $emailAddress\r\n";
$headers .= "From: sybase@opsdb1p.int.interactivemedia.com\r\n";
$headers .= "Cc: \r\n";
$headers .= "Bcc: \r\n";

$emailAddress = $execProc2[eString];

mail($emailAddress, $subject, $emailBody, $headers);
}
?>
