#!/usr/bin/perl -w

use strict;

my @param=@ARGV;
print "$0\n$param[0]\n";


my $server=$param[0];


my %SectionKey;
my %SectionValue;
my $time;
#my(@d)=(localtime)[0,1,2,3,4,5];
#my $date=sprintf("%04d%02d%02d%02d02d%02d",$d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0]);
#my $logfile=$server.".".$date;


$time=localtime(time);
$SectionKey{"Kernel Utilization - Average"}="Average";
$SectionKey{"Commited Xacts per sec"}="Committed Xacts";
$SectionKey{"Total Rows Affected per sec"}="Total Rows Affected";
$SectionKey{"Total Lock Requests per sec"}="Total Lock Requests";
$SectionKey{"Avg Lock Contention per sec"}="Avg Lock Contention";
$SectionKey{"Total Cache Hits % of total"}="Total Cache Hits";
$SectionKey{"Total Req Disk I/Os per sec"}="Total Requested Disk I/Os";




while (<STDIN>){
 foreach my $key (keys %SectionKey){
   my $l=$_;
   my $k=$SectionKey{$key};
   if ($k =~ /Cache/){
     if ($l =~ /($k)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)/ ) {
       $SectionValue{$key}=$9;
       print"$server\t$time\t\"$key\"\t\t$SectionValue{$key}  \n";
     }
   } else {
     if ($l =~ /($k)(\s+)(\S+)/ ) {
       $SectionValue{$key}=$3;
       print"$server\t$time\t\"$key\"\t\t$SectionValue{$key}  \n";
     }
   }
 }
}
