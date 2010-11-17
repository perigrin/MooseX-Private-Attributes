package MooseX::Private::Attributes::AttributeTrait;
use Moose::Role;
use namespace::autoclean;

requires '_process_is_option';

sub _process_is_option {
    my ( $class, $name, $options ) = @_;

    return unless $options->{is};

    my $method_name = $name =~ /^_/ ? $name : "_$name";

    ### -------------------------
    ## is => ro, writer => _foo    # turns into (reader => foo, writer => _foo) as before
    ## is => rw, writer => _foo    # turns into (reader => foo, writer => _foo)
    ## is => rw, accessor => _foo  # turns into (accessor => _foo)
    ## is => ro, accessor => _foo  # error, accesor is rw
    ### -------------------------

    if ( $options->{is} eq 'ro' ) {
        $class->throw_error(
"Cannot define an accessor name on a read-only attribute, accessors are read/write",
            data => $options
        ) if exists $options->{accessor};
        $options->{reader} ||= $method_name;
    }
    elsif ( $options->{is} eq 'rw' ) {
        if ( $options->{writer} ) {
            $options->{reader} ||= $method_name;
        }
        else {
            $options->{accessor} ||= $method_name;
        }
    }
    elsif ( $options->{is} eq 'bare' ) {
        return;

        # do nothing, but don't complain (later) about missing methods
    }
    else {
        $class->throw_error(
"I do not understand this option (is => $options->{is}) on attribute ($name)",
            data => $options->{is}
        );
    }
}

package Moose::Meta::Attribute::Custom::Trait::Private;
sub register_implementation { 'MooseX::Private::Attributes::AttributeTrait' }

1;
__END__
