#! perl

package Text::Template::Tiny;

use warnings;
use strict;

=head1 NAME

Text::Template::Tiny - Variable substituting template processor

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This is a very small and limited template processor. The only thing it
can do is substitute variables in a text.

Often that is all you need :-).

Example:

    use Text::Template::Tiny;

    # Create a template processor, with preset subtitutions.
    my $xp = Text::Template::Tiny->new(
      home    => $ENV{HOME},
      lib     => "/etc/mylib",
      version => 1.02,
    );

    # Add some more substitutions.
    $xp->add( app => "MyApp" );

    # Apply it.
    print $xp->expand(<<EOD);
    For [% app %] version [% version %], the home of all operations
    will be [% home %],
    EOD

=cut

sub new {
    my ($pkg, %ctrl) = @_;
    bless { _ctrl => { %ctrl } }, $pkg;
}

sub add {
    my ($self, %ctrl) = @_;
    @{$self->{_ctrl}}{keys %ctrl} = values %ctrl;
}

sub expand {
    my ($self, $text) = @_;

    my $pat = $self->{_pat};
    my $ctrl = $self->{_ctrl};

    unless ( $pat ) {
	$pat = "(";
	foreach ( keys(%{$self->{_ctrl}}) ) {
	    $pat .= quotemeta($_) . "|";
	}
	chop($pat);
	$pat .= ")";
	$self->{_pat} = $pat = qr/\[\%\s+$pat\s+\%\]/;
    }

    $text =~ s/$pat/$self->{_ctrl}->{$1}/ge;
    return $text;
}

=head1 AUTHOR

Johan Vromans, C<< <jv at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-text-template-tiny at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Template-Tiny>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Text::Template::Tiny


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Template-Tiny>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Text-Template-Tiny>

=item * Search CPAN

L<http://search.cpan.org/dist/Text-Template-Tiny>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Johan Vromans, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Text::Template::Tiny
