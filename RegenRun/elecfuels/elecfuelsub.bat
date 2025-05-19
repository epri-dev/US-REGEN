@echo off
REM  This is command file elecfuelsub.bat (in the elecfuels subdirectory of the run directory).
REM  It is used to run one iteration of the electric+fuels sector model.

setlocal enabledelayedexpansion

REM  The caller should specify a desired scenario name, either as argument %1 or by
REM    setting environment variable "scen" to the name.
REM  The caller may set a reference case (for paref) via environment variable "ref".
REM  ref should be of the form "group_name scenario_name", where
REM    group_name should be "." if it does not apply.
REM  DO NOT INCLUDE SPACE CHARACTERS in the group or scenario names.

REM  A keyword is used to specify whether or not to solve the scenario.
REM    Any value other than "YES" or "yes" specifies no solve.
REM  There are two ways to specify this keyword.
REM  (1) Load the keyword in an environment variable with name equal to the scenario name.
REM  (2) Supply the keyword as a command line argument:
REM     (a) argument %2 if the scenario name is passed in as argument %1
REM     (b) argument %1 if the scenario name is set via the environment variable "scen"

if '%2' neq '' (
  REM  Two arguments present ==> presume case (2a) applies.
  set scen=%1
  set doit=%2
  goto TESTNOGO
)

if '%1' neq '' (
  REM  One argument is present. Which is it?
  if defined scen (
    REM  Presume the argument is the keyword and case (2b) applies.
    set doit=%1
    goto TESTNOGO
  )
  REM  Presume the argument is the scenario name and case (1) applies.
  set scen=%1
) else (
  REM  No arguments present. If scen is defined, presume case (1) applies; otherwise do nothing.
  if not defined scen goto :EOF
)

REM  Arriving here means case (1) applies.
REM  This pulls a value from the environment variable named by the scenario name.
REM  It has the necessary advantage of stripping leading and trailing blanks around a non-blank value.
for /F %%Y in ("!%scen%!") do (set doit=%%Y)

REM  If the value of the environment variable is all blank, doit comes out undefined,
REM    in which case does nothing.
if not defined doit goto :EOF

:TESTNOGO
echo Open-Source U.S. Regional Economy, Greenhouse Gas, and Energy (US-REGEN) Model (Version 2025.0.0.1)
echo *
echo EPRI
echo 3420 Hillview Ave.
echo Palo Alto, CA 94304
echo *
echo Copyright (c) 2025 EPRI, Inc. All Rights Reserved.
echo *
echo This software is a beta version that may have problems that could potentially harm your system.
echo *
echo EPRI will evaluate all tester feedback but does not guarantee it will be incorporated into any future release of the product.
echo *
echo Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
echo - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
echo - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
echo - Neither the name of EPRI nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission from EPRI's authorized representative.
echo *

echo Resolved args: [%scen%] [%doit%]
if /I %doit% neq YES goto :EOF

set message=Executing the %scen% case of the electric sector model
title !message!
echo *
echo !message! ...
echo *

REM  ---------------------------------------------------------------------------------------------------------------------------
REM  Documentation of the directory-naming environment variables is in settoplevel.bat,
REM    which is in the util subdirectory of the run directory.

REM  The execution runs from the %elecrun% directory for standalone solves of the electric sector model.

REM  Environment variable "elecrun" has not been set as of yet, but it is possible to set the
REM    active directory to what will come to be referenced as %elecrun% by means of this device:
pushd %~dp0   &::  "%~dp0" provides the absolute path of the directory containing this commmand file.

REM  The caller may set environment variable "group", which causes the case directory
REM    (%casedir%) to be located under %regencases%\%group% rather
REM    than %regencases%.
REM  DO NOT INCLUDE SPACE CHARACTERS in the group name.

call setelecfuelsdirs.bat  &::  This will set all necessary directory-related environment variables.

REM  ---------------------------------------------------------------------------------------------------------------------------
REM  Environment variables that build up parameter specifications to be used in GAMS processing:

REM  The caller may set environment variable "elecparms" with parameters to pass to GAMS.

REM  The caller may set environment variable "listparms" to override the following defaults.
if not defined listparms set listparms=errmsg=1 logoption=3 logline=1 nocr=1 pagecontr=2 pagesize=0 pagewidth=256

if defined licelec set elecparms=%elecparms% license=%licelec%

REM  ---------------------------------------------------------------------------------------------------------------------------
REM  Execution section

set moreargs=s=%elecrestart%\%scen%.elec.g00  gdx=%elecout%\%scen%.elec.gdx --basisgdx=%elecbasis%\%scen%.elec

if defined ref_scen (
  call %runutil%\getmaingdx.bat elecfuels %group% %ref_scen% elecrefgdx
  call %runutil%\getrptgdx.bat elecfuels %group% %ref_scen% elec_rpt elecrptrefgdx
  set moreargs=%moreargs% --elecrefgdx=!elecrefgdx! --elecrptrefgdx=!elecrptrefgdx!
)
if defined fixIXref_scen (
  call %runutil%\getmaingdx.bat elecfuels %group% %fixIXref_scen% fixIXgdx
  set moreargs=%moreargs% --fixIXgdx=!fixIXgdx!
)
if defined etsref_scen (
  call %runutil%\getmaingdx.bat elecfuels %group% %etsref_scen% etsrefgdx
  set moreargs=%moreargs% --etsrefgdx=!etsrefgdx!
)
if defined dynfx_scen (
  call %runutil%\getmaingdx.bat elecfuels %group% %dynfx_scen% dynfxgdx
  set moreargs=%moreargs% --dynfxgdx=!dynfxgdx!
  
  if defined dynfx_prevscen (
    call %runutil%\getmaingdx.bat elecfuels %group% static_%dynfx_scen%_%dynfx_prevscen% dynfx_prevgdx
    set moreargs=!moreargs! --dynfx_prevgdx=!dynfx_prevgdx!
  )
)
if defined statfx_scen (
  call %runutil%\getmaingdx.bat elecfuels %group% %statfx_scen% statfxgdx
  set moreargs=%moreargs% --statfxgdx=!statfxgdx!
)

set errorlevel=0
if not %runmode%==full goto %runmode%

REM * * * * * Electric Model Solve * * * * *
gams regenelecfuels  %elecparms%  %listparms%  %moreargs%  o=%eleclist%\%scen%.elec.lst  |  tee  %eleclist%\%scen%.elec.log
if not exist  %eleclist%\%scen%.elec.lst  goto FAILEDSOLVE
find "ERROR(S) ENCOUNTERED" %eleclist%\%scen%.elec.lst  > nul  &&  goto FAILEDSOLVE
if not ["%errorlevel%"]==["0"] goto FAILEDSOLVE

set message=Successful execution of the %scen% case of the electric-fuels model
echo !message!. > %caseelec%\success_solve.txt

REM * * * * * Electric Model Report * * * * *
:report
gams regen_report %elecparms% r=%elecrestart%\%scen%.elec.g00 o=%eleclist%\%scen%.elecrpt.lst |  tee  %eleclist%\%scen%.elecrpt.log
if not exist  %eleclist%\%scen%.elecrpt.lst  goto FAILEDREPORT
find "ERROR(S) ENCOUNTERED" %eleclist%\%scen%.elecrpt.lst  > nul  &&  goto FAILEDREPORT
if not ["%errorlevel%"]==["0"] goto FAILEDREPORT


set message=Successful execution of the %scen% case of the electric-fuels model report
echo !message!. > %caseelec%\success_report.txt

goto END

:FAILEDSOLVE
set message=Error in solving the %scen% case of the electric-fuels model (code = %errorlevel%)
set errcode=1
echo !message!. > %caseelec%\failed_solve.txt

goto END

:FAILEDREPORT
set message=Error in the %scen% case of the electric-fuels model report
set errcode=1
echo !message!. > %caseelec%\failed_report.txt

:END
popd

title !message!
echo *
echo * !message!. *
echo *
echo *

if !errcode! equ 1  exit /b 1

:eof