<?php

	/*
	 * Vectron loads this script to get aamaps from the web without
	 * having to deal with the (IMHO lame) flash security system.
	 *
	 * The script takes the url without "http://" because -again- flash's URLRequest
	 * will throw security issues if there's "http://" in the url.
	 */

	$url = $_GET['url'];

	if(strlen($url) == 0)
		die('Error: url parameter required');

	$xml = file_get_contents('http://' . $url);

	echo $xml;

?>