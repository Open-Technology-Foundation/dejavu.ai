#!/bin/bash
#@ Global  : _ent_VERSION
#@ Version : 0.998.420.50.omicron-991
#@ Desc    : Return version/build for this version of e.bash.
#@         :
#@         : Returns string in the form:
#@         :   majorver.minorver.420.build.release[-dayssince]
#@         :
#@         : Where:
#@         :   majorver   0
#@         :   minorver   998
#@         :   420        Constant.
#@         :   build      Build number.
#@         :   release    Release name.
#@         :   dayssince  Days since 2019-06-21.
#@         :
#@ See Also: _ent_SCRIPT_VERSION version.set
declare -xg _ent_VERSION='0.998.420.50.omicron-991'
#fin
