package SWF::Analysis::Structure;

use warnings;
use strict;

sub getUI8 {
    my $self = shift;
    return unpack "C", shift;
}

sub getUI16 {
    my $self = shift;
    return unpack "n", shift;
}

sub getUI32 {
    my $self = shift;
    return unpack "N", shift;
}

sub getUI16LE {
    my $self = shift;
    return unpack "v", shift;
}

sub getUI32LE {
    my $self = shift;
    return unpack "V", shift;
}

sub setUI8 {
    my $self = shift;
    return pack "C", shift;
}

sub setUI16 {
    my $self = shift;
    return pack "n", shift;
}

sub setUI32 {
    my $self = shift;
    return pack "N", shift;
}

sub setUI16LE {
    my $self = shift;
    return pack "v", shift;
}

sub setUI32LE {
    my $self = shift;
    return pack "V", shift;
}

1;
