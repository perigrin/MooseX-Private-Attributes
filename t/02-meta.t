#!/usr/bin/perl
use strict;
use Test::More;
use Try::Tiny;
use Test::Deep;

{

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
}

my $meta = Foo->meta;
can_ok( $meta, qw(get_all_private_attributes get_private_attribute_list) );
is_deeply( [ $meta->get_private_attribute_list ], [qw(_bar baz foo)] );

done_testing;
