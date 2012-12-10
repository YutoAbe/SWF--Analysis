package SWF::Analysis::Reader;

use warnings;
use strict;

use POSIX;
use Compress::Zlib;

sub new {
    my $pkg = shift;
    bless {
        io          => undef,
        surplus     => undef,
        surplus_bit => undef,
        complessed  => undef,
        comp_bin    => undef
    }, $pkg;
}

sub set {
    my $self = shift;
    my $file = shift;

    open $self->{io}, '<', $file or die "file open error:$!";
}

sub close {
    my $self = shift;
    if ( defined $self->{io} ) {
        close $self->{io};
        $self->{io} = undef;
    }
}

sub byteAlign {
    my $self = shift;
    $self->{surplus} = $self->{surplus_bit} = undef if defined $self->{surplus};
}

sub skip {
    my $self = shift;
    $self->getData(shift);
}

sub thawing {
    my $self = shift;
    my $buf  = undef;
    while ( my $readbuf = $self->getData(1024) ) {
        $buf .= $readbuf;
    }
    my $data = uncompress($buf) or die "file not uncompressed:$!";

    $self->{complessed} = 1;
    $self->{comp_bin}   = $data;
}

sub getData {
    my $self = shift;
    my $data = undef;
    if ( defined $self->{compressed} ) { read $self->{io}, $data, shift; }
    else { $data = substr( $self->{comp_bin}, 0, shift, '' ); }
    return $data;
}

sub getUI8 {
    my $self = shift;
    return unpack "C", $self->getData(1);
}

sub getUI16 {
    my $self = shift;
    return unpack "n", $self->getData(2);
}

sub getUI32 {
    my $self = shift;
    return unpack "N", $self->getData(4);
}

sub getUI16LE {
    my $self = shift;
    return unpack "v", $self->getData(2);
}

sub getUI32LE {
    my $self = shift;
    return unpack "V", $self->getData(4);
}

sub getUIBits {
    my $self = shift;
    my $bits = shift;

    my $num;
    my $surplus_bit;
    if ( defined $self->{surplus} ) {
        my $diff = $bits - $self->{surplus_bit};
        $num = $self->{surplus};
        $self->{surplus} = undef;
        if ( $diff > 0 ) {
            my $byte = ceil( $diff / 8 );
            $surplus_bit = $byte * 8 - $diff;
            $num = $num << ( $byte * 8 );
            $num += $self->_BitsToNum( $self->getData($byte) );
        }
        else {
            $surplus_bit = $diff;
        }
    }
    else {
        my $byte = ceil( $bits / 8 );
        $surplus_bit = $byte * 8 - $bits;
        $num         = $self->_BitsToNum( $self->getData($byte) );
    }
    if ($surplus_bit) {
        $self->{surplus_bit} = $surplus_bit;
        $self->{surplus}     = $num & ( 2**$surplus_bit - 1 );
        $num                 = $num >> $surplus_bit;
    }
    return $num;
}

sub _BitsToNum {
    my $self = shift;
    my $data = shift;

    my @nums = unpack "C" . length($data), $data;
    my $num = 0;

    foreach my $no ( 1 .. @nums ) {
        $num = $num << 8;
        $num += $nums[ $no - 1 ];
    }

    return $num;
}
1;
