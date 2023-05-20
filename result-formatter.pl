#!/usr/bin/env perl

use bigint;

my $content = "";

while (<>) {
    $content .= $_;
}

my @cells = ('id', 'caller', 'origin', 'coinbase', 'account-id');

foreach my $cell (@cells) {
    my $re = qr|<$cell>\s+(\d+)\s+</$cell>|s;
    while ($content =~ $re) {
        my $hex = Math::BigInt->new($1)->as_hex();
        $hex = sprintf('0x%040s', substr($hex, 2));
        $content =~ s|$&|<$cell>$hex</$cell>|g;
    }
}

print $content;