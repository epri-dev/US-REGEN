@echo off
REM Merge and Export data to Excel Chart Reports for %report%

REM  %~dp0 is the path to the directory containing this command file, with a trailing "\".
REM  The util directory is parallel to the report directory, thus allowing this invocation:
call %~dp0..\util\settoplevel.bat

REM To create a new report with name <name>:
REM add new folder RegenReport\<name>\template with Excel template
REM add new file <name>_export.rsp in RegenRun\report with Excel export script
REM add new line in RegenRun\elecfuels\setelecfuelsdirs.bat to identify target directory:
REM       set    report<name>=%regenreport%\<name>\%group%
REM add new line in RegenRun\util\setglobals.gms to pass target directory address to model
REM       $if setenv report<name>   $setglobal report<name>       %sysenv.report<name>%
REM add new line in RegenRun\elecfuels\regen_report.gms to export scenario parameters
REM       execute_unload '%report<name>%\%scen%.gdx', <parameters>;
REM add new section in run_reports.bat corresponding to <name>

echo Regenreport is set to %regenreport%
echo Reportrun is set to %reportrun%

if not exist %regenreport%\%report% goto error_report
if not exist %reportrun%\%report%_export.rsp goto error_report

REM =========== If Necessary, Copy Reporting Template  ==============
if not exist %regenreport%\%report%\%report%_report_%rptgroup%.xlsm copy %regenreport%\%report%\template\%report%_report.xlsm %regenreport%\%report%\%report%_report_%rptgroup%.xlsm

if not exist %reportrun%\temp\null mkdir %reportrun%\temp
if not exist %regenreport%\%report%\temp\null mkdir %regenreport%\%report%\temp

REM =========== Merge desired scenario gdx files ================

cd %regenreport%\%report%\%group%

gdxmerge @%regenrun%\scenario_list_%rptgroup%.txt
if not ["%errorlevel%"]==["0"] goto error_merge
if exist ..\%report%_report_%rptgroup%.gdx rm ..\%report%_report_%rptgroup%.gdx
if exist ..\%report%_report_%rptgroup%.gdx (
	echo Please close file %report%_report_%rptgroup%.gdx.
	pause	
	rm ..\%report%_report_%rptgroup%.gdx
	if exist ..\%report%_report_%rptgroup%.gdx (
		echo File is still open.
		cd ..
		goto error_gdx
	))
move merged.gdx ..\%report%_report_%rptgroup%.gdx
cd ..

REM =========== Export scenario data and headers to Excel ========
:export
call gdxxrw i=%report%_report_%rptgroup%.gdx o=%report%_report_%rptgroup%.xlsm epsout=0 log=%reportrun%\temp\%report%_gdxxrw_report.log @%reportrun%\%report%_export.rsp
if not ["%errorlevel%"]==["0"] goto error_gdxxrw

:headers
cd %reportrun%
call gams headers --regenreport=%regenreport% --report=%report% --group=%group% --rptgroup=%rptgroup% o=temp\headers.lst
call gdxxrw i=%regenreport%\%report%\temp\headers_%report%_%rptgroup%.gdx o=%regenreport%\%report%\%report%_report_%rptgroup%.xlsm log=temp\headers.log @temp\headers.rsp
if not ["%errorlevel%"]==["0"] goto error_headers

goto eof

:error_report
echo Report name [%report%] not specified or not recognized.
goto eof_error

:error_template
echo Please close file %report%_report_%rptgroup%.xlsm.
goto eof_error

:error_gdx
echo Please close file %report%_report_%rptgroup%.gdx.
goto eof_error

:error_merge
echo Gdxmerge cannot find one or more %rptgroup% output files in %group% for %report% report.
goto eof_error

:error_gdxxrw
echo Gdxxrw failed for %report% report, see temp\%report%_gdxxrw_report.log. 
goto eof_error

:error_headers
echo Gdxxrw failed for %report% headers, see temp\headers.lst or temp\headers.log. 
goto eof_error

:eof_error
set reportmerge_error=1

cd %regenrun%
:eof
