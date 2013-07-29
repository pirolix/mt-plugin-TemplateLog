package MT::Plugin::Template::OMV::TemplateLog;
# TemplateLog (C) 2013 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id: PluginTemplate.pl 344 2013-07-20 07:49:34Z pirolix $

use strict;
use warnings;
use MT 4;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev: 344 $') =~ s/\D//g;
$VERSION = 'v0.10'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    # Basic descriptions
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/YYYY/MMDDhhmm/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Supply some template tags to make a log onto the activity logs when rebuilding.">
HTMLHEREDOC
    l10n_class => "${FULLNAME}::L10N",

    # Registry
    registry => {
        tags => {
            help_url => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME#tag-%t",
            function => {
                Log => "${FULLNAME}::Tags::Log",
            },
            block => {
                LogBlock => "${FULLNAME}::Tags::LogBlock",
            },
        },
    },
});
MT->add_plugin ($plugin);

1;