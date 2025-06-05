#!/usr/bin/perl -w
# Extracts only results tables from Wikipedia HTML pages

use strict;

package MyHTMLParser;
use base "HTML::Parser";

my $fgResults = 0;
my $fgTable = 0;
my $fgPrint = 1;
my $fgTitle = 0;
my $fgBridgestone = 0;
my $fgKumho = 0;

my @tagsCopy = qw( body head html meta title );
my @tagsTablePrint = qw( td th tr );
my @tagsTableSkip = qw( caption style sup );
my %tagsCopy = map { $_ => 1 } @tagsCopy;
my %tagsTablePrint = map { $_ => 1 } @tagsTablePrint;
my %tagsTableSkip = map { $_ => 1 } @tagsTableSkip;

sub text {
  my ($self, $text) = @_;
  if ( $fgTitle || ( $fgTable && $fgPrint && $text ne "" && $text ne " " ) )
  {
    print $text;
  }
}

sub start {
  my ($self, $tag, $attr, $attrseq, $origtext) = @_;

  if ( $tag eq "title" ) {
    $fgTitle = 1;
  }
  if ( exists($tagsCopy{$tag}) )
  {
    my $nl = "";
    if ( $origtext !~ /\n$/ && $tag ne "title" )
    {
      $nl = "\n";
    }
    print($origtext.$nl);
  }
  if ( $tag =~ /^h[2-3]$/
       && defined $attr->{'id'}
       && (   $attr->{'id'} =~ /^Official_results/i
           || $attr->{'id'} =~ /^Results$/i
           || $attr->{'id'} =~ /^Race_results?$/i
           || $attr->{'id'} =~ /^Race_classification/i
           || $attr->{'id'} =~ /^Disqualified$/i
           || $attr->{'id'} =~ /^Not_classified/i
           || $attr->{'id'} =~ /^Did_Not_Finish/i
           || $attr->{'id'} =~ /^Did_Not_Start/i
           || $attr->{'id'} =~ /^Did_Not_Practise/i
           || $attr->{'id'} =~ /^Schlussklassement$/i
           || $attr->{'id'} =~ /^Nur_in_der_Meldeliste$/i
           || $attr->{'id'} =~ /^Meldeliste$/i
           || $attr->{'id'} =~ /^Entry_list$/i
           || $attr->{'id'} =~ /^Reserve_entries$/i
          )
     )
  {
    $fgResults = 1;
  }
  if ( $fgResults && $tag =~ /^table$/ && defined $attr->{'class'} && $attr->{'class'} =~ /^wikitable/ )
  {
    $fgTable = 1;
    print $origtext;
  }
  if ( $fgResults && $tag =~ /^img$/ )
  {
    print "<img alt=\"".$attr->{'alt'}."\" src=\"".$attr->{'src'}."\" />";
  }
  if ( $fgResults && $tag =~ /^br$/ )
  {
    print "|";
  }
  if ( $fgTable )
  {
    if ( exists($tagsTablePrint{$tag}) )
    {
      print $origtext;
    }
    if ( exists($tagsTableSkip{$tag}) )
    {
      $fgPrint = 0;
    }
    if ( $tag eq "span" && exists($attr->{'style'}) && $attr->{'style'} eq "display:none;" )
    {
      $fgPrint = 0;
    }
    if ( $tag eq "a" )
    {
      print " ";
    }
    if ( $tag eq "a" && exists($attr->{'title'}) && $attr->{'title'} eq "Bridgestone" )
    {
      $fgBridgestone = 1;
    }
    if ( $tag eq "a" && exists($attr->{'title'}) && $attr->{'title'} eq "Kumho Tires" )
    {
      $fgKumho = 1;
    }
  }
}

sub end {
  my ($self, $tag, $origtext) = @_;

  if ( $tag eq "title" ) {
    $fgTitle = 0;
  }
  if ( exists($tagsCopy{$tag}) )
  {
    my $nl = "";
    if ( $origtext !~ /\n$/ )
    {
      $nl = "\n";
    }
    print($origtext.$nl);
  }
  if ( $fgTable )
  {
    if ( $tag =~ /^table$/ )
    {
      print $origtext."\n";
      $fgTable = 0;
#     $fgResults = 0;
    }
    if ( exists($tagsTablePrint{$tag}) )
    {
      print $origtext;
    }
    if ( exists($tagsTableSkip{$tag}) )
    {
      $fgPrint = 1;
    }
#   if ( $tag eq "span" && $fgPrint == 0 )
#   {
#     $fgPrint = 1;
#   }
    if ( $fgBridgestone && $tag eq "span" )
    {
      print "R";
      $fgBridgestone = 0;
    }
    if ( $fgKumho && $tag eq "span" )
    {
      print "H";
      $fgKumho = 0;
    }
  }
}

if ( scalar @ARGV > 0 )
{
  my $p = new MyHTMLParser;
  $p->unbroken_text(1);
  $p->parse_file($ARGV[0]);
}

