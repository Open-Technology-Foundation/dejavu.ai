     About:  e.bash
      Desc:  E.bash Functions/Globals Declarations and Initialisations.
          : 
          :  E.bash is a light-weight Bash function library for systems
          :  programmers and administrators.
          : 
          :  Latest release is available at
          :  http://github.com/OkusiAssociates/entities.bash
          : 
          :  To install, use e.install.
          : 
          :    _ent_0       $PRGDIR/$PRG
          :    PRG          basename of current script.
          :    PRGDIR       directory location of current script, with
          :                 symlinks resolved to actual location.
          :    _ent_LOADED  is set if e.bash has been successfully
          :                 loaded.
          : 
          :  PRG/PRGDIR are *always* initialised as local vars regardless of
          :  'inherit' status when loading e.bash.
          : 
   Depends:  readlink
       Url: file:///usr/share/e.bash/e.bash
