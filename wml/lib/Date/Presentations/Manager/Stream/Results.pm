package Date::Presentations::Manager::Stream::Results;

use strict;
use warnings;

use base 'Date::Presentations::Manager::Base';

__PACKAGE__->mk_accessors(qw(
    items
));

sub _initialize
{
    my $self = shift;
    $self->items([]);
    return 0;
}

sub insert
{
    my $self = shift;
    my $item = shift;
    push @{$self->items()}, $item;
}

sub get_items
{
    my $self = shift;
    return $self->items();
}

1;

1;

