use strict;
use Test::More tests => 46;

use HTTP::MobileAgent;

my @Tests = (
    [ { HTTP_X_JPHONE_DISPLAY => '120*117', HTTP_USER_AGENT => 'J-PHONE/2.0/J-DN02',
	HTTP_X_JPHONE_COLOR => 'C256' },
      { width => 120, height => 117, color => 1, depth => 256. } ],
    [ { HTTP_X_JPHONE_DISPLAY => '480*640', HTTP_X_S_DISPLAY_INFO => '468*540/29*16/TB',
	HTTP_USER_AGENT => 'SoftBank/1.0/814SH/SHJ001/SNXXXXXXXXX Browser/NetFront/3.4 Profile/MIDP-2.0 Configuration/CLDC-1.1',
	HTTP_X_JPHONE_COLOR => 'C262144' },
      { width => 468, height => 540, color => 1, depth => 262144. } ],
    [ { HTTP_X_UP_DEVCAP_SCREENPIXELS => '90,70',
	HTTP_USER_AGENT => 'KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1',
	HTTP_X_UP_DEVCAP_SCREENDEPTH => '16,RGB565',
	HTTP_X_UP_DEVCAP_ISCOLOR => 1, },
      { width => 90, height => 70, color => 1, depth => 2**16 }, ],
    [ { HTTP_X_UP_DEVCAP_SCREENPIXELS => '90,70',
	HTTP_USER_AGENT => 'KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1',
	HTTP_X_UP_DEVCAP_SCREENDEPTH => '1',
	HTTP_X_UP_DEVCAP_ISCOLOR => 0 },
      { width => 90, height => 70, color => '', depth => 2 }, ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D501i' },
      { width => 96, height => 72, color => '', depth => 2 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D502i' },
      { width => 96, height => 90, color => 1, depth => 256 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/N502i' },
      { width => 118, height => 128, color => '', depth => 4 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 N703imyu' },
      { width => 240, height => 270, color => 1, depth => 262144 } ],
    [ { HTTP_USER_AGENT => "DoCoMo/1.0/D505i/c20/TC/W20H10" },
      { width_bytes => 20, height_bytes => 10 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 N04A(c100;TB;W24H16)' },
      { width => 240, height => 320 } ],
);

for (@Tests) {
    my($env, $values) = @$_;
    local *ENV = $env;
    my $ua = HTTP::MobileAgent->new;
    my $display = $ua->display;
    isa_ok $display, 'HTTP::MobileAgent::Display';
    for my $method (keys %$values) {
	is $display->$method(), $values->{$method}, "$method = $values->{$method}";
    }
}


