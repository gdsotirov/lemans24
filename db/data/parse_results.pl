#!/usr/bin/perl -w
# Parse results tables and dump as CSV

use strict;
use warnings;
use utf8;
use open ( ":encoding(UTF-8)", ":std" );
use HTML::TreeBuilder 3;  # make sure our version isn't ancient
use Encode qw/encode decode/;

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
  "DQ" , # Disqualified
  "NC" , # Not classified
  "RES"  # Reserve
);
my %pos_codes = map { $_ => 1 } @pos_codes_arr;
my %ctry_iso = (
  "ANGOLA"              => "AGO",
  "ARGENTINA"           => "ARG",
  "AUSTRALIA"           => "AUS",
  "AUSTRIA"             => "AUT",
  "BAHAMAS"             => "BHS",
  "BELGIUM"             => "BEL",
  "BOLIVIA"             => "BOL",
  "BRAZIL"              => "BRA",
  "BULGARIA"            => "BGR",
  "CANADA"              => "CAN",
  "CHILE"               => "CHL",
  "CHINA"               => "CHN",
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
  "INDIA"               => "IND",
  "IRELAND"             => "IRL",
  "ITALY"               => "ITA",
  "JAPAN"               => "JPN",
  "LATVIA"              => "LVA",
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
  "PHILIPPINES"         => "PHL",,
  "POLAND"              => "POL",
  "PORTUGAL"            => "PRT",
  "PUERTO RICO"         => "PRI",
  "REPUBLIC OF IRELAND" => "IRL",
  "ROMANIA"             => "ROU",
  "RUSSIA"              => "RUS",
  "SAUDI ARABIA"        => "SAU",
  "SAN MARINO"          => "SMR",
  "SCOTLAND"            => "SCO",
  "SINGAPORE"           => "SGP",
  "SLOVAKIA"            => "SVK",
  "SLOVENIA"            => "SVN",
  "SOUTH AFRICA"        => "ZAF",
  "SOUTH KOREA"         => "KOR",
  "SOUTHERN RHODESIA"   => "RHZW",
  "SPAIN"               => "ESP",
  "SWEDEN"              => "SWE",
  "SWITZERLAND"         => "CHE",
  "TAIWAN"              => "TWN",
  "THAILAND"            => "THA",
  "TURKEY"              => "TUR",
  "UNITED ARAB EMIRATES"=> "ARE",
  "UNITED KINGDOM"      => "GBR",
  "UNITED STATES"       => "USA",
  "VENEZUELA"           => "VEN",
  "WEST GERMANY"        => "DEU");
my %ctry_iso_de = (
  "ARGENTINIEN"             => "ARG",
  "AUSTRALIEN"              => "AUS",
  "ÖSTERREICH"              => "AUT",
  "BELGIEN"                 => "BEL",
  "BOLIVIEN"                => "BOL",
  "BRASILIEN"               => "BRA",
  "BULGARIEN"               => "BGR",
  "KANADA"                  => "CAN",
  "KOLUMBIEN"               => "COL",
  "KUBA"                    => "CUB",
  "TSCHECHIEN"              => "CZE",
  "TSCHECHOSLOWAKEI"        => "CSHH",
  "DÄNEMARK"                => "DNK",
  "DOMINIKANISCHE REPUBLIK" => "DOM",
  "DEUTSCHE DEMOKRATISCHE REPUBLIK" => "DDDE",
  "FINNLAND"                => "FIN",
  "FRANKREICH"              => "FRA",
  "GEORGIEN"                => "GEO",
  "DEUTSCHLAND"             => "DEU",
  "GRIECHENLAND"            => "GRC",
  "HONGKONG"                => "HKG",
  "INDIEN"                  => "IND",
  "IRLAND"                  => "IRL",
  "ITALIEN"                 => "ITA",
  "LETTLAND"                => "LVA",
  "MEXIKO"                  => "MEX",
  "MAROKKO"                 => "MAR",
  "NIEDERLANDE"             => "NLD",
  "NEUSEELAND"              => "NZL",
  "NORWEGEN"                => "NOR",
  "PHILIPPINEN"             => "PHL",
  "POLEN"                   => "POL",
  "RUMÄNIEN"                => "ROU",
  "RUSSLAND"                => "RUS",
  "SAUDI-ARABIEN"           => "SAU",
  "SINGAPUR"                => "SGP",
  "SLOWAKEI"                => "SVK",
  "SLOWENIEN"               => "SVN",
  "SÜDAFRIKA"               => "ZAF",
  "SÜDKOREA"                => "KOR",
  "SPANIEN"                 => "ESP",
  "SCHWEDEN"                => "SWE",
  "SCHWEIZ"                 => "CHE",
  "TÜRKEI"                  => "TUR",
  "VEREINIGTES KÖNIGREICH"  => "GBR",
  "VEREINIGTE ARABISCHE EMIRATE" => "ARE",
  "VEREINIGTE STAATEN"      => "USA",
  "VENEZUELA"               => "VEN",
  "VOLKSREPUBLIK CHINA"     => "CHN");
my %tyre_codes = (
  "A"  => "Avon",
  "B"  => "Barum",
  "BF" => "BF Goodrich",
  "BR" => "Bridgestone",
  "C"  => "Continental",
  "D"  => "Dunlop",
  "E"  => "Englebert",
  "F"  => "Firestone",
  "G"  => "Goodyear",
  "H"  => "Hankook",
  "I"  => "India",
  "K"  => "Klèber",
  "KH" => "Kumho",
  "M"  => "Michelin",
  "P"  => "Pirelli",
  "R"  => "Rapson",
  "Y"  => "Yokohama");

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

my $rowspan = 0;
my @tables = $root->find_by_tag_name('table');
foreach my $tab (@tables) {
  if ( $tab->attr('class') =~ 'wikitable' )
  {
    my @rows = $tab->content_list();
    my %headers = ();
    my $row_idx = 1;
    foreach my $row (@rows) {
      my @cells = $row->content_list();
      my $col_idx = 1;

      # skip rows where sources or 70% of winner's race distance are given
      if ( defined $cells[0]->attr('colspan') &&
           $cells[0]->attr('colspan') >= 8
         )
      {
        next;
      }

      # If rows are not spanned, initialize columns in output array for each row after the first
      # If rows are spanned, initialize columns in output array for each odd row after the first two
      if ( ( $rowspan == 0 && $row_idx > 1) || ( $rowspan == 2 && $row_idx > $rowspan && ($row_idx % 2) != 0 ) ) {
        for (keys %columns) {
          $outarr[$outarr_idx][$columns{$_}] = "";
        }
        $outarr[$outarr_idx][0] = $race_yr;
      }

      foreach my $cell (@cells) {
        my $txt = "";

        # parse header and store column indexes
        if ( $row_idx == 1 || ( $row_idx == $rowspan ) ) {
          my $title = trimboth($cell->as_text());
          if ( $title =~ /^Pos\.?/ ) {
            $headers{'Pos'} = $col_idx;
          }
          elsif ( $title eq "Class" || $title eq "Klasse" ) {
            $headers{'Class'} = $col_idx;
          }
          elsif ( $title =~ /No\.?/ || $title =~ /Nr\.?/ ) {
            $headers{'No'} = $col_idx;
          }
          elsif ( $title eq "Team" ) {
            $headers{'Team'} = $col_idx;
          }
          elsif ( $title eq "Drivers" || $title eq "Fahrer" ) {
            $headers{'Drivers'} = $col_idx;
          }
          elsif ( $title eq "Chassis" ) {
            $headers{'Chassis'} = $col_idx;
          }
          elsif ( $title eq "Engine" || $title eq "Motor" ) {
            $headers{'Engine'} = $col_idx;
          }
          elsif ( $title =~ /Tyres?/ || $title eq "Reifen" ) {
            $headers{'Tyres'} = $col_idx;
          }
          elsif ( $title eq "Laps" || $title eq "Runden" ) {
            $headers{'Laps'} = $col_idx;
          }
          elsif ( $title eq "Reason" ) {
            $headers{'Reason'} = $col_idx;
          }

          if ( $row_idx == 1 && defined $cell->attr('rowspan') ) {
            if ( $cell->attr('rowspan') == 2 && $rowspan == 0 ) {
              $rowspan = 2;
            }
          }

          $col_idx++;
          next;
        }

        # If rows are spanned process odd rows first
        if ( $rowspan == 0 || ( $rowspan == 2 && ($row_idx % 2) == 1 ) ) {
          if ( $col_idx == $headers{'Pos'} ) { # parse position
            my $pos = trimboth($cell->as_text());
            my $pos_str = $pos;
            $pos_str =~ s/[^a-zA-Z]//g;

            if ( $pos_str ne "" ) {
              if ( $pos_str eq "Reserve" ) {
                $pos_str = "RES";
              }
              elsif ( $pos_str eq "DQ" ) {
                $pos_str = "DSQ";
              }
              elsif ( $pos_str eq "EX" ) {
                $pos_str = "DSQ";
              }
              elsif ( $pos_str eq "WD" ) {
                $pos_str = "DNS";
                $outarr[$outarr_idx][$columns{'Reason'}] = "Withdrawn";
              }

              if ( exists($pos_codes{$pos_str}) ) {
                $txt = $pos_str;
              }
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
              my $ctry_code = "";
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
  
              if ( exists($ctry_iso{uc($txt)}) ) {
                $ctry_code = $ctry_iso{uc($txt)};
              }
              elsif ( exists($ctry_iso_de{uc($txt)}) ) {
                $ctry_code = $ctry_iso_de{uc($txt)};
              }
              else {
                $ctry_code = "???"; # unknown
              }
  
              if ( $ctries ne "" ) {
               $ctries .= "|".$ctry_code;
              }
              else {
                $ctries = $ctry_code;
              }
            }
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
              $txt =~ s/^\"//g;
              $txt =~ s/\"$//g;
              $txt =~ s/\-\s/-/g;
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
            $txt = trimboth($cell->as_text());
            $txt =~ s/^[\-–]$/0/g; # dash and en dash
            $outarr[$outarr_idx][$columns{'Laps'}] = $txt;
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
        }
        else { # then process even rows with only column Engine
          if ( $col_idx == $headers{'Engine'} ) {
            $txt = trimboth($cell->as_text());
            $txt =~ s/\|//g;
            $outarr[$outarr_idx][$columns{'Engine'}] = $txt;
          }
        }

        $col_idx++;
      }
      # If rows are not spanned, increase index for each row after the first one
      if ( $rowspan == 0 && $row_idx > 1 ) {
        $outarr_idx++;
      } # If rows are spanned, increase out index for each even row
      elsif ( $rowspan == 2 && $row_idx > $rowspan && ($row_idx % 2) == 0 ) {
        $outarr_idx++;
      }
      $row_idx++;
    }
  }
}

# Dump results table as CSV
for my $row ( @outarr ) {
  print join(';', map { defined ? $_ : '' }
                  map { tr/“”/"/s; $_ }
                  map { s/‘/'/; $_ }
                  map { s/’/'/; $_ }
                  map { s/–/-/; $_ } # en dash
                  map { s/—/-/; $_ } # em dash
                  map { s/\240/ /; $_ } # non-breaking space
                  @$row ), "\n";
}

$root->delete; # erase this tree because we're done with it

