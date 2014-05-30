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
        fclose($socketConnection);
   	$theListOfTickets = file($ticketCreationLogFile); 
	$user="NOC";
	$pass="chicken";
	$id="new";                                         // value to create a new ticket
	$status="new";                                     // normal status for a new ticket
	$requestors="BACKUP_and_SCHEDULE_MONITOR";
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
		$content.="Job Name         $thisTicket[4]--<br> ";
		$content.="Job Id           $thisTicket[3]--<br> ";
		$content.="Scheduled Name   $thisTicket[6]--<br> ";
		$content.="Schedule Id      $thisTicket[5]--<br> ";
		$content.="Alert Id         $thisTicket[7]--<br> ";
		$content.="Execution Id     $thisTicket[8]--<br> ";
		$content.="<br>";
		$content.="$thisTicket[9]<br> ";
		$content=str_replace(" ", "%20", $content);
	
		$socketConnection = fsockopen($domain, 80, $errno, $errstr, $numberOfSeconds);
	
		print "\nPOST http://rtdb1p/Ticket/Create.html?user={$user}&pass={$pass}&id={$id}&Status={$status}&Queue={$queue}&Owner={$owne}&Requestors={$requestors}&Cc={$cc}&AdminCc={$adminCc}&Content={$content}&Subject={$subject}&Object-RT::Ticket--CustomField-10-Values={$field10}&Object-RT::Ticket--CustomField-26-Values={$field26}\n";    
		$request =  "POST http://rtdb1p/Ticket/Create.html?user={$user}&pass={$pass}&id={$id}&Status={$status}&Queue={$queue}&Owner={$owne}&Requestors={$requestors}&Cc={$cc}&AdminCc={$adminCc}&Content={$content}&Subject={$subject}&Object-RT::Ticket--CustomField-10-Values={$field10}&Object-RT::Ticket--CustomField-26-Values={$field26}\n";    
		
      		//echo "REQUEST $request\n";
		echo "\nSOCKETCONNECTION $socketConnection\n";
		echo ":: $domain , 80 , $errno, $errstr, $numberOfSeconds ::";
		
		if (fwrite($socketConnection, $request)) {
		  echo "\nTICKET CREATED FOR ALERT ID $thisTicket[7]\n";
			while (!feof($socketConnection)) {
		        	$tresponse = fread($socketConnection, 4096);
				if (preg_match("/<TITLE>/i", $tresponse)) {
				  echo "\n";
				  preg_match("/<TITLE>\#(\d*):.*<\/TITLE>/s", $tresponse, $ticketNumber);
				  echo "TICKET NUMBER : $ticketNumber[1] \n";
				}

		        }
		}
		#echo "$tresponse";
		echo;
		fclose($socketConnection);
	}
   }
   

?>
