package dancer_bootstrap_fontawesome_template;
use Dancer ':syntax';
use strict;
use warnings;
use Cwd;
use Sys::Hostname;
use Data::Dump qw/dump/;
use Dancer::Plugin::Mongo;
use Dancer::Plugin::Auth::Twitter;

auth_twitter_init();

our $VERSION = '0.1';

before sub {
    return if request->path =~ m{/auth/twitter/callback};
    if (not session('twitter_user')) {
        redirect auth_twitter_authenticate_url;
    }
};

get '/' => sub {
    my $widget = mongo->test->test->find_one({ "potato" => 'awesome' });

	print dump($widget); 

    template 'index';
};

get '/deploy' => sub {
    template 'deployment_wizard', {
		directory => getcwd(),
		hostname  => hostname(),
		proxy_port=> 8000,
		cgi_type  => "fast",
		fast_static_files => 1,
	};
};

#The user clicked "updated", generate new Apache/lighttpd/nginx stubs
post '/deploy' => sub {
    my $project_dir = param('input_project_directory') || "";
    my $hostname = param('input_hostname') || "" ;
    my $proxy_port = param('input_proxy_port') || "";
    my $cgi_type = param('input_cgi_type') || "fast";
    my $fast_static_files = param('input_fast_static_files') || 0;

    template 'deployment_wizard', {
		directory => $project_dir,
		hostname  => $hostname,
		proxy_port=> $proxy_port,
		cgi_type  => $cgi_type,
		fast_static_files => $fast_static_files,
	};
};

true;
