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
        # check config 
        my $config = Jifty->find_plugin('Jifty::Plugin::Gravatar');
        if( $config->{Cache} ) {
            img { { id is 'g-i-' . $gravatar_id, class is 'gravatar-image', src is '/=/gravatar/' . $gravatar_id }; };
        }
        else {
            div { { class is 'gravatar-image-wrapper' };
                img { { id is 'g-i-' . $gravatar_id, class is 'gravatar-image', src is $gravatar_url }; };
            };
        }
    };

};

template '/=/gravatar/image' => sub {
    my $config = Jifty->find_plugin('Jifty::Plugin::Gravatar');
    Jifty->handler->apache->content_type("image/jpeg");
    Jifty->handler->apache->header_out(Expires =>  HTTP::Date::time2str(time() + ( $config->{Cache} || 3600 ) )); 
    # XXX: use cache::file
    my $id = get('id');
    my $gravatar_url = gravatar_url( id => $id );
    use LWP::Simple qw();
    my $binary_image = LWP::Simple::get( $gravatar_url );
    outs_raw( $binary_image );
};

1;
