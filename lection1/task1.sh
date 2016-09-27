ls -l | perl -lne 'if ($.>1) {$_=~ s/\s+/;/g; print $_}' | cat > 'result'
