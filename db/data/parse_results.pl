#!/usr/bin/perl -w
# Parse results tables and dump as CSV

use strict;
use HTML::TreeBuilder 3;  # make sure our version isn't ancient

# Column names and indexes
my %columns = (
  "Year"    => 0,
  "Pos"     => 1,
  "Class"   => 2,
  "No"      => 3,
  "TeamCtry"=> 4,
  "Team"    => 5,
  "DrCtry"  => 6,
  "Drivers" => 7,
  "Chassis" => 8,
  "Engine"  => 9,
  "Tyres"   => 10,
  "Laps"    => 11,
  "Distance"=> 12,
  "Time"    => 13,
  "Reason"  => 14);
my @pos_codes_arr = (
  "DNA", # Did Not Attend
  "DNF", # Did Not Finish
  "DNP", # Did Not Practice
  "DNS", # Did Not Start
  "DNQ", # Did Not Qualify
  "DSQ", # Disqualified
  "NC" , # Not classified
  "RES"  # Reserve
);
my %pos_codes = map { $_ => 1 } @pos_codes_arr;
my %ctry_iso = (
  "ARGENTINA"           => "ARG",
  "AUSTRALIA"           => "AUS",
  "AUSTRIA"             => "AUT",
  "BAHAMAS"             => "BHS",
  "BELGIUM"             => "BEL",
  "BOLIVIA"             => "BOL",
  "BRAZIL"              => "BRA",
  "CANADA"              => "CAN",
  "CHILE"               => "CHL",
  "COLOMBIA"            => "COL",
  "CUBA"                => "CUB",
  "CZECH REPUBLIC"      => "CZE",
  "CZECHOSLOVAKIA"      => "CSHH",
  "DENMARK"             => "DNK",
  "DOMINICAN REPUBLIC"  => "DOM",
  "EAST GERMANY"        => "DDDE",
  "ECUADOR"             => "ECU",
  "EL SALVADOR"         => "SLV",
  "FINLAND"             => "FIN",
  "FRANCE"              => "FRA",
  "GEORGIA"             => "GEO",
  "GERMANY"             => "DEU",
  "GREECE"              => "GRC",
  "GUATEMALA"           => "GTM",
  "HONG KONG"           => "HKG",
  "IRELAND"             => "IRL",
  "ITALY"               => "ITA",
  "JAPAN"               => "JPN",
  "LIECHTENSTEIN"       => "LIE",
  "LUXEMBOURG"          => "LUD",
  "MALAYSIA"            => "MYS",
  "MEXICO"              => "MEX",
  "MONACO"              => "MCO",
  "MOROCCO"             => "MAR",
  "NETHERLANDS"         => "NLD",
  "NEW ZEALAND"         => "NZL",
  "NORWAY"              => "NOR",
  "PANAMA"              => "PAN",
  "POLAND"              => "POL",
  "PORTUGAL"            => "PRT",
  "PUERTO RICO"         => "PRI",
  "REPUBLIC OF IRELAND" => "IRL",
  "ROMANIA"             => "ROU",
  "RUSSIA"              => "RUS",
  "SAUDI ARABIA"        => "SAU",
  "SCOTLAND"            => "SCO",
  "SLOVAKIA"            => "SVK",
  "SLOVENIA"            => "SVN",
  "SOUTH AFRICA"        => "ZAF",
  "SOUTHERN RHODESIA"   => "RHZW",
  "SPAIN"               => "ESP",
  "SWEDEN"              => "SWE",
  "SWITZERLAND"         => "CHE",
  "THAILAND"            => "THA",
  "UNITED KINGDOM"      => "GBR",
  "UNITED STATES"       => "USA",
  "VENEZUELA"           => "VEN",
  "WEST GERMANY"        => "DEU");
my %tyre_codes = (
  "A"  => "Avon",
  "B"  => "Barum",
  "BF" => "BF Goodrich",
  "C"  => "Continental",
  "D"  => "Dunlop",
  "E"  => "Englebert",
  "F"  => "Firestone",
  "G"  => "Goodyear",
  "I"  => "India",
  "K"  => "Kleber",
  "M"  => "Michelin",
  "P"  => "Pirelli",
  "R"  => "Rapson");

# trim string from both sides
sub trimboth {
  my $str = shift;

  $str =~ s/^\s+|\s+$//g;

  return $str;
}

if ( scalar @ARGV < 1 )
{
  die "Usage: $0 <file_name|year>\n";
}

my $race_yr;
my $root = HTML::TreeBuilder->new();

# process standard input
if ( $ARGV[0] =~ /^[0-9]{4}$/ ) {
  $race_yr = $ARGV[0];
  while(<STDIN>) {
    $root->parse($_);
  }
  $root->eof();
}
elsif ( -e $ARGV[0] ) {
  $race_yr = $ARGV[0];
  $race_yr =~ s/[^0-9]//g;

  $root->parse_file($ARGV[0]);
}
else {
  die "Error: File '".$ARGV[0]."' not found!\n";
}

my @outarr;
my $outarr_idx = 0;
# build header
for ( keys %columns ) {
  $outarr[$outarr_idx][$columns{$_}] = $_;
}
$outarr_idx++;

my @tables = $root->find_by_tag_name('table');
foreach my $tab (@tables) {
  if ( $tab->attr('class') eq 'wikitable' )
  {
    my @rows = $tab->content_list();
    my %headers = ();
    my $row_idx = 1;
    foreach my $row (@rows) {
      my @cells = $row->content_list();
      my $col_idx = 1;

      # skip rows where sources or 70% of winner's race distance are given
      if ( defined $cells[0]->attr('colspan') &&
           $cells[0]->attr('colspan') > 8
           && (   $cells[0]->as_text() =~ /Sources/g
               || $cells[0]->as_text() =~ /race distance/g
              )
         )
      {
        next;
      }

      # initialize columns in output array for each row
      if ( $row_idx > 1 ) {
        for (keys %columns) {
          $outarr[$outarr_idx][$columns{$_}] = "";
        }
        $outarr[$outarr_idx][0] = $race_yr;
      }
      else {
        $outarr_idx--;
      }

      foreach my $cell (@cells) {
        my $txt = "";

        # parse header and store column indexes
        if ( $row_idx == 1 ) {
          my $title = $cell->as_text();
          if ( $title =~ /Pos\.?/ ) {
            $headers{'Pos'} = $col_idx;
          }
          elsif ( $title eq "Class" ) {
            $headers{'Class'} = $col_idx;
          }
          elsif ( $title =~ /No\.?/ ) {
            $headers{'No'} = $col_idx;
          }
          elsif ( $title eq "Team" ) {
            $headers{'Team'} = $col_idx;
          }
          elsif ( $title eq "Drivers" ) {
            $headers{'Drivers'} = $col_idx;
          }
          elsif ( $title eq "Chassis" ) {
            $headers{'Chassis'} = $col_idx;
          }
          elsif ( $title eq "Engine" ) {
            $headers{'Engine'} = $col_idx;
          }
          elsif ( $title =~ /Tyres?/ ) {
            $headers{'Tyres'} = $col_idx;
          }
          elsif ( $title eq "Laps" ) {
            $headers{'Laps'} = $col_idx;
          }
          elsif ( $title eq "Reason" ) {
            $headers{'Reason'} = $col_idx;
          }

          $col_idx++;
          next;
        }

        if ( $col_idx == $headers{'Pos'} ) { # parse position
          my $pos = $cell->as_text();
          $pos =~ s/^\s+|\s+$//g;
          $pos =~ s/[^0-9a-zA-Z]//g;
          if ( $pos eq "Reserve" ) {
            $pos = "RES";
          }
          if ( exists($pos_codes{$pos}) ) {
            $txt = $pos;
          }
          else {
            $pos =~ /([0-9]+)/;
            $txt = $1;
          }
          $outarr[$outarr_idx][$columns{'Pos'}] = $txt;
        }
        # do not split class
        elsif ( $col_idx == $headers{'Class'} ) {
          my @lns = split(/[\|\s]/, $cell->as_text());
          $txt = join("", @lns);
          $outarr[$outarr_idx][$columns{'Class'}] = $txt;
        }
        # strip car number (leave only digits)
        elsif ( $col_idx == $headers{'No'} ) {
          $txt = $cell->as_text();
          $txt =~ s/[^0-9]//g;
          $outarr[$outarr_idx][$columns{'No'}] = $txt;
        }
        # extract team and driver countries into separate columns
        elsif ( $col_idx == $headers{'Team'} || $col_idx == $headers{'Drivers'} ) {
          my @imgs = $cell->find_by_tag_name('img'); 
          my $ctries = "";
          foreach my $img (@imgs) { # build countries list
            $txt = $img->attr('alt');
            # Handle special values
            if ( $txt eq "Flag of the Georgian Soviet Socialist Republic.svg" ) {
              $txt = "Georgia";
            }
            elsif ( $txt eq "Canadian Red Ensign (1921–1957).svg" ) {
              $txt = "Canada";
            }
            elsif ( $txt eq "Federation of Rhodesia and Nyasaland" ) {
              $txt = "Southern Rhodesia";
            }
            elsif ( $txt eq "The Bahamas" ) {
              $txt = "Bahamas";
            }
            if ( $ctries ne "" ) {
             $ctries .= "|".$ctry_iso{uc($txt)};
            }
            else {
              $ctries = $ctry_iso{uc($txt)};
            }
          }
          #print $ctries.",";
          if ( $col_idx == $headers{'Team'} ) {
            $outarr[$outarr_idx][$columns{'TeamCtry'}] = $ctries;
          }
          else {
            $outarr[$outarr_idx][$columns{'DrCtry'}] = $ctries;
          }

          if ( $ctries =~ /\|/ ) {
            my @lns = split(/\|/, $cell->as_text());
            s{^\s+|\s+$}{}g, s{\s*\/\s*}{}g foreach @lns;
            $txt = join("|", @lns);
          }
          else {
            $txt = trimboth($cell->as_text());
            $txt =~ s/\|//g;
          }
          $txt =~ s/\|\(private/ (private/g;

          if ( $col_idx == $headers{'Team'} ) {
            $outarr[$outarr_idx][$columns{'Team'}] = $txt;
          }
          else {
            $outarr[$outarr_idx][$columns{'Drivers'}] = $txt;
          }
        }
        elsif ( $col_idx == $headers{'Chassis'} ) {
          $txt = trimboth($cell->as_text());
          $txt =~ s/\|//g;
          $outarr[$outarr_idx][$columns{'Chassis'}] = $txt;
        }
        elsif ( $col_idx == $headers{'Engine'} ) {
          $txt = trimboth($cell->as_text());
          $txt =~ s/\|//g;
          $outarr[$outarr_idx][$columns{'Engine'}] = $txt;
        }
        elsif ( defined $headers{'Tyres'} && $col_idx == $headers{'Tyres'} ) {
          my $tyres = trimboth($cell->as_text());
          $tyres =~ s/[^a-zA-Z]//g;
          if ( $tyres =~ /[A-Z]/ ) { # if only one capital letter search in codes
            $outarr[$outarr_idx][$columns{'Tyres'}] = $tyre_codes{$tyres};
          }
          else {
            $outarr[$outarr_idx][$columns{'Tyres'}] = $tyres;
          }
        }
        elsif ( defined $headers{'Laps'} && $col_idx == $headers{'Laps'} ) {
          $outarr[$outarr_idx][$columns{'Laps'}] = trimboth($cell->as_text());
        }
        elsif ( defined $headers{'Reason'} && $col_idx == $headers{'Reason'} ) {
          $txt = trimboth($cell->as_text());
          $txt =~ s/\|//g;
          if ( $txt =~ /\((\d+)hr\)$/g ) {
            my $ret_hr = $1; 
            $ret_hr--;
            $outarr[$outarr_idx][$columns{'Time'}] = "$ret_hr:00:00";
            $txt =~ s/\s*\(\d+hr\)$//g;
          }
          $outarr[$outarr_idx][$columns{'Reason'}] = ucfirst($txt);
        }

        $col_idx++;
      }
      $row_idx++;
      $outarr_idx++;
    }
  }
}

# Dump results table as CSV
for my $row ( @outarr ) {
  print join(';', map { defined ? $_ : '' }
                  map { s/“/"/; $_ }
                  map { s/”/"/; $_ }
                  map { s/‘/'/; $_ }
                  map { s/’/'/; $_ }
                  @$row ), "\n";
}

$root->delete; # erase this tree because we're done with it

