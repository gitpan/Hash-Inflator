package Hash::Inflator;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.02';

sub new {
    my $class = shift;

    # handle simple scalars - could happen if we're called with the elements
    # of a list
    return $_[0] if @_ == 1 && !ref $_[0];
    my %hash = @_ > 1 ? @_ : %{ $_[0] };
    for my $key (keys %hash) {
        if (ref $hash{$key} eq 'HASH') {
            $hash{$key} = Hash::Inflator->new($hash{$key});
        } elsif (ref $hash{$key} eq 'ARRAY') {
            $_ = Hash::Inflator->new($_) for @{ $hash{$key} };
        }
    }
    bless \%hash, $class;
}

sub AUTOLOAD {
    my $self = shift;
    our $AUTOLOAD;
    $AUTOLOAD =~ s/.+:://;
    return if $AUTOLOAD =~ /^[A-Z]+$/;
    $self->{$AUTOLOAD};
}
1;
__END__

=for stopwords Measham

=head1 NAME

Hash::Inflator - Access hash entries through methods

=head1 SYNOPSIS

    my %h = (
        persons => [
            {
                last_name  => 'Shindou',
                first_name => 'Hikaru',
            },
            {
                last_name  => 'Touya',
                first_name => 'Akira',
            },
        ],
        # ...
    );

    my $obj = Hash::Inflator->new(%h);
    print $obj->persons->[0]->first_name;

=head1 DESCRIPTION

This class can inflate a hash so that you can access it using methods instead
of plain hash keys. So instead of C<< $x->{foo} >> you can do C<< $x->foo() >>.

Why would we want to do this?

First, because this way you can quickly prototype a class. Your class can
inherit from Hash::Inflator and the code using your class can just assume the
attributes are there. You can bother with writing the methods later. Although
tools like L<Class::Accessor> and friends make this very easy anyway.

Second, because we can.

You can call any method on the object. If the name corresponds to a hash key,
its value will be returned. If there is no such key, C<undef> will be
returned. If the hash contains other hashes (however deep down), those will
become inflated as well.

The code has been taken, with very little adaption, from L<Net::Jaiku> by Rick
Measham, with his permission.

=head1 METHODS

=over 4

=item C<new>

Takes a hash or a hash ref and returns the inflated hash as a reference.

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Hash-Inflator/>.

=head1 AUTHORS

Rick Measham, C<< <rickm@cpan.org> >>

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2009 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

