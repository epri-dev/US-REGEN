* Include file setglobals.gms

$if setenv group        $setglobal group         %sysenv.group%

$if setenv scen         $setglobal scen          %sysenv.scen%

$if setenv iter         $setglobal iter          %sysenv.iter%

$if setenv elecdata     $setglobal elecdata      %sysenv.elecdata%
$if setenv endusedata   $setglobal endusedata    %sysenv.endusedata%
$if setenv hoursdata    $setglobal hoursdata     %sysenv.hoursdata%

$if setenv casedir      $setglobal casedir       %sysenv.casedir%

$if setenv elecout      $setglobal elecout       %sysenv.elecout%
$if setenv elecrpt      $setglobal elecrpt       %sysenv.elecrpt%

$if setenv reportelec   $setglobal reportelec    %sysenv.reportelec%
$if setenv reportsankey $setglobal reportsankey  %sysenv.reportsankey%
$if setenv reporttrn    $setglobal reporttrn     %sysenv.reporttrn%

$if setenv enduseout    $setglobal enduseout     %sysenv.enduseout%
$if setenv enduserpt    $setglobal enduserpt     %sysenv.enduserpt%

$if not defined putscr file putscr /%gams.scrdir%\tmp.scr/;

