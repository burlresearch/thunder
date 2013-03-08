#!/usr/bin/perl
## To install module (linux)
# sudo perl -MCPAN -e 'install Text::CSV'
# sudo cpanm IO::Prompt

use Text::CSV;
use IO::Prompt;

%ages = (
"Adult" => 'ad',
"Junior" => 'jr',
"Petite" => 'pt',
"Senior" => 'sr',
"Teen" => 'tn'
);

%types = (
  "Acrobatic" => 'acro',
  "Ballet" => 'ballet',
  "Character" => 'char',
  "Contemporary" => 'cntmp',
  "Hip Hop" => 'hhop',
  "Jazz" => 'jazz',
  "Lyrical/Modern" => 'lyr',
  "Musical Theater" => 'thtr',
  "Open" => 'open',
  "Pointe" => 'pointe',
  "Production" => 'prod',
  "Tap" => 'tap',
  "Vocal" => 'vcl'
);

my $comp_city = prompt("Enter a suffix/code for the competition city: ");
my $outfile = length($comp_city) > 0 ? $outfile = "thunder-" . $comp_city . ".pl" : 'thunder.pl';

my $fn = prompt("Choose an input file: ", -lm=>[<*.csv>], -speed=>0.4);

my $csv = Text::CSV->new() or die "Cannot use CSV: ".Text::CSV->error_diag();

open my $io, "<:encoding(utf8)", $fn or die "$fn: $!\n";
open VIDS, ">:encoding(utf8)", $outfile or die "$outfile: $!\n";

$csv->column_names($csv->getline($io));   # performanceOrder,routineName,ageCategory,subject

print VIDS "#!/usr/bin/perl\n\n\@an = (\n";

while((my $row = $csv->getline($io))) {
  my @columns = @$row;
  my ($cnum, $cname, $cage, $ctype) = @columns[0..3];

  $cnum = sprintf("%03d",$cnum);

  $cname =~ s/"//g;
  $cname =~ s/\s+([[:punct:]])\s+/$1/g;
  $cname =~ s/^\s*(.*?)\s*$/$1/;    # TRIM $cname
  $cname =~ s/ /_/g;

  my $vtyp = $types{$ctype} ? $types{$ctype} : lc($ctype);

  # my $vid = "$cnum-$cname-$ages{$cage}_$vtyp.mts";
  my $vid = "$cnum-$cname-$ages{$cage}_$vtyp";
  $vid =~ s/[-_]*$//;
  $vid .= ".mts";
  
  print "$cnum | $cname | $cage | $ctype => $vid\n";
  print VIDS "  \"$vid\",\n";
}

print VIDS <<EOF;
);

\@fn = <*.MTS>;

if (\$#an != \$#fn) {
  print "I/O count mismatch:\\nfiles: \$#fn\\nnames: \$#an\\n";
} else {
  for (\$i=0; \$i <= \$#fn; \$i++) {
    rename \$fn[\$i], \$an[\$i];
    printf("%3d %s -> %s\\n", \$i, \$fn[\$i], \$an[\$i]);
  }
  print "Converted: \$i files.\\n";
}
EOF

close VIDS;
close $io;
chmod 0755, $outfile;

