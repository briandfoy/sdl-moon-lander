#!/usr/bin/perl
use SDL; #needed to get all constants
use SDL::App;
use SDL::Surface;
use SDL::Rect;

use strict;
use warnings;


my $app = SDL::App->new(
    -title  => "Lunar Lander",
    -width  => 800,
    -height => 600,
    -depth  => 32,
	);

use File::Basename; use File::Spec::Functions;
my $dir = dirname( $0 );
chdir $0;
	
my $background = SDL::Surface->new( -name => catfile( $dir, 'images/background.jpg' ), );
my $ship       = SDL::Surface->new( -name => catfile( $dir, 'images/ship.jpg' ), );

my $background_rect = SDL::Rect->new(
    -height => $background->height(),
    -width  => $background->width(),
	);


my $ship_rect = SDL::Rect->new(
    -height => $ship->height(),
    -width  => $ship->width(),
	);

sub draw {
    my ( $x, $y ) = @_; # spaceship position

    # fix $y for screen resolution
    $y = 450 * ( 1000 - $y ) / 1000;

    # background
    $background->blit( $background_rect, $app, $background_rect );

    # ship
    my $ship_dest_rect = SDL::Rect->new(
        -height => $ship->height(),
        -width  => $ship->width(),
        -x      => $x,
        -y      => $y,
    	);

    $ship->blit( $ship_rect, $app, $ship_dest_rect );

    #$app->update($background_rect);
    $app->sync;
	}

my $lat      = 100;
my $height   = 1000; # m
my $velocity = 0;    # m/s
my $gravity  = 1;    # m/s^2

my $t = 0;

use Term::TransKeys;
  my $listener = Term::TransKeys->new(
        actions => {
            '<UP>' => sub {
                $velocity -= 2;
            },
            '<DOWN>' => sub {
                $velocity += 2;
            },
            '<RIGHT>' => sub {
                $lat += 10;
            },
            '<LEFT>' => sub {
                $lat -= 10;
            },
        }
    );
    
my $script_re = qr/(\d+) \D+ (\d+)/x;
my %up = map { $_ =~ $script_re } <DATA>;
<STDIN>;


while ( $height > 0 ) {
    print "at $t s height = $height m, velocity = $velocity m/s\n";
	$listener->ActionRead( mode => 0.01 );

    if ( $up{$t} ) {
        my $a = $up{$t};
        print "(accellerating $a m/s^2)\n";
        $velocity = $velocity - $a;
    	}

    $height   = $height - $velocity;
    $height   = 1000 if $height > 1000;
    
    $velocity = $velocity + $gravity;
    $t        = $t + 1;

    draw( $lat, $height );
    $app->delay(100);
	}

if ( $velocity > 10 ) {
    print "CRASH!!!\n";
	} 
else {
    print "You landed on the surface safely! :-D\n";
	}

sleep 2;

