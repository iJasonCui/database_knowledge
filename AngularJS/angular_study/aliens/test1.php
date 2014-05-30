#!/usr/bin/php -q

<?php
$con=mysqli_connect("localhost","cron_sa","63vette","aliendatabase");

// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

mysqli_close($con);
?>
