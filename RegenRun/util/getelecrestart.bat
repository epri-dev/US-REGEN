@echo off
REM  This is file getelecrestart.bat (in the util subdirectory of the run directory).
REM  It is used to obtain the complete filename of the elec only restart files (.g00)
REM    stored with a saved case of the electric only run.

REM  %1  should be "elec"
REM  %2  should be a group name or a "." if none applies.
REM  %3  should be the scenario_name.
REM  %4  is where the fully specified filename (or a dummy if not found) will be returned.

REM  Documentation of the directory-naming environment variables is in settoplevel.bat,
REM    which is also in the util subdirectory of the run directory.

setlocal

set type=%1
set scen=%3
if '%2' neq '.' set group=%2

REM  The elecfuels run subdirectory is parallel to the util subdirectory.
REM  So the results subdirectories for the desired case can be obtained as follows.
REM  "%~dp0" provides the absolute path of the directory containing this commmand file, with a trailing "\".

call %~dp0..\elecfuels\setelecfuelsdirs.bat %group% %scen% nocreate

set g00=%casedir%\restart\%scen%.%type%.g00

if not exist %g00% set g00=ElecRestartNotFound.g00

REM  The endlocal and final assignment must go on the same line.
endlocal  &  set %4=%g00%
