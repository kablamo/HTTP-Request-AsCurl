package HTTP::Request::AsCurl;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";


# hide this from PAUSE indexer
package
    HTTP::Request;

sub as_curl {
    my ($self)  = @_;
    my $content = $self->content;
    my @data    = split '&', $content;
    my $X       = $self->method;
    my $uri     = $self->uri;
    my $headers = $self->headers;
    my $u       = $headers->authorization_basic;
    my @headers = grep { $_ !~ /(authorization|content-length|content-type)/i }
        $headers->header_field_names;

    my @cmd;
    push @cmd, "curl --dump-header - -X$X \"$uri\"";
    push @cmd, "--user '$u'" if $u;
    push @cmd, "--header '$_: " . $headers->header($_) . "'" for sort @headers;
    push @cmd, "--data '$_'" for sort @data;

    my $last = pop @cmd;
    @cmd = map { $_ . " \\" } @cmd;

    return @cmd, $last;
}


1;
__END__

=encoding utf-8

=head1 NAME

HTTP::Request::AsCurl - Generate a curl command from an HTTP::Request object.

=head1 SYNOPSIS

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

=head1 DESCRIPTION

This module is a bit naughty because it injects an as_curl() method into the
HTTP::Request namespace.  I use it for debugging REST APIs.  Perhaps that makes
it ok.

This module also handles headers and basic authentication.

=head1 LICENSE

Copyright (C) Eric Johnson.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Eric Johnson E<lt>eric.git@iijo.orgE<gt>

=cut

