use Test::Most;

use HTTP::Request::Common;
use HTTP::Request::AsCurl;


my @tests = ({
    request  => GET("example.com"),
    expected => [
        'curl --dump-header - -XGET "example.com"',
    ],
},{
    request  => GET("example.com/boop?answer=42"),
    expected => [
        'curl --dump-header - -XGET "example.com/boop?answer=42"',
    ],
},{
    request  => POST("example.com"),
    expected => [
        q|curl --dump-header - -XPOST "example.com"|,
    ],
},{
    name     => 'POST example.com with form data',
    request  => POST("example.com", [mars => 'invades', 'venus' => 'peaceful']),
    expected => [
        q|curl --dump-header - -XPOST "example.com" \\|,
        q|--data 'mars=invades' \\|,
        q|--data 'venus=peaceful'|,
    ],
},{
    name     => 'POST example.com with form data and basic authorization header',
    request  => sub { 
        my $headers = HTTP::Headers->new;
        $headers->authorization_basic('username', 'p@ssw0rd');

        my $request = POST 'example.com', { mars  => 'invades', venus => 'peaceful' },
            Authorization => $headers->header('Authorization');

        $request->headers($headers);

        return $request;
    },
    expected => [
        q|curl --dump-header - -XPOST "example.com" \\|,
        q|--user 'username:p@ssw0rd' \\|,
        q|--data 'mars=invades' \\|,
        q|--data 'venus=peaceful'|,
    ],
});

for my $test (@tests) {

    my $request = ref $test->{request} eq 'CODE' 
        ? $test->{request}->()
        : $test->{request};

    my $name = $test->{name} // $request->method . " " . $request->uri;

    subtest $name => sub {
        is_deeply [$request->as_curl], $test->{expected};
    };

}

done_testing;
