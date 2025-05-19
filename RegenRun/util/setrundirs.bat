@echo off
REM  This is file setrundirs.bat (in the util subdirectory of the run directory).

REM  Documentation of the directory-naming environment variables is in settoplevel.bat,
REM    which is also in the util subdirectory of the run directory.

REM  "%~dp0" provides the absolute path of the directory containing this commmand file, with a trailing "\".

REM  Move up to the parent directory which is to be set as %regenrun%.
pushd %~dp0..
set regenrun=%cd%

REM  Move up to the grandparent directory which is to be set as %regenroot%.
cd ..
set regenroot=%cd%

REM  Return to the original working directory.
popd

REM  The following specify the second-tier levels of directories with run-related files and utilities

(set elecrun=%regenrun%\elecfuels)   &::  standalone executions of the electric sector model
(set enduserun=%regenrun%\enduse)    &::  standalone executions of the enduse model
(set hoursrun=%regenrun%\hours)      &::  executions of the hour-choice code
(set reportrun=%regenrun%\report)    &::  executions of merged scenario reporting
(set runutil=%regenrun%\util)        &::  utility command files
