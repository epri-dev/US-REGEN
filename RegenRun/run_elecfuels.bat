@echo off
REM  ==================================================================================================
REM  Execute REGEN Electric-Fuels Model
REM  ==================================================================================================

REM Specify name of scenario group
set group=example

REM Specify regional definitions for scenarios in this group
set ragg=sup16

call  .\util\settoplevel.bat

REM  ==================================================================================================
REM  Electric Model Parameter Switches Applied Across Multiple Cases
REM  ==================================================================================================

REM  Operational, load, and market parameters
set  opparm=--pssm=yes
set  opparm8760=--i_end=yes

REM  Policy parameters
set  polparm=

REM  Technology parameters
set  techparm=

REM  ==================================================================================================
REM  Scenario Definition and Run Commands
REM  ==================================================================================================

REM Set runmode to   full     to run all components of regenelecfuels
REM set runmode to   report   to run only regen_report
set runmode=full

REM Example of a default reference scenario
set scen=reference
set iter=1
set elecparms=%opparm% %polparm% %techparm% --iter=%iter% --endusescen=ref_ref_def --enduseiter=1
call %elecrun%\elecfuelsub.bat YES  &:: The YES just tells it to run the case -- useful in multi-case files.

REM Examples of alternative scenarios

REM Net-zero target for electric sector
set scen=nzele
set iter=1
set elecparms=%opparm% %polparm% %techparm% --iter=%iter% --endusescen=ref_ref_def --enduseiter=1 --cap_ele=zero50 --iraext=2040
REM call %elecrun%\elecfuelsub.bat YES  &:: The YES just tells it to run the case -- useful in multi-case files.

REM Net-zero target for economy-wide emissions
set scen=nzecon
set iter=1
set elecparms=%opparm% %polparm% %techparm% --iter=%iter% --endusescen=nzby50_ref_def --enduseiter=1 --cap=nzby50 --iraext=2035
REM call %elecrun%\elecfuelsub.bat YES  &:: The YES just tells it to run the case -- useful in multi-case files.

REM Static reference scenario for 2035
set dynfx_scen=reference
set dynfx_year=2035
set scen=static_%dynfx_scen%_%dynfx_year%
set iter=1
set elecparms=%opparm8760% %polparm% %techparm% --dynfx8760=%dynfx_year% --iter=%iter% --endusescen=ref_ref_def --enduseiter=1
REM call %elecrun%\elecfuelsub.bat YES  &:: The YES just tells it to run the case -- useful in multi-case files.

:eof