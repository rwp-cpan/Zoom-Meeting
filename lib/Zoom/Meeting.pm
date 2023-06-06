# ABSTRACT: Launch Zoom meetings via Perl

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

=method new

Constructor method used to create a C<Zoom::Meeting> object

Accepts C<id> and C<password> parameters to initialize its fields

=cut

  method id ( $new_id = undef ) {
    if ( defined $new_id ) {
      $id = $new_id;
    }
    else {
      return $id;
    }
  }

=method id([$new_id])

Return or set meeting ID

=cut


  method password ( $new_password = undef ) {
    if ( defined $new_password ) {
      $password = $new_password;
    }
    else {
      return $password;
    }
  }

=method password([$new_password])

Return or set meeting password

=cut

  method _url ( ) {
    my $uri = URI -> new( 'zoommtg://zoom.us' ); # scheme is '_foreign' class, so no 'host' method
    $uri -> path( 'join' );
    $uri -> query_form_hash( {
      'confno' => $id ,
      'pwd'    => $password
    } );
    return $uri;
  }

=method _url

Private method constructing Zoom URL containing C<confno> and C<pwd> fields
standing for meeting ID and password respectively

=cut


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

=method launch()

Launch the Zoom meeting object in a Zoom application

Supports only WSL currently, Linux and native Windows support to be added

=cut

}
