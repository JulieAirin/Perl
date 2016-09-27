ls -l | perl -lne 'if ($.>1) {for (my $i=1; $i<9; $i+=1) {$_=~ s/\s+/;/}; print $_}' | cat > result
