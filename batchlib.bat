@goto main


rem Function Library 1.2.1
rem Updated on 2017-08-27
rem Made by wthe22 - http://winscr.blogspot.com/


:restart
endlocal

:main
@echo off
prompt $s
call :setupEndlocal
setlocal EnableDelayedExpansion EnableExtensions

rem ======================================== Settings ========================================

rem Active Settings
set "dataPath=BatchScript_Data\Functions\"
set "tempPath=!temp!\BatchScript\"

rem None of these are used in this script
set "dataFile=Script.dat"
set "configFile=Script.cfg"
set "defaultScreenWidth=80"
set "defaultScreenHeight=25"
set "screenWidth=!defaultScreenWidth!"
set "screenHeight=!defaultScreenHeight!"
set "pingTimeout=750"

rem ======================================== Script Setup ========================================

set "scriptVersion=1.2.1"
set "releaseDate=08/27/2017"
set "debugFile="

cd /d "%~dp0"
if not exist "!dataPath!" md "!dataPath!"
if not exist "!tempPath!" md "!tempPath!"
cd /d "!dataPath!"


title Function Library !scriptVersion!
cls
echo Loading script...

call :capchar CR LF BS BASE DQ
call :readFunctions
set "debugMode=FALSE"
goto categoryMenu


rem === Multiple batch script windows ===
start "" "%~f0" [Command to execute]
rem =====================================

rem File location:   %~f0
if not exist "!dataPath!" md "!dataPath!"


:errorExit
echo=
echo ERROR: !errorMsg!
echo Script will exit
pause > nul
exit

rem ======================================== Main Menu ========================================

:categoryMenu
set "userInput=?"
cls
call :getCategory list
echo=
if defined lastUsed_function echo L. Last used Function
echo S. Search Functions
echo D. Toggle debug mode [!debugMode!]
echo 0. Exit
echo=
echo Which tool do you want to use?
set /p "userInput="
if "!userInput!" == "0" exit
if defined lastUsed_function if /i "!userInput!" == "L" goto startFunction
if /i "!userInput!" == "S" goto searchFunction
if /i "!userInput!" == "D" call :toggleDebugMode
call :getCategory !userInput!
if defined selected_category goto functionMenu
goto categoryMenu


:toggleDebugMode
if /i "!debugMode!" == "TRUE" (
    set "debugMode=FALSE"
) else set "debugMode=TRUE"
goto :EOF


:functionMenu
set "userInput=?"
cls
call :getFunction !selected_category! list
echo=
echo 0. Back
echo=
echo Input function number:
set /p "userInput="
if "!userInput!" == "0" goto categoryMenu
call :getFunction !selected_category! !userInput!
if defined selected_function goto startFunction
goto functionMenu


:searchFunction
set "userInput=?"
cls
echo 0. Back
echo=
echo Input search keyword:
set /p "userInput="
if "!userInput!" == "0" goto categoryMenu

rem Search for keyword in function name
set "fxList_search="
for %%f in (!fxList_all!) do (
    set "_temp= %%f"
    if not "!_temp:%userInput%=!" == "!_temp!" set "fxList_search=!fxList_search! %%f"
)
:searchResult
cls
echo Keyword:   !userInput!
echo=
call :getFunction search list
echo=
echo 0. Back
echo=
echo Input function number:
set /p "userInput="
if "!userInput!" == "0" goto categoryMenu
call :getFunction search !userInput!
if defined selected_function goto startFunction
goto searchResult


:startFunction
set "lastUsed_function=!selected_function!"
setlocal EnableDelayedExpansion EnableExtensions
title Function Library - !selected_function!

if /i "!debugMode!" == "TRUE" (
    call :debugMenu
) else call :startFunction_noDebug

title Function Library !scriptVersion!
endlocal
goto categoryMenu


:startFunction_noDebug
cls
echo =============================== START OF FUNCTION ==============================
echo=!fxParam_%selected_function%!
echo=
call :!selected_function!_Scripts
echo=
echo ================================ END OF FUNCTION ===============================
echo=
pause
goto :EOF

rem ======================================== Debug Menu ========================================

:debugMenu
set "userInput=?"
title Function Library - Debug Mode
cls
echo !selected_function!()
echo=
echo 1. Single test
echo 2. Multiple tests
echo=
echo 0. Back to main menu
echo C. Execute Commands
echo=
echo What do you want to do?
set /p "userInput="
if "!userInput!" == "0" goto :EOF
if /i "!userInput!" == "C" call :scriptCmd
if "!userInput!" == "1" goto debugSingle
if "!userInput!" == "2" goto debugMultiple
goto debugMenu


:scriptCmd
cls
echo Batch Script CMD
echo Be careful with special characters
echo Type "EXIT /B" to return to previous menu
echo=
:scriptCmd_Loop
set /p "userInput=> "
%userInput%
goto scriptCmd_Loop

rem ======================================== Debug Single ========================================


:debugSingle
cls
echo !selected_function!()
echo=
echo=!fxParam_%selected_function%!
echo=
echo Input parameter for the function:
echo=
set /p "testParameter="

rem Display settings
cls
echo !selected_function!(!testParameter!)
echo=
pause
echo=

call :!selected_function!_Settings 2> nul

rem Run function test
setlocal EnableDelayedExpansion EnableExtensions
cls
@echo on    & set "startTime=!time!"
call :!selected_function! !testParameter!
@echo off   & set "functionOutput=!return!"
call :difftime !time! !startTime!
call :ftime !return!
set "runTime=!return!"
echo=
pause 

rem Display test result
cls
echo Parameter:
echo=
echo=!testParameter!
echo=
echo Return     : !functionOutput!
echo=
echo Time taken    : !runTime!
echo=
call :!selected_function!_SingleTest_EndInfo 2> nul
echo=
endlocal
pause
goto debugMenu


:debugMultiple
cls
set "testTotal=1000"
call :inputNumber testTotal 0 2147483647

cls
echo !selected_function!()
echo=
echo Test !testTotal! times for speed and output of function
echo=
pause

setlocal EnableDelayedExpansion EnableExtensions
call :!selected_function!_Settings 2> nul
set "errorDescription="
set "functionTime=0"
set "testStartTime=!time!"

for /l %%l in (1,1,!testTotal!) do (
    set "testCount=%%l"
    title Function Library !scriptVersion! - Debug Mode - Test #%%l / !testTotal!
    call :!selected_function!_Setup 2> nul
    set "return="
    set "functionTimeCS=0"
    set "functionStartTime=!time!"
    
    call :!selected_function! !testParameter!
    
    for %%t in (!time! !functionStartTime!) do (
        for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
            set /a "functionTimeCS+=24%%a %% 24 *360000 +1%%b*6000 +1%%c*100 +1%%d -610100"
        )
        set /a "functionTimeCS*=-1"
    )
    if !functionTimeCS! LSS 0 set /a "return+=8640000"
    set /a "functionTime+=!functionTimeCS!"
    
    set "functionOutput=!return!"
    call :!selected_function!_Check 2> nul
    if defined errorDescription goto debugError
)
call :difftime !time! !testStartTime!
set /a "testTimeAverage=!return!/!testTotal!"
set /a "functionTimeAverage=!functionTime!/!testTotal!"
call :ftime !return!
set "runTime=!return!"
call :ftime !testTimeAverage!
set "testTimeAverage=!return!"
call :ftime !functionTime!
set "functionTime=!return!"
call :ftime !functionTimeAverage!
set "functionTimeAverage=!return!"
echo=
echo Test Done
pause

title Function Library !scriptVersion! - Debug Mode
cls
echo Run time taken         : !runTime!
echo Function time taken    : !functionTime!
echo Average function time  : !functionTimeAverage!
echo Average time per test  : !testTimeAverage!
echo Number of tests        : !testTotal!
echo=
call :!selected_function!_MultiTest_EndInfo 2> nul
echo=
endlocal
pause
goto debugMenu


:debugError
cls
echo An error occured...
echo=
echo Parameter  : !testParameter!
echo=
echo Return     : !functionOutput!
echo=
echo Error Description  :
echo=!errorDescription!
echo=
call :!selected_function!_MultiTest_ErrorInfo 2> nul
echo=
endlocal
pause
goto debugMenu


rem ======================================== Category Functions ========================================

:readFunctions
set "categoryList="
set "lastFoundFunction="
for /f "usebackq tokens=*" %%o in ("%~f0") do for /f "tokens=1,2* delims= " %%a in ("%%o") do (
    if /i "%%a" == "#CATEGORY" if not defined catName_%%b (
        set "categoryList=!categoryList! %%b"
        set "catName_%%b=%%c"
        set "fxList_%%b="
    )
    if /i "%%a" == "#FUNCTION" for /f "tokens=1* delims= " %%d in ("%%c") do (
        set "fxName_%%d=%%e"
        set "lastFoundFunction=%%d"
        if defined catName_%%b (
            set "fxList_%%b=!fxList_%%b! %%d"
        ) else set "fxList_others=!fxList_others! %%d"
    )
    if /i "%%a" == ":!lastFoundFunction!" (
        set "_temp=%%o"
        set "fxParam_!lastFoundFunction!=!_temp:~1!"
    )
)
set "catName_others=Others"
set "categoryList=!categoryList! others"
set "fxList_all="
set "fxCount_all=0"
for %%c in (!categoryList!) do (
    set "fxList_all=!fxList_all! !fxList_%%c!"
    set "fxCount_%%c=0"
    for %%f in (!fxList_%%c!) do set /a "fxCount_%%c+=1"
    set /a "fxCount_all+=!fxCount_%%c!"
)
set "catName_all=All"
set "categoryList=all !categoryList!"
goto :EOF


:getCategory   list|number
set "_listCount=0"
set "selected_category="
for %%c in (!categoryList!) do (
    set /a "_listCount+=1"
    if /i "%1" == "LIST" (
        set "_listCount=   !_listCount!"
        echo !_listCount:~-3,3!. !catName_%%c! [!fxCount_%%c!]
    ) else if "%1" == "!_listCount!" set "selected_category=%%c"
)
goto :EOF


:getFunction   category  list|number
set "_listCount=0"
set "selected_function="
for %%f in (!fxList_%1!) do (
    set /a "_listCount+=1"
    if /i "%2" == "list" (
        set "_listCount=   !_listCount!"
        echo !_listCount:~-3,3!. !fxName_%%f!
    ) else if "%2" == "!_listCount!" set "selected_function=%%f"
)
goto :EOF

rem ======================================== Define Categories ========================================

:DEFINE_CATEGORY_HERE --> #CATEGORY category_ID  name

#CATEGORY math      Math
#CATEGORY str       String
#CATEGORY conv      Convert
#CATEGORY time      Date and Time
#CATEGORY file      File and Folder
#CATEGORY env       Environment
#CATEGORY dev       Developer

rem ======================================== Functions Library ========================================

rem ======================================== example(only) ========================================

rem #FUNCTION [category_ID] [label] [name on the menu]
:example_Scripts    // Scripts to simulate the function
echo Hello world!
call :example
goto :EOF


:example_Settings   // Things to do before running multi test. Only executed ONCE
set "chanceOfError=5"
goto :EOF


:example_Setup      // Things to do before EACH test (Setup parameter)
set /a "testParameter=!random! %% !chanceOfError!"
goto :EOF


:example            // This is the function
set "return=no_error"
if "!testParameter!" == "0" (
    echo 1 + 1 = 11
    set "return=error"
) else echo 1 + 1 = 2
exit /b


:example_Check      // Check if the output of the function is correct or not
if /i "!functionOutput!" == "error" set "errorDescription=1 + 1 is not 11!!"
rem Describe whats wrong with function output in "errorDescription"
rem Defining this will call "MultiTest_ErrorInfo"
goto :EOF


:example_MultiTest_ErrorInfo    // Informations add for multiple test error result
echo Chance of error: !chanceOfError!
goto :EOF


:example_SingleTest_EndInfo     // Informations to show for single test end result
echo Test Done
goto :EOF


:example_MultiTest_EndInfo      // Informations to show for multiple test end result
echo MultiTest Success!!
goto :EOF           // All labels above ends with this

rem ======================================== Functions List ========================================

rem ======================================== rand(min,max) ========================================

#FUNCTION math rand rand (min,max)


:rand_Scripts   // Scripts to simulate the function
echo Generate random number within a range
echo=
call :inputNumber minimum 0 2147483647
call :inputNumber maximum 0 2147483647
call :rand "!minimum!" "!maximum!"
echo=
echo Random Number  : !return!
goto :EOF


:rand   minimum  maximum
set /a "return=!random!*65536 + !random!*2 + !random!/16384"
set /a "return%%= (%~2) - (%~1) + 1"
set /a "return+=%~1"
exit /b


rem Variation
:randn
rem Generate a random integer from -2147483648 to 2147483647
set /a "return=!random!*131072 + !random!*4 + !random!/8192"
exit /b

rem ======================================== randw(weights[]) ========================================

#FUNCTION math randw randw (weights[])

:randw_Scripts
echo Generate random number based on weights
echo=
call :inputString weights
call :randw !weights!
echo=
echo Random Number  : !return!
goto :EOF


:randw   weight1  [weight2]  [...]
set "_sum=0"
for %%n in (%*) do set /a "_sum+=%%n"
set /a "_rand=!random!*65536 + !random!*2 + !random!/16384"
set /a "_rand%%=!_sum!"
set /a "_rand+=1"
set "_sum=0"
set "return=0"
for %%n in (%*) do (
    set /a "_sum+=%%n"
    if !_rand! LEQ !_sum! exit /b
    set /a "return+=1"
)
set "return=-1"
exit /b

rem ======================================== sqrt(int) ========================================

#FUNCTION math sqrt sqrt (int)


:sqrt_Scripts
echo Calculate square root of x
echo=
call :inputNumber number 0 2147483647
call :sqrt !number!
echo=
echo Square root of !number! is !return!
echo Result is floored
goto :EOF


:sqrt   integer
set "return=0"
for %%n in (32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    set /a "_guess=!return! + %%n"
    set /a "_guess*=!_guess!"
    if !_guess! LEQ %1 set /a "return+=%%n"
)
exit /b

rem ======================================== cbrt(int) ========================================

#FUNCTION math cbrt cbrt (x)


:cbrt_Scripts
echo Calculate cube root of x
echo=
call :inputNumber number 0 2147483647
call :cbrt !number!
echo=
echo Cube root of !number! is !return!
echo Result is floored
goto :EOF


:cbrt   integer
set "return=0"
for %%n in (1024 512 256 128 64 32 16 8 4 2 1) do (
    set /a "_guess=!return! + %%n"
    set /a "_guess*=!_guess!*!_guess!"
    if !_guess! LEQ %1 set /a "return+=%%n"
)
exit /b

rem ======================================== yroot(int,pow) ========================================

#FUNCTION math yroot yroot (x,y)


:yroot_Scripts
echo Calculate y root of x
echo=
call :inputNumber number 0 2147483647
call :inputNumber power 0 2147483647
call :yroot !number! !power!
echo=
echo Root to the power of !power! of !number! is !return!
echo Result is floored
goto :EOF


:yroot   integer  power
set "return=0"
for %%n in (32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    set "_guess=1"
    for /l %%p in (1,1,%2) do set /a "_guess*=!_guess! + %%n"
    if not !_guess! LEQ 0 if !_guess! LEQ %1 set /a "return+=%%n"
)
exit /b

rem ======================================== pow(int,pow) ========================================

#FUNCTION math pow pow (x,y)


:pow_Scripts
echo Calculate x to the power of n
echo=
call :inputNumber number 0 2147483647
call :inputNumber power 0 2147483647
call :pow !number! !power!
echo=
echo !number! to the power of !power! is !return!
goto :EOF


:pow   integer  power
set "return=1"
for /l %%p in (1,1,%2) do set /a "return*=%~1"
exit /b

rem ======================================== prime(int) ========================================

#FUNCTION math prime prime (x)


:prime_Scripts
echo Test for prime number
echo=
call :inputNumber number 0 2147483647
call :prime !number! !power!
echo=
if "!return!" == "!number!" (
    echo !number! is a prime number
) else if "!return!" == "0" (
    echo !number! is not a prime number nor a composite number
) else (
    echo !number! is a composite number. It is divisible by !return!
)
goto :EOF


:prime   integer
set "return=0"
if %1 GEQ 2 (
    set /a "_remainder=%1 %% 2"
    if "!_remainder!" == "1" (
        set "_max=0"
        for %%n in (32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
            set /a "_guess=!_max! + %%n"
            set /a "_guess*=!_guess!"
            if !_guess! LEQ %1 set /a "_max+=%%n"
        )
        set "return=%1"
        for /l %%n in (3,2,!_max!) do if "!return!" == "%1" (
            set /a "_remainder=%1 %% %%n"
            if "!_remainder!" == "0" set "return=%%n"
        )
    ) else set "return=2"
)
exit /b

rem ======================================== gcf(int,int) ========================================

#FUNCTION math gcf gcf (x,y)


:gcf_Scripts
echo Calculate greatest common factor (GCF) of 2 numbers
echo=
call :inputNumber number1 0 2147483647
call :inputNumber number2 0 2147483647
call :gcf !number1! !number2!
echo=
echo GCF of !number1! and !number2! is !return!
goto :EOF


:gcf   integer  integer
set /a "return=%~1"
set /a "_num=%~2"
for /l %%n in (0,1,22) do if not "!_num!" == "0" (
    set /a "_num%%=!return!"
    if not "!_num!" == "0" (
        set /a "return%%=!_num!"
        if "!return!" == "0" set "return=!_num!"
    )
)
exit /b

rem ======================================== strlen(string) ========================================

#FUNCTION str strlen strlen (string)


:strlen_Scripts
echo Calculate string length
echo=
call :inputString string
call :strlen string
echo=
echo The length of the string is !return! characters
goto :EOF


:strlen   variable_name
set "return=0"
if defined %1 (
    for %%n in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        set /a "return+=%%n"
        for %%l in (!return!) do if "!%1:~%%l,1!" == "" set /a "return-=%%n"
    )
    set /a "return+=1"
)
exit /b

rem ======================================= toUppercase(string) ========================================

#FUNCTION str toUppercase toUppercase (string)


:toUppercase_Scripts
echo Convert string to uppercase
echo=
call :inputString string
call :toUppercase string
echo=
echo Uppercase:
echo !string!
goto :EOF


:toUppercase   variable_name
set "%1=.!%1!"
for %%a in (
    A B C D E F G H I J K L M 
    N O P Q R S T U V W X Y Z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b

rem ======================================= toLowercase(string) ========================================

#FUNCTION str toLowercase toLowercase (string)


:toLowercase_Scripts
echo Convert string to lowercase
echo=
call :inputString string
call :toLowercase string
echo=
echo Lowercase:
echo !string!
goto :EOF


:toLowercase   variable_name
set "%1=.!%1!"
for %%a in (
    a b c d e f g h i j k l m 
    n o p q r s t u v w x y z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b

rem ======================================== shuffle(variable_name) ========================================

#FUNCTION str shuffle shuffle (string)


:shuffle_Scripts
echo Shuffle characters in a string
echo=
call :inputString text
call :shuffle text
echo=
echo Shuffled string: 
echo=!text!
goto :EOF


:shuffle   variable_name
if defined %1 (
    set "_len=0"
    for %%n in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        set /a "_len+=%%n"
        for %%l in (!_len!) do if "!%1:~%%l,1!" == "" set /a "_len-=%%n"
    )
    set /a _len+=1
    for /l %%n in (!_len!,-1,1) do (
        set /a "_rand=!random! %% %%n"
        for %%i in (!_rand!) do (
            set "_text=!%1:~0,%%i!"
            set "%1=!%1:~%%i!"
            set "%1=!_text!!%1:~1!!%1:~0,1!"
        )
    )
)
exit /b

rem ======================================== strchk(string) ========================================

#FUNCTION str strchk strchk (string,charset)


:strchk_Scripts
echo Check string for invalid characters
echo=
call :inputString string
call :inputString valid_characters
call :strchk string valid_characters
echo=
if "!return!" == "-1" (
    echo String is valid
) else echo Character index !return! of the string is invalid
goto :EOF


:strchk   variable_name  valid_characters_variable
set "return=-1"
for /l %%n in (0,1,8191) do if not "!%1:~%%n,1!" == "" if "!return!" == "-1" (
    set "_char=!%1:~%%n,1!"
    for %%c in ("!_char!") do if "!%2:%%~c=!" == "!%2!" set /a "return=%%n"
)
exit /b

rem ======================================== difftime(end,start) =======================================

#FUNCTION time difftime difftime (end,start)


:difftime_Scripts
echo Calculate difference of 2 times in centiseconds
echo If start_time is not defined then it assumes it is 00:00:00.00
echo=
call :inputString start_time
call :inputString end_time
call :difftime !end_time! !start_time!
echo=
echo Time difference: !return! centiseconds
goto :EOF


:difftime   end_time  [start_time  [/n]]
set "return=0"
for %%t in (%1:00:00:00:00 %2:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
    set /a "return+=24%%a %% 24 *360000 +1%%b*6000 +1%%c*100 +1%%d -610100"
    set /a "return*=-1"
)
if /i not "%3" == "/n" if !return! LSS 0 set /a "return+=8640000"
exit /b

rem /n      Don't fix negative centiseconds

rem ======================================== ftime(int) ========================================

#FUNCTION time ftime ftime (int)


:ftime_Scripts
echo Convert time (in centiseconds) to HH:MM:SS.CC format
echo=
call :inputString time_in_centisecond
call :ftime !time_in_centisecond!
echo=
echo Formatted time : !return!
goto :EOF


:ftime   time_in_centiseconds
set /a "_remainder=%* %% 8640000"
set "return="
for %%n in (360000 6000 100 1) do (
    set /a "_result=!_remainder! / %%n"
    set /a "_remainder%%= %%n"
    set "_result=?0!_result!"
    set "return=!return!!_result:~-2,2!:"
)
set "return=!return:~0,-4!.!return:~-3,2!"
exit /b

rem ================================== diffdate(end,start) ==================================

#FUNCTION time diffdate diffdate (end,start)


:diffdate_Scripts
echo Calculate difference between 2 dates in days
echo If start_date is not defined then it assumes it is 1/01/1
echo=
call :inputString start_date
call :inputString end_date
call :diffdate !end_date! !start_date!
echo=
echo Difference : !return! Days
goto :EOF


:diffdate   end_date  [start_date]  [days_to_add]
set "return=0"
set "_param=/%~1/1/1/1  /%~2/1/1/1"
set "_param=!_param:/0=/!"
for %%d in (!_param!) do for /f "tokens=1-3 delims=/" %%a in ("%%d") do (
    set /a "return+= (%%c-1) * 365  +  %%c/4 - %%c/100 + %%c/400"
    set /a "_leapyear=%%c %% 100"
    if "!_leapyear!" == "0" (
        set /a "_leapyear=%%c %% 400"
    ) else set /a "_leapyear=%%c %% 4"
    if "!_leapyear!" == "0" if %%a LEQ 2 set /a "return-=1"
    set /a "return+= 30 * (%%a-1) + %%a / 2 + %%b"
    if %%a GTR 8 set /a "return+=%%a %% 2"
    if %%a GTR 2 set /a "return-=2"
    set /a "return*=-1"
)
set /a "return+=%~3 + 0"
exit /b

rem ================================== dayof(date) ==================================

#FUNCTION time dayof dayof (date)


:dayof   date  [/n | /s]
call :diffdate %1 1 1
set /a return%%=7
if /i "%2" == "/n" exit /b
if "!return!" == "0" set "return=Sunday"
if "!return!" == "1" set "return=Monday"
if "!return!" == "2" set "return=Tuesday"
if "!return!" == "3" set "return=Wednesday"
if "!return!" == "4" set "return=Thursday"
if "!return!" == "5" set "return=Friday"
if "!return!" == "6" set "return=Saturday"
if /i "%2" == "/s" set "return=!return:~0,3!"
exit /b

rem /n      Returns number value
rem /s      Returns short date name

rem ================================== timeleft(start,progress,end) ==================================

#FUNCTION time timeleft timeleft (start,progress,end)


:timeleft_Scripts
echo Calculate run time remaining
echo=
for %%t in (without with) do (
    echo Simulate Primality Test [1 - 1000] %%t timeleft
    set /a "total=1000"
    set "start_time=!time!"
    for /l %%p in (1,1,!total!) do (
        set "return=0"
        if %%p GEQ 2 (
            set /a "_remainder=%%p %% 2"
            if "!_remainder!" == "1" (
                set "_max=0"
                for %%n in (32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
                    set /a "_guess=!_max! + %%n"
                    set /a "_guess*=!_guess!"
                    if !_guess! LEQ %%p set /a "_max+=%%n"
                )
                set "return=%%p"
                for /l %%n in (3,2,!_max!) do if "!return!" == "%%p" (
                    set /a "_remainder=%%p %% %%n"
                    if "!_remainder!" == "0" set "return=%%n"
                )
            ) else set "return=2"
        )
        if "!return!" == "%%p" (
            set "display=%%p    "
            echo=|set/p=!display:~0,4!
        )
        
        if /i "%%t" == "with" (
            rem timeleft function starts here ========================================
            set "_remainder=0"
            for %%t in (!time!:00:00:00:00 !start_time!:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
                set /a "_remainder+=24%%a %% 24 *360000 +1%%b*6000 +1%%c*100 +1%%d -610100"
                set /a "_remainder*=-1"
            )
            if !_remainder! LSS 0 set /a "_remainder+=8640000"
            
            set /a "_remainder*= 1000 - %%p*1000/!total!"
            set /a "_remainder/=%%p*1000/!total!"
            
            set /a "_remainder=!_remainder! %% 8640000"
            set "_timeRemaining="
            for %%n in (360000 6000 100 1) do (
                set /a _result=!_remainder! / %%n
                set /a _remainder=!_remainder! %% %%n
                set "_result=?0!_result!"
                set "_timeRemaining=!_timeRemaining!!_result:~-2,2!:"
            )
            set "_timeRemaining=!_timeRemaining:~0,-4!.!_timeRemaining:~-3,2!"
            rem timeleft function ends here ========================================
            
            title Simulate Primality Test - Time remaining : !_timeRemaining!
        )
    )

    call :difftime !time! !start_time!
    call :ftime !return!

    echo=
    echo=
    echo Actual time taken: !return!
    echo=
)
goto :EOF

rem ======================================== binToDec(bin) ========================================

#FUNCTION conv binToDec binToDec (bin)


:binToDec_Scripts
echo Convert binary to decimal
echo=
call :inputString binary
call :binToDec !binary!
echo=
echo The decimal value is !return!
goto :EOF


:binToDec   unsigned_binary
set "return=0"
set "_bin=%1"
for %%n in (
    1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 
    16384 32768 65536 131072 262144 524288 1048576 
    2097152 4194304 8388608 16777216 33554432 67108864
    134217728 268435456 536870912 1073741824
) do if defined _bin (
    set /a "return+= !_bin:~-1,1! * %%n"
    set "_bin=!_bin:~0,-1!"
)
exit /b

rem ======================================== decToBin(int) ========================================

#FUNCTION conv decToBin decToBin (int)


:decToBin_Scripts
echo Convert decimal to unsigned binary
echo=
call :inputNumber decimal 0 2147483647
call :decToBin !decimal!
echo=
echo The binary value is !return!
goto :EOF


:decToBin   positive_integer
set /a "_result=%~1 + 0"
set "return="
if not "%~1" == "" if "!_result!" == "0" (
    set "return=0"
) else for /l %%n in (0,1,31) do if not "!_result!" == "0" (
    set /a "_remainder=!_result! %% 2"
    set "return=!_remainder!!return!"
    set /a "_result/=2"
)
exit /b

rem ======================================== decToOctal(int) ========================================

#FUNCTION conv decToOctal decToOctal (int)


:decToOctal_Scripts
echo Convert decimal to octal
echo=
call :inputNumber decimal 0 2147483647
call :decToOctal !decimal!
echo=
echo The octal value is !return!
goto :EOF


:decToOctal   positive_integer
set /a "_result=%~1 + 0"
set "return="
if not "%~1" == "" if "!_result!" == "0" (
    set "return=0"
) else for /l %%n in (0,1,10) do if not "!_result!" == "0" (
    set /a "_remainder=!_result! %% 8"
    set "return=!_remainder!!return!"
    set /a "_result/=8"
)
exit /b

rem ======================================== decToHex(int) ========================================

#FUNCTION conv decToHex decToHex (int)


:decToHex_Scripts
echo Convert decimal to hexadecimal
echo=
call :inputNumber decimal 0 2147483647
call :decToHex !decimal!
echo=
echo The hexadecimal value is !return!
goto :EOF


:decToHex   positive_integer
set /a "_result=%~1 + 0"
set "return="
set "_charset=0123456789ABCDEF"
if not "%~1" == "" if "!_result!" == "0" (
    set "return=0"
) else for /l %%n in (0,1,7) do if not "!_result!" == "0" (
    set /a "_remainder=!_result! %% 16"
    for %%r in (!_remainder!) do set "return=!_charset:~%%r,1!!return!"
    set /a "_result/=16"
)
exit /b

rem ======================================== baseX(int,out_charset) ========================================

#FUNCTION conv baseX baseX (int,charset)


:baseX_Scripts
echo Convert decimal to baseX
echo=
call :inputNumber decimal 0 2147483647
call :inputString output_character_set
call :baseX !decimal! output_character_set
echo=
echo The value is !return!
goto :EOF


:baseX   positive_integer  output_charset_variable
set /a "_result=%~1 + 0"
set "return="
if not "!%2!" == "" if not "!_result!" == "0" (
    set "_charCount=0"
    for %%n in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        set /a "_charCount+=%%n"
        for %%l in (!_charCount!) do if "!%2:~%%l,1!" == "" set /a "_charCount-=%%n"
    )
    set /a _charCount+=1
    
    for /l %%n in (0,1,31) do if not "!_result!" == "0" (
        set /a "_remainder=!_result! %% !_charCount!"
        for %%r in (!_remainder!) do set "return=!%2:~%%r,1!!return!"
        set /a "_result/=!_charCount!"
    ) 
) else set "return=!%2:~0,1!"
exit /b

rem =============================== base10(string,in_charset) ===============================

#FUNCTION conv base10 base10 (string,charset)


:base10_Scripts
echo Convert characters from any encoding to base10 (decimal)
echo=
call :inputString characters
call :inputString input_character_set
call :base10 characters input_character_set
echo=
echo The converted value is !return!
goto :EOF


:base10   variable_name  input_charset_variable
set "return="
if not "!%2!" == "" if not "!%1!" == "" (
    set "_charCount=0"
    for %%n in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        set /a "_charCount+=%%n"
        for %%l in (!_charCount!) do if "!%2:~%%l,1!" == "" set /a "_charCount-=%%n"
    )
    set /a _charCount+=1
    
    set "return=0"
    set "_chars=!%1!"
    set "_power=1"
    for /l %%l in (31,-1,0) do if defined _chars (
        for /l %%n in (0,1,!_charCount!) do if "!_chars:~-1,1!" == "!%2:~%%n,1!" set /a "return+= %%n * !_power!"
        set "_chars=!_chars:~0,-1!"
        set /a "_power*=!_charCount!" 2> nul
    )
)
exit /b

rem ======================================== romanNumeral(int) ========================================

#FUNCTION conv romanNumeral romanNumeral (int)


:romanNumeral_Scripts
echo Convert number to roman numeral
echo=
call :inputNumber number 0 4999
call :romanNumeral !number!
echo=
echo The Roman Numeral value is !return!
goto :EOF

:romanNumeral   integer(1-4999)
set "return="
set /a "_value=%~1"
for %%v in (
    M:1000
    CM:900 D:500 CD:400 C:100
    XC:90  L:50  XL:40  X:10
    IX:9   V:5   IV:4   I:1
) do for /f "tokens=1-2 delims=:" %%a in ("%%v") do (
    for /l %%n in (%%b,%%b,!_value!) do set "return=!return!%%a"
    set /a "_value%%=%%b"
)
exit /b

rem ======================================== unromanNumeral(string) ========================================

#FUNCTION conv unromanNumeral unromanNumeral (string)


:unromanNumeral_Scripts
echo Convert roman numeral to number
echo=
call :inputString romanNumeral
call :unromanNumeral !romanNumeral!
echo=
echo The decimal value is !return!
goto :EOF


:unromanNumeral   roman_numeral
set "return=%1"
for %%l in (
    IV:4 XL:40 CD:400 IX:9 XC:90 CM:900
    I:1 V:5 X:10 L:50 C:100 D:500 M:1000
) do for /f "tokens=1-2 delims=:" %%a in ("%%l") do set "return=!return:%%a=+%%b!"
set /a "return=!return!"
exit /b

rem ======================================== speedtest() ========================================

#FUNCTION env speedtest speedtest ()


:speedtest_Scripts
echo Test for system speed
echo=
set "startTime=!time!"
call :speedtest
call :difftime !time! !startTime!
call :ftime !return!
echo=
echo Loop speed : !loopSpeed!
echo Time taken : !return!
echo=
echo Info: Loop speed is number of FOR Loops in 1 centisecond
goto :EOF


[Requires]
call :wait


:speedtest
if not defined loopSpeed set "loopSpeed=300"
set "return="
for %%s in (50) do for /l %%n in (1,1,12) do if not "!return!" == "%%s" (
    set "_startTime=!time!"
    call :wait %%s * 10
    set "return=0"
    for %%t in (!time!:00:00:00:00 !_startTime!:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
        set /a "return+=24%%a %% 24 *360000+1%%b*6000+1%%c*100+1%%d-610100"
        set /a "return*=-1"
    )
    if !return! LSS 0 set /a "return+=8640000"
    set /a "loopSpeed=!loopSpeed! * %%s / !return!"
)
set "_startTime="
exit /b

rem ======================================== wait() ========================================

#FUNCTION ? wait wait (int)


:wait_Scripts
echo Wait for n milliseconds
echo This version burns alot of CPU
echo=
call :inputNumber time_in_milliseconds 0 2147483647
echo=
echo Calibrating speed with speedtest()
call :speedtest
echo Calibration done
echo=
echo Loop speed : !loopSpeed!
echo=
echo Info: Loop speed is number of FOR Loops in 1 centisecond
echo=
echo Sleep for !time_in_milliseconds! milliseconds...
set "start_time=!time!"
call :wait !time_in_milliseconds!
call :difftime !time! !start_time! 
echo=
echo Actual time taken: ~!return!0 milliseconds
goto :EOF


[Prerequisites]
call :speedtest


:wait   milliseconds
set /a "return=!loopSpeed! * %* / 10"
for /l %%n in (1,1,!return!) do call
exit /b

rem ======================================== sleep() ========================================

#FUNCTION ? sleep sleep (int)


:sleep_Scripts
echo Sleep for n milliseconds (VBScript hybrid)
echo Similar to wait(), but this version does not burn CPU
echo=
call :inputNumber time_in_milliseconds 0 2147483647
echo=
echo Calibrating speed with setupSleep()
call :setupSleep
echo Calibration done
echo=
echo Delay      : !sleepDelay!ms
echo=
echo Sleep for !time_in_milliseconds! milliseconds...
set "start_time=!time!"
call :sleep !time_in_milliseconds!
call :difftime !time! !start_time! 
echo=
echo Actual time taken: ~!return!0 milliseconds
goto :EOF


[Prerequisites]
set "tempPath=your_path_here"

[Prerequisites]
call :setupSleep


:setupSleep
set "return="
set "_totalDelay=0"
set "sleepDelay="
echo WScript.Sleep WScript.Arguments(0) > "!tempPath!\sleep.vbs"
for /l %%n in (1,1,10) do (
    set "_startTime=!time!"
    call :sleep
    set "return=0"
    for %%t in (!time!:00:00:00:00 !_startTime!:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
        set /a "return+=24%%a %% 24 *360000+1%%b*6000+1%%c*100+1%%d-610100"
        set /a "return*=-1"
    )
    if !return! LSS 0 set /a "return+=8640000"
    set /a "_totalDelay+=!return!"
    
)
set /a "sleepDelay=!_totalDelay!"
set "_totalDelay="
set "_startTime="
exit /b


:sleep   milliseconds
set /a "return=%* - !sleepDelay! + 0"
cscript //NoLogo "!tempPath!\sleep.vbs" !return!
exit /b

rem ======================================== getScreenSize() ========================================

#FUNCTION env getScreenSize getScreenSize ()


:getScreenSize_Scripts
echo Get console screen buffer size
call :getScreenSize
echo=
echo Screen buffer size    : !screenHeight!x!screenWidth!
goto :EOF


:getScreenSize
set "_lineNum=0"
for /f "usebackq tokens=2 delims=:" %%a in (`mode con`) do (
	set /a "_lineNum+=1"
    if "!_lineNum!" == "1" set /a "screenHeight= 0 + %%a + 0"
    if "!_lineNum!" == "2" set /a "screenWidth= 0 + %%a + 0"
)
set "_lineNum="
exit /b

rem ======================================== chkAdmin() ========================================

#FUNCTION env chkAdmin chkAdmin ()


:chkAdmin_Scripts
echo Check for administrator privilege
echo=
call :chkAdmin
echo=
if "!return!" == "0" (
    echo Administrator privilege detected
) else echo No administrator privilege detected
goto :EOF


:chkAdmin
(net session || openfiles) > nul 2> nul
set "return=!errorlevel!"
goto :EOF

rem ======================================== getSID() ========================================

#FUNCTION env getSID getSID ()


:getSID_Scripts
echo Get currect user's SID
echo=
call :getSID
echo=
echo User SID : !return!
goto :EOF


:getSID
set "return="
for /f "tokens=2" %%s in ('whoami /user /fo table /nh') do set "return=%%s"
goto :EOF

rem ======================================== watchvar() ========================================

#FUNCTION env watchvar watchvar ()


:watchvar_Scripts
echo Watch for new and deleted variables in batch script
echo=
for /l %%n in (1,1,50) do set "tests%%n=."
call :watchvar /i
for /l %%n in (1,1,5) do (
    for /l %%n in (1,1,10) do (
        set /a "_move=!random! %% 2"
        set /a "_num=!random! %% 10"
        if "!_move!" == "0" (
            set "test!_num!="
        ) else set "test!_num!=filled"
    )
    set "_move="
    set "_num="
    
    call :watchvar /w
    pause > nul
)
goto :EOF


:watchvar   [/i]  [/c]  [/w]
rem Temp folder address
for %%f in ("!tempPath!\watchvar") do (
    if not exist "%%~f" md "%%~f"
    pushd "%%~f"
)
setlocal

rem Write variable list to file
for %%f in ("varList") do (
    set > "%%~f_raw.txt"
    set "filename_rawTxt=%%~f_raw.txt"
    set "filename_nowTxt=%%~f_now.txt"
    set "filename_oldTxt=%%~f_old.txt"
    set "filename_newTxt=%%~f_new.txt"
    set "filename_delTxt=%%~f_del.txt"
    
    set "filename_rawHex=%%~f_raw.hex"
    set "filename_nowHex=%%~f_now.hex"
    set "filename_oldHex=%%~f_old.hex"
    set "filename_newHex=%%~f_new.hex"
    set "filename_delHex=%%~f_del.hex"
    
    set "filename_log=%%~f.log"
)

rem Get variable name
if exist "!filename_rawHex!" del /f /q "!filename_rawHex!"
certutil -encodehex "!filename_rawTxt!" "!filename_rawHex!" > nul
(
    set "readLine=0"
    set "inputHex=0d 0a"
    for /f "usebackq delims=" %%o in ("!filename_rawHex!") do (
        set "input=%%o"
        set "inputHex=!inputHex! !input:~5,48!"
        set /a "readLine+=1"
        if "!readLine!" == "160" call :watchvar_parseHex
    )
    call :watchvar_parseHex
) > "!filename_nowHex!"
if exist "!filename_nowTxt!" del /f /q "!filename_nowTxt!"
certutil -decodehex "!filename_nowHex!" "!filename_nowTxt!" > nul

rem Parse parameter
set "initialize=false"
set "countOnly=false"
set "writeToFile=false"
if not exist "!filename_oldHex!" set "initialize=true"
for %%p in (%*) do (
    if /i "%%p" == "/I" set "initialize=true"
    if /i "%%p" == "/C" set "countOnly=true"
    if /i "%%p" == "/W" set "writeToFile=true"
)
set "writeMode="
if /i "!writeToFile!" == "true" set "writeMode= ^>^> !filename_log!"

rem Count variable
set "variableCount=0"
for /f "usebackq tokens=*" %%o in ("!filename_nowHex!") do set /a "variableCount+=1"

rem Display variable count (if initialize only)
if /i "!initialize!" == "true" (
    echo Initial variables: !variableCount! %writeMode%
    goto watchvar_cleanup
)

rem Find new variables
set "newCount=0"
call 2> "!filename_newHex!"
for /f "usebackq tokens=*" %%s in ("!filename_nowHex!") do (
    set "found=false"
    for /f "usebackq tokens=*" %%t in ("!filename_oldHex!") do if "%%s" == "%%t" set "found=true"
    if /i "!found!" == "false" (
        echo=%%s
        set /a "newCount+=1"
    )
) >> "!filename_newHex!"
if exist "!filename_newTxt!" del /f /q "!filename_newTxt!"
certutil -decodehex "!filename_newHex!" "!filename_newTxt!" > nul

rem Find deleted variables
set "delCount=0"
call 2> "!filename_delHex!"
for /f "usebackq tokens=*" %%s in ("!filename_oldHex!") do (
    set "found=false"
    for /f "usebackq tokens=*" %%t in ("!filename_nowHex!") do if "%%s" == "%%t" set "found=true"
    if /i "!found!" == "false" (
        echo=%%s
        set /a "delCount+=1"
    )
) >> "!filename_delHex!"
if exist "!filename_delTxt!" del /f /q "!filename_delTxt!"
certutil -decodehex "!filename_delHex!" "!filename_delTxt!" > nul

if "!countOnly!" == "true" (
    echo Variables: !variableCount! [+!newCount!/-!delCount!] %writeMode%
) else (
    echo Variables: !variableCount!
    rem Display new variables
    if not "!newCount!" == "0" (
        set /p "=[+!newCount!] " < nul 
        for /f "usebackq tokens=*" %%o in ("!filename_newTxt!") do set /p "=%%o " < nul 
        echo=
    )

    rem Display deleted variables
    if not "!delCount!" == "0" (
        set /p "=[-!delCount!] " < nul 
        for /f "usebackq tokens=*" %%o in ("!filename_delTxt!") do set /p "=%%o " < nul 
        echo=
    )
) %writeMode%
goto watchvar_cleanup

:watchvar_parseHex
set "inputHex=.!inputHex!"
set "inputHex=!inputHex:  = !"
set "inputHex=!inputHex:0d 0a=_@:!"
set "inputHex=!inputHex:3d=_#:!"
set "inputHex=!inputHex: =!"
set "inputHex=!inputHex:_= !"
set "inputHex=!inputHex:~1!"
set "lastInput="
for %%h in (!inputHex!) do (
    if defined lastInput (
        echo !lastInput! 0d0a
        set "lastInput="
    )
    if /i "%%~dh" == "@:" set "lastInput=%%~nh"
)
set "inputHex="
if defined lastInput set "inputHex=@:!lastInput!"
set "readLine=0"
goto :EOF

:watchvar_cleanup
rem Cleanup
for %%t in (Txt Hex) do (
    if exist "!filename_old%%t!" del /f /q "!filename_old%%t!"
    ren "!filename_now%%t!" "!filename_old%%t!"
)
echo= %writeMode%
endlocal
popd
exit /b

rem ======================================== stripDQotes(string) ========================================

#FUNCTION str stripDQotes stripDQotes (string)

:stripDQotes_Scripts
echo Remove surrounding double quotes
echo=
call :inputString string
call :stripDQotes string
echo=
echo Stripped : !string!
goto :EOF


:stripDQotes   variable_name
set _tempvar="!%~1:~1,-1!"
if "!%~1!" == "!_tempvar!" set "%~1=!%~1:~1,-1!"
set "_tempvar="
exit /b

rem ======================================== strval(string) ========================================

#FUNCTION dev strval strval (string)


:strval_Scripts
echo Determine the integer value of a variable
echo=
call :inputString string
call :strval string
echo=
echo Integer value : !return!
goto :EOF


:strval   variable_name
set "return=-2147483647"
for %%n in (
    2147483647 1073741824 536870912 
    268435456 134217728 67108864 
    33554432 16777216 8388608 4194304 
    2097152 1048576 524288 262144 131072 
    65536 32768 16384 8192 4096 2048 
    1024 512 256 128 64 32 16 8 4 2 1
) do (
    set /a "return+=%%n"
    if !%1! LSS !return! set /a "return-=%%n"
)
goto :EOF

rem ======================================== wcdir() ========================================

#FUNCTION file wcdir wcdir (filepath)

:wcdir_Scripts
echo List files/folders with wildcard path
echo=
call :inputString wildcard_path
call :stripDQotes wildcard_path
call :wcdir "!wildcard_path!"
echo=
echo Found List:
echo=!return!
echo=
goto :EOF


[Prerequisites]
call :capchar LF


:wcdir   [drive:][path]filename
set "return="
set "_findNext=%~1"
set "_isFile=Y"
if "!_findNext:~-1,1!" == "\" set "_isFile="
call :wcdir_loop
set "_findNext="
set "_isFile="
exit /b 
:wcdir_loop
for /f "tokens=1* delims=\" %%a in ("!_findNext!") do if not "%%a" == "*:" (
    if "%%b" == "" (
        if defined _isFile (
            for /f "delims=" %%f in ('dir /b /a:-d "%%a" 2^> nul') do set "return=!return!%%~ff!LF!"
        ) else for /f "delims=" %%f in ('dir /b /a:d "%%a" 2^> nul') do set "return=!return!%%~ff\!LF!"
    ) else for /d %%f in ("%%a") do pushd "%%~f\" 2> nul && (
        set "_findNext=%%b"
        call :wcdir_loop
        popd
    )
) else for %%l in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do pushd "%%l:\" 2> nul && (
    set "_findNext=%%b"
    call :wcdir_loop
    popd
)
exit /b

rem ======================================== setupEndlocal() ========================================

#FUNCTION dev setupEndlocal setupEndlocal (filepath)

:setupEndlocal_Scripts
echo Macro version of endlocal 
echo And make variable(s) survive endlocal
echo=
echo SETLOCAL
setlocal
set "survivor=Hello world"
set survivor
echo ENDLOCAL
%endlocal% survivor
set survivor
goto :EOF

[Prerequisites]
call :capchar LF

:setupEndlocal
if "!!" == "" exit /b 1
set ^"NL=^^^%LF%%LF%^%LF%%LF%^^"
set ^"endlocal=for %%# in (1 2) do if %%# == 2 (%NL%
    setlocal EnableDelayedExpansion%NL%
    set "_setCommand==!LF!"%NL%
    for %%v in (!_args!) do set "_setCommand=!_setCommand!%%~v=!%%~v!!LF!"%NL%
    for /F "delims=" %%c in ("!_setCommand!") do if "%%c" == "=" (%NL%
        endlocal%NL%
        endlocal%NL%
    ) else set "%%c"%NL%
) else set _args="
exit /b 0

rem ======================================== setupClearline() ========================================

#FUNCTION ? setupClearline setupClearline (filepath)

:setupClearline_Scripts
echo Macro version of clear line
echo=
call :getScreenSize
call :setupClearline "!screenWidth!-1"
set /p "=Press any key to continue..." < nul
pause > nul
echo !CL!Line cleared^^!
goto :EOF


[Prerequisites]
call :capchar BS CR LR

[Requires]
call :getOS


:setupClearline
set /a "_length=%~1"
call :getOS /b
set "CL="
if !return! GEQ 100 (
    for /l %%n in (1,1,!_length!) do set "CL=!CL! "
    set "CL=!BASE!!CR!!CL!!CR!"
) else for /l %%n in (1,1,!_length!) do set "CL=!CL!!BS!"
goto :EOF

rem ======================================== parseArgs() ========================================

#FUNCTION dev parseArgs parseArgs (filepath)

:parseArgs_Scripts
echo Parse argument for required parameter and options
echo=
echo Example (From DEL /?) :
echo=
echo DEL [/P] [/F] [/S] [/Q] [/A[[:]attributes]] names
echo=
echo  names         One or more files or folder. Wildcards may be used.
echo                If it is a folder, all files in that folder will be deleted.
echo=
echo  /P            Prompts for confirmation before deleting each file.
echo  /F            Force deleting of read-only files.
echo  /S            Delete specified files from all subdirectories.
echo  /Q            Quiet mode, do not ask if ok to delete on global wildcard
echo  /A            Selects files to delete based on attributes
echo  attributes    R  Read-only        S  System       H  Hidden 
echo                L  Reparse Points   A  Ready for archiving 
echo                I  Not content indexed          -  Prefix meaning not          
echo=
echo This is just an example. This script will not delete any file.
echo=
call :inputString parameter
echo=
set "_options=P.flag:param_promptUser F.flag:param_forceDelete S.flag:param_includeSubdir 
set "_options=!_options! Q.flag:param_wildcardPrompt A:param_attributes"
set "_required=param_filename"

rem Flag type arguments are initialized to "false"
rem Initialize default value for non-flag arguments
set "param_attributes="
set "param_filename="
call :parseArgs !parameter! > nul || exit /b 1
set "param_"
goto :EOF


:parseArgs   %*  [_required]  [_options]
for %%o in (!_options!) do for /f "tokens=1* delims=:" %%a in ("%%~o") do (
    if /i "%%~xa" == ".flag" set "%%~b=false"
)
set "_prevArg="
set "_varName="
set "_paramCount=0"
set "requiredCount=0"
for %%r in (!_required!) do (
    set "_required!requiredCount!=%%~r"
    set /a "requiredCount+=1"
)
:parseArgs_options
set "_value=%1"
if not defined _value goto parseArgs_cleanup
set "_arg="
if "!_value:~0,1!" == "-" set "_arg=!_value:~1!"
if "!_value:~0,1!" == "/" set "_arg=!_value:~1!"
if defined _arg (
    if defined _varName (
        echo Invalid parameter: !_prevArg! 1>&2
        exit /b 2
    )
    set "_prevArg=%1"
    for /f "tokens=1* delims=:" %%s in ("!_arg!") do for %%o in (!_options!) do (
        for /f "tokens=1* delims=:" %%p in ("%%~o") do if /i "%%~s" == "%%~np" (
            set "_arg="
            if "%%~xp" == "" (
                set "_varName=%%~q"
                set "_value=%%~t"
            ) else (
                set "%%~q=true"
                set "_value="
            )
        )
    )
) else set "_value=%~1"
if defined _value if defined _varName (
    set "!_varName!=!_value!"
    set "_varName="
) else if defined _arg (
    echo Unknown parameter: %1 1>&2
    exit /b 1
) else if !_paramCount! LSS !requiredCount! (
    for %%n in (!_paramCount!) do set "!_required%%n!=%~1"
    set /a "_paramCount+=1"
)
shift
goto parseArgs_options
:parseArgs_cleanup
set "_arg="
set "_prevArg="
set "_varName="
set "_value="
for /l %%r in (0,1,!requiredCount!) do set "_required%%r="
set "_paramCount="
set "requiredCount="
exit /b 0

rem ======================================== colorPrint(color,text) ========================================

#FUNCTION ? colorPrint colorPrint (color,text)

:colorPrint_Scripts
echo Print text with color and background color
echo=
call :inputString text
call :inputString textColor
call :inputString backgroundColor
echo=
rem Capture Backspace Character
for /f %%a in ('"prompt $h & echo on & for %%b in (1) do rem"') do (
    set "BS=%%a %%a"
)
call :colorPrint "!backgroundColor!!textColor!" "!text!" && (
    echo !LF!Print Success
) || echo !LF!Print Failed
goto :EOF


[Prerequisites]
call :capchar BS


:colorPrint   color  text
if "%~2" == "" exit /b 2
pushd "!tempPath!"
(
    set /p "=!BS!!BS!" < nul > "%~2_"
    findstr /l /v /a:%~1 "." "%~2_" nul || exit /b 1
    del /f /q "%~2_" > nul
) 2> nul
popd
exit /b 0

rem ======================================== getOS() ========================================

#FUNCTION env getOS getOS ()

:getOS_Scripts
echo Get OS version
echo=
call :getOS /n
echo Your windows version is: !return!
goto :EOF


:getOS   [/n | /e]
for /f "tokens=4-5 delims=. " %%i in ('ver') do set "return=%%i.%%j"
if /i "%~1" == "/N" (
    if "!return!" == "10.0" set "return=Windows 10"
    if "!return!" == "6.3" set "return=Windows 8.1"
    if "!return!" == "6.2" set "return=Windows 8"
    if "!return!" == "6.1" set "return=Windows 7"
    if "!return!" == "6.0" set "return=Windows Vista"
    if "!return!" == "5.2" set "return=Windows XP 64-Bit"
    if "!return!" == "5.1" set "return=Windows XP"
    if "!return!" == "5.0" set "return=Windows 2000"
)
if /i "%~1" == "/B" set "return=!return:.=!"
exit /b


rem ======================================== expandPath() ========================================

#FUNCTION dev expandPath expandPath (string)

:expandPath_Scripts
echo Expands given path to:
echo [D]rive letter, [A]ttributes, [T]ime stamp, si[Z]e, 
echo [N]ame, e[X]tension, [P]ath, [F]ull path
echo=
call :expandPath "!cd!" currentDir_
set currentDir_
goto :EOF


:expandPath   file_path  [prefix]
set "%~2D=%~d1" Drive Letter
set "%~2A=%~a1" Attributes
set "%~2T=%~t1" Time Stamp
set "%~2Z=%~z1" Size
set "%~2N=%~n1" Name
set "%~2X=%~x1" Extension
set "%~2P=%~p1" Path
set "%~2F=%~f1" Full Path
exit /b

rem ======================================== capchar() ========================================

#FUNCTION dev capchar capchar (string)

:capchar_Scripts
echo Capture extended characters
echo=
call :capchar BS CR LF
echo Hello[BS] World.[CR]Test[LF]Me
echo Hello!BS! World.!CR!Test!LF!Me
goto :EOF


:capchar   character1  [character2] [...]
rem Capture backspace character
if /i "%~1" == "B" for /f %%a in ('"prompt $h & echo on & for %%b in (1) do rem"') do (
    set "B=%%a"
)
rem Create "backspace"
if /i "%~1" == "BS" call :capchar "B" && set "BS=!B! !B!"
rem Create "base" for "set /p" output
if /i "%~1" == "BASE" call :capchar "BS" && set BASE=_!BS!
rem Create "invisible" doublequote for displaying control characters
if /i "%~1" == "DQ" call :capchar "BS" && set DQ="!BS!
rem Capture Carriage Return character
if /i "%~1" == "CR" for /f %%a in ('copy /Z "%~f0" nul') do set "CR=%%a"
rem Capture Line Feed character (2 empty lines requred)
if /i "%~1" == "LF" set LF=^
%=REQURED=%
%=REQURED=%
rem Shift parameter
shift /1
if "%~1" == "" exit /b 0
goto capchar


:END_OF_FUNCTIONS

rem ======================================== Helper Functions ========================================

rem ================================ Input Number ================================

:inputNumber   variable_name  minimum  maximum  [description]
echo=
if "%~4" == "" (
    set /p "%~1=Input %~1 [%~2 to %~3]: "
) else set /p "%~1=Input %~4 [%~2 to %~3]: "
set /a "%~1=!%~1!"
if %~2 LEQ !%~1! (
    if !%~1! LEQ %~3 exit /b
    if %~3 GEQ 0 if !%~1! LSS 0 exit /b
)
if %~2 LEQ 0 if !%~1! GTR 0 (
    if !%~1! LEQ %~3 exit /b
    if %~3 GEQ 0 if !%~1! LSS 0 exit /b
)
goto inputNumber

rem ================================ Input String ================================

:inputString   variable_name  [description]
echo=
if "%~2" == "" (
    echo Input %~1:
) else echo Input %~2:
set /p "%~1="
exit /b

rem ================================ Input Path ================================

:inputPath   variable_name  [/F | /D]  [/S]
rem /F Input is a file
rem /D Input is a folder
rem /S Input is skippble
set "_inputType=file/folder"
set "_skippable="
for %%p in (%*) do (
    if /i "%%p" == "/F" set "_inputType=file"
    if /i "%%p" == "/D" set "_inputType=folder"
    if /i "%%p" == "/S" set "_skippable=true"
)
set "%~1="
:inputPath_in
set "userInput="
cls
echo Current directory:
echo=!cd!
echo=
echo Previous input:
echo=!lastUsed_file!
echo=
echo Enter nothing to use previous input
if defined _skippable               echo Enter "\:" to skip this step
if /i "!_inputType!" == "folder"    echo Enter ".\" to select current folder
echo=
echo Input !_inputType! address:
set /p "userInput="
echo=

if defined _skippable               if "!userInput!" == "\:" exit /b 2
if /i "!_inputType!" == "folder"    if "!userInput!" == ".\" set "userInput=!cd!"
if not defined userInput            set "userInput=!lastUsed_file!"

call :stripDQotes userInput
if not exist "!userInput!" (
    echo The !_inputType! does not exist
    pause
    goto pathIn
)
set "%~1=!userInput!"
call :expandPath "!userInput!" _file_
if /i "!_file_A:~0,1!" == "d" (
    if /i "!_inputType!" == "file" (
        echo Your input is not a file...
    ) else exit /b 0
) else if /i "!_inputType!" == "folder" (
    echo Your input is not a folder...
) else exit /b 0
pause
goto pathIn

rem ================================ Input IPv4 ================================

:inputIPv4   variable_name  [/W]
rem /W Allow wildcard
set "_allowWildcard="
if /i "%~2" == "/W" set "_allowWildcard= (wildcard allowed)"
echo=
:inputIPv4_input
set /p "userInput=Input IP adress!_allowWildcard! (0 to Quit): "
if "!userInput!" == "0" exit /b
set "userInput= !userInput!"
set ^"userInput=!userInput:.=^
%=REQURED=%
!"
set "userInput=!userInput:~1!"
set "%~1="
set "_numCount=0"
for /f "tokens=*" %%n in ("!userInput!") do (
    set /a "_numCount+=1"
    if !_numCount! GTR 4 goto inputIPv4_input
    if "%%n" == "*" (
        if not defined _allowWildcard goto inputIPv4_input
    ) else (
        set /a "_num=%%n" 2> nul || goto inputIPv4_input
        if %%n LSS 0    goto inputIPv4_input
        if %%n GTR 255  goto inputIPv4_input
    )
    set "%~1=!%~1!.%%n"
)
if not "!_numCount!" == "4" goto inputIPv4_input
set "%~1=!%~1:~1!"
exit /b

rem ================================ Change Screen Size ================================

[Requires]
call :getScreenSize
call :setupClearline

:changeScreenSize   width  height
mode %~1,%~2
call :getScreenSize
call :setupClearline "!screenWidth!-1"
goto :EOF

rem ======================================== End of Script ========================================








rem ======================================== Other Function ========================================

rem Size: !puzzleRow!x!puzzleCol!

:matrix
if /i "%1" == "create" (
    if "!%~3!" == "" goto :EOF
    set "tempArray1=!%3!"
)
if /i "%1" == "toArray" set "%3="
if /i "%1" == "count"   set "return=0"
if /i "%1" == "compare" set "return=0"
for /l %%i in (1,1,!puzzleRow!) do (
    for /l %%j in (1,1,!puzzleCol!) do (
        if /i "%1" == "create" (
            set "%2_%%i-%%j=!tempArray1:~0,1!"
            set "tempArray1=!tempArray1:~1!"
        )
        if /i "%1" == "swap" for %%n in (!%2_%%i-%%j!) do (
            if "%%n" == "%~3" set "%2_%%i-%%j=%~4"
            if "%%n" == "%~4" set "%2_%%i-%%j=%~3"
        )
        if /i "%1" == "set"     set "%2_%%i-%%j=%~3"
        if /i "%1" == "copy"    set "%3_%%i-%%j=!%2_%%i-%%j!"
        if /i "%1" == "toArray" set "%3=!%3!!%2_%%i-%%j!"
        if /i "%1" == "delete"  set "%2_%%i-%%j="
        if /i "%1" == "count"   if     "!%2_%%i-%%j!" == "%~3"  set /a "return+=1"
        if /i "%1" == "compare" if not "!%2_%%i-%%j!" == "!%3_%%i-%%j!"  set /a "return+=1"
    )
)
goto :EOF
rem CREATE [Matix_Name] [Source_Array]
rem SET [Matix_Name] [Source_Array]
rem COPY [Source_Matix] [Destination_Matrix]
rem SWAP [Matix_Name] [Number1] [Number2]
rem toArray [Source_Matix] [Destination_Array]
rem DELETE [Matix_Name]
rem COUNT [Matix_Name] [Symbol]
rem COMPARE [Matix_Name] [Matix_Name]
goto :EOF


:checkCellcode
set "cellCode=%1"
set "rowNumber="
for /l %%n in (1,1,!puzzleRow!) do if not defined rowNumber (
    if /i "!cellCode:~0,1!" == "!alphabets:~%%n,1!" (
        set "rowNumber=%%n"
        set /a "colNumber=!cellCode:~1! + 0" 2> nul
    )
    if /i "!cellCode:~-1,1!" == "!alphabets:~%%n,1!" (
        set "rowNumber=%%n"
        set /a "colNumber=!cellCode:~0,-1! + 0" 2> nul
    )
)
set "cellPos="
if !rowNumber! GEQ 1 if !rowNumber! LEQ !puzzleRow! (
    if !colNumber! GEQ 1 if !colNumber! LEQ !puzzleCol! (
        set "cellPos=!rowNumber!-!colNumber!"
    )
)
goto :EOF


:viewIP_Scripts
set "_listCount=0"
echo Connected Networks:
echo=
for /f "tokens=* usebackq" %%o in (`ipconfig /all`) do (
    set "output=%%o"
    if "!output:~-1,1!" == ":" if not "!output:~-2,1!" == " " set "_net_name=!output:~0,-1!"
    if /i "!output:~0,11!" == "Description"     set "_net_desc=!output:~36,75!"
    if /i "!output:~0,12!" == "IPv4 Address"    set "_net_IPv4=!output:~36,62!"
    if /i "!output:~0,15!" == "Default Gateway" if /i not "!output:~36,2!" == "::" (
        set /a "_listCount+=1"
        set "_listCount=   !_listCount!"
        set "_listCount=!_listCount:~-3,3!"
        echo !_listCount!. !_net_name!
        echo     Desciption : !_net_desc!
        echo     IPv4       : !_net_IPv4!
        echo     Gateway    : !output:~36,62!
        echo=
    )
)
goto :EOF

rem ======================================== WIP Function ========================================

:Time_Done_with_Date [Start Time] [Progress done] [Total Progress] ????
set "return=0"
call :Time_Subtract %1 %time%
set /a return+=%return% * (%3 - %2) / %2 2> nul
set /a tempVar6=%return% / 8640000
call :Time_CS_Format %return%
set "tempVar7=%return%"
call :Date_Subtract 0/1/1 %date:~4%
set /a tempVar6+=%return%
call :Date_Format %tempVar6%
set "return=%return% %tempVar7%"
goto :EOF

rem ======================================== Notes ========================================

rem Unimplemented Functions
diffdate(x)
strRand()

rem File parameters
for %%f in ("%~f0") do (
    echo Drive Letter   : %%~df
    echo Attributes     : %%~af
    echo Last Modified  : %%~tf
    echo Size           : %%~zf
    echo Name           : %%~nf
    echo Extension      : %%~xf
    echo Path           : %%~pf
    echo Full Path      : %%~ff
)

rem Case insensitive comparison
if /i NOT "asd" == "ASD" echo This wont display

rem Delay 1s
ping localhost -n 2 > nul

rem New Line (DisableDelayedExpansion)
set NL=^^^%LF%%LF%^%LF%%LF%

rem Copy to clipboard
echo Copy with CRLF| clip
set /p "=Copy without CRLF" < nul | clip
(
    set /p "=Block " < nul
    set /p "=copy" < nul
) | clip

rem Write to stderr
echo message 1>&2

rem Variables in Variable
set "var1=Nested"
set "var2=^!var1^! Variable"
set "var3=!var2!"
echo %var3%

rem Display each line of the output
for /f "usebackq tokens=*" %%o in (`your command here`) do echo Output: %%o
rem Display each line of the file
for /f "usebackq tokens=*" %%o in ("your file here") do echo Output: %%o
rem Display all exept 1st token
for /f "tokens=2* delims=:" %%a in ("your text here") do echo Output: %%a
rem Display each line of the file + tokens delims
for /f "usebackq tokens=2* delims=:" %%o in ("your file here") do echo Output: %%o

rem Multi SET (Arithmetic only)
set /a var5=5 , var6=7+2
set /a var7=var8=7+8

rem GUI Stuffs
2> nul (
    chcp 437
) && (
    call :ASCII_GUI     This is the default GUI
) || call :UTF8_GUI     Backup GUI, In case ASCII doesn't display correctly

:GUI_char_ASCII
set "hGrid=Ä"
set "vGrid=³"
set "cGrid=Å"
set "hBorder=Í"
set "vBorder=º"
set "cBorder=Î"
set "uEdge=Ë"
set "dEdge=Ê"
set "lEdge=Ì"
set "rEdge=¹"
set "ulCorner=É"
set "urCorner=»"
set "dlCorner=È"
set "drCorner=¼"
goto :EOF


:GUI_char_UTF8
set "hGrid=-"
set "vGrid=|"
set "cGrid=+"
set "hBorder=="
set "vBorder=||"
set "cBorder=++"
set "uEdge==="
set "dEdge==="
set "lEdge=||"
set "rEdge=||"
set "ulCorner==="
set "urCorner==="
set "dlCorner==="
set "drCorner==="
goto :EOF

rem ======================================== File I/O ========================================

rem Create 0-byte file
call 2> "File.txt"

rem File Lock/Unlocked State

rem Create State
echo File is in locked state
(
    pause > nul
) >> "!filePath!"
echo File is in unlocked state

rem Detect State
2> nul (
  call >> "!filePath!"
) && ( 
    echo File is in unlocked state
) || (
    echo File is in locked state
)

rem Count numeber of lines of a file (include empty lines)
for /f "delims=" %%n in ('type FILENAME ^| find "" /v /c') do set "lines=%%n"

rem Encode / Decode
certutil -encode inFile outFile
certutil -decode inFile outFile
certutil -encodehex inFile outFile
certutil -decodehex inFile outFile

rem Hash SHA1
certutil -hashfile fileName

rem ======================================== Collect Data ========================================

rem Get registry value
for /f "tokens=3" %%v in ('reg query !regKeyName! /v !regVarName! ^| findstr !regVarName!') do set "regValue=%%v"

rem Get SID of user
whoAmI /user

rem Get battery status
wmic /NameSpace:"\\root\WMI" Path BatteryStatus Get Charging,PowerOnline /Format:list
wmic Path Win32_Battery Get EstimatedChargeRemaining,EstimatedRunTime  /Format:list

rem Disk drive info
wmic diskdrive get capabilities capabilityDescription caption

rem Get screen resoltion
wmic desktopmonitor get screenheight, screenwidth

rem Get CPU load
wmic cpu get loadpercentage /format:list

rem Get volume name
mountvol
label
vol

rem Check OS bit
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
IF EXIST "%PROGRAMFILES(X86)%" (set bit=x64) ELSE (set bit=x86)
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (set bit=x86) else (set bit=x64)

rem Others
driverquery
gpresult
telnet