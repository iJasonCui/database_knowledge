#!/usr/bin/perl -w

use strict;
use Finance::Quote;

#------------------------------------------------------------------
# Usage: ./show.pl nasdaq FB AAPL MSFT IBM  2>/dev/null 
#------------------------------------------------------------------

@ARGV >= 2 or die "Usage: $0 exchange symbol symbol symbol ...\n";

my $exchange = shift;  # Where do we fetch our stocks from.
my @symbols = @ARGV;   # Which stocks are we interested in.

#-----------------------------------------------------------------
#    Lable List
#----------------------------------------------------------------- 
#    name         Company or Mutual Fund Name
#    last         Last Price
#    high   Highest trade today
#    low    Lowest trade today
#    date         Last Trade Date  (MM/DD/YY format)
#    time         Last Trade Time
#    net          Net Change
#    p_change     Percent Change from previous day's close
#    volume       Volume
#    avg_vol      Average Daily Vol
#    bid          Bid
#    ask          Ask
#    close        Previous Close
#    open         Today's Open
#    day_range    Day's Range
#    year_range   52-Week Range
#    eps          Earnings per Share
#    pe           P/E Ratio
#    div_date     Dividend Pay Date
#    div          Dividend per Share
#    div_yield    Dividend Yield
#    cap          Market Capitalization
#    ex_div   Ex-Dividend Date.
#    nav          Net Asset Value
#    yield        Yield (usually 30 day avg)
#    exchange   The exchange the information was obtained from.
#-----------------------------------------------------------------

my $quoter = Finance::Quote->new();   # Create the F::Q object.

$quoter->timeout(30);   # Cancel fetch operation if it takes
# longer than 30 seconds.

# Grab our information and place it into %info.
my %info = $quoter->fetch($exchange,@symbols);

#--------------------------------------------------
# function: send mail
# send_mail($subject, $recipient,$email_file)
#--------------------------------------------------
sub send_mail
{
   my $cmd="mailx -s ".$_[0]." ".$_[1]." < ".$_[2];
   system($cmd);

}

foreach my $stock (@symbols) {
    unless ($info{$stock,"success"}) {
    warn "Lookup of $stock failed - ".$info{$stock,"errormsg"}."\n";
    next;
    }

    my $sql_file="sql.".$stock;

    open (MY_SQL_FILE, ">$sql_file");

    my $year=substr($info{$stock,"date"}, 6, 4);
    my $month=substr($info{$stock,"date"}, 0, 2);
    my $day=substr($info{$stock,"date"}, 3, 2);
    my $date=$year."-".$month."-".$day;
    my $date_time=$date." ".$info{$stock,"time"};

    print MY_SQL_FILE "use my_quote; INSERT INTO quote  ",
         "VALUES ( '",
          $stock, "',",
          $info{$stock,"last"}, ", ",
          $info{$stock,"high"}, ", ",
          $info{$stock,"low"},  ", ",
          $info{$stock,"net"}, ", ",
          $info{$stock,"p_change"},  ", ",
          $info{$stock,"volume"}, ", ",
          $info{$stock,"avg_vol"},  ", ",
          $info{$stock,"close"}, ", ",
          $info{$stock,"open"},  ", ", 
          "'", $date_time, "');\n";

    close(MY_SQL_FILE);

    my $mysql_cmd="cat ".$sql_file." | mysql -u root --password=63vette";
    system($mysql_cmd);


    #----------------------------------------------------------------------
    # screen 1:  p_change    Percent Change from previous day's close 
    # Threshold = 2
    #----------------------------------------------------------------------
    my $screen_in="LaCl"; 
    my $percent_last_close=$info{$stock,"p_change"};

    my $alert_msg_in=$stock." La ".$info{$stock,"last"}." P ".$percent_last_close;

    my $alert_sql_in="use my_quote; CALL qsp_insert_alert ( '".$stock."','".$screen_in."','".$alert_msg_in."',".$percent_last_close.",'".$date_time."');";

    send_alert($screen_in, $percent_last_close, $alert_msg_in, $alert_sql_in, $stock);

    #---------------------------------------------------------
    # screen 2: Percent Change from today's low to last 
    # Threshold = 2
    #---------------------------------------------------------
    $screen_in="LaLo";
    my $percent_last_low=sprintf "%.2f",($info{$stock,"last"} - $info{$stock,"low"})*100/$info{$stock,"low"};

    $alert_msg_in=$stock."P ".$percent_last_low."La".$info{$stock,"last"}."Lo".$info{$stock,"low"};

    $alert_sql_in="use my_quote; CALL qsp_insert_alert ('".$stock."','".$screen_in."','".$alert_msg_in."',".$percent_last_low.", '".$date_time."');";
 
    send_alert($screen_in, $percent_last_low, $alert_msg_in, $alert_sql_in, $stock);
    
}

#---------------------------------------------------------
# function: send alert
# send_alert( $screen, $percent, $alert_msg, $alert_sql, $stock)
#---------------------------------------------------------
sub send_alert
{
    my $screen=$_[0];
    my $percent=$_[1];
    my $alert_msg=$_[2];
    my $alert_sql=$_[3];
    my $stock_pass=$_[4]; 
     
    my $percent_change=2;
  
    if ( abs($percent) >= $percent_change ) {
  
         my $sms_file="sms_".$screen."_".$stock_pass;
         open  (MY_SMS_FILE, ">$sms_file");
         print  MY_SMS_FILE  "$alert_msg ", "\n";
         close (MY_SMS_FILE);
  
         my $sql_alert_file="sql_alert_".$screen."_".$stock_pass;
         open  (MY_SQL_ALERT, ">$sql_alert_file");
         print  MY_SQL_ALERT "$alert_sql ", "\n";
         close (MY_SQL_ALERT);
  
         my $sql_alert_out="sql_alert_".$screen."_".$stock_pass.".out";
         my $mysql_cmd="cat ".$sql_alert_file." | mysql -u root --password=63vette > ".$sql_alert_out ;
         system($mysql_cmd);
 
         open (MY_OUT, "$sql_alert_out");
 
         my @lines=<MY_OUT>;
 
         my $alert_flag=$lines[1];
 
         if ( $alert_flag == 1) {
             my $recipient="6472233071\@txt.bellmobility.ca";
             send_mail($screen, $recipient, $sms_file);
         }
 
         close (MY_OUT);
 
    }
}

__END__

