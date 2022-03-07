<?
/* generic string functions */
 
// reduce white space, tabs, double space, with optional addslashes
function cln($str, $adsl=false) {
	$str = str_replace(["\t", '   ', '  '], ' ', trim($str));
	if ($adsl) return addslashes($str);
	return $str;
}

// remove blank entries from delimited string list and sort unique
function clnlist($list, $dl=',', $altdl=NULL) {
	if($altdl) $list = str_replace($altdl, $dl, $list);
	$list = str_replace([ " $dl", "$dl ", "{$dl}{$dl}{$dl}", "{$dl}{$dl}" ], $dl, cln($list));
	if($list == '') return '';
	if($list[0] == $dl) $list = substr($list, 1);
	if(substr($list, -1, 1) == $dl) return substr($list, 0, -1);
	return $list;
}

// shorthand add/strip slashes
function adsl($str) {	return addslashes($str); }
function stsl($str) { return stripslashes($str); }

// shorthand htmlentities
function htm($str)  { return htmlentities(trim($str), ENT_QUOTES, 'UTF-8', false); }
function htmd($str) { return html_entity_decode($str, ENT_QUOTES, 'UTF-8'); }

?>