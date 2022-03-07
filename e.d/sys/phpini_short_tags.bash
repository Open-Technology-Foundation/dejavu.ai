#!/bin/bash
#@ Function: phpini_short_tags
#@ Desc    : Modify php.ini short_open_tag to 'yes' in both cli and apache2.
#@ Synopsis: phpini_short_tags
phpini_short_tags() { 
  PHPdir=$(php -r 'echo phpversion();') || return 1
  PHPdir=${PHPdir%-*}; PHPdir=${PHPdir%.*}
  [[ -z $PHPdir ]]  && return 2
  # make sure php-cli can use short tag "<?"
  sed -i 's/^\s*short_open_tag.*/short_open_tag = On/g' "/etc/php/$PHPdir/cli/php.ini" \
      || return 3
  [[ -f "/etc/php/$PHPdir/apache2/php.ini" ]] \
    && sed -i 's/^\s*short_open_tag.*/short_open_tag = On/g' "/etc/php/$PHPdir/apache2/php.ini"
  return 0
}
declare -fx 'phpini_short_tags'
#fin
