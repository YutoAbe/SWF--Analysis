package SWF::Analysis::ReCompile;

use warnings;
use strict;

use POSIX;

use constant RECT_LIST => qw/Xmin Xmax Ymin Ymax/;

sub new {
    my $pkg = shift;
    bless { body => undef, }, $pkg;
}

sub run {
    my $self     = shift;
    my $analysis = shift;

    my $body = $self->makeBody( $analysis->{Body} );
    my $head = $self->makeHead( $analysis->{Header}, length($body) );

    return $head . $body;
}

sub makeHead {
    my $self   = shift;
    my $head   = shift;
    my $length = shift;

    my $NBits = 0;
    foreach my $key (RECT_LIST) {
        $head->{FrameSize}->{$key} *= 20;

        my $len = $self->chkLen( $head->{FrameSize}->{$key} );
        $NBits = $len if $NBits < $len;
    }
    $NBits++;

    my $frameLength = ceil( ( $NBits * 4 + 5 ) / 8 );
    my $surplus = $frameLength * 8 - ( $NBits * 4 + 5 );

    my $frameSize = $NBits;
    $frameSize = $frameSize << $NBits;
    $frameSize += $head->{FrameSize}->{Xmin};
    $frameSize = $frameSize << $NBits;
    $frameSize += $head->{FrameSize}->{Xmax};
    $frameSize = $frameSize << $NBits;
    $frameSize += $head->{FrameSize}->{Ymin};
    $frameSize = $frameSize << $NBits;
    $frameSize += $head->{FrameSize}->{Ymax};
    $frameSize = $frameSize << $surplus;

    $length += 3 + 1 + 4 + $frameLength + 2 + 2;

    my $bin = $head->{Signature};
    $bin  .= $self->setUI8( $head->{Version} );
    $bin  .= $self->setUI32LE($length);
    $bin  .= pack "H*" , (sprintf "%0" . ( $frameLength * 2 ) . "X", $frameSize);
    $bin  .= $self->setUI16LE( $head->{FrameRate} * 0x0100 );
    $bin  .= $self->setUI16LE( $head->{FrameCount} );

    return $bin;
}

sub makeBody {
    my $self = shift;
    my $body = shift;

    my $bin = "";

    for my $no ( 1 .. @$body ) {
        $bin .= $self->tagHead( $body->[ $no - 1 ]->{Type},
            $body->[ $no - 1 ]->{Length} );
        $bin .= $body->[ $no - 1 ]->{Body}
          if defined $body->[ $no - 1 ]->{Body};
    }

    return $bin;
}

sub tagHead {
    my $self   = shift;
    my $type   = shift;
    my $length = shift;

    my $head;
    $head = $type << 6;
    if ( $length >= 0x3F ) {
        $head += 0x3F;
        return $self->setUI16LE($head) . $self->setUI32LE($length);
    }
    else { $head += $length; return $self->setUI16LE($head); }
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

sub chkLen {
    my $self = shift;
    my $num  = shift;
    foreach my $no ( 1 .. 32 ) {
        return $no if $num < 2**$no;
    }
}
1;
