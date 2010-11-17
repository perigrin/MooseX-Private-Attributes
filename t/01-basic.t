#!/usr/bin/perl
use strict;
use Test::More;
use Try::Tiny;

{

    package Foo;
    use Moose;
    use MooseX::Private::Attributes;

    has foo => (    # private
        traits => ['Private'],
        is     => 'ro',
    );

    has baz => (    # private with a writer _baz
        traits => ['Private'],
        is     => 'rw'
    );
}

my $trait = 'MooseX::Private::Attributes::Trait';
my $o     = Foo->new();

for (qw(foo baz)) {
    my $attr = $o->meta->find_attribute_by_name($_);
    ok( $attr->does($trait), "$_ does $trait" );
}

can_ok( $o, qw(_foo _baz) );
is( $o->_baz(1), 1, 'can write to _baz too' );
try {
    $o->_foo(1);    # should die here
    ::fail('wrote to _foo()');
}
catch {
    ::pass('failed writing to _foo');
};

done_testing;
