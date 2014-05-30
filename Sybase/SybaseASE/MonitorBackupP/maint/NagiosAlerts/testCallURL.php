#!/usr/local/bin/php -q
<?php

	$ticketCreationLogFile =  $argv[1];
   
   	$oneTicket = file($ticketCreationLogFile); 
	foreach($oneTicket as $line) {
        	$tresponse = $line;
        		//echo ":: $tresponse";
	        	if (preg_match("/<TITLE>/i", $tresponse)) {
	        		echo "\n\n\nGASIT !!!!!!!!!!!!!!!!\n\n\n";
			        preg_match("/<TITLE>\#(\d*):.*<\/TITLE>/s", $tresponse, $ticketNumber);
				echo "ticketNumber : $ticketNumber[1] \n";
			}
				
	}
	echo;
//<TITLE>#55932: SMS Block</TITLE>
// http://rtdb1p/Ticket/Create.html?user=NOC&pass=chicken&Queue=18&id=new&Status=new&Owner=674&Requestors=Requestor name text&Cc=test@lavalife.com&AdminCc=adrian.alb@lavalife.com&Subject=THIS IS A TEST&Object-RT::Ticket--CustomField-10-Values=1&Object-RT::Ticket--CustomField-26-Values=1&Content=THIS IS A TEST.HERE COMES THE DESCRIPTION
?>
