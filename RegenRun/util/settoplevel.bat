REM @echo off

REM  This is command file settoplevel.bat (in the util subdirectory of the RegenRun directory).

REM  REGEN operation depends upon the setting of various environment variables used to
REM    identify the locations of essential subdirectories.

REM  -------------------------------------------------------------------------------------------
REM  Directories containing files controlling executions.

REM  %regenrun%   is the root directory for GAMS files, command files, and
REM                 supporting files used to solve cases, report results, etc.
REM  %regenroot%  is the parent directory of %regenrun%.

REM  Under %regenrun% are subdirectories:
REM  %elecrun%     execution files for the electric-fuels model
REM  %enduserun%   execution files for the enduse models
REM  %hoursrun%    execution files for the representative hour choice model
REM  %runutil%     utility command files

REM  The locations of these execution-related directories are established by setrundirs.bat,
REM    which is located in %runutil% along with the current command file, settoplevel.bat.

REM  "%~dp0" provides the absolute path of the directory containing this commmand file, with a trailing "\".
REM  Hence, setrundirs.bat can be dispatched as follows, regardless of calling context:

call %~dp0\setrundirs.bat

REM  -------------------------------------------------------------------------------------------
REM  Directories containing (1) input data and (2) case results and reports.

REM  %elecdata%    contains the input data files (GDX) for execution of the electric/fuels model
REM  %endusedata%  contains the input data files (GDX) for execution of the enduse model
REM  %hoursdata%   contains the input data files (GDX) for execution of the representative hour choice model

REM  %regencases%   is the root directory for all files output by the execution of a case
REM  %regenhours%   is the root directory for all files output by the execution of the hour choice model
REM  %regenreport%  is the root directory for all files output for merged reporting

REM  -------------------------------------------------------------------------------------------

REM  Set any unspecified directories to those of the standard setup, for which %regenroot%
REM    happens to be the parent directory for the data and results directories.

REM  Data directories are specified based on chosen regional aggregation (%ragg%)
set  elecdata=%regenroot%\RegenData\elecfuels\%ragg%
set  endusedata=%regenroot%\RegenData\enduse\%ragg%
set  hoursdata=%regenroot%\RegenData\hours\%ragg%

if not defined regencases      set regencases=%regenroot%\RegenCases
if not defined regenhours      set regenhours=%regenroot%\RegenHours
if not defined regenreport     set regenreport=%regenroot%\RegenReport

REM  The case results directories are created here if they do not yet exist.

if not exist  %regencases%     mkdir  %regencases%
if not exist  %regenhours%     mkdir  %regenhours%
if not exist  %regenreport%    mkdir  %regenreport%

