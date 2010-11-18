# MooseX::Private::Attributes

    21:06 <@mst> I write
    21:06 <@mst> has '_foo' => (is => 'ro', init_arg => 'foo');
    21:06 <@mst> far far too much
    [...]
    21:07 <@rjbs> I think my version of that is:
    21:07 <@rjbs> has foo => (reader => '_foo');
    [...]
    21:08  * perigrin wonders if it wouldn't be worth the hour to sit down and  write MosoeX::PrivateAccessors
    21:08 <@perigrin> for is => 'private' 
    21:08 <@perigrin> that does rjbs' answer 


## Synopsis 

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
        
## Description

This module does I<not> create truely private accessors. Instead it is a way
of creating the C<_foo> style idiom for Perl. It also adds a set of methods to
Moose::Meta::Class for finding private attributes easily.

