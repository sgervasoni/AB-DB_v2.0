#!/usr/bin/perl
#
#.DATE:   8 Giugno 2006
#.PURPOSE: Fare la lista di freq e int dall'output di Gaussian
#
#use warnings;

$filein1 = $ARGV[0];
$filein2 = $ARGV[1];

open (FILE1,"<$filein1");
open (FILE2,"<$filein2");

while ($line1 = <FILE1>)
  {
    $line2 = <FILE2>;
    chomp $line1;
    chomp $line2;

    @line1 = split " ", $line1;
    @line2 = split " ", $line2;

    printf("%.4f %.4f\n%.4f %.4f\n%.4f %.4f\n", 
           $line1[2],$line2[3],
	   $line1[3],$line2[4],
	   $line1[4],$line2[5]);
   }
