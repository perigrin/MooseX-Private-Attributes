package MooseX::Private::Attributes::ClassTrait;
use Moose::Role;
use namespace::autoclean;

use constant AttributeTrait => 'MooseX::Private::Attributes::AttributeTrait';

requires 'add_attribute';

around add_attribute => sub {
    my ( $next, $self, $name, %args ) = @_;
    if ( $name =~ /^_/ ) {
        $args{traits} ||= [];
        push @{ $args{traits} }, 'Private';
    }
    $self->$next( $name, %args );
};

sub get_all_private_attributes {    # TODO: Optimize ???
    my ($self) = @_;
    grep { $_->does(AttributeTrait) } $self->get_all_attributes;
}

sub get_private_attribute_list {
    my ($self) = @_;
    map { $_->name } $self->get_all_private_attributes;    # TODO: Optimize this
}

package Moose::Meta::Class::Custom::Trait::PrivateAttributes;
sub register_implementation { ' MooseX::Private::Attributes::ClassTrait ' }

1;
__END__
