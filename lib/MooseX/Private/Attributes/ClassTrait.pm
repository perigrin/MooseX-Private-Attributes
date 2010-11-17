package MooseX::Private::Attributes::ClassTrait;
use Moose::Role;
use namespace::autoclean;

requires 'add_attribute';

around add_attribute => sub {
    my ( $next, $self, $name, %args ) = @_;
    if ( $name =~ /^_/ ) {
        $args{traits} ||= [];
        push @{ $args{traits} }, 'Private';
    }
    $self->$next( $name, %args );
};

package Moose::Meta::Class::Custom::Trait::PrivateAttributes;
sub register_implementation { 'MooseX::Private::Attributes::ClassTrait' }

1;
__END__
