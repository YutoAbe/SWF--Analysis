package SWF::Analysis::Body;

use warnings;
use strict;

use SWF::Analysis::Reader;

sub new {
    my $pkg = shift;
    bless { tags => undef, }, $pkg;
}

sub decompile {
    my $self = shift;
    my $reader   = shift;

    my @tags = ();

    while(1) {
        my $header = $reader->getUI16LE();
        my $type   = ( $header & 0xFFC0 ) >> 6;
        my $length = $header & 0x003F;
        if ( $length == 0x3F ) {
            $length = $reader->getUI32LE();
        }
        unless ($type) {
            push( @tags, { Type => $type, Length => $length, Body => undef });
            last;
        }
        else {
            my $body = $reader->getData($length);
            push( @tags, { Type => $type, Length => $length, Body => $body });
        }
    };
    $self->{tags} = \@tags;
}

sub get {
    my $self = shift;

    return $self->{tags};
}
1;
