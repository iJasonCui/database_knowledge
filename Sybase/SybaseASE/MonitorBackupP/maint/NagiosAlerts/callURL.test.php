#!/usr/local/bin/php -q
<?php

   // Set maximum number of seconds to wait for feed before displaying page without feed
   $numberOfSeconds=4;    

   // Report all errors except E_NOTICE
   error_reporting(E_ALL ^ E_NOTICE);

   $domain = "rtdb1p";
   // Establish a connection
   $socketConnection = fsockopen($domain, 80, $errno, $errstr, $numberOfSeconds);

   $ticketCreationLogFile =  $argv[1];
   

   if (!$socketConnection){
   	print("<!-- Network error: $errstr ($errno) -->");
   }
   else{
   	$theListOfTickets = file($ticketCreationLogFile); 
	$user="NOC";
	$pass="chicken";
	$id="new";                                         // value to create a new ticket
	$status="new";                                     // normal status for a new ticket
	$requestors="BACKUP and SCHEDULE MONITOR";
	$requestors=str_replace(" ", "%20", $requestors);
	$adminCc="adrian.alb@lavalife.com";
	$field10="";  	    				   // we know no city. this tool is generic.
	$field26="";       				   // nor IVR neither WEB. This tool is generic.

	foreach($theListOfTickets as $oneTicket) {
		// Backup~5~674~33~MonitorBac~31~Daily~21365~1911714~THIS IS A SMOKE TEST. IGNORE.~~DBM
		
		$thisTicket = explode("~",$oneTicket);
		$thisTicket[11] = rtrim($thisTicket[11]);
		$queue=$thisTicket[1];       // 5 = Backup  
		$owner=$thisTicket[2];       // normal owner for these tickets should be NOC (674)

		$subject="$thisTicket[0] - $thisTicket[11] - Alert ID $thisTicket[7] - Job ID $thisTicket[3]";
		$subject.="- Schedule ID $thisTicket[5] - Schedule Name $thisTicket[6]";

		$subject=str_replace(" ", "%20", $subject);
	
		$cc=$thisTicket[10];                     // NAGHIOSServices.emailString

		$content="";
		$content.="Job Name         $thisTicket[4]--";
		$content.="Job Id           $thisTicket[3]--";
		$content.="Scheduled Name   $thisTicket[6]--";
		$content.="Schedule Id      $thisTicket[5]--";
		$content.="Alert Id         $thisTicket[7]--";
		$content.="Execution Id     $thisTicket[8]-- ";
		$content.="";
		$content.="$thisTicket[9]";
		$content=str_replace(" ", "%20", $content);
		
		print "\nPOST http://rtdb1p/Ticket/Create.html?user={$user}&pass={$pass}&id={$id}&Status={$status}&Queue={$queue}&Owner={$owne}&Requestors={$requestors}&Cc={$cc}&AdminCc={$adminCc}&Content={$content}&Subject={$subject}&Object-RT::Ticket--CustomField-10-Values={$field10}&Object-RT::Ticket--CustomField-26-Values={$field26}\n";    
		$request =  "POST http://rtdb1p/Ticket/Create.html?user={$user}&pass={$pass}&id={$id}&Status={$status}&Queue={$queue}&Owner={$owne}&Requestors={$requestors}&Cc={$cc}&AdminCc={$adminCc}&Content={$content}&Subject={$subject}&Object-RT::Ticket--CustomField-10-Values={$field10}&Object-RT::Ticket--CustomField-26-Values={$field26}\n";    
		
	    
		//echo "REQUEST $request\n";
		//echo "SOCKETCONNECTION $socketConnection";
		echo ":: $domain , 80 , $errno, $errstr, $numberOfSeconds ::";
		
		if (fwrite($socketConnection, $request)) {
			while (!feof($socketConnection)) {
		        	$tresponse .= fread($socketConnection, 4096);
		        }
		}
		//echo ":: $tresponse";
		echo;
	}
   }
   
   fclose($socketConnection);




// http://rtdb1p/Ticket/Create.html?user=NOC&pass=chicken&Queue=18&id=new&Status=new&Owner=674&Requestors=Requestor name text&Cc=test@lavalife.com&AdminCc=adrian.alb@lavalife.com&Subject=THIS IS A TEST&Object-RT::Ticket--CustomField-10-Values=1&Object-RT::Ticket--CustomField-26-Values=1&Content=THIS IS A TEST.HERE COMES THE DESCRIPTION
?>
