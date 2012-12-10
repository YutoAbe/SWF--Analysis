package SWF::Analysis::Body;

use warnings;
use strict;

use SWF::Analysis::Reader;
use SWF::Analysis::Tags;

sub new {
    my $pkg = shift;
    bless { tags => undef, }, $pkg;
}

sub decompile {
    my $self = shift;
    my $reader   = shift;

    $self->{tags} = SWF::Analysis::Tags->run($reader);
}

sub get {
    my $self = shift;

    return $self->{tags};
}
1;
