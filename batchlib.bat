@goto main


rem Function Library 1.3
rem Updated on 2018-03-31
rem Made by wthe22 - http://winscr.blogspot.com/


rem ======================================== Change Log ========================================
:__CHANGE_LOG__     Version History


rem     x.x.x (YYYY-MM-DD)
rem     - Changes to .....

rem ======================================== Entry Point ========================================
:__ENTRY__     Entry Point
@rem These kinds of labels serves as a bookmark


:restart
endlocal

:main
@echo off
prompt $g
call :setupEndlocal
setlocal EnableDelayedExpansion EnableExtensions

rem ======================================== Settings ========================================

rem Active Settings
set "data_path=BatchScript_Data\Functions\"
set "temp_path=!temp!\BatchScript\"

rem None of these are used in this script
set "data_file=Script.dat"
set "debug_file=Script.log"
set "config_file=Script.cfg"
set "default_screen_width=80"
set "default_screen_height=25"
set "screen_width=!default_screen_width!"
set "screen_height=!default_screen_height!"
set "ping_timeout=750"

rem ======================================== Script Setup ========================================

set "SOFTWARE_NAME=Function Library"
set "SOFTWARE_VERSION=1.3"
set "SOFTWARE_RELEASE_DATE=03/31/2018"


title !SOFTWARE_NAME! !SOFTWARE_VERSION!

cd /d "%~dp0"
if not exist "!data_path!" md "!data_path!"
if not exist "!temp_path!" md "!temp_path!"
cd /d "!data_path!"


cls
echo Loading script...
call :capchar CR LF BS BASE DQ
call :Category.read
call :Function.read
set "debug_mode=FALSE"
goto category_menu


rem === Multiple batch script windows ===
start "" "%~f0" [Command to execute]
rem =====================================

rem File location:   %~f0

rem Start in new window
if "%~1" == "" goto start_in_new_window

:start_in_new_window
start "!SOFTWARE_NAME! !SOFTWARE_VERSION!" "%~f0" new_window
exit /b


:error_exit
echo=
echo ERROR: !errorMsg!
echo Script will exit
pause > nul
exit

rem ======================================== Menu ========================================
:__MENU__     Main Menu


:category_menu
set "user_input=?"
cls
call :Category.get_item list
echo=
if defined lastUsed_function echo L. Last used Function
echo S. Search Functions
echo D. Toggle debug mode [!debug_mode!]
echo 0. Exit
echo=
echo Which tool do you want to use?
set /p "user_input="
if "!user_input!" == "0" exit
if defined lastUsed_function if /i "!user_input!" == "L" goto start_function
if /i "!user_input!" == "S" goto function_search
if /i "!user_input!" == "D" call :toggle.debug_mode
call :Category.get_item !user_input!
if defined selected_category goto function_menu
goto category_menu


:function_menu
set "user_input=?"
cls
call :Function.get_item !selected_category! list
echo=
echo 0. Back
echo=
echo Input function number:
set /p "user_input="
if "!user_input!" == "0" goto category_menu
call :Function.get_item !selected_category! !user_input!
if defined selected_function goto start_function
goto function_menu


:function_search
set "user_input=?"
cls
echo 0. Back
echo=
echo Input search keyword:
set /p "user_input="
if "!user_input!" == "0" goto category_menu

rem Search for keyword in function name
set "cat_search_functions="
for %%f in (!cat_all_functions!) do (
    set "_temp= !fx_%%f_param!"
    if not "!_temp:%user_input%=!" == "!_temp!" set "cat_search_functions=!cat_search_functions! %%f"
)
:function_search.result
cls
echo Keyword : %user_input%
echo=
call :Function.get_item search list
echo=
echo 0. Back
echo=
echo Input function number:
set /p "user_input="
if "!user_input!" == "0" goto category_menu
call :Function.get_item search !user_input!
if defined selected_function goto start_function
goto function_search.result


:start_function
set "lastUsed_function=!selected_function!"
setlocal EnableDelayedExpansion EnableExtensions
title !SOFTWARE_NAME! - !selected_function!

if /i "!debug_mode!" == "TRUE" (
    call :debug_menu
) else call :start_function.normal

title !SOFTWARE_NAME! !SOFTWARE_VERSION!
endlocal
goto category_menu


:start_function.normal
cls
echo =============================== START OF FUNCTION ==============================
echo=!fx_%selected_function%_param!
echo=
call :!selected_function!.Demo
echo=
echo ================================ END OF FUNCTION ===============================
echo=
pause
goto :EOF


:toggle.debug_mode
if /i "!debug_mode!" == "TRUE" (
    set "debug_mode=FALSE"
) else set "debug_mode=TRUE"
goto :EOF


rem ======================================== Debug Menu ========================================
:__DEBUG__     Debug function


:debug_menu
set "user_input=?"
title !SOFTWARE_NAME! - Debug Mode
cls
echo !selected_function!
echo=
echo 1. Single test
echo 2. Multiple tests
echo=
echo 0. Back to main menu
echo C. Execute Commands
echo=
echo What do you want to do?
set /p "user_input="
if "!user_input!" == "0" goto :EOF
if /i "!user_input!" == "C" call :script_cmd
if "!user_input!" == "1" goto debug_single
if "!user_input!" == "2" goto debug_multiple
goto debug_menu

rem ======================================== Debug Single ========================================

:debug_single
cls
echo Guide:
echo=!fx_%selected_function%_param!
echo=
echo=
echo Input parameter for the function:
set /p "debug_param="

rem Display settings
cls
echo Guide:
echo=!fx_%selected_function%_param!
echo=
echo=
echo Command:
echo !selected_function!   !debug_param!
echo=
ceho=
pause
echo=

call :!selected_function!.Debug.settings 2> nul

rem Run function test
setlocal EnableDelayedExpansion EnableExtensions
cls
@echo on    & set "debug_start_time=!time!"
call :!selected_function! !debug_param!
@echo off   & set "debug_function_output=!return!"
call :difftime !time! !debug_start_time!
call :ftime !return!
set "debug_time_taken=!return!"
echo=
pause 

rem Display test result
cls
echo Command:
echo=!selected_function! !debug_param!
echo=
echo=
echo Return     : !debug_function_output!
echo=
echo Time taken : !debug_time_taken!
echo=
call :!selected_function!.Debug.single_end 2> nul
echo=
endlocal
pause
goto debug_menu

rem ======================================== Debug Multiple ========================================

:debug_multiple
cls
set "test_total=1000"
call :input_number test_total 0 2147483647

cls
echo !selected_function!()
echo=
echo Test !test_total! times for speed and output of function
echo=
pause

setlocal EnableDelayedExpansion EnableExtensions
call :!selected_function!.Debug.settings 2> nul
set "debug_error_desc="
set "function_run_time=0"
set "debug_start_time=!time!"

for /l %%l in (1,1,!test_total!) do (
    set "test_count=%%l"
    title !SOFTWARE_NAME! !SOFTWARE_VERSION! - !selected_function! - Test #%%l / !test_total!
    call :!selected_function!.Debug.setup 2> nul
    set "return="
    set "function_run_timeCS=0"
    set "function_start_time=!time!"
    
    call :!selected_function! !debug_param!
    
    for %%t in (!time! !function_start_time!) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
        set /a "function_run_timeCS+=24%%a %% 24 *360000 +1%%b*6000 +1%%c*100 +1%%d -610100"
        set /a "function_run_timeCS*=-1"
    )
    if !function_run_timeCS! LSS 0 set /a "function_run_timeCS+=8640000"
    set /a "function_run_time+=!function_run_timeCS!"
    
    set "debug_function_output=!return!"
    call :!selected_function!_Debug.check 2> nul
    if defined debug_error_desc goto debug_error
)
call :difftime !time! !debug_start_time!
set /a "debug_avg_time=!return!/!test_total!"
set /a "function_avg_time=!function_run_time!/!test_total!"
call :ftime !return!
set "debug_time_taken=!return!"
call :ftime !debug_avg_time!
set "debug_avg_time=!return!"
call :ftime !function_run_time!
set "function_run_time=!return!"
call :ftime !function_avg_time!
set "function_avg_time=!return!"
echo=
echo Test Done
pause

title !SOFTWARE_NAME! !SOFTWARE_VERSION! - Debug Mode
cls
echo Debug time taken       : !debug_time_taken!
echo Function time taken    : !function_run_time!
echo Average function time  : !function_avg_time!
echo Average time per test  : !debug_avg_time!
echo Number of tests        : !test_total!
echo=
call :!selected_function!.Debug.multiple_end 2> nul
echo=
endlocal
pause
goto debug_menu


:debug_error
cls
echo An error occured...
echo=
echo Parameter  : !debug_param!
echo=
echo Return     : !debug_function_output!
echo=
echo Error Description  :
echo=!debug_error_desc!
echo=
call :!selected_function!.Debug.multiple_error 2> nul
echo=
endlocal
pause
goto debug_menu


:script_cmd
cls
echo Batch Script CMD
echo Be careful with special characters
echo Type "EXIT /B" to return to previous menu
echo=
:script_cmd.loop
set /p "user_input=>"
%user_input%
goto script_cmd.loop

rem ======================================== Category Functions ========================================
:__CATEGORY_FUNCTIONS__     Read / list cateogry and functions


:Category.read
rem #CATEGORY category  name
set "category_tag=#CATEGORY"
set "category_list="
for /f "usebackq tokens=*" %%o in ("%~f0") do for /f "tokens=1,2* delims= " %%b in ("%%o") do (
    if /i "%%b" == "!category_tag!" if not "%%c" == "" (
        if not defined cat_%%c_name (
            set "category_list=!category_list! %%c"
            set "cat_%%c_name=%%d"
            set "cat_%%c_functions= "
        )
    )
)
set "category_list=all !category_list! others"
set "cat_all_name=All"
set "cat_all_functions= "
set "cat_others_name=Others"
set "cat_others_functions= "
goto :EOF


:Category.get_item   list|number
set "_count=0"
set "selected_category="
for %%c in (!category_list!) do (
    set /a "_count+=1"
    if /i "%~1" == "LIST" (
        set "_count=   !_count!"
        echo !_count:~-3,3!. !cat_%%c_name! [!cat_%%c_item_count!]
    ) else if "%~1" == "!_count!" set "selected_category=%%c"
)
goto :EOF


:Function.read
rem #FUNCTION category label
set "function_tag=#FUNCTION"
set "current_function_label="
for /f "usebackq tokens=*" %%o in ("%~f0") do for /f "tokens=1,2* delims= " %%b in ("%%o") do (
    if /i "%%b" == "!function_tag!" if not "%%d" == "" (
        set "current_function_label=%%d"
        if /i defined cat_%%c_name (
            if /i "%%c" == "all" (
                set "cat_others_functions=!cat_others_functions! %%d"
            ) else set "cat_%%c_functions=!cat_%%c_functions! %%d"
        ) else set "cat_others_functions=!cat_others_functions! %%d"
    )
    if /i "%%b" == ":!current_function_label!" (
        set "_temp=%%o"
        set "fx_!current_function_label!_param=!_temp:~1!"
    )
)
set "current_function_label="
set "_temp="
set "cat_all_functions="
set "cat_all_item_count=0"
for %%c in (!category_list!) do (
    set "cat_%%c_item_count=0"
    for %%f in (!cat_%%c_functions!) do set /a "cat_%%c_item_count+=1"
    set "cat_all_functions=!cat_all_functions! !cat_%%c_functions!"
    set /a "cat_all_item_count+=!cat_%%c_item_count!"
)
goto :EOF


:Function.get_item   category list|number
set "_count=0"
set "selected_function="
for %%f in (!cat_%~1_functions!) do (
    set /a "_count+=1"
    if /i "%~2" == "list" (
        set "_count=   !_count!"
        echo !_count:~-3,3!. !fx_%%f_param!
    ) else if "%~2" == "!_count!" set "selected_function=%%f"
)
goto :EOF

rem ======================================== Category Definition ========================================
:__CATEGORY_DEFINITION__     Define Category here


rem #CATEGORY category  name

#CATEGORY math      Math
#CATEGORY str       String
#CATEGORY conv      Convert
#CATEGORY time      Date and Time
#CATEGORY file      File and Folder
#CATEGORY env       Environment
#CATEGORY dev       Developer

rem ======================================== Functions Template ========================================

rem ======================================== example(only) ========================================

rem #FUNCTION category label

:example.Demo    // Scripts to simulate the function
echo Hello world!
call :example
goto :EOF


:example.Debug.settings   // Things to do before running multi test. Only executed ONCE
set "chanceOfError=5"
goto :EOF


:example.Debug.setup      // Things to do before EACH test (Setup parameter)
set /a "debug_param=!random! %% !chanceOfError!"
goto :EOF


:example            // This is the function
set "return=no_error"
if "!debug_param!" == "0" (
    echo 1 + 1 = 11
    set "return=error"
) else echo 1 + 1 = 2
exit /b


:example_Debug.check      // Check if the output of the function is correct or not
if /i "!debug_function_output!" == "error" set "debug_error_desc=1 + 1 is not 11!!"
rem Describe whats wrong with function output in "debug_error_desc"
rem Defining this will call ".Debug.multiple_error"
goto :EOF


:example.Debug.multiple_error    // Informations add for multiple test error result
echo Chance of error: !chanceOfError!
goto :EOF


:example.Debug.single_end     // Informations to show for single test end result
echo Test Done
goto :EOF


:example.Debug.multiple_end      // Informations to show for multiple test end result
echo MultiTest Success!!
goto :EOF           // All labels above ends with this

rem ======================================== Functions Library ========================================
:__FUNCTION_LIBRARY__     Collection of Functions


rem ======================================== rand(min, max) ========================================

#FUNCTION math rand


:rand.Demo   // Scripts to simulate the function
echo Generate random number within a range
echo=
call :input_number minimum 0 2147483647
call :input_number maximum 0 2147483647
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

#FUNCTION math randw

:randw.Demo
echo Generate random number based on weights
echo Random number generated is index number (starts from 0)
echo=
call :input_string weights
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

#FUNCTION math sqrt


:sqrt.Demo
echo Calculate square root of x
echo=
call :input_number number 0 2147483647
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
    if !_guess! LEQ %~1 set /a "return+=%%n"
)
exit /b

rem ======================================== cbrt(int) ========================================

#FUNCTION math cbrt


:cbrt.Demo
echo Calculate cube root of x
echo=
call :input_number number 0 2147483647
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
    if !_guess! LEQ %~1 set /a "return+=%%n"
)
exit /b

rem ======================================== yroot(int, pow) ========================================

#FUNCTION math yroot


:yroot.Demo
echo Calculate y root of x
echo=
call :input_number number 0 2147483647
call :input_number power 0 2147483647
call :yroot !number! !power!
echo=
echo Root to the power of !power! of !number! is !return!
echo Result is floored
goto :EOF


:yroot   integer  power
set "return=0"
for %%n in (32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    set "_guess=1"
    for /l %%p in (1,1,%~2) do set /a "_guess*=!return! + %%n"
    if not !_guess! LEQ 0 if !_guess! LEQ %~1 set /a "return+=%%n"
)
exit /b

rem ======================================== pow(int, pow) ========================================

#FUNCTION math pow


:pow.Demo
echo Calculate x to the power of n
echo=
call :input_number number 0 2147483647
call :input_number power 0 2147483647
call :pow !number! !power!
echo=
echo !number! to the power of !power! is !return!
goto :EOF


:pow   integer  power
set "return=1"
for /l %%p in (1,1,%2) do set /a "return*=%~1"
exit /b

rem ======================================== prime(int) ========================================

#FUNCTION math prime


:prime.Demo
echo Test for prime number
echo=
call :input_number number 0 2147483647
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

rem ======================================== gcf(int, int) ========================================

#FUNCTION math gcf


:gcf.Demo
echo Calculate greatest common factor (GCF) of 2 numbers
echo=
call :input_number number1 0 2147483647
call :input_number number2 0 2147483647
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

#FUNCTION str strlen


:strlen.Demo
echo Calculate string length
echo=
call :input_string string
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

#FUNCTION str toUppercase


:toUppercase.Demo
echo Convert string to uppercase
echo=
call :input_string string
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

#FUNCTION str toLowercase


:toLowercase.Demo
echo Convert string to lowercase
echo=
call :input_string string
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

#FUNCTION str shuffle


:shuffle.Demo
echo Shuffle characters in a string
echo=
call :input_string text
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

#FUNCTION str strchk


:strchk.Demo
echo Check string for invalid characters
echo=
call :input_string string
call :input_string valid_characters
call :strchk string valid_characters
echo=
if "!return!" == "-1" (
    echo String is valid
) else echo Character index !return! of the string is invalid
goto :EOF


:strchk   variable_name  valid_characters_variable
set "return=-1"
if defined %~1 for /l %%n in (0,1,8191) do (
    if not "!%~1:~%%n,1!" == "" if "!return!" == "-1" (
        set "_char=!%~1:~%%n,1!"
        for %%c in ("!_char!") do if "!%~2!" == "!%~2:%%~c=!" set "return=%%n"
    )
)
exit /b

rem Known bugs:
rem Does not handle '!' and '~' correctly

0123456789012345678901234567890

3
5
0!@#$%&*(){}[]:;'<>,/?^.~1"|
0!@#$%&*(){}[]:;'<>,/?^.~1"|

rem ======================================== strip_dquotes(string) ========================================

#FUNCTION str strip_dquotes

:strip_dquotes.Demo
echo Remove surrounding double quotes
echo=
call :input_string string
call :strip_dquotes string
echo=
echo Stripped : !string!
goto :EOF


:strip_dquotes   variable_name
if not "!%~1!" == "" (
    set _tempvar="!%~1:~1,-1!"
    if "!%~1!" == "!_tempvar!" set "%~1=!%~1:~1,-1!"
    set "_tempvar="
)
exit /b

rem ======================================== difftime(end, start) =======================================

#FUNCTION time difftime


:difftime.Demo
echo Calculate difference of 2 times in centiseconds
echo If start_time is not defined then it assumes it is 00:00:00.00
echo=
call :input_string start_time
call :input_string end_time
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

#FUNCTION time ftime


:ftime.Demo
echo Convert time (in centiseconds) to HH:MM:SS.CC format
echo=
call :input_string time_in_centisecond
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
    set "_result=E0!_result!"
    set "return=!return!!_result:~-2,2!:"
)
set "return=!return:~0,-4!.!return:~-3,2!"
exit /b

rem ================================== diffdate(end, start) ==================================

#FUNCTION time diffdate


:diffdate.Demo
echo Calculate difference between 2 dates in days
echo If start_date is not defined then it assumes it is 1/01/1
echo=
call :input_string start_date
call :input_string end_date
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

#FUNCTION time dayof


:dayof.Demo
echo Determine what day is a date
echo=
call :input_string a_date
call :dayof !a_date!
echo=
echo That day is !return!
goto :EOF


[Requires]
call :diffdate


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

rem ================================== timeleft(start, progress, end) ==================================

#FUNCTION time timeleft


:timeleft.Demo
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
:timeleft    start_time current_progress total_progress
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
                set "_result=E0!_result!"
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

#FUNCTION conv binToDec


:binToDec.Demo
echo Convert binary to decimal
echo=
call :input_string binary
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

#FUNCTION conv decToBin


:decToBin.Demo
echo Convert decimal to unsigned binary
echo=
call :input_number decimal 0 2147483647
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

#FUNCTION conv decToOctal


:decToOctal.Demo
echo Convert decimal to octal
echo=
call :input_number decimal 0 2147483647
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

#FUNCTION conv decToHex


:decToHex.Demo
echo Convert decimal to hexadecimal
echo=
call :input_number decimal 0 2147483647
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

rem ======================================== baseX(int, out_charset) ========================================

#FUNCTION conv baseX


:baseX.Demo
echo Convert decimal to baseX
echo=
call :input_number decimal 0 2147483647
call :input_string output_character_set
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

rem =============================== base10(string, in_charset) ===============================

#FUNCTION conv base10


:base10.Demo
echo Convert characters from any encoding to base10 (decimal)
echo=
call :input_string characters
call :input_string input_character_set
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

#FUNCTION conv romanNumeral


:romanNumeral.Demo
echo Convert number to roman numeral
echo=
call :input_number number 0 4999
call :romanNumeral !number!
echo=
echo The Roman Numeral value is !return!
goto :EOF


:romanNumeral   integer(1-4999)
set "return="
set /a "_value=%~1"
for %%r in (
    1000.M 900.CM 500.D 400.CD 
     100.C  90.XC  50.L  40.XL
      10.X   9.IX   5.V   4.IV   1.I
) do (
    for /l %%n in (%%~nr,%%~nr,!_value!) do set "return=!return!%%~xa"
    set /a "_value%%=%%~nr"
)
set "return=!return:.=!"
exit /b

rem ======================================== unromanNumeral(string) ========================================

#FUNCTION conv unromanNumeral


:unromanNumeral.Demo
echo Convert roman numeral to number
echo=
call :input_string romanNumeral
call :unromanNumeral !romanNumeral!
echo=
echo The decimal value is !return!
goto :EOF


:unromanNumeral   roman_numeral
set "return=%~1"
for %%r in (
    IV.4 XL.40 CD.400 IX.9 XC.90 CM.900 I.1 V.5 X.10 L.50 C.100 D.500 M.1000
) do set "return=!return:%%~nr=+%%~xr!"
set /a "return=!return:.=!"
exit /b

rem ======================================== speedtest() ========================================

#FUNCTION env speedtest


:speedtest.Demo
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

#FUNCTION ? wait


:wait.Demo
echo Wait for n milliseconds (This function burns a lot of CPU)
echo sleep() is a version that does not burn CPU
echo=
call :input_number time_in_milliseconds 0 2147483647
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

#FUNCTION ? sleep


:sleep.Demo
echo Sleep for n milliseconds (VBScript hybrid)
echo Similar to wait(), but this version does not burn CPU
echo=
call :input_number time_in_milliseconds 0 2147483647
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
set "temp_path=your_path_here"

[Prerequisites]
call :setupSleep


:setupSleep
set "return="
set "_totalDelay=0"
set "sleepDelay="
echo WScript.Sleep WScript.Arguments(0) > "!temp_path!\sleep.vbs"
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
cscript //NoLogo "!temp_path!\sleep.vbs" !return!
exit /b

rem ======================================== getScreenSize() ========================================

#FUNCTION env getScreenSize


:getScreenSize.Demo
echo Get console screen buffer size
call :getScreenSize
echo=
echo Screen buffer size    : !screen_height!x!screen_width!
goto :EOF


:getScreenSize
set "_lineNum=0"
for /f "usebackq tokens=2 delims=:" %%a in (`mode con`) do (
	set /a "_lineNum+=1"
    if "!_lineNum!" == "1" set /a "screen_height= 0 + %%a + 0"
    if "!_lineNum!" == "2" set /a "screen_width= 0 + %%a + 0"
)
set "_lineNum="
exit /b

rem ======================================== chkAdmin() ========================================

#FUNCTION env chkAdmin


:chkAdmin.Demo
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

#FUNCTION env getSID


:getSID.Demo
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

#FUNCTION dev watchvar


:watchvar.Demo
echo Watch for new, deleted and changed variables in batch script
echo=
echo /i     Initialize variable list
echo /n     Display variable names
echo /w     Write to file instead of console
echo=
call :watchvar /i
for /l %%n in (1,1,5) do (
    for /l %%n in (1,1,10) do (
        set /a "_write=!random! %% 2"
        set /a "_num=!random! %% 10"
        if "!_write!" == "0" (
            set "var!_num!="
        ) else set "var!_num!=!random!"
    )
    set "_write="
    set "_num="
    
    call :watchvar /n
    pause > nul
)
goto :EOF


[Prerequisites]
set "temp_path=your_path_here"


:watchvar   [/i]  [/n]  [/w]
setlocal EnableDelayedExpansion EnableExtensions
for %%f in ("!temp_path!\watchvar") do (
    if not exist "%%~f" md "%%~f"
    pushd "%%~f"
)

rem Setup and rename/delete old files
for %%f in ("var") do (
    for %%t in (txt hex) do (
        if exist "%%~f_old.%%t" del /f /q "%%~f_old.%%t"
        ren "%%~f_current.%%t" "%%~f_old.%%t"
    )
    
    set > "%%~f_current.txt"
    
    set "filename=%%~f"
    set "logfile=%%~f.log"
)

rem Parse parameter
set "initialize_only=False"
set "display_variable_names=False"
set "write_to_file=False"
if not exist "!filename!_old.hex" set "initialize_only=True"
for %%p in (%*) do (
    if /i "%%p" == "/I" set "initialize_only=True"
    if /i "%%p" == "/N" set "display_variable_names=True"
    if /i "%%p" == "/W" set "write_to_file=True"
)
set "new_symbol=+"
set "deleted_symbol=-"
set "changed_symbol=~"

rem Convert to hex and format
certutil -encodehex "!filename!_current.txt" "!filename!_current_raw.hex" > nul
(
    set "read_lines=0"
    set "input_hex="
    for /f "usebackq delims=" %%o in ("!filename!_current_raw.hex") do (
        set "input=%%o"
        set "input_hex=!input_hex! !input:~5,48!"
        set /a "read_lines+=1"
        if "!read_lines!" == "155" call :watchvar.format_hex
    )
    call :watchvar.format_hex
) > "!filename!_current.hex"
del /f /q "!filename!_current_raw.hex"

rem Count variable
set "var_count=0"
for /f "usebackq tokens=*" %%o in ("!filename!_current.hex") do set /a "var_count+=1"

set "WRITE_MACRO="
if /i "!write_to_file!" == "True" set "WRITE_MACRO= ^>^> ^"!logfile!^""

if /i "!initialize_only!" == "True" (
    echo Initial variables: !var_count! %WRITE_MACRO%
    goto watchvar.cleanup
)

rem Compare variables
set "new_count=0"
set "deleted_count=0"
set "changed_count=0"
call 2> "!filename!_changes.hex"
for /f "usebackq tokens=1,3 delims= " %%a in ("!filename!_current.hex") do (
    set "old_value="
    for /f "usebackq tokens=1,3 delims= " %%s in ("!filename!_old.hex") do if "%%a" == "%%s" set "old_value=%%t"
    if defined old_value (
        if not "%%b" == "!old_value!" (
            echo 6368616e676564 20 %%a 0d0a
            set /a "changed_count+=1"
        )
    ) else (
        echo 6e6577 20 %%a 0d0a
        set /a "new_count+=1"
    )
) >> "!filename!_changes.hex"
for /f "usebackq tokens=1 delims= " %%a in ("!filename!_old.hex") do (
    set "found_value=False"
    for /f "usebackq tokens=1 delims= " %%s in ("!filename!_current.hex") do if "%%a" == "%%s" set "found_value=True"
    if /i "!found_value!" == "False" (
        echo 64656c65746564 20 %%a 0d0a
        set /a "deleted_count+=1"
    )
) >> "!filename!_changes.hex"
if exist "!filename!_changes.txt" del /f /q "!filename!_changes.txt"
certutil -decodehex "!filename!_changes.hex" "!filename!_changes.txt" > nul

(
    if "!display_variable_names!" == "True" (
        echo Variables: !var_count!
        for %%t in (new deleted changed) do if not "!%%t_count!" == "0" (
            set /p "=[!%%t_symbol!!%%t_count!] " < nul 
            for /f "usebackq tokens=1* delims= " %%a in ("!filename!_changes.txt") do (
                if "%%a" == "%%t" set /p "=%%b " < nul
            )
            echo=
        )
        
    ) else echo Variables: !var_count! [+!new_count!/~!changed_count!/-!deleted_count!]
) %WRITE_MACRO%
goto watchvar.cleanup

:watchvar.format_hex
set "input_hex=!input_hex! $"
set "input_hex=!input_hex:  = !"
set input_hex=!input_hex:0d 0a=_0d0a^
%=REQURED=%
!
set "input_hex=!input_hex: 3d = .# !"
set "input_hex=!input_hex: =!"
set "input_hex=!input_hex:_= !"
for /f "tokens=1* delims=." %%a in ("!input_hex!") do (
    if "%%b" == "" (
        set "value=%%a"
    ) else (
        set "value=%%b"
        set "value=!value:.=3d!"
        set "value=%%a 3d !value:#=!"
    )
    if /i "!value:~-4,4!" == "0d0a" (
        echo !value!
    ) else set "input_hex=!value!"
)
set "read_lines=7"
if not "!input_hex:~344!" == "" set "read_lines=41"
rem If line is too long then cut off part of the line and write "%=TOO_LONG=%"
if not "!input_hex:~2010!" == "" set "input_hex=!input_hex:~0,1972!20253d544f4f5f4c4f4e473d2520!input_hex:~-9,9!"
set "input_hex=!input_hex:~0,-1!"
goto :EOF

:watchvar.cleanup
echo= %WRITE_MACRO%
popd
endlocal
exit /b

rem Verify
del /f /q "!filename!_current_reverse_hex.txt"
certutil -decodehex "!filename!_current.hex" "!filename!_current_reverse_hex.txt" > nul
fc "!filename!_current.txt" "!filename!_current_reverse_hex.txt" > nul
if "!errorlevel!" == "1" echo WARNING: Content is not the same

rem ======================================== strval(string) ========================================

#FUNCTION dev strval


:strval.Demo
echo Determine the integer value of a variable
echo=
call :input_string string
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

#FUNCTION file wcdir

:wcdir.Demo
echo List files/folders with wildcard path
echo=
call :input_string wildcard_path
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
call :wcdir.find
set "_findNext="
set "_isFile="
exit /b 
:wcdir.find
for /f "tokens=1* delims=\" %%a in ("!_findNext!") do if not "%%a" == "*:" (
    if "%%b" == "" (
        if defined _isFile (
            for /f "delims=" %%f in ('dir /b /a:-d "%%a" 2^> nul') do set "return=!return!%%~ff!LF!"
        ) else for /f "delims=" %%f in ('dir /b /a:d "%%a" 2^> nul') do set "return=!return!%%~ff\!LF!"
    ) else for /d %%f in ("%%a") do pushd "%%~f\" 2> nul && (
        set "_findNext=%%b"
        call :wcdir.find
        popd
    )
) else for %%l in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do pushd "%%l:\" 2> nul && (
    set "_findNext=%%b"
    call :wcdir.find
    popd
)
exit /b


rem Combination Wildcard Dir
:combinwcdir   path_list1 path_list2
for %%p in (%1 %2) do (
    set ^"_temp=!%%p:;=%NL%!^"
    for /f "tokens=*" %%a in ("!_temp!") do (
        set "_is_listed="
        for /f "tokens=*" %%b in ("!%%p!") do if "%%a" == "%%b" set "_is_listed=True"
        if not defined _is_listed set "%%p=!%%p!%%a!LF!"
    )
)
set "_found="
for /f "tokens=*" %%a in ("!_path1!") do for /f "tokens=*" %%b in ("!_path2!") do (
    call :wcdir "%%a\%%b"
    set "_found=!_found!!return!"
)
set "return=!_found!"
exit /b

rem ======================================== setupEndlocal() ========================================

#FUNCTION dev setupEndlocal

:setupEndlocal.Demo
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

#FUNCTION ? setupClearline

:setupClearline.Demo
echo Macro version of clear line
echo=
call :getScreenSize
call :setupClearline "!screen_width!-1"
set /p "=Press any key to continue..." < nul
pause > nul
echo !CL!Line cleared^^!
goto :EOF


[Prerequisites]
call :capchar BS CR LR

[Requires]
call :getOS


:setupClearline   length
set /a "_length=%~1"
call :getOS /b
set "CL="
if !return! GEQ 100 (
    for /l %%n in (1,1,!_length!) do set "CL=!CL! "
    set "CL=!BASE!!CR!!CL!!CR!"
) else for /l %%n in (1,1,!_length!) do set "CL=!CL!!BS!"
goto :EOF

rem ======================================== parse_args() ========================================

#FUNCTION dev parse_args

:parse_args.Demo
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
call :input_string parameter
echo=
set "_options=P.flag:param.prompt_user!LF!F.flag:param.force_delete!LF!S.flag:param.include_subdir"
set "_options=!_options!!LF!Q.flag:param.wildcard_prompt!LF!A:param.attributes"
set "_required=!LF!param.filename"

echo ===== Parameter =====
echo=[!parameter!]
echo=
echo ===== Settings =====
set _options
echo=
set _required
echo=

rem Flag type arguments are initialized to "false"
rem Initialize default value for non-flag arguments
set "param.attributes="
set "param.filename="
echo ===== Parse result =====
call :parse_args !parameter! > nul || exit /b 1
set "param."
goto :EOF


:parse_args   %*  [_required]  [_options]
for /f "tokens=1* delims=:" %%a in ("!_options!") do (
    if /i "%%~xa" == ".flag" set "%%~b=false"
)
set "_prevArg="
set "_optName="
set "_paramCount=0"
set "_requiredCount=0"
for %%r in (!_required!) do (
    set "_required!_requiredCount!=%%~r"
    set /a "_requiredCount+=1"
)
:parse_args.options
set "_value=%1"
if not defined _value goto parse_args.cleanup
set "_arg="
if "!_value:~0,1!" == "-" set "_arg=!_value:~1!"
if "!_value:~0,1!" == "/" set "_arg=!_value:~1!"
if defined _arg (
    if defined _optName echo Invalid parameter: !_prevArg! 1>&2 & exit /b 2
    set "_prevArg=%1"
    for /f "tokens=1* delims=:" %%s in ("!_arg!") do for /f "tokens=1* delims=:" %%p in ("!_options!") do (
        if /i "%%~s" == "%%~np" (
            set "_arg="
            if "%%~xp" == ".flag" (
                set "%%~q=true"
                set "_value="
            ) else (
                set "_optName=%%~q"
                set "_value=%%t"
            )
        )
    )
    if defined _arg echo Unknown parameter: %1 1>&2 & exit /b 1
)
if defined _value if defined _optName (
    for /f "tokens=*" %%v in ("!_value!") do set "!_optName!=%%~v"
    set "_optName="
) else if not defined _arg if !_paramCount! LSS !_requiredCount! (
    for %%n in (!_paramCount!) do set "!_required%%n!=%~1"
    set /a "_paramCount+=1"
)
shift /1
goto parse_args.options
:parse_args.cleanup
set "_arg="
set "_prevArg="
set "_optName="
set "_value="
for /l %%r in (0,1,!_requiredCount!) do set "_required%%r="
set "_paramCount="
set "_requiredCount="
exit /b 0

rem ======================================== colorPrint(color, text) ========================================

#FUNCTION ? colorPrint

:colorPrint.Demo
echo Print text with color and background color
echo=
call :input_string text
call :input_string textColor
call :input_string backgroundColor
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
pushd "!temp_path!" 2> nul || exit /b 1
(
    set /p "=!BS!!BS!" < nul > "%~2_"
    findstr /l /v /a:%~1 "." "%~2_" nul || exit /b 1
    del /f /q "%~2_" > nul
) 2> nul
popd
exit /b 0

rem ======================================== getOS() ========================================

#FUNCTION env getOS

:getOS.Demo
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


rem ======================================== expand_path() ========================================

#FUNCTION dev expand_path

:expand_path.Demo
echo Expands given path to:
echo [D]rive letter, [A]ttributes, [T]ime stamp, si[Z]e, 
echo [N]ame, e[X]tension, [P]ath, [F]ull path
echo=
call :expand_path currentDir_ "!cd!"
set currentDir_
goto :EOF


:expand_path   prefix file_path
set "%~1D=%~d2" Drive Letter
set "%~1A=%~a2" Attributes
set "%~1T=%~t2" Time Stamp
set "%~1Z=%~z2" Size
set "%~1N=%~n2" Name
set "%~1X=%~x2" Extension
set "%~1P=%~p2" Path
set "%~1F=%~f2" Full Path
set "%~1DP=%~dp2" D + P
set "%~1NX=%~nx2" N + X
exit /b


:expand_multipath   prefix file_path1 [file_path2 ...]
for %%a in (D P N X F DP NX) do set "%~1%%a="
set "_continue="
for %%f in (%*) do if defined _continue (
    set ^"%~1Ds=!%~1Ds! "%%~df"^"
    set ^"%~1Ps=!%~1Ps! "%%~pf"^"
    set ^"%~1Ns=!%~1Ns! "%%~nf"^"
    set ^"%~1Xs=!%~1Xs! "%%~xf"^"
    set ^"%~1Fs=!%~1Fs! "%%~ff"^"
    set ^"%~1DPs=!%~1DPs! "%%~dpf"^"
    set ^"%~1NXs=!%~1NXs! "%%~nxf"^"
) else set "_continue=True"
exit /b

rem ======================================== capchar() ========================================

#FUNCTION dev capchar

:capchar.Demo
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

rem ======================================== getExternalIP() ========================================

#FUNCTION env getExternalIP

:getExternalIP.Demo
echo Get external IP address
echo=
call :getExternalIP
echo=
echo External IP: !return!
goto :EOF


:getExternalIP
> nul 2> nul (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('http://ipecho.net/plain', '!temp!\ip.txt')"
) || exit /b !errorlevel!
for /f "usebackq tokens=*" %%o in ("!temp!\ip.txt") do set "return=%%o"
exit /b 0

rem Download file
powershell -Command "Invoke-WebRequest http://www.example.com/package.zip -OutFile package.zip"

rem ======================================== getExternalIP() ========================================

#FUNCTION env listIP

:listIP.Demo
echo List interface IP address
echo Does not show interfaces with no IPv4 address
echo=
echo=
call :listIP
goto :EOF

:listIP
set "interface_count=0"
for /f "tokens=* usebackq" %%o in (`ipconfig /all`) do (
    set "output=%%o"
    if "!output:~-1,1!" == ":" (
        if not "!interface_count!" == "0" if defined interface_ipv4 call :listIP.output
        set /a "interface_count+=1"
        set "interface_name="
        set "interface_desc="
        set "interface_ipv4="
        set "interface_type="
        set "interface_dhcp_server="
    )
    if "!output:~-1,1!" == ":" (
        set "_temp=!output:~0,-1!"
        for %%n in (!_temp!) do if defined _temp (
            if "%%n" == "adapter" (
                set "_temp="
            ) else set "interface_type=!interface_type! %%n"
        ) else set "interface_name=!interface_name! %%n"
        set "interface_name=!interface_name:~1!"
        set "interface_type=!interface_type:~1!"
    )
    if "!output:~0,11!" == "Description" set "interface_desc=!output:~36!"
    if "!output:~0,12!" == "IPv4 Address" set "interface_ipv4=!output:~36!"
    if "!output:~0,30!" == "Autoconfiguration IPv4 Address" set "interface_ipv4=!output:~36!"
    if "!output:~0,11!" == "DHCP Server" set "interface_dhcp_server=!output:~36!"
)
if not "!interface_count!" == "0" if defined interface_ipv4 call :listIP.output
exit /b
:listIP.output
echo [!interface_type!] !interface_name!:
echo Desc        : !interface_desc!
echo IPv4        : !interface_ipv4!
if defined interface_dhcp_server echo DHCP Server : !interface_dhcp_server!
echo=
goto :EOF

rem ======================================== Helper Functions ========================================
:__HELPER_FUNCTIONS__     Helper Functions (not part of Function Library)


rem ================================ Input Number ================================

:input_number   variable_name  minimum  maximum  [description]
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
goto input_number

rem ================================ Input String ================================

:input_string   variable_name  [description]
echo=
if "%~2" == "" (
    echo Input %~1:
) else echo Input %~2:
set /p "%~1="
exit /b

rem ================================ Input Yes No ================================

:input_yesno   variable_name  [description]
echo=
if "%~2" == "" (
    set /p "%~1=%~1 Y/N? "
) else set /p "%~1=%~2 Y/N? "
if /i "!%~1!" == "Y" exit /b
if /i "!%~1!" == "N" exit /b
goto input_yesno

rem ================================ Input Path ================================

:input_path   variable_name  [/F | /D]  [/S]
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
:input_path.input
set "user_input="
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
set /p "user_input="
echo=

if defined _skippable               if "!user_input!" == "\:" exit /b 2
if /i "!_inputType!" == "folder"    if "!user_input!" == ".\" set "user_input=!cd!"
if not defined user_input            set "user_input=!lastUsed_file!"

call :stripDQotes user_input
if not exist "!user_input!" (
    echo The !_inputType! does not exist
    pause
    goto input_path.input
)
set "%~1=!user_input!"
call :expand_path "!user_input!" _file_
if /i "!_file_A:~0,1!" == "d" (
    if /i "!_inputType!" == "file" (
        echo Your input is not a file...
    ) else exit /b 0
) else if /i "!_inputType!" == "folder" (
    echo Your input is not a folder...
) else exit /b 0
pause
goto input_path.input

rem ================================ Input IPv4 ================================

:input_ipv4   variable_name  [/W]
rem /W Allow wildcard
set "_allowWildcard="
if /i "%~2" == "/W" set "_allowWildcard= (wildcard allowed)"
echo=
:input_ipv4.input
set /p "user_input=Input IP adress!_allowWildcard! (0 to Quit): "
if "!user_input!" == "0" exit /b
set "user_input= !user_input!"
set ^"user_input=!user_input:.=^
%=REQURED=%
!"
set "user_input=!user_input:~1!"
set "%~1="
set "_numCount=0"
for /f "tokens=*" %%n in ("!user_input!") do (
    set /a "_numCount+=1"
    if !_numCount! GTR 4 goto input_ipv4.input
    if "%%n" == "*" (
        if not defined _allowWildcard goto input_ipv4.input
    ) else (
        set /a "_num=%%n" 2> nul || goto input_ipv4.input
        if %%n LSS 0    goto input_ipv4.input
        if %%n GTR 255  goto input_ipv4.input
    )
    set "%~1=!%~1!.%%n"
)
if not "!_numCount!" == "4" goto input_ipv4.input
set "%~1=!%~1:~1!"
exit /b

rem ================================ Change Screen Size ================================

[Requires]
call :getScreenSize
call :setupClearline

:changeScreenSize   width  height
mode %~1,%~2
call :getScreenSize
call :setupClearline "!screen_width!-1"
goto :EOF

rem ======================================== End of Script ========================================








rem ======================================== Other Function ========================================
:__OTHER_FUNCTIONS__     Actually working functions but not listed


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



:move [source] [destination_folder]
if not exist "%~1" exit /b 1
if not exist "%~f2" md "%~f2"
if "%~d1" == "%~d2" (
    for /d %%d in ("%~1") do move /y "%%~fd" "%~f2" > nul || exit /b !errorlevel!
    if exist "%~1" for %%f in ("%~1") do move /y "%%~ff" "%~f2" > nul || exit /b !errorlevel!
) else (
    echo robocopy /move /e "%~1" "%~2\%~nx1"
    exit /b 2
)
exit /b 0


rem ======================================== Dynamic Menu Creator ========================================

:dynamenu.read
for /f "usebackq tokens=1,2 delims= " %%a in ("%~f0") do (
    if "%%~xa" == ".dynamenu" set "dynamenu_%%b=!dynamenu_%%b! %%~na"
)
exit /b 0


:dynamenu   menu_type number|list
if not defined dynamenu_%~1 exit /b 1
set "selected_menu="
set "_menu_count=0"
for %%m in (!dynamenu_%~1!) do call %%m.dynamenu && (
    set /a "_menu_count+=1"
    if /i "%~2" == "list" (
        set "_menu_count=   !_menu_count!"
        echo !_menu_count:~-3,3!. !dynamenu_text!
    ) else if "%~2" == "!_menu_count!" set "selected_menu=%%m"
)
set "dynamenu_text="
if defined selected_menu call !selected_menu!
goto :EOF

call :dynamenu.read
call :dynamenu menu_type list
call :dynamenu menu_type 1


:menulabel.dynamenu   options
set "dynamenu_text=Menu name here"
rem Allow condition here
if not "!nginx_state!" == "STOPPED" exit /b 1
exit /b 0
:menulabel
rem Your function here
exit /b 0

rem ======================================== WIP Function ========================================
:__WIP_FUNCTIONS__     Work In Progress Functions


rem ======================================== timedatedone(start_time, progress, progress) ========================================

:timedatedone   start_time progress [Total Progress] ????
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

rem =============================== convEnc(string, in_charset, string, out_charset) ===============================

.#FUNCTION conv convEnc


:convEnc.Demo
echo Convert string from one encoding to another
echo=
echo Example: Convert Hexadecimal to Base64
echo=
set "hexadecimal=0123456789ABCDEF"
set "base64=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
call :input_string input_string
call :convEnc input_string hexadecimal base64
echo=
echo Converted string:
echo=!return!
goto :EOF


:convEnc   variable_name  input_charset_variable  output_charset_variable
set "return="
set "_inCharsetLen=0"
set "_outCharsetLen=0"
set "_inBits=13"
set "_outBits=13"
for %%n in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1 0) do (
    set /a "_inCharsetLen+=%%n"
    for %%l in (!_inCharsetLen!) do if "!%~2:~%%l,1!" == "" (
        set /a "_inCharsetLen-=%%n"
        set /a "_inBits-=1"
    )
)
set /a "_inCharsetLen+=1"
for %%n in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1 0) do (
    set /a "_outCharsetLen+=%%n"
    for %%l in (!_outCharsetLen!) do if "!%~3:~%%l,1!" == "" (
        set /a "_outCharsetLen-=%%n"
        set /a "_outBits-=1"
    )
)
set /a "_outCharsetLen+=1"
echo IL[!_inCharsetLen!] OL[!_outCharsetLen!]
echo IB[!_inBits!] OB[!_outBits!]

call :strlen %~1
set "_varLen=!return!"
echo VL[!_varLen!]

rem Read and get value of 1600 chars
set "_charValues="
for /l %%i in (0,1,!_varLen!) do if not "!%~1:~%%i,1!" == "" (
    for /l %%n in (0,1,!_inCharsetLen!) do if "!%~1:~%%i,1!" == "!%~2:~%%n,1!" set "_charValues=!_charValues! %%n"
)
echo VV[!_charValues!]

if not defined %1 goto :EOF
for /l %%i in (0,1,8191) do (
    if not "!%1:~%%i,1!" == "" (
        set "nextValue=0"
        for /l %%n in (0,1,!encodingLength!) do if "!%1:~%%i,1!" == "!%2:~%%n,1!" set "nextValue=%%n"
        for /l %%l in (1,1,!encodingBit!) do (
            set /a "remainder= !remainder! << 1   |   !nextValue! >> !encodingBit!-1 "
            set /a "nextValue%%= 1 << !encodingBit!-1"
            set /a "nextValue<<=1"
            if !remainder! GEQ !requirementXOR! set /a "remainder= !remainder! - !requirementXOR! ^^ %4"
        )
    )
)
set /a "nextValue=%6 + 0"
for /l %%l in (1,1,%3) do (
    set /a "nextValue*=2"
    set /a "remainder= !remainder! * 2 + !nextValue! / !requirementXOR!"
    set /a "nextValue%%= !requirementXOR!"
    if !remainder! GEQ !requirementXOR! set /a "remainder= !remainder! - !requirementXOR! ^^ %4"
)
pause
exit /b

rem ======================================== Notes ========================================
:__NOTES__     Useful stuffs worth looking at


rem ======================================== Notes (General) ========================================

rem Date and Time
set "dateAndTime=!date:~10!!date:~4,2!!date:~7,2!_!time:~0,2!!time:~3,2!!time:~6,2!"

rem Wildcard from %~nx1
set "_isDir=%~a1"
set "isWildcard=%~nx1"
if "!_isDir:~0,1!" == "-" set "_isDir="
if not "!isWildcard:~0,1!" == "." set "isWildcard="

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
set ^"NL=^^^%LF%%LF%^%LF%%LF%^"

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

set "server_state=STOPPED | RUNNING | ERROR
set "server_state_msg=!server_state_msg_%server_state%!"
set "found_time=!date:~10!!date:~4,2!!date:~7,2!_!time:~0,2!!time:~3,2!!time:~6,2!"


rem Label Names
::Preset.init
::Server.setup
::Preset.read
::Preset.get_item   list|number
::Server.check_state
::Server.edit_config

rem ======================================== Notes (File I/O) ========================================

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

:File.generate file_id file_location
call 2> "%~f2.b64"
set "write_to_file=false"
for /f "usebackq tokens=*" %%o in ("%~f0") do (
    for /f "tokens=1,2* delims= " %%a in ("%%o") do (
        if /i "!write_to_file!" == "TRUE" (
            if /i "%%a" == "!file_end_tag!" goto File.generate.decode
            echo %%o >> "%~f2.b64"
        )
        if /i "%%a" == "!file_start_tag!" (
            if "%%b" == "%~1" set "write_to_file=true"
        )
    )
)
:File.generate.decode
certutil -decode "%~f2.b64" "%~f2" > nul 2> nul && (
    echo Generate successful
) || (
    echo Generate failed
)
del /f /q "%~f2.b64"
goto :EOF


:File.import filename
call 2> "%~nx1.b64"
certutil -encode "%~nx1" "%~nx1.b64" > nul 2> nul || (
    echo Import failed
    goto :EOF
)
set "file_id=FILE!date:~10!!date:~4,2!!date:~7,2!_!time:~0,2!!time:~3,2!!time:~6,2!"
(
    echo=
    echo #file !file_id! %~nx1
    type "%~nx1.b64"
    echo #end
) >> "%~f0"
del /f /q "%~nx1.b64"
popd
goto :EOF

rem ======================================== Notes (Data Collection) ========================================

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
wmic desktopmonitor get screen_height, screen_width

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

rem Get Downloads folder
for /f "usebackq skip=1 tokens=1,2*" %%t in (`reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" 2^>nul`) do (
    if /I "%%t"=="{374DE290-123F-4565-9164-39C4925E467B}" set "download_folder=%%v"
)

rem Download file
powershell -Command "Invoke-WebRequest http://www.example.com/package.zip -OutFile package.zip"

rem Others
driverquery
gpresult
telnet


