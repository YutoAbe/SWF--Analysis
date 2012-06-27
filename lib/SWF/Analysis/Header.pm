package SWF::Analysis::Header;

use warnings;
use strict;

use SWF::Analysis::Reader;

sub new {
    my $pkg = shift;
    bless {
        Signature  => undef,
        Version    => undef,
        Length     => undef,
        FrameSize  => undef,
        FrameRate  => undef,
        FrameCount => undef,
    }, $pkg;
}

sub decompile {
    my $self   = shift;
    my $reader = shift;

    $self->{Signature} = $reader->getData(3);
    $self->{Version}   = $reader->getUI8();
    $self->{Length}    = $reader->getUI32LE();

    my $NBits = $reader->getUIBits(5);
    $self->{FrameSize} = {
        Xmin => $reader->getUIBits($NBits) / 20,
        Xmax => $reader->getUIBits($NBits) / 20,
        Ymin => $reader->getUIBits($NBits) / 20,
        Ymax => $reader->getUIBits($NBits) / 20,
    };
    $reader->byteAlign();
    $self->{FrameRate}  = $reader->getUI16LE() / 0x0100;
    $self->{FrameCount} = $reader->getUI16LE();
}

sub get {
    my $self = shift;
    return {
        Signature  => $self->{Signature},
        Version    => $self->{Version},
        Length     => $self->{Length},
        FrameSize  => $self->{FrameSize},
        FrameRate  => $self->{FrameRate},
        FrameCount => $self->{FrameCount},
    };
}
1;
