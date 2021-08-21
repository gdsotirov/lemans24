#!/usr/bin/perl -w
# Extracts only results tables from Wikipedia HTML pages

use strict;

package MyHTMLParser;
use base "HTML::Parser";

my $fgResults = 0;
my $fgTable = 0;
my $fgPrint = 1;
my $fgBridgestone = 0;
my $fgKumho = 0;

sub text {
  my ($self, $text) = @_;
  if ( $fgTable && $fgPrint && $text ne "" && $text ne " " )
  {
    print $text;
  }
}

sub start {
  my ($self, $tag, $attr, $attrseq, $origtext) = @_;

  if ( $tag =~ /^span$/
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
  if ( $fgResults && $tag =~ /^table$/ )
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
    if ( $tag eq "tr" || $tag eq "th" || $tag eq "td" ) 
    {
      print $origtext;
    }
    if ( $tag eq "sup" )
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

  if ( $fgTable )
  {
    if ( $tag =~ /^table$/ )
    {
      print $origtext."\n";
      $fgTable = 0;
      $fgResults = 0;
    }
    if ( $tag eq "tr" || $tag eq "th" || $tag eq "td" )
    {
      print $origtext;
    }
    if ( $tag eq "sup" )
    {
      $fgPrint = 1;
    }
    if ( $tag eq "span" && $fgPrint == 0 )
    {
      $fgPrint = 1;
    }
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

