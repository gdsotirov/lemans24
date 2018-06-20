#!/usr/bin/perl -w
# Extracts only results tables from Wikipedia HTML pages

use strict;

package MyHTMLParser;
use base "HTML::Parser";

my $fgResults = 0;
my $fgTable = 0;

sub text {
  my ($self, $text) = @_;
  if ( $fgTable && $text ne "" && $text ne " " )
  {
    print $text;
  }
}

sub start {
  my ($self, $tag, $attr, $attrseq, $origtext) = @_;

  if ( $tag =~ /^span$/
       && defined $attr->{'id'}
       && ( $attr->{'id'} =~ /^Official_results$/
           || $attr->{'id'} =~ /^Did_Not_Finish$/
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
    print "<img alt=\"".$attr->{'alt'}."\" />";
  }
  if ( $fgResults && $tag =~ /^br$/ )
  {
    print "|";
  }
  if ( $fgTable && ( $tag eq "tr" || $tag eq "th" || $tag eq "td" ) )
  {
    print $origtext;
  }
}

sub end {
  my ($self, $tag, $origtext) = @_;

  if ( $fgTable && $tag =~ /^table$/ )
  {
    print $origtext."\n";
    $fgTable = 0;
    $fgResults = 0;
  }
  if ( $fgTable && ( $tag eq "tr" || $tag eq "th" || $tag eq "td" ) )
  {
    print $origtext;
  }
}

if ( scalar @ARGV > 0 )
{
  my $p = new MyHTMLParser;
  $p->unbroken_text(1);
  $p->parse_file($ARGV[0]);
}

