package OMV::TemplateLog::Tags;
# $Id$

use strict;
use warnings;
use MT;

use vars qw( $VENDOR $MYNAME $FULLNAME );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[0, 1]);

sub instance { MT->component($FULLNAME); }



### mt:LogBlock block tag
sub LogBlock {
    my ($ctx, $args, $cond) = @_;

    defined (my $out = $ctx->slurp ($args, $cond))
        or return; # pass throught the error
    $args->{target} =~ /^meta(data)?$/i
        ? $args->{metadata} = $out
        : $args->{message} = $out;

    return Log ($ctx, $args);
}

### $mt:Log$ function tag
sub Log {
    my ($ctx, $args) = @_;

    defined (my $message = $args->{message} || $args->{msg})
        or return $ctx->error (&instance->translate ('You nees a valid <[_1]> attribute.', 'message'));

    # http://www.sixapart.jp/movabletype/manual/object_reference/archives/mt_log.html
    require MT::Log;
    my $log = MT::Log->new;
    $log->message ($message);
    $ctx->stash ('blog')
        ? $log->blog_id ($ctx->stash ('blog')->id)
        : undef;
    $log->category ($args->{category} || $FULLNAME);
    $log->level ({
        'INFO' => 1,
        'WARNING' => 2,
        'ERROR' => 4,
        'SECURITY' => 8,
        'DEBUG' => 16,
    }->{uc $args->{level} || 'INFO'});
    $log->metadata ($args->{metadata} || $args->{meta});
    $log->save
        or return $ctx->error ($log->errstr);

    return $args->{debug}
        ? $message
        : '';
}

1;