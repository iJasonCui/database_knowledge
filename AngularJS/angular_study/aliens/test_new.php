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
	$query = "insert test_table values (3)";
	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);

// CLOSE CONNECTION
	mysqli_close($mysqli);
	
?>
