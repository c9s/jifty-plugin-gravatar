package Jifty::Plugin::Gravatar::View;
use warnings;
use strict;
use Jifty::View::Declare -base;
use Jifty::View::Declare::Helpers;

template '/gravatar' => sub {
    my ( $self, $email ) = @_;
    use Gravatar::URL;
    my $gravatar_url = gravatar_url( email => $email );
    my $gravatar_id = gravatar_id($email);

    div { { class is 'gravatar-image-wrapper' };
        img { { id is 'g-i-' . $gravatar_id, class is 'gravatar-image', src is '/=/gravatar/' . $gravatar_id }; };
    };

#    div { { class is 'gravatar-image-wrapper' };
#        img { { id is 'g-i-' . $gravatar_id, class is 'gravatar-image', src is $gravatar_url }; };
#    };
};

template '/=/gravatar/image' => sub {
    Jifty->handler->apache->content_type("image/jpeg");
    Jifty->handler->apache->header_out(Expires =>  HTTP::Date::time2str(time() + 3600 ));  # Expire in a year
    my $id = get('id');
    my $gravatar_url = gravatar_url( id => $id );
    use LWP::Simple qw();
    my $binary_image = LWP::Simple::get( $gravatar_url );
    outs_raw( $binary_image );
};

1;
