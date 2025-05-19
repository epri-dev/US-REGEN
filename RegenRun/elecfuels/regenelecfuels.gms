* ----------------------
* regenelecfuels.gms
* ----------------------
* REGEN Electric+Fuels Model
* Main execution file


* Headers, system options, and code verion

* Cause dollar statements to appear in lst file
$ondollar
* Set EOL comment indicator to the default of !!
$oneolcom

* Set global directory names (%elecdata% etc)
$include %sysenv.runutil%\setglobals

* Set code version (please do not use '.' in the version name)
$set codeversion v2025_1

* Include long scenario name
$if not set longname $set longname %scen%
set scenarioname /"%longname%"/;

* Set titles
$set titlelead "Scenario %scen% Iter %iter% | US-REGEN Electric-Fuels Model %codeversion%"

put putscr;
$setlocal marker "%titlelead% setup"
put_utility  "title" / "%marker%" /  "msg" / "==== %marker% ====" /  "msg" / " " /;

* Suppress listing of equations and variables in lst file
option limrow=0;
option limcol=0;
* Suppress solution listing in lst file
option solprint=off;
* Include information about execution time and memory use in lst file
*option profile=3;
* Include status report from solver in lst file
option sysout=on;
* Display system resources information
option profile=1;

$show

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* Control parameter defaults
$include regen_defaults.gms

* Set declaration and load
$include regen_sets.gms

* Parameter declaration and load
$include regen_parameters.gms

* Iterative parameter load (from end-use model)
$include regen_iterative.gms

* Resolve run-time set and parameter assignments
$include regen_runtime.gms

* Model variable, equation, and model declarations
$include regen_model.gms

* Upper and lower bound constraints
$include regen_bounds.gms

* Solve statement
$include regen_solve.gms


