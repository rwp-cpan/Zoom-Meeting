use v5.37.12;

use Zoom::Meeting;

my $zoom = Zoom::Meeting -> new (id => '123456789', password => 'pass');

say $zoom;
