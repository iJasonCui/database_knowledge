my %hash;
open FILE, "filename.txt" or die $!;
my $key;
while (my $line = <FILE>) {
     chomp($line);
     if ($line !~ /^\s/) {
        ($key) = $line =~ /^\S+/g;
        $hash{$key} = [];
     } else {
        $line =~ s/^\s+//;
        push @{ $hash{$key} }, $line;
     }
 }
 close FILE;
