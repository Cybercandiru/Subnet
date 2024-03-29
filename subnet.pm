#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use Term::ANSIColor;
use 5.010;
my $datatime = localtime;
print color('bold green');
if($^O =~ /MSWin32/){system('cls');}else{system('clear');}

print q(
|---0101010---1001--1001-1010--|
|--  101-1001---11001001-1---10|
|---01-1010---1-1-1--1001-1010-|
|---00-10-----1001--1001-1010--|
|-01---10-----1001--1001-1010--|
[-->perl subnet.pm site.com <--]
);
print color('reset');

print colored ("->[subnet v0.1]\n",'white on_red');


sub find_subdomain{
        my ($domain) = @_;
        my $ua = LWP::UserAgent->new;
        $ua->agent('Mozilla/5.0');
        my $url = "https://crt.sh/?q=%.$domain&output=json";
        my $response = $ua->get($url);
        die "error cont404:\n" unless $response->is_success; # $@
        my $content = $response->decoded_content;
        my @subdomains;
        my $json = decode_json($content);
        foreach my $entry(@$json){
                my $name_value = $entry->{'name_value'};
                push @subdomains,$name_value;
        }
        return @subdomains;
}
my $domain = shift||die "perl subnet.pl site.com";
chomp $domain;
my @subdomains = find_subdomain($domain);
if(@subdomains){

        print "[found for :$domain]\n";

        foreach my $subdomain (@subdomains){
        print "$subdomain\n";
        }
}else{
        print "subdomain no found for $domain\n";
}
1;
