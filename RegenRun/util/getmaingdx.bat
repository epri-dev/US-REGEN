@echo off
REM  This is file getmaingdx.bat (in the util subdirectory of the run directory).
REM  It is used to obtain the complete filename (minus the ".gdx") of the full GDX file
REM    stored with a saved case of an execution of electric-fuel or enduse model.

REM  %1  should be one of "elecfuels" or "enduse".
REM  %2  should be a group name or a "." if none applies.
REM  %3  should be the scenario_name.
REM  %4  is where the fully specified filename (or a dummy if not found) will be returned.

REM  Documentation of the directory-naming environment variables is in settoplevel.bat,
REM    which is also in the util subdirectory of the run directory.

setlocal enabledelayedexpansion

set type=%1
set scen=%3
if '%2' neq '.' set group=%2

REM  The elecfuels and enduse run subdirectories are parallel to the util subdirectory.
REM  So the results subdirectories for the desired case can be obtained as follows.
REM  "%~dp0" provides the absolute path of the directory containing this commmand file, with a trailing "\".

call %~dp0..\%type%\set%type%dirs.bat nocreate

set gdx=!elecout!\%scen%.elec

if not exist %gdx%.gdx set gdx=NotFound

REM  The endlocal and final assignment must go on the same line.
endlocal  &  set %4=%gdx%
