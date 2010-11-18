package MooseX::Private::Attributes;

# ABSTRACT: A way to mark private attributes and generate accessors proper for them

use Moose 1.19 ();
use Moose::Exporter;
use Moose::Util::MetaRole;

use MooseX::Private::Attributes::AttributeTrait; # make sure the trait is loaded
use MooseX::Private::Attributes::ClassTrait;     # make sure the trait is loaded

Moose::Exporter->setup_import_methods();

sub init_meta {
    shift;
    my %args = @_;

    Moose->init_meta(%args);

    Moose::Util::MetaRole::apply_metaroles(
        for => $args{for_class},
        class_metaroles =>
          { class => => ['MooseX::Private::Attributes::ClassTrait'], },
    );

    return $args{for_class}->meta();
}

1;
__END__

=head1 Synopsis 

    package Foo;
    use Moose;
    use MooseX::Private::Attributes;

    has foo => (    # private
         traits => ['Private'],
         is     => 'ro',
    );

    has _bar => (    # private
         is => 'ro',
    );

    has baz => (     # private with a writer _baz
         traits => ['Private'],
         is     => 'rw'
    );
    
    1;
    
    package main; 
    
    my $meta = Foo->meta;
    say for $meta->get_private_attribute_list; 
    
=head1 Description

This module does I<not> create truely private accessors. Instead it is a way
of creating the C<_foo> style idiom for Perl. It also adds a set of methods to
L<Moose::Meta::Class|Moose::Meta::Class> for finding private attributes.

