:: Description: This script changes the style format of
::              all the source code of the project.

:: Setup the command line
@echo off
title Code Formatter

:: Go to the directory where the script is run
cd /d %~dp0

:: Style and format the source code recursively
astyle --style=linux ^
       --align-pointer=type --align-reference=type ^
       --attach-return-type-decl --attach-return-type ^
       --indent-preproc-block --indent-preproc-define --indent-col1-comments ^
       --remove-brackets ^
       --convert-tabs ^
       --close-templates ^
       --max-code-length=100 ^
       --max-instatement-indent=50 ^
       --lineend=windows ^
       --suffix=none ^
       --recursive ^
       ../../*.h ../../*.cpp

:: Notify the user that we have finished
echo.
echo Code styling complete!
echo.

:: Let the user see the output
pause
