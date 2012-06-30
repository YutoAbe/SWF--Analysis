package SWF::Analysis;

use warnings;
use strict;

use SWF::Analysis::Header;
use SWF::Analysis::Body;
use SWF::Analysis::Reader;
use SWF::Analysis::ReCompile;

our $VERSION = '0.07';

sub new {
    my $pkg = shift;
    bless {
        Reader => undef,
        Header => undef,
        Body   => undef,
    }, $pkg;
}

sub init {
    my $self = shift;
    $self->{Reader} = SWF::Analysis::Reader->new();
    $self->{Header} = SWF::Analysis::Header->new();
    $self->{Body}   = SWF::Analysis::Body->new();
}

sub run {
    my $self = shift;
    my $file = shift;

    $self->init();

    $self->{Reader}->set($file);
    $self->{Header}->decompile( $self->{Reader} );
    $self->{Body}->decompile( $self->{Reader} );

    $self->{Reader}->close();
}

sub get {
    my $self = shift;

    return {
        Header => $self->{Header}->get,
        Body   => $self->{Body}->get,
    };
}

sub compile {
    my $self = shift;

    return SWF::Analysis::ReCompile->run(shift);
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

SWF::Analysis - Analysis to SWF

=head1 SYNOPSIS

  use SWF::Analysis;
  my $swf = SWF::Analysis->new();
  my $data = $swf->run('hogehoge.swf');

  #ReCompile
  $swf->compile($data);

  #View Analysis Data
  use SWF::Analysis::View;
  SWF::Analysis::View->run($data);

=head1 DESCRIPTION

Stub documentation for Test, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

yuto abe<lt>toward-the-dream580829@hotmail.co.jp<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by yuto abe

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
