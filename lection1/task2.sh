cat result | perl -le 'my $bigf=0; while(<>) {chomp $_; my @sp=split(/;/,$_,0); if ($sp[4]>1048576) {print $sp[8]; $bigf+=1}}; print $.." ".$bigf' 
