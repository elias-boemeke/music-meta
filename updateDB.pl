#! /bin/perl

use strict;
use warnings;


my $dblocation = "/media/wdo/multimedia/audio/music";


my $albs = "albums.txt";
my $songs = "songs.txt";


sub doAlbums {
  my $fh = $_[0];
  for (`find "$dblocation" -type d -links 2 -not -path "$dblocation/dl" -not -path "$dblocation/dl/*" | sort`) {
    chomp;

    my $dir = $_;
    /^$dblocation\/(.*)$/ && print $fh "[$1]\n";
    my @files = `find "$dir" -type f | sort`;
    @files = map {/^\Q$dir\E\/(?:\d+ - )?(.*)\.[a-z0-9]{3,4}$/ && "$1"} @files;
    for (@files) {
      print $fh "$_\n";
    }
    print $fh "\n\n";
  }
}

sub doSongs {
  my $fh = $_[0];
  my @s;
  for (`find "$dblocation" -type f -not -path "$dblocation/dl" -not -path "$dblocation/dl/*"`) {
    chomp;
    /^.*\/(?:\d+ - )?([^\/]*)\.[a-z0-9]{3,4}$/ && push @s, "$1\n";
  }
  # sort case insensitively
  @s = sort {"\L$a" cmp "\L$b"} @s;
  $" = "";
  print $fh "@s";
}

# main
open(my $afh, ">", $albs);
open(my $sfh, ">", $songs);

doAlbums($afh);
doSongs($sfh);

close($afh);
close($sfh);

