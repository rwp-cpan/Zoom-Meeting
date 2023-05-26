use v5.37.12;
use experimental qw(class);

package Zoom::Meeting; # quirk
class Zoom::Meeting {

  use overload q("") => sub { $_[0] -> _url; };

  field $id :param;
  field $password :param = undef;

  method _url () {
    use URI;
    my $uri = URI -> new ('zoommtg://zoom.us'); # scheme is '_foreign' class, so no 'host' method
    $uri -> path('join');
    $uri -> query_form_hash( {
      'confno' => $id,
      'pwd' => $password
    } );
    return $uri;
  }

  method launch () {
    say $self -> _url;
  }

}
