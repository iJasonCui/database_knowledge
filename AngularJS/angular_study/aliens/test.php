#!/usr/bin/php -q

<?php

// CONNECT TO THE DATABASE
	$DB_NAME = 'aliendatabase';
	$DB_HOST = 'localhost';
	$DB_USER = 'cron_sa';
	$DB_PASS = '63vette';
	
	$mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
	
	if (mysqli_connect_errno()) {
		printf("Connect failed: %s\n", mysqli_connect_error());
		exit();
	}

// A QUICK QUERY ON A FAKE USER TABLE
	$query = "SELECT * FROM test_table WHERE col1 = 1";
	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);

// GOING THROUGH THE DATA
	if($result->num_rows > 0) {
              printf("Connect succceed %s\n", $result->num_rows);               
	      while($row = $result->fetch_assoc()) {
                        printf("Col1 is %s\n", $row['col1'] );	
         	}
	}
	else {
		echo 'NO RESULTS';	
	}
	
// CLOSE CONNECTION
	mysqli_close($mysqli);
	
?>
