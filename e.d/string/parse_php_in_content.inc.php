<?
/*	
## Function	: parse_php_in_content
## Syntax		: $str = parse_php_in_content($str);
## Example	:
##					: $str = '<?$sx=420.420; ?>|<?php return "PHP";?>|<?=$sx?>|<?return 420; ?>+one two three <?$sx=12232233+3; return $sx;?>one two three <?= 420*23; ?>';
##					: echo 'str:' .	$str . PHP_EOL;
##					: echo PHP_EOL;
##					: echo 'parse:' . parse_php_in_content($str) . PHP_EOL;
##					: echo PHP_EOL;
*/
function parse_php_in_content($str) {
	while( ($spos = strpos($str, '<?')) !== false) {
		if ( ($epos = strpos($str, '?>', $spos+2)) === false) return false;
		$fragment = substr($str, $spos+2, $epos-$spos-2);
		if (substr($str, $spos+2, 1) == '=') { 
			$fragment = substr($fragment, 1);
			$str = substr($str, 0, $spos) . eval("return $fragment;") . substr($str, $epos+2);
		} elseif (substr($str, $spos+2, 3) == 'php') { 
			$fragment = trim(substr($fragment, 3));
			$str = substr($str, 0, $spos) . eval($fragment) . substr($str, $epos+2);
		} else {
			$str = substr($str, 0, $spos) . eval($fragment) . substr($str, $epos+2);
		}
	} 
	return $str;
}
?>
