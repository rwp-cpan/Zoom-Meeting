use v5.37.12;

use Zoom::Meeting;

my $zoom = Zoom::Meeting -> new (id => '', password => '');

say $zoom;

$zoom -> launch;
