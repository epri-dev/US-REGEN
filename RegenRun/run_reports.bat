@echo off
REM  ==================================================================================================
REM  Run REGEN Model Summary Reporting
REM  ==================================================================================================

REM Specify name of scenario group (%group%)
REM (corresponds to full collection of scenarios)
set group=example

REM Specify name of reporting group (%rptgroup%)
REM (corresponds to set of scenarios to be included in
REM excel report for comparsion, specified in batch call)
REM if no rptgroup specified, exit with error
if "%1"=="" (goto error_rptgroup)
set rptgroup=%1

REM use second argument to run only a single report
REM if second argument is blank, run all
if not "%2"=="" set runmode=%2
if "%2"=="" set runmode=all

call  .\util\settoplevel.bat

REM =============== List scenarios to chart ======================
REM scenarios included in reporting group rptgroup should be
REM listed in order in a separate text file

REM alternatively they can be listed here
REM scenario names must be preceded by echo and followed by .gdx
REM (
REM echo reference.gdx
REM end of list
REM ) > scenario_list_%rptgroup%.txt

if not exist scenario_list_%rptgroup%.txt goto error_rptgroup

REM =========== Create individual chart reports ===================

set reportmerge_error=0
if not %runmode%==all goto %runmode%

REM === Electric Sector Report ===

:electric
set report=electric
call %reportrun%\reportmerge.bat
if not %runmode%==all goto eof
if %reportmerge_error%==1 goto eof_error

REM === Sankey Diagram Report ===

:sankey
set report=sankey
call %reportrun%\reportmerge
if not %runmode%==all goto eof
if %reportmerge_error%==1 goto eof_error

goto eof

:error_rptgroup
echo Reporting-group name is missing or not recognized.
goto eof

:eof_error
echo Error in run_reports batch file at %report%.

:eof