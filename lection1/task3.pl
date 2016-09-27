open (INPUT,"result");
my @array; 
while(<INPUT>) {
	chomp $_; 
	my @temp=split(/;/,$_,0); 
	my $i=0; 
	foreach $data (@temp) {
		$array[$.-1][$i]=$data; 
		$i+=1
		}
	}; 
use Data::Dumper; 
print Dumper(@array);
use DDP;
p @array;
