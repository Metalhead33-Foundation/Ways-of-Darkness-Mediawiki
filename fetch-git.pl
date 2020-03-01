#!/bin/env perl

use strict;
use File::Path qw(rmtree);

my $WIKI_RELEASE = "1_34";

sub read_extensions {
    my $file = $_[0];
    my $mode = $_[1];
    
    my %extensions;

    if(open my $FH, '<', $file) {
        while(<$FH>) {
            chomp;
            
            if(/^([^;]+);([^;]+)$/) {
                $extensions{$1} = [$2];
            } elsif (/^([^;]+)$/) {
                $extensions{$1} = ["https://github.com/wikimedia/mediawiki-$mode-$1.git","-b","REL".$WIKI_RELEASE];
            }
        }
        close $FH;
    }
    
    return %extensions;
}

my %extensions = read_extensions("extensions.txt","extensions");
my %skins = read_extensions("skins.txt","skins");

my %rm_extensions;

if ( ! -e "addons" ) {mkdir ("addons");}

chdir("addons");

if ( ! -e "extensions" ) {mkdir ("extensions");}
chdir("extensions");

while( <"*"> ) {
    if( -d ) {
        if ( exists $extensions{$_} ) {
            delete $extensions{$_};
            chdir($_);
            system("git pull");
            chdir("..");
        } else {
            print "Deleting $_\n";
            rmtree($_);
        }
    }
}

while ( my ($ext,$git) = each %extensions) {
    system("git","clone","--recursive",@{$git},$ext);
}

chdir("../");

my @rm_skins;

if ( ! -e "skins" ) {mkdir ("skins");}

chdir("skins");

while( <"*"> ) {
    if( -d ) {
        if ( exists $skins{$_} ) {
            delete $skins{$_};
            chdir($_);
            system("git pull");
            chdir("..");
        } else {
            print "Deleting $_\n";
            rmtree($_);
        }
    }
}

while ( my ($ext,$git) = each %skins) {
    system("git","clone","--recursive",@{$git},$ext);
}
