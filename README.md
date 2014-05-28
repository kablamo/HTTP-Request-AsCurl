
# NAME

HTTP::Request::AsCurl - Generate curl commands from an HTTP::Request object.

# SYNOPSIS

    use HTTP::Request::Common;
    use HTTP::Request::AsCurl;

    my $request = POST('api.earth.defense/weapon1', { 
        target => 'mothership', 
        when   => 'now' 
    });

    say join "\n", $request->as_curl;
    # curl --dump-header - -XPOST "api.earth.defense/weapon1" \
    # --data 'target=mothership' \
    # --data 'when=now

# DESCRIPTION

This module is a bit naughty because it injects an as\_curl() method into the
HTTP::Request namespace.  I only use it for debugging.  Perhaps that makes it
ok.

This module also handles headers and basic authentication.

# LICENSE

Copyright (C) Eric Johnson.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Eric Johnson <eric.git@iijo.org>
