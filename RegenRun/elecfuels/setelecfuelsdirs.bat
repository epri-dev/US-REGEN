@echo off
REM  This is command file setelecfuelsdirs.bat (in the elecfuels subdirectory of the RegenRun directory).

REM  If optional argument %1 is "nocreate", the mkdir operations are skipped.

REM  Documentation of the directory-naming environment variables is in settoplevel.bat,
REM    which is in the util subdirectory of the RegenRun directory
REM    and should be run first.

REM  %~dp0 is the path to the directory containing this command file, with a trailing "\".
REM  The util directory is parallel to the elecfuels directory, thus allowing this invocation:
call %~dp0..\util\settoplevel.bat

REM scen is name of current scenario
REM group is name of the current scenario group

if not defined scen set scen=default_scen
if not defined group set group=default_group

set groupdir=%regencases%\%group%

set    casedir=%groupdir%\%scen%

set    caseelec=%casedir%\elecfuels
set    caseenduse=%casedir%\enduse

set    eleclist=%caseelec%\list
set    elecbasis=%caseelec%\basis
set    elecout=%caseelec%\out
set    elecrpt=%caseelec%\report
set    elecrestart=%caseelec%\restart

set    enduserpt=%caseenduse%\report

set    reportelec=%regenreport%\Electric\%group%
set    reportsankey=%regenreport%\Sankey\%group%
set    reporttrn=%regenreport%\Transmission\%group%

if '%1'=='nocreate' goto :EOF

if not exist  %groupdir%     mkdir  %groupdir%
if not exist  %casedir%      mkdir  %casedir%
if not exist  %caseelec%     mkdir  %caseelec%
if not exist  %eleclist%     mkdir  %eleclist%
if not exist  %elecbasis%    mkdir  %elecbasis%
if not exist  %elecout%      mkdir  %elecout%
if not exist  %elecrpt%      mkdir  %elecrpt%
if not exist  %elecrestart%  mkdir  %elecrestart%

if not exist %endusedata%\elecfuelscen\%scen% mkdir %endusedata%\elecfuelscen\%scen%
if not exist %hoursdata%\elecfuelscen\%scen% mkdir %hoursdata%\elecfuelscen\%scen%

if not exist  %reportelec%   mkdir  %reportelec%
if not exist  %reportsankey% mkdir  %reportsankey%
if not exist  %reporttrn%    mkdir  %reporttrn%
