use v5.37.12;
use experimental qw( class try builtin );
use builtin qw( true false blessed );

package Zoom::Meeting; # quirk
class Zoom::Meeting {

  use overload q("") => sub { $_[0] -> _url; };
  use URI;
  use Path::Tiny;
  use System::Command;

  # @formatter:off
  field $id :param;
  field $password :param = undef;
  # @formatter:on

  method _url ( ) {
    my $uri = URI -> new( 'zoommtg://zoom.us' ); # scheme is '_foreign' class, so no 'host' method
    $uri -> path( 'join' );
    $uri -> query_form_hash( {
      'confno' => $id ,
      'pwd'    => $password
    } );
    return $uri;
  }

  method launch ( ) {

    my $zoom;

    if ( $^O eq 'linux' and -f '/proc/sys/fs/binfmt_misc/WSLInterop' ) {
      $zoom = path '/mnt/c/Program Files/Zoom/bin/zoom.exe';
    }

    System::Command -> new(
      $zoom ,
      "--url=@{ [ $self -> _url ] }" ,
      # { trace => 3 }
    );

  }

}
