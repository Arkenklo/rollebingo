#!/usr/bin/env perl

use strict;

my $XMAX=5;
my $SIZE=100;
my $FULLSIZE=$SIZE * $XMAX;
my $FILE="lista";
my $COOKIEMAXAGE=43200;

sub fisher_yates_shuffle {
	my $deck = shift;  # $deck is a reference to an array
	my $i = @$deck;
	while ($i--) {
		my $j = int rand ($i+1);
		@$deck[$i,$j] = @$deck[$j,$i];
	}
}

sub getcookies {
	my $c = {};
	if(!$_[0]) {
		return $c;
	}
	foreach my $pairs (split('; ', $_[0])) {
		my @p = split('=', $pairs);
		$c->{$p[0]} = $p[1];
	}

	return $c;
}

sub bakecookie {
	my $cookie;

	while($_[0]) {
		my $k = shift;
		my $v = shift;
		$cookie .= "$k";
		if($v) {
			$cookie .= "=$v";
		}
		if($_[0]) { #not the last
			$cookie .= '; ';
		}
	}

	return $cookie;
}

my $cookies = getcookies($ENV{HTTP_COOKIE});
my $newcookie;
my $cookielista;
my $lines = [];

if($cookies->{lista}) {
	foreach my $l (split(',', $cookies->{lista})) {
		if($l) {
			push(@$lines, $l);
		}
	}
} else {
	open(my $fh, "<", $FILE) or die("Could not read $FILE");
	while ( <$fh> ) {
		chomp($_);
		push(@$lines, $_);
	}

	fisher_yates_shuffle($lines);

	foreach my $l (@$lines) {
		$cookielista .= ",$l";
	}

	$newcookie = bakecookie(lista=>$cookielista, "max-age"=>$COOKIEMAXAGE);
	print "Set-Cookie: $newcookie\r\n";
}
print "Content-Type: text/html; charset=utf-8\r\n\r\n";

print <<ENDOFFILE;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Rollebingo!</title>
<style type="text/css">
body
{
	font-family: sans-serif;
}
h1
{
	font-size: 300%;
}
p
{
	font-size: 60%;
}
table
{
	border-collapse:collapse;
}
table, td, th
{
	border:1px solid black;
	text-align: center;
}
td
{
	width: ${SIZE}px;
	height: ${SIZE}px;
	max-width: ${SIZE}px;
	max-height: ${SIZE}px;
	word-wrap: break-word;
	overflow: hidden;
	font-size: 80%;
}
.cont {
	margin-left: auto;
	margin-right: auto;
	text-align: center;
	width: ${FULLSIZE}px;
}
.sel {
	background: #dd3939;
}
.unsel {
	background: white;
}
</style>
</head>
<body>
<script type="text/javascript">
function checkbox(box) {
	var node = document.getElementById(box);
	if(node.getAttribute("class") == "sel") {
		node.setAttribute("class", "unsel");
	} else {
		node.setAttribute("class", "sel");
	}
}
function uncheckbox(box) {
	var node = document.getElementById(box);
	node.setAttribute("class", "unsel");
}
</script>

<div></div><div class="cont"><h1>ROLLEBINGO!</h1>
<table border="1">

<tr>
ENDOFFILE

my $x=-1;
my $j=0;
my $y=0;
foreach my $l (@$lines) {
	$x++;
	if($x == $XMAX) {
		$y++;
		if( $y == $XMAX ) {
			last;
		}
		print "</tr>
		<tr>";
		$x=0;
	}
	$j++;
	print "<td id=\"ruta$j\" class=\"unsel\" onclick=\"checkbox('ruta$j')\">$l</td>\n";
}
print "</tr></table><p><br />När du får fem i rad vinner du en kaka. <br /><br />Finns ett ord med flera gånger får du fylla i alla rutor när du hör det.<br \><br \>Klicka på rutorna för att markera dem.</p><p><a href=\"https://datarymden.se\">Sponsrat av Datarymden</a></p></div><div></div>

</body>
</html>";

