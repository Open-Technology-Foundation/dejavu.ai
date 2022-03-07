<?

/*
	#file test.sh:
	file_put_contents('test.sh', "
		TEST=1234
		TEST2=\"345\"
			TEST10= 'this is a test'
		#
		TEST4=6789
		this is a statement = nothing
		test2=98232 this is a test
		test3= 34324
	");

	$phpvars = bashvars2php('test.sh', $arg);
	echo "phpvars: $phpvars\n\n";
	echo "print_r(arg): " . print_r($arg, true) . "\n";
	echo "evalutation phpvars:";
	eval($phpvars);
	echo "\t\nTEST4=$TEST4\t\narg[1]={$arg[1]}\n";
*/


/* 	extract variable assignment statements in 
		bash code and output php equivalent.
		return string with concatenated variable assignment statements.
		optionally initialise array variable with all assignment statements.
*/
function bashvars2php($file, &$phpvars=[]) {
	$phpvars = [];

	$lines = file($file,  FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES );
	foreach($lines as $ln) {
		$lnt = trim($ln);
		if($lnt == '' || $lnt[0] == '#') continue; 

		$eq = strpos($lnt, '=');
		if($eq == 0) continue;

		$var = substr($lnt, 0, $eq);
		if(strpos($var, ' ') !== false) continue;

		$val = trim(substr($lnt, $eq+1));
		if($val[0] == '"' || $val[0] == "'" || is_numeric($val)) $qt = ''; 
		else $qt = '"';
		$phpvars[] = '$' . $var . ' = ' . $qt . $val . $qt . ';';
	}

	return implode("\n", $phpvars);
}
?>