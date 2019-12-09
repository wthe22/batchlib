@goto Module.detect

rem ======================================== Script Meta-data ========================================

:__setup__   [prefix]
set "%~1NAME=batchlib"
set "%~1DESCRIPTION=Batch Script Library"
set "%~1VERSION=2.0-b.1"
set "%~1RELEASE=03/25/2019"   :: MM/DD/YYYY
set "%~1URL=https://winscr.blogspot.com/2017/08/function-library.html"
set "%~1DOWNLOAD_URL=https://gist.github.com/wthe22/4c3ad3fd1072ce633b39252687e864f7/raw"
exit /b 0


:__about__
setlocal EnableDelayedExpansion
call :__setup__
title !NAME! !VERSION!
cls
echo A collection of functions for batch script
echo Created to make batch scripting easier
echo=
echo Updated on !RELEASE!
echo=
echo Feel free to use, share, or modify this script for your projects :)
echo=
echo Visit http://winscr.blogspot.com/ for more scripts^^!
echo=
echo=
echo=
echo Copyright (C) 2019 by wthe22
echo Licensed under The MIT License
echo=
endlocal
pause > nul
exit /b 0

rem ======================================== Settings ========================================

:__settings__
set "temp_path=!temp!\BatchScript\"

rem Below are not used here, but for reference only
set "data_path=data\Functions\"
set "default_console_width=80"
set "default_console_height=25"
set "console_width=!default_console_width!"
set "console_height=!default_console_height!"
set "ping_timeout=750"
set "debug_mode=FALSE"
exit /b 0

rem ======================================== Changelog ========================================

:__changelog__
echo    2.0-b.1 (2019-03-25)
echo    Bug fix update
echo    - fixed Module.updater not upgrading script
exit /b 0


:__changelog__.full
call :__changelog__
echo=
echo    2.0-b (2019-03-25)
echo    Major update
echo    - fixed parameter when calling script as lib module
echo    - removed unnecessary watchvar -w flag, since it can be done using >> redirection
echo    - fixed a rare display error of watchvar()
echo    - fixed error in unzip() if path ends with slash
echo    - fixed error when capturing Carriage Return using capchar() if script is set to read-only
echo    - fixed endlocal() not copying empty variables
echo    - fixed incorrect EOL format if script is downloaded from GitHub
echo    - removed get_os() /b flag, it is now the default option
echo    - reworking sleep(), still unavailable for now
echo    - re-factored several functions (no feature change)
echo    - regrouped category and functions
echo    - improved demo of download()
echo    - fixed expand_link(), and now it can work with incomplete urls (e.g.: no scheme defined)
echo    - expand_link can now seperate query ('?') and fragment ('#') in url
echo    - wcdir() can now search for both file and directory at the same time
echo    - wcdir() search file/directory only now requires additional parameter
echo    - Module.detect() no longer set __name__
echo    - Module.detect() now changes %* argument
echo    - added path_check(), check_eol(), color2seq()
echo    - added assertion for debugging
exit /b 0

rem ======================================== Debug function ========================================

:__error__.assertion
@echo=
@echo=
@ < nul set /p "=Assertion error: "
@for %%t in (%*) do @echo %%~t
@echo=
@echo Press any key to exit...
@pause > nul
@exit

rem ======================================== Library module ========================================

rem Call script as library module and call the function
call your_file_name.bat --module:lib <function> [arg1 [arg2 [...]]]

rem Example:
call batch --module:lib pow result 2 16
call batch --module:lib :Input_number age "Input your age: " 0~200


:__module__.lib
@call :%*
@exit /b

rem ======================================== Main module ========================================

:__module__.__main__.reload
endlocal

:__module__.__main__
@set "__name__=__main__"
@echo off
prompt $g
setlocal EnableDelayedExpansion EnableExtensions
call :__setup__ SOFTWARE_
title !SOFTWARE_DESCRIPTION! !SOFTWARE_VERSION!
cls
echo Loading script...

@call :check_eol --check-exist && @(
    call :check_eol || @(
        echo Converting EOL...
        type "%~f0" | more /t4 > "%~f0.tmp" && (
            move "%~f0.tmp" "%~f0" > nul && goto __module__.__main__.reload
        )
        echo warn: Convert EOL failed
    )
) || @echo warn: Cannot check EOL

call :__settings__

for %%p in (
    %= Add your path here =%
) do if not exist "!%%p!" md "!%%p!"

call :Function.read
set "last_used.function="
call :capchar *
call :get_con_size console_width console_height

:main.loop
call :select_function
if "!user_input!" == "0" exit
if /i "!user_input!" == "A" call :__about__
if not defined selected.function goto :main.loop
call :start_function !selected.function!
goto main.loop

rem ================================ Menu ================================
:_.MENU._     Main Menu


:select_function
:select_function.category
set "search_keyword="
set "user_input="
cls
call :Category.get_item list
echo=
if defined last_used.function echo L. Last used function
echo S. Search function
echo A. About script
echo 0. Exit
echo=
echo Which tool do you want to use?
set /p "user_input="
if "!user_input!" == "0" goto :EOF
if /i "!user_input!" == "A" goto :EOF
if defined last_used.function if /i "!user_input!" == "L" (
    set "selected.function=!last_used.function!"
    goto :EOF
)
if /i "!user_input!" == "S" goto select_function.search
call :Category.get_item "!user_input!" && goto select_function.name
goto select_function.category


:select_function.search
set "user_input="
cls
echo 0. Back
echo=
echo Input search keyword:
set /p "user_input="
if "!user_input!" == "0" goto select_function.category

rem Search for keyword in function arguments
set "Category_search.functions="
for /f "delims=" %%k in ("!user_input!") do for %%f in (!Category_all.functions!) do (
    set "_temp= !Function_%%f.args!"
    if not "!_temp:%%k=!" == "!_temp!" set "Category_search.functions=!Category_search.functions! %%f"
)
set "search_keyword=!user_input!"
set "selected.category=search"
goto select_function.name


:select_function.name
set "user_input="
cls
if defined search_keyword (
    echo Search keyword: !search_keyword!
    echo=
)
call :Function.get_item !selected.category! list
echo=
echo 0. Back
echo=
echo Input function number:
set /p "user_input="
if "!user_input!" == "0" goto select_function.category
call :Function.get_item "!selected.category!" "!user_input!" && (
    set "last_used.function=!selected.function!"
    goto :EOF
)
goto select_function.name


:start_function
setlocal EnableDelayedExpansion EnableExtensions
title !SOFTWARE_DESCRIPTION! !SOFTWARE_VERSION! - %~1
cls
echo call :!Function_%~1.args!
echo=
call :%~1.__demo__
echo=
echo ================================ END OF FUNCTION ===============================
title !SOFTWARE_DESCRIPTION! !SOFTWARE_VERSION!
echo=
pause
endlocal
exit /b 0

rem ======================================== Class ========================================
:_.CLASS._     For "objects"


:Function.read
set "Category.list="
set "Category_all.name=All"
set "Category_all.functions="
set "Category_all.item_count=0"
set "Category_others.name=Others"
set "Category_others.functions="
set "Category_others.item_count=0"
set "_function="
for /f "usebackq tokens=*" %%a in ("%~f0") do for /f "tokens=1-3* delims= " %%b in ("%%a") do (
    if /i "%%b %%c" == "$ Category" (
        if not defined Category_%%d.name (
            set "Category.list=!Category.list! %%d"
            set "Category_%%d.name=%%~e"
            set "Category_%%d.functions="
            set "Category_%%d.item_count=0"
        )
    )
    if /i "%%b %%c" == "$ Function" (
        set "_category=%%d"
        if not defined Category_%%d.name set "_category=others"
        for %%n in (all !_category!) do (
            set "Category_%%n.functions=!Category_%%n.functions! %%e"
            set /a "Category_%%n.item_count+=1"
        )
        set "_function=%%e"
    )
    if /i "%%b" == ":!_function!" (
        set "_temp=%%a"
        set "Function_!_function!.args=!_temp:~1!"
    )
)
set "_temp="
set "_category="
set "_function="
set "Category.list=all !Category.list!"
if not "!Category_others.item_count!" == "0" set "Category.list=!Category.list! others"
exit /b 0


:Category.get_item   list|number
set "_count=0"
set "selected.category="
for %%v in (!Category.list!) do (
    set /a "_count+=1"
    if /i "%1" == "list" (
        set "_count=   !_count!"
        echo !_count:~-3,3!. !Category_%%v.name! [!Category_%%v.item_count!]
    ) else if "%~1" == "!_count!" set "selected.category=%%v"
)
if /i not "%1" == "list" if not defined selected.category exit /b 1
exit /b 0


:Function.get_item   category  list|number
set "_count=0"
set "selected.function="
for %%v in (!Category_%~1.functions!) do (
    set /a "_count+=1"
    if /i "%2" == "list" (
        set "_count=   !_count!"
        echo !_count:~-3,3!. !Function_%%v.args!
    ) else if "%~2" == "!_count!" set "selected.function=%%v"
)
if /i not "%2" == "list" if not defined selected.function exit /b 1
exit /b 0

rem ======================================== Functions Library ========================================
:_.FUNCTION_LIBRARY._     Collection of Functions


$ Category  math    Math
$ Category  str     String
$ Category  time    Date and Time
$ Category  file    File and Folder
$ Category  net     Network
$ Category  env     Environment
$ Category  io      Input / Output
$ Category  fw      Framework


rem ================================ GUIDES ================================

rem Variable names: best to not name a variable with special characters (!%^&*(),"/\=|;)

rem What parameter means:
rem variable_name: the name of variable of the input
rem return_var: the name of variable to write the result
rem variable: also refers to variable_name
rem integer: whole number from -2147483647 to 2147483647, no decimals '.' allowed
rem          sometimes hexadecimal and octal can be used
rem minimum/min: integer, usually for range
rem maximum/max: integer, usually for range
rem power: integer, usually for math functions (e.g.: 2^n)
rem time: formatted as HH:MM:SS.CC (C means 1/100 of a second or called centiseconds)
rem date: formatted as MM/DD/YYYY
rem milliseconds: unit of time, stored as integer
rem charset: character set or list of characters

rem Note:
rem - Most functions assumes that the parameter is valid

rem ========================================================================

rem ================================ rand() ================================
$ Function math rand


:rand.__demo__
echo Generate random number within a range
echo=
echo Note:
echo - Does not generate uniform random numbers (modulo bias)
echo=
call :Input_number minimum "" "0~2147483647"
call :Input_number maximum "" "0~2147483647"
call :rand random_int !minimum! !maximum!
echo=
echo Random Number  : !random_int!
goto :EOF


:rand   return_var  minimum  maximum
set /a "%~1=((!random!<<16) + (!random!<<1) + (!random!>>14)) %% ((%~3)-(%~2)+1) + (%~2)"
exit /b 0


:rand.__optimized__   return_var  minimum  maximum
set /a "%~1=((!random!<<0x10) + (!random!<<0x1) + (!random!>>0xE)) %% ((%~3)-(%~2)+0x1) + (%~2)"
exit /b 0

rem Generate random number from -2^31 to 2^31-1:
set /a "%~1=(!random!<<17 + !random!<<2 + !random!>>13) %% ((%~3)-(%~2)+1) + (%~2)"

rem ================================ randw() ================================
$ Function math randw


:randw.__demo__
echo Generate random number based on weights
echo Random number generated is index number (starts from 0)
echo=
echo Note:
echo - Based on: rand()
echo - Does not generate uniform random numbers (modulo bias)
echo=
call :Input_string weights
call :randw !weights!
echo=
echo Random Number  : !return!
goto :EOF


:randw   return_var  weight1  [weight2 [...]]
set "%~1="
setlocal EnableDelayedExpansion
set "_sum=0"
for %%n in (%*) do set /a "_sum+=%%~n"
set /a "_rand=((!random!<<16) + (!random!<<1) + (!random!>>14)) %% !_sum!"
set "_sum=0"
set "_index=0"
set "_result="
for %%n in (%*) do if not defined _result (
    set /a "_sum+=%%n"
    if !_rand! LSS !_sum! set "_result=!_index!"
    set /a "_index+=1"
)
if not defined _result set "_result=-1"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ yroot() ================================
$ Function math yroot


:yroot.__demo__
echo Calculate y root of x
echo=
call :Input_number number "" "0~2147483647"
call :Input_number power "" "0~2147483647"
call :yroot result !number! !power!
echo=
echo Root to the power of !power! of !number! is !result!
echo Result is round down
goto :EOF


:yroot   return_var  integer  power
set "%~1="
setlocal EnableDelayedExpansion
set "_result=0"
for /l %%b in (15,-1,0) do (
    set "_guess=1"
    set "_limit=0x7FFFFFFF"
    for /l %%p in (1,1,%~3) do if not "!_limit!" == "0" (
        set /a "_guess*=!_result! + (1<<%%b)"
        set /a "_limit/=!_result! + (1<<%%b)"
    )
    if not "!_limit!" == "0" if !_guess! LEQ %~2 set /a "_result+=(1<<%%b)"
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ pow() ================================
$ Function math pow


:pow.__demo__
echo Calculate x to the power of n
echo=
echo Note:
echo - It will set errorlevel to 1 if result is too large (^> 2147483647)
echo=
call :Input_number number "" "0~2147483647"
call :Input_number power "" "0~2147483647"
call :pow result !number! !power!
echo=
echo !number! to the power of !power! is !result!
goto :EOF


:pow   return_var  integer  power
set "%~1="
setlocal EnableDelayedExpansion
set "_result=1"
set "_limit=0x7FFFFFFF"
for /l %%p in (1,1,%~3) do (
    set /a "_result*=%~2"
    set /a "_limit/=%~2"
)
if "!_limit!" == "0" 1>&2 echo error: result is too large & exit /b 1
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ prime() ================================
$ Function math prime


:prime.__demo__
echo Test for prime number, returns factor if number is composite
echo Prime numbers: 2, 3, 5, 7, ..., 2147483587, 2147483629, 2147483647
echo=
echo Note:
echo - Based on: yroot()
echo=
call :Input_number number "" "0~2147483647"
call :prime factor !number!
echo=
if "!factor!" == "!number!" (
    echo !number! is a prime number
) else if "!factor!" == "0" (
    echo !number! is not a prime number nor a composite number
) else (
    echo !number! is a composite number. It is divisible by !factor!
)
goto :EOF


:prime   return_var  integer
set "%~1="
setlocal EnableDelayedExpansion
set "_factor=0"
if %~2 GEQ 0 if %~2 GEQ 2 (
    set /a "_remainder=%~2 %% 2"
    if "!_remainder!" == "1" (
        set "_max=0"
        for /l %%b in (15,-1,0) do (
            set "_guess=1"
            set "_limit=0x7FFFFFFF"
            for /l %%p in (1,1,2) do (
                set /a "_guess*=!_max! + (1<<%%b)"
                set /a "_limit/=!_max! + (1<<%%b)"
            )
            if not "!_limit!" == "0" if !_guess! LEQ %~2 set /a "_max+=(1<<%%b)"
        )
        set "_factor="
        for /l %%f in (3,2,!_max!) do if not defined _factor (
            set /a "_remainder=%~2 %% %%f"
            if "!_remainder!" == "0" set "_factor=%%f"
        )
        if not defined _factor set "_factor=%~2"
    ) else set "_factor=2"
)
for /f "tokens=*" %%r in ("!_factor!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ gcf() ================================
$ Function math gcf


:gcf.__demo__
echo Calculate greatest common factor (GCF) of 2 numbers
echo=
echo Two largest number with GCF of 1: 1134903170 1836311903
echo=
call :Input_number number1 "" "0~2147483647"
call :Input_number number2 "" "0~2147483647"
call :gcf result !number1! !number2!
echo=
echo GCF of !number1! and !number2! is !result!
goto :EOF


:gcf   return_var  integer1  integer2
setlocal EnableDelayedExpansion
set /a "_result=%~2"
set /a "_temp=%~3"
for /l %%l in (1,1,46) do for %%n in (!_temp!) do if not "!_temp!" == "0" (
    set /a "_temp=!_result! %% %%n"
    set /a "_result=%%n"
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ bin2int() ================================
$ Function math bin2int


:bin2int.__demo__
echo Convert binary to decimal
echo=
call :Input_string binary
call :bin2int result !binary!
echo=
echo The decimal value is !result!
goto :EOF


:bin2int   return_var  unsigned_binary
set "%~1="
setlocal EnableDelayedExpansion
set "_input=00000000000000000000000000000000%~2"
set "_result=0"
for /l %%i in (1,1,32) do set /a "_result+=!_input:~-%%i,1! << %%i-1"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ int2bin() ================================
$ Function math int2bin


:int2bin.__demo__
echo Convert decimal to unsigned binary
echo=
call :Input_number decimal "" "0~2147483647"
call :int2bin result !decimal!
echo=
echo The binary value is !result!
goto :EOF


:int2bin   return_var  positive_integer
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
for /l %%i in (0,1,31) do (
    set /a "_bits=(%~2>>%%i) & 0x1"
    set "_result=!_bits!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Z0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0

rem ================================ int2oct() ================================
$ Function math int2oct


:int2oct.__demo__
echo Convert decimal to octal
echo=
call :Input_number decimal "" "0~2147483647"
call :int2oct result !decimal!
echo=
echo The octal value is !result!
goto :EOF


:int2oct   return_var  positive_integer
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
for /l %%i in (0,3,31) do (
    set /a "_bits=(%~2>>%%i) & 0x7"
    set "_result=!_bits!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Z0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0

rem ================================ int2hex() ================================
$ Function math int2hex


:int2hex.__demo__
echo Convert decimal to hexadecimal
echo=
call :Input_number decimal "" "0~2147483647"
call :int2hex result !decimal!
echo=
echo The hexadecimal value is !result!
goto :EOF


:int2hex   return_var  positive_integer
set "%~1="
setlocal EnableDelayedExpansion
set "_charset=0123456789ABCDEF"
set "_result="
for /l %%i in (0,4,31) do (
    set /a "_bits=(%~2>>%%i) & 0xF"
    for %%b in (!_bits!) do set "_result=!_charset:~%%b,1!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Z0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0

rem ================================ int2roman() ================================
$ Function math int2roman


:int2roman.__demo__
echo Convert number to roman numeral
echo=
call :Input_number number "" "0~4999"
call :int2roman result !number!
echo=
echo The roman numeral value is !result!
goto :EOF


:int2roman   return_var  integer(1-4999)
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
set /a "_remainder=%~2"
for %%r in (
    1000.M 900.CM 500.D 400.CD
     100.C  90.XC  50.L  40.XL
      10.X   9.IX   5.V   4.IV   1.I
) do (
    for /l %%m in (%%~nr,%%~nr,!_remainder!) do set "_result=!_result!%%~xr"
    set /a "_remainder%%=%%~nr"
)
set "_result=!_result:.=!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ roman2int() ================================
$ Function math roman2int


:roman2int.__demo__
echo Convert roman numeral to number
echo=
call :Input_string roman_numeral
call :roman2int result !roman_numeral!
echo=
echo The decimal value is !result!
goto :EOF


:roman2int   return_var  roman_numeral
set "%~1=%~2"
for %%r in (
    IV.4 XL.40 CD.400 IX.9 XC.90 CM.900 I.1 V.5 X.10 L.50 C.100 D.500 M.1000
) do set "%~1=!%~1:%%~nr=+%%~xr!"
set /a "%~1=!%~1:.=!"
exit /b 0

rem ================================ strlen() ================================
$ Function str strlen


:strlen.__demo__
echo Calculate string length
echo=
call :Input_string string
call :strlen length string
echo=
echo The length of the string is !length! characters
goto :EOF


:strlen   return_var  input_var
set "%~1=0"
if defined %~2 (
    for /l %%b in (12,-1,0) do (
        set /a "%~1+=(1<<%%b)"
        for %%i in (!%~1!) do if "!%~2:~%%i,1!" == "" set /a "%~1-=(1<<%%b)"
    )
    set /a "%~1+=1"
)
exit /b 0

rem ======================================= to_upper() ================================
$ Function str to_upper


:to_upper.__demo__
echo Convert string to uppercase
echo=
call :Input_string string
call :to_upper string
echo=
echo Uppercase:
echo=!string!
goto :EOF


:to_upper   variable_name
set "%1= !%1!"
for %%a in (
    A B C D E F G H I J K L M
    N O P Q R S T U V W X Y Z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0

rem ======================================= to_lower() ================================
$ Function str to_lower


:to_lower.__demo__
echo Convert string to lowercase
echo=
call :Input_string string
call :to_lower string
echo=
echo Lowercase:
echo=!string!
goto :EOF


:to_lower   variable_name
set "%1= !%1!"
for %%a in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0

rem ======================================= to_capital() ================================
$ Function str to_capital


:to_capital.__demo__
echo Convert string to capitalcase
echo=
call :Input_string string
call :to_capital string
echo=
echo Capitalcase:
echo=!string!
goto :EOF


:to_capital   variable_name
set "%1= !%1!"
for %%a in (
    A:a B:b C:c D:d E:e F:f G:g H:h I:i J:j K:k L:l M:m
    N:n O:o P:p Q:q R:r S:s T:t U:u V:v W:w X:x Y:y Z:z
) do for /f "tokens=1,2 delims=:" %%b in ("%%a") do (
    set "%1=!%1:%%c=%%c!"
    set "%1=!%1: %%b= %%b!"
)
set "%1=!%1:~1!"
exit /b 0

rem ================================ strip_dquotes() ================================
$ Function str strip_dquotes


:uquote.__demo__
echo Remove surrounding double quotes
echo=
call :Input_string string
call :strip_dquotes string
echo=
echo Stripped : !string!
goto :EOF


:strip_dquotes   variable_name
if "!%~1:~0,1!!%~1:~-1,1!" == ^"^"^"^" set "%~1=!%~1:~1,-1!"
exit /b 0

rem ================================ shuffle() ================================
$ Function str shuffle


:shuffle.__demo__
echo Shuffle characters in a string
echo=
call :Input_string text
call :shuffle text
echo=
echo Shuffled string:
echo=!text!
goto :EOF


[require]
call :strlen


:shuffle   variable_name
if defined %~1 (
    setlocal EnableDelayedExpansion
    set "_result=!%~1!"
    call :strlen _length _result
    for /l %%s in (0,1,!_length!) do (
        set /a "_rand=((!random!<<0x10) + (!random!<<0x1) + (!random!>>0xE)) %% (!_length! - %%s + 1)"
        set /a "_index=!_rand!+%%s"
        for %%r in (!_rand!) do for %%i in (!_index!) do set "_result=!_result:~0,%%s!!_result:~%%i!!_result:~%%s,%%r!"
    )
    for /f "tokens=*" %%a in ("!_result!") do (
        endlocal
        set "%~1=%%a"
    )
)
exit /b 0

rem ================================ strval() ================================
$ Function str strval


:strval.__demo__
echo Determine the integer value of a variable
echo=
call :Input_string string
call :strval result string
echo=
echo Integer value : !result!
goto :EOF


:strval   return_var  variable_name
set /a "%~1=0x80000000"
for /l %%i in (31,-1,0) do (
    set /a "%~1+=0x1<<%%i"
    if !%~2! LSS !%~1! set /a "%~1-=0x1<<%%i"
)
goto :EOF

rem ================================ difftime() =======================================
$ Function time difftime


:difftime.__demo__
echo Calculate difference of start time and end time in centiseconds
echo If start_time is not defined then 00:00:00.00 is taken
echo=
echo Options:
echo -n  Don't fix negative centiseconds
echo=
call :Input_string start_time
call :Input_string end_time
call :difftime time_taken !end_time! !start_time!
echo=
echo Time difference: !time_taken! centiseconds
goto :EOF


:difftime   return_var  end_time  [start_time] [-n]
set "%~1=0"
for %%t in (%~2:00:00:00:00 %~3:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
    set /a "%~1+=24%%a %% 24 *360000 +1%%b*6000 +1%%c*100 +1%%d -610100"
    set /a "%~1*=-1"
)
if /i not "%4" == "-n" if "!%~1:~0,1!" == "-" set /a "%~1+=8640000"
exit /b 0


:difftime.__optimized__   return_var  end_time  [start_time] [-n]
set "%~1=0"
for %%t in (%~2:00:00:00:00 %~3:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
    set /a "%~1+=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"
    set /a "%~1*=0xffffffff"
)
if /i not "%4" == "-n" if "!%~1:~0,1!" == "-" set /a "%~1+=0x83D600"
exit /b 0

rem ================================ ftime() ================================
$ Function time ftime


:ftime.__demo__
echo Convert time (in centiseconds) to HH:MM:SS.CC format
echo=
call :Input_string time_in_centisecond
call :ftime time_taken !time_in_centisecond!
echo=
echo Formatted time : !time_taken!
goto :EOF


:ftime   return_var  time_in_centiseconds
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
set /a "_remainder=(%~2) %% 8640000"
for %%s in (360000 6000 100 1) do (
    set /a "_digits=!_remainder! / %%s + 100"
    set /a "_remainder%%= %%s"
    set "_result=!_result!!_digits:~-2,2!:"
)
set "_result=!_result:~0,-4!.!_result:~-3,2!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================== diffdate() ==================================
$ Function time diffdate


:diffdate.__demo__
echo Calculate difference between 2 dates in days
echo If start_date is not defined then it assumes it is 1/01/1
echo=
call :Input_string start_date
call :Input_string end_date
call :diffdate difference !end_date! !start_date!
echo=
echo Difference : !difference! Days
goto :EOF


:diffdate   return_var  end_date  [start_date]  [days_to_add]
set "%~1="
setlocal EnableDelayedExpansion
set "_difference=0"
set "_args=/%~2/1/1/1  /%~3/1/1/1"
set "_args=!_args:/0=/!"
for %%d in (!_args!) do for /f "tokens=1-3 delims=/" %%a in ("%%d") do (
    set /a "_difference+= (%%c-1)*365  +  (%%c/4 - %%c/100 + %%c/400) + (%%a-1)*30 + %%a/2 + %%b"
    set /a "_leapyear=%%c %% 100"
    if "!_leapyear!" == "0" (
        set /a "_leapyear=%%c %% 400"
    ) else set /a "_leapyear=%%c %% 4"
    if "!_leapyear!" == "0" if %%a LEQ 2 set /a "_difference-=1"
    if %%a GTR 8 set /a "_difference+=%%a %% 2"
    if %%a GTR 2 set /a "_difference-=2"
    set /a "_difference*=-1"
)
set /a "_difference+=%~4 + 0"
for /f "tokens=*" %%r in ("!_difference!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================== what_day() ==================================
$ Function time what_day


:what_day.__demo__
echo Determine what day is a date
echo=
echo= Options:
echo= -n  Returns number value (0: Sunday, 1: Monday)
echo= -s  Returns short date name (first 3 letters)
echo=
echo Note:
echo - Requires: diffdate()
echo=
call :Input_string a_date
call :what_day day !a_date!
echo=
echo That day is !day!
goto :EOF


:what_day   return_var  date  [-n|-s]
set "%~1="
setlocal EnableDelayedExpansion
call :diffdate _day %~2 1 1
set /a _day%%=7
if /i "%3" == "-n" exit /b 0
if "!_day!" == "0" set "_day=Sunday"
if "!_day!" == "1" set "_day=Monday"
if "!_day!" == "2" set "_day=Tuesday"
if "!_day!" == "3" set "_day=Wednesday"
if "!_day!" == "4" set "_day=Thursday"
if "!_day!" == "5" set "_day=Friday"
if "!_day!" == "6" set "_day=Saturday"
if /i "%3" == "-s" set "_day=!_day:~0,3!"
for /f "tokens=*" %%r in ("!_day!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================== timeleft() ==================================
$ Function time timeleft


:timeleft.__demo__
echo Calculate the estimated time remaining for a running process
echo=
echo Note:
echo - Based on: difftime, ftime
echo - Put the function below (not above) where you need it, because it is 
echo   much faster (if performance is an issue)
echo - If performance is still an issue, just integrate it in your script (~4x faster)
echo=
echo Press any key to try it...
pause > nul
echo=
set "total_test=1000"
for %%c in (without called integrated) do (
    echo Simulate Primality Test [1 - !total_test!] %%c timeleft
    set "start_time=!time!"
    call :difftime start_time_cs !start_time!

    for /l %%i in (1,1,!total_test!) do (
        set "_factor=0"
        if %%i GEQ 0 if %%i GEQ 2 (
            set /a "_remainder=%%i %% 2"
            if "!_remainder!" == "1" (
                set "_max=0"
                for %%s in (8000 4000 2000 1000 800 400 200 100 80 40 20 10 8 4 2 1) do (
                    set "_guess=1"
                    set "_limit=0x7FFFFFFF"
                    for /l %%p in (1,1,2) do (
                        set /a "_guess*=!_max! + 0x%%s"
                        set /a "_limit/=!_max! + 0x%%s"
                    )
                    if not "!_limit!" == "0" if !_guess! LEQ %%i set /a "_max+=0x%%s"
                )
                set "_factor="
                for /l %%f in (3,2,!_max!) do if not defined _factor (
                    set /a "_remainder=%%i %% %%f"
                    if "!_remainder!" == "0" set "_factor=%%f"
                )
                if not defined _factor set "_factor=%%i"
            ) else set "_factor=2"
        )
        if "!_factor!" == "%%i" (
            set "display=%%i     "
            < nul set /p "=!display:~0,5!"
        )

        if /i not "%%c" == "without" if not "!time!"  == "!_call_time!" (
            set "_call_time=!time!"

            if /i "%%c" == "called" call :timeleft time_remaining !start_time_cs! %%i !total_test!

            if /i "%%c" == "integrated" (
                setlocal EnableDelayedExpansion
                for /f "tokens=1-4 delims=:. " %%a in ("!time!") do (
                    set /a "_remainder=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34 -!start_time_cs!"
                )
                if "!_remainder:~0,1!" == "-" set /a "_remainder+=0x83D600"
                set /a "_remainder=!_remainder! * (!total_test! - %%i) / %%i"
                set "_result="
                for %%s in (0x57E40 0x1770 0x64 0x1) do (
                    set /a "_digits=!_remainder! / %%s + 0x64"
                    set /a "_remainder%%= %%s"
                    set "_result=!_result!!_digits:~-2,2!:"
                )
                set "_result=!_result:~0,-4!.!_result:~-3,2!"
                for /f "tokens=*" %%r in ("!_result!") do (
                    endlocal
                    set "time_remaining=%%r"
                )
            )

            title Simulate Primality Test - Time remaining : !time_remaining!
        )
    )
    echo=

    call :difftime time_taken !time! !start_time!
    if /i "%%c" == "without" set "base_time=!time_taken!"
    set /a "overhead_time+=!time_taken! - !base_time!"
    call :ftime time_taken !time_taken!
    call :ftime overhead_time !overhead_time!
    echo=
    echo Actual time taken  : !time_taken!
    echo Overhead time      : !overhead_time!
    echo=
    echo=
)
goto :EOF


:timeleft    return_var  start_time_cs  current_progress  total_progress
setlocal EnableDelayedExpansion
for /f "tokens=1-4 delims=:. " %%a in ("!time!") do (
    set /a "_remainder=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34 -%~2"
)
if "!_remainder:~0,1!" == "-" set /a "_remainder+=0x83D600"
set /a "_remainder=!_remainder! * (%~4 - %~3) / %~3"
set "_result="
for %%s in (0x57E40 0x1770 0x64 0x1) do (
    set /a "_digits=!_remainder! / %%s + 0x64"
    set /a "_remainder%%= %%s"
    set "_result=!_result!!_digits:~-2,2!:"
)
set "_result=!_result:~0,-4!.!_result:~-3,2!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ wait() ================================
$ Function time wait


:wait.__demo__
echo Delay for n milliseconds
echo Supports delay up to 21474 milliseconds
echo=
echo Note:
echo - This function have high CPU usage
echo - Using it directly is more preferable than calling the function,
echo   because it has more consistent results
echo - If you still prefer calling the function, do not put the calibration
echo    function below the wait function as it may introduce some innacuracy
rem echo - Alternative for better CPU usage for long delays is sleep()
echo=
call :wait.calibrate 500

echo=
call :Input_number time_in_milliseconds "" "0~10000"
echo=
echo Sleep for !time_in_milliseconds! milliseconds...
set "start_time=!time!"

rem Direct
for %%t in (%=wait=% !time_in_milliseconds!) do for /l %%w in (0,!wait._increment!,%%t00000) do call

rem Called
rem call :wait !time_in_milliseconds!

call :difftime time_taken !time! !start_time!
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
goto :EOF


:wait.calibrate
setlocal EnableDelayedExpansion
echo Calibrating wait()
set "wait._increment=10000"
set "_delay_target=%~1"
set "_time_taken=-1"
for /l %%i in (1,1,12) do if not "!_time_taken!" == "!_delay_target!" (
    if "%~1" == "" set "_delay_target=!wait._increment:~0,3!"
    set "_start_time=!time!"
    for %%t in (%=wait=% !_delay_target!) do for /l %%w in (0,!wait._increment!,%%t00000) do call
    set "_time_taken=0"
    for %%t in (!time!:00:00:00:00 !_start_time!:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
        set /a "_time_taken+=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"
        set /a "_time_taken*=0xffffffff"
    )
    if "!_time_taken:~0,1!" == "-" set /a "_time_taken+=0x83D600"
    set /a "_time_taken*=10"
    echo Calibration #%%i: !wait._increment!, !_delay_target! -^> ~!_time_taken! milliseconds
    set /a "wait._increment=!wait._increment! * !_time_taken! / !_delay_target!"
)
echo Calibration done: !wait._increment!
for /f "tokens=*" %%r in ("!wait._increment!") do (
    endlocal
    set "wait._increment=%%r"
)
exit /b 0


:wait   milliseconds
for %%t in (%=wait=% %~1) do for /l %%w in (0,!wait._increment!,%%t00000) do call
exit /b 0

rem ================================ sleep(WIP) ================================
.$ Function time sleep


:sleep.__demo__
echo Delay for n milliseconds
echo This function have high CPU usage for maximum of 2 seconds on each call
echo Requires wait() for millisecond accuracy
echo=
echo Note:
echo - This function have high CPU usage for maximum of 2 seconds on each call
echo=
echo function unavailable: still under development (WIP)
goto :EOF
call :wait.calibrate 500
echo=
call :Input_number time_in_milliseconds "" "0~2147483647"
echo=
echo Sleep for !time_in_milliseconds! milliseconds...
set "start_time=!time!"
call :sleep !time_in_milliseconds!
call :difftime time_taken !time! !start_time!
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
goto :EOF


[require]
call :wait.calibrate
call :wait


:sleep   milliseconds
setlocal EnableDelayedExpansion
set /a "_sec=%~1 / 1000"
set /a "_sec-=1"
if not "!_sec:~0,1!" == "-" timeout /t !_sec! / nobreak
for %%t in (%=wait=% %~1) do for /l %%w in (0,!wait._increment!,%%t00000) do call

set "%~1=0"
for %%t in (%~2:00:00:00:00 %~3:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
    set /a "%~1+=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"
    set /a "%~1*=0xffffffff"
)
if /i not "%4" == "-n" if "!%~1:~0,1!" == "-" set /a "%~1+=0x83D600"
endlocal
exit /b 0

rem ================================ check_path() ================================
$ Function file check_path


:check_path.__demo__
echo Check if a path satisfies the requirement
echo=
echo Options:
echo -e, --exist         Target must exist
echo -n, --not-exist     Target must not exist
echo -d, --directory     Target must be a folder (if exist)
echo -f, --file          Target must be a file (if exist)
echo=
echo Note:
echo - This function does not expand variables (e.g.: %appdata%)
echo=

call :Input_string config_file "Input an existing file: "
call :check_path --exist --file config_file && (
    echo Your input is valid
) || echo Your input is invalid

call :Input_string folder "Input an existing folder or a new folder name: "
call :check_path --directory folder && (
    echo Your input is valid
) || echo Your input is invalid

call :Input_string new_name "Input an existing folder or a new folder name: "
call :check_path --not-exist new_name && (
    echo Your input is valid
) || echo Your input is invalid
goto :EOF


:check_path   variable_name  [-e|-n]  [-d|-f]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_require_attrib  _require_exist) do set "%%v="
set "_argc=1"
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in ("-e" "--exist") do      if /i "%%a" == "%%~f" set "_set_cmd=_require_exist=true"
    for %%f in ("-n" "--not-exist") do  if /i "%%a" == "%%~f" set "_set_cmd=_require_exist=false"
    for %%f in ("-f" "--file") do       if /i "%%a" == "%%~f" set "_set_cmd=_require_attrib=-"
    for %%f in ("-d" "--directory") do  if /i "%%a" == "%%~f" set "_set_cmd=_require_attrib=d"
    if defined _set_cmd (
        set "!_set_cmd!"
        shift /!_argc!
    ) else set /a "_argc+=1"
)
set /a "_argc-=1"
set "_path=!%~1!"
if "!_path:~0,1!!_path:~-1,1!" == ^"^"^"^" set "_path=!_path:~1,-1!"
if "!_path:~-1,1!" == ":" set "_path=!_path!\"
for /f tokens^=1-2*^ delims^=?^"^<^>^| %%a in ("_?_!_path!_") do if not "%%c" == "" 1>&2 echo Invalid path & exit /b 1
for /f "tokens=1-2* delims=*" %%a in ("_*_!_path!_") do if not "%%c" == "" 1>&2 echo Wildcards are not allowed & exit /b 1
if "!_path:~1,1!" == ":" (
    if not "!_path::=!" == "!_path:~0,1!!_path:~2!" 1>&2 echo Invalid path & exit /b 1
) else if not "!_path::=!" == "!_path!" 1>&2 echo Invalid path & exit /b 1
set "file_exist=false"
for %%f in ("!_path!") do (
    set "_path=%%~ff"
    set "_attrib=%%~af"
)
if defined _attrib (
    set "_attrib=!_attrib:~0,1!"
    set "file_exist=true"
)
if defined _require_exist if not "!file_exist!" == "!_require_exist!" (
    if "!_require_exist!" == "true" 1>&2 echo Input does not exist
    if "!_require_exist!" == "false" 1>&2 echo Input already exist
    exit /b 1
)
if "!file_exist!" == "true" if defined _require_attrib if not "!_attrib!" == "!_require_attrib!" (
    if defined _require_exist (
        if "!_require_attrib!" == "d" 1>&2 echo Input is not a folder
        if "!_require_attrib!" == "-" 1>&2 echo Input is not a file
    ) else (
        if "!_require_attrib!" == "d" 1>&2 echo Input must be a new or existing folder, not a file
        if "!_require_attrib!" == "-" 1>&2 echo Input must be a new or existing file, not a folder
    )
    exit /b 1
)
for /f "tokens=*" %%c in ("!_path!") do (
    endlocal
    set "%~1=%%c"
)
exit /b 0

rem Path invalid characters:
rem <>|?*":\/

rem if : is the 2nd character, it will add backslash after it if 3rd is not
rem if path starts with 'C:' and not followed by '\' it will replace 'C:' with the script's initial cwd
rem If ? is in the string then it will not be processed
rem :"<>| are treated as normal characters
rem * is treated as wildcard

rem ================================ wcdir() ================================
$ Function file wcdir


:wcdir.__demo__
echo List files/folders with wildcard path
echo=
echo Note:
echo Options:
echo -f  Search for file only
echo -d  Search for directory only

echo - Requires: capchar()
call :Input_string wildcard_path
call :strip_dquotes wildcard_path
call :wcdir result "!wildcard_path!"
echo=
echo Found List:
echo=!result!
echo=
goto :EOF


[require]
call :capchar LF


:wcdir   return_var  file_path  [-f|-d]
set "%~1="
setlocal EnableDelayedExpansion
set "_list_dir=true"
set "_list_file=true"
if "%~3" == "-d" set "_list_file="
if "%~3" == "-f" set "_list_dir="
set "_args=%~2"
set "_args=!_args:/=\!"
set "_result="
pushd "!temp!"
call :wcdir.find "!_args!"
for /f "tokens=*" %%r in ("!_result!") do (
    if not defined %~1 endlocal
    set "%~1=!%~1!%%r!LF!"
)
exit /b 0
:wcdir.find
for /f "tokens=1* delims=\" %%a in ("%~1") do if "%%a" == "*:" (
    for %%l in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do pushd "%%l:\" 2> nul && call :wcdir.find %%b
) else if "%%b" == "" (
    if defined _list_file for /f "delims=" %%f in ('dir /b /a:-d "%%a" 2^> nul') do set "_result=!_result!%%~ff!LF!"
    if defined _list_dir for /f "delims=" %%f in ('dir /b /a:d "%%a" 2^> nul') do set "_result=!_result!%%~ff!LF!"
) else for /d %%f in ("%%a") do pushd "%%~f\" 2> nul && call :wcdir.find "%%b"
popd
exit /b

rem ================================ expand_path() ================================
$ Function file expand_path


:expand_path.__demo__
echo Expands given path to:
echo [D]rive letter, [A]ttributes, [T]ime stamp, si[Z]e,
echo [N]ame, e[X]tension, [P]ath, [F]ull path
echo=
call :Input_string path_string
call :expand_path path_string "!path_string!"
set path_string
goto :EOF


:expand_path   prefix  path
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
exit /b 0


:expand_multipath   prefix  file_path1  [file_path2 [...]]
for %%a in (D P N X F DP NX) do set "%~1%%a="
:expand_multipath.loop
set ^"%~1D=!%~1D! "%%~d2"^"
set ^"%~1P=!%~1P! "%%~p2"^"
set ^"%~1N=!%~1N! "%%~n2"^"
set ^"%~1X=!%~1X! "%%~x2"^"
set ^"%~1F=!%~1F! "%%~f2"^"
set ^"%~1DP=!%~1DP! "%%~dp2"^"
set ^"%~1NX=!%~1NX! "%%~nx2"^"
if not "%~3" == "" (
    shift /2
    goto expand_multipath.loop
)
exit /b 0

rem ================================ unzip() ================================
$ Function file unzip


:unzip.__demo__
echo Unzip files (VBScript hybrid)
echo=
call :Input_string zip_file
echo=
call :unzip "!zip_file!" "."
echo=
echo Done
goto :EOF


:unzip   zip_file  destination_folder
if not exist "%~1" 1>&2 echo error: zip file does not exist & exit /b 1
if not exist "%~2" md "%~2" || 1>&2 echo error: create folder failed & exit /b 2
for %%s in ("!temp!\unzip.vbs") do (
    (
        echo zip_file = WScript.Arguments(0^)
        echo dest_path = WScript.Arguments(1^)
        echo=
        echo MsgBox(zip_file^)
        echo MsgBox(dest_path^)
        echo set ShellApp = CreateObject("Shell.Application"^)
        echo set content = ShellApp.NameSpace(zip_file^).items
        echo ShellApp.NameSpace(dest_path^).CopyHere(content^)
    ) > "%%~s"
    cscript //nologo "%%~s" "%~f1" "%~f2"
    del /f /q "%%~s"
)
exit /b 0

rem ================================ checksum() ================================
$ Function file checksum


:checksum.__demo__
echo Calculate checksum of file
echo=
echo Available checksums:
echo MD2 MD4 MD5   SHA1 SHA256 SHA512
echo=
echo SHA1 will be used if function called
echo without specifying checksum type
echo=
echo Press any key to try it...
pause > nul
echo=
call :Input_path file_path
call :Input_string checksum_type
if defined checksum_type set "checksum_type=--!checksum_type!"
call :checksum checksum !checksum_type! "!file_path!"
echo=
echo Checksum: !checksum!
goto :EOF


:checksum   return_var  file_path
set "%~1="
setlocal EnableDelayedExpansion EnableExtensions
set "_algorithm="
set "_argc=1"
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in (
        MD2 MD4 MD5
        SHA1 SHA256 SHA512
    ) do if /i "--%%a" == "%%f" set "_set_cmd=_algorithm=%%f"
    if defined _set_cmd (
        set "!_set_cmd!"
        shift /!_argc!
    ) else set /a "_argc+=1"
)
set /a "_argc-=1"
if not defined _algorithm set "_algorithm=sha1"
set "_result="
for /f "usebackq skip=1 tokens=*" %%a in (`certutil -hashfile "%~f2" !_algorithm!`) do (
    if not defined _result set "_result=%%a"
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ diffbin() ================================
$ Function file diffbin


:diffbin.__demo__
echo Find difference between two files and returns the offset bytes
echo of the first difference
echo=
echo Note:
echo - Still a beta version, so far it works as expected, 
echo   but it still needs more testing
echo=
echo Press any key to try it...
pause > nul
echo=
call :Input_path --exist --file file1
call :Input_path --exist --file file2
echo=
call :diffbin offset "!file1!" "!file2!"
echo=
if "!offset:~0,1!" == "-" (
    if "!offset!" == "-" echo Both files are the same
    if "!offset!" == "-1" echo No content difference, but file 1 is longer
    if "!offset!" == "-2" echo No content difference, but file 2 is longer
) else set /a "!offset!" 2> nul && (
        echo First difference at offset !offset! bytes
) || echo unknown result: !offset!
goto :EOF


:diffbin   return_var_offset  file1  file2
set "%~1="
setlocal EnableDelayedExpansion
if not defined temp_path set "temp_path=!temp!"
if not exist "!temp_path!" md "!temp_path!"
set "_filename=diff.txt"
set "_result="
for %%f in ("!temp_path!\!_filename!") do (
    fc /b "%~2" "%~3" > "%%~ff"
    for /f "usebackq skip=1 tokens=1* delims=:" %%a in ("%%~ff") do (
        if defined _result goto diffbin.done
        set "_result=%%a: %%b"
        if /i "%%a" == "FC" (
            if /i "%%b" == " %~f2 longer than %~f3" set "_result=-1"
            if /i "%%b" == " %~f3 longer than %~f2" set "_result=-2"
            if /i "%%b" == " no differences encountered" set "_result=-"
        ) else set /a "_result=0x%%a"
    )
)
:diffbin.done
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ expand_link() ================================
$ Function net expand_link


:expand_link.__demo__
echo Expands a given URL to several smaller piece
echo=
echo [U] URL        https://news.example.com:80/1970/01/index.html?view=full#part2
echo [S] Scheme     https
echo                     ://
echo [H] Hostname           news.example.com
echo                                        :
echo [P] Port                                80
echo [D] Path                                  /1970/01/
echo [N] Filename                                       index
echo [X] Extension                                           .html
echo                                                              ?
echo [Q] Query                                                     view=full
echo                                                                        #
echo [F] Fragment                                                            part2
echo=
call :Input_string web_url || set "web_url=https://news.example.com:80/1970/01/index.html?view=full#part2"
call :expand_link web_url "!web_url!"
set web_url
goto :EOF


:expand_link   prefix  link
pushd "%~d0\"
for %%v in (S H P P Q F) do set "%~1%%v="
for /f "tokens=1* delims=#" %%a in ("%~2") do (
    set "%~1F=%%b"
    for /f "tokens=1* delims=?" %%c in ("%%a") do (
        set "%~1Q=%%d"
        set "%~1H=%%c"
        for /f "tokens=1* delims=:\/" %%e in ("%%c") do (
            if "%%e://%%f" == "%%c" (
                set "%~1S=%%e"
                set "%~1H=%%f"
            )
        )
        for /f "tokens=1* delims=\/" %%e in ("!%~1H!") do (
            set "%~1D= %%~pf"
            set "%~1D=!%~1D:\=/!"
            set "%~1D=!%~1D:~1!"
            set "%~1N=%%~nf"
            set "%~1X=%%~xf"
            for /f "tokens=1* delims=:" %%g in ("%%e") do (
                set "%~1H=%%g"
                set "%~1P=%%h"
            )
        )
    )
)
popd
set "%~1U="
if defined %~1S set "%~1U=!%~1U!!%~1S!://"
set "%~1U=!%~1U!!%~1H!"
if defined %~1P set "%~1U=!%~1U!:!%~1P!"
set "%~1U=!%~1U!!%~1D!!%~1N!!%~1X!"
if defined %~1Q set "%~1U=!%~1U!?!%~1Q!"
if defined %~1F set "%~1U=!%~1U!#!%~1F!"
exit /b 0

rem ================================ get_ext_ip() ================================
$ Function net get_ext_ip


:get_ext_ip.__demo__
echo Get external IP address (PowerShell hybrid)
echo=
call :get_ext_ip ext_ip
echo=
echo External IP    : !return!
goto :EOF


:get_ext_ip   return_var
> nul 2> nul (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('http://ipecho.net/plain', '!temp!\ip.txt')"
) || exit /b 1
for /f "usebackq tokens=*" %%o in ("!temp!\ip.txt") do set "%~1=%%o"
del /f /q "!temp!\ip.txt"
exit /b 0

rem ================================ download() ================================
$ Function net download


:download.__demo__
echo Download file from the internet (VBScript hybrid)
echo=
echo Note:
echo - Function can determine download name automatically
echo - Function returns the download file path in a variable
echo=
echo For this demo, file will be saved to "!cd!"
echo Enter nothing to download laravel v4.2.11 (41 KB)
echo=
call :Input_string download_link || set "download_link=https://codeload.github.com/laravel/laravel/zip/v4.2.11"
echo=
echo Download link:
echo=!download_link!
echo=
echo Downloading file...
call :download file_path "!download_link!" "." || echo Download failed
echo=
echo Downloaded to "!file_path!"
goto :EOF


echo Optional:
echo set "temp_path=path to write vbs script for download"


:download   return_var_file_path  link  destination_folder
set "%~1="
setlocal EnableDelayedExpansion
if not defined temp_path set "temp_path=!temp!"
if not exist "!temp_path!" md "!temp_path!"
for /f "tokens=1* delims=?#" %%a in ("%~2") do (
    set "_filename=%%~nxa"
    if not defined _filename set "_filename=download"
)
set "_script=!temp_path!\download_!random!.vbs"
(
    echo url = WScript.Arguments(0^)
    echo dest_path = WScript.Arguments(1^)
    echo filename = WScript.Arguments(2^)
    echo=
    echo set xmlHttp = createobject("MSXML2.ServerXMLHTTP.6.0"^)
    echo On Error Resume Next
    echo xmlHttp.Open "GET", url, False
    echo if err.number ^<^> 0 then Wscript.Quit 1
    echo xmlHttp.Send
    echo if err.number ^<^> 0 then Wscript.Quit 1
    echo on error goto 0
    echo if xmlHttp.Status ^<^> 200 then WScript.Quit 1
    echo=
    echo set filename_regex = New RegExp
    echo filename_regex.Pattern = "filename=""?([^"";]+)""?;?"
    echo filename_regex.IgnoreCase = True
    echo cdHeader = xmlHttp.getResponseHeader("Content-Disposition"^)
    echo for each match in filename_regex.Execute(cdHeader^)
    echo     filename = match.SubMatches(0^)
    echo next
    echo set FSO = CreateObject("Scripting.FileSystemObject"^)
    echo save_path = FSO.BuildPath(dest_path, filename^)
    echo if FSO.FileExists(save_path^) then FSO.DeleteFile save_path
    echo Wscript.StdOut.Write save_path
    echo=
    echo set stream = createobject("Adodb.Stream"^)
    echo stream.Type = 1
    echo stream.Open
    echo stream.Write xmlHttp.ResponseBody
    echo stream.SaveToFile save_path, 2
) > "!_script!"
set "_result="
for /f "usebackq tokens=*" %%o in (`cscript //nologo "!_script!" "%~2" "%~f3" "!_filename!"`) do set "_result=%%~fo"
del /f /q "!_script!"
if not defined _result exit /b 1
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem PowerShell command, but filename have to be set and PowerShell is so sloooowww
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://codeload.github.com/laravel/laravel/zip/v4.2.11', 'l.zip')"

rem ================================ get_con_size() ================================
$ Function env get_con_size


:get_con_size.__demo__
echo Get console screen buffer size
call :get_con_size console_width console_height
echo=
echo Screen buffer size    : !console_width!x!console_height!
goto :EOF


:get_con_size   return_var_width  return_var_height
setlocal EnableDelayedExpansion
set "_index=0"
for /f "usebackq tokens=2 delims=:" %%a in (`mode con`) do (
    set /a "_index+=1"
    if "!_index!" == "1" set /a "_height=%%a"
    if "!_index!" == "2" set /a "_width=%%a"
)
set "_index="
for /f "tokens=1-2 delims=x" %%a in ("!_width!x!_height!") do (
    endlocal
    set "%~1=%%a"
    set "%~2=%%b"
)
exit /b 0

rem ================================ get_sid() ================================
$ Function env get_sid


:get_sid.__demo__
echo Get currect user's SID
echo=
call :get_sid result
echo=
echo User SID : !result!
goto :EOF


:get_sid   return_var
set "%~1="
for /f "tokens=2" %%s in ('whoami /user /fo table /nh') do set "%~1=%%s"
exit /b 0

rem ================================ get_os() ================================
$ Function env get_os


:get_os.__demo__
echo Get OS version
echo=
echo Options:
echo -n  Returns OS name
echo=
call :get_os result -n
echo Your OS is !result!
goto :EOF


:get_os   return_var  [-n]
for /f "tokens=4-5 delims=. " %%i in ('ver') do set "%~1=%%i.%%j"
if /i "%~2" == "-n" (
    if "!%~1!" == "10.0" set "%~1=Windows 10"
    if "!%~1!" == "6.3" set "%~1=Windows 8.1"
    if "!%~1!" == "6.2" set "%~1=Windows 8"
    if "!%~1!" == "6.1" set "%~1=Windows 7"
    if "!%~1!" == "6.0" set "%~1=Windows Vista"
    if "!%~1!" == "5.2" set "%~1=Windows XP 64-Bit"
    if "!%~1!" == "5.1" set "%~1=Windows XP"
    if "!%~1!" == "5.0" set "%~1=Windows 2000"
)
exit /b 0

rem ================================ get_pid() ================================
$ Function env get_pid


:get_pid.__demo__
echo Get current script process ID (PowerShell Hybrid)
echo=
echo Note:
echo - PowerShell is only used to generate unique id for current batch script
echo - A pure batch script version is also included below, but not as bulletproof
echo - Use powershell version if you have multiple batch script that starts at
echo   the same time and also calls get_pid() at the same time.
echo=
call :get_pid result
echo PID: !result!
goto :EOF


:get_pid
for /f %%g in ('powershell -command "$([guid]::NewGuid().ToString())"') do (
    for /f "usebackq tokens=*" %%a in (
        `wmic process where "name='cmd.exe' and CommandLine like '%% get_pid %%g %%'" get ParentProcessID`
    ) do for %%b in (%%a) do set "%~1=%%b"
)
exit /b 0


rem Pure batch script version
::get_pid
for /f "usebackq tokens=*" %%a in (
    `wmic process where "name='cmd.exe' and CommandLine like '%% get_pid %random% %%'" get ParentProcessID`
) do for %%b in (%%a) do set "%~1=%%b"
exit /b 0

rem ================================ watchvar() ================================
$ Function env watchvar


:watchvar.__demo__
echo Watch for new, deleted and changed variables in batch script
echo=
echo Options:
echo -i, --initialize   Initialize variable list
echo -l, --list         Display variable names
echo=
echo Optional:
echo set "temp_path=path to write variable changes"
echo=
echo Note:
echo - watchvar can only compare the first 3840 characters for very long variables
echo=
call :watchvar -i
for /l %%n in (1,1,5) do (
    for /l %%n in (1,1,10) do (
        set /a "_operation=!random! %% 2"
        set /a "_num=!random! %% 10"
        if "!_operation!" == "0" (
            set "var!_num!="
        ) else set "var!_num!=!random!"
    )
    set "_operation="
    set "_num="
    echo=
    call :watchvar -n
    pause > nul
)
goto :EOF


:watchvar   [-i]  [-n]
setlocal EnableDelayedExpansion EnableExtensions
if not defined temp_path set "temp_path=!temp!"
set "temp_path=!temp_path!\watchvar"
if not exist "!temp_path!" md "!temp_path!"
cd /d "!temp_path!"
set "_filename=watchvar"
for %%x in (txt hex) do (
    if exist "!_filename!_old.%%x" del /f /q "!_filename!_old.%%x"
    if exist "!_filename!_latest.%%x" ren "!_filename!_latest.%%x" "!_filename!_old.%%x"
)
for %%f in (!temp_path!\!_filename!) do (
    endlocal
    set > "%%~ff_latest.txt"
    setlocal EnableDelayedExpansion EnableExtensions
    cd /d "%%~dpf"
    set "_filename=%%~nf"
)
for %%v in (_init_only  _list_names) do set "%%v="
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in ("-i" "--initialize") do if /i "%%a" == "%%~f" set "_set_cmd=_init_only=true"
    for %%f in ("-l" "--list") do       if /i "%%a" == "%%~f" set "_set_cmd=_list_names=true"
    if defined _set_cmd (
        set "!_set_cmd!"
    ) else 1>&2 echo error: unknown argument %%a & exit /b 1
)

rem Convert to hex and format
if exist "!_filename!_latest.tmp" del /f /q "!_filename!_latest.tmp"
certutil -encodehex "!_filename!_latest.txt" "!_filename!_latest.tmp" > nul
> "!_filename!_latest.hex" (
    set "_hex="
    for /f "usebackq delims=" %%o in ("!_filename!_latest.tmp") do (
        set "_input=%%o"
        set "_hex=!_hex! !_input:~5,48!"
        if not "!_hex:~7680!" == "" call :watchvar.format_hex
    )
    call :watchvar.format_hex
    echo=!_hex!
    set "_hex="
)

rem Count variable
set "_var_count=0"
for /f "usebackq tokens=*" %%o in ("!_filename!_latest.hex") do set /a "_var_count+=1"

if defined _init_only (
    echo Initial variables: !_var_count!
    exit /b 0
)

set "_new_sym=+"
set "_deleted_sym=-"
set "_changed_sym=~"
set "_new_hex_=6E6577"
set "_deleted_hex=64656C65746564"
set "_changed_hex=6368616E676564"
set "_states=new deleted changed"

rem Compare variables
for %%s in (!_states!) do set "_%%s_count=0"
call 2> "!_filename!_changes.hex"
for /f "usebackq tokens=1-3 delims= " %%a in ("!_filename!_latest.hex") do (
    set "_old_value="
    for /f "usebackq tokens=1-3 delims= " %%x in ("!_filename!_old.hex") do if "%%a" == "%%x" set "_old_value=%%z"
    if defined _old_value (
        if not "%%c" == "!_old_value!" (
            set /a "_changed_count+=1"
            echo !_changed_hex!20 %%a 0D0A
        )
    ) else (
        echo !_new_hex_!20 %%a 0D0A
        set /a "_new_count+=1"
    )
) >> "!_filename!_changes.hex"
for /f "usebackq tokens=1 delims= " %%a in ("!_filename!_old.hex") do (
    set "_value_found="
    for /f "usebackq tokens=1 delims= " %%x in ("!_filename!_latest.hex") do if "%%a" == "%%x" set "_value_found=true"
    if not defined _value_found (
        echo !_deleted_hex!20 %%a 0D0A
        set /a "_deleted_count+=1"
    )
) >> "!_filename!_changes.hex"
if exist "!_filename!_changes.txt" del /f /q "!_filename!_changes.txt"
certutil -decodehex "!_filename!_changes.hex" "!_filename!_changes.txt" > nul

if defined _list_names (
    echo Variables: !_var_count!
    for %%s in (!_states!) do if not "!_%%s_count!" == "0" (
         < nul set /p "=[!_%%s_sym!!_%%s_count!] "
        for /f "usebackq tokens=1* delims= " %%a in ("!_filename!_changes.txt") do (
            if "%%a" == "%%s" < nul set /p "=%%b "
        )
        echo=
    )
) else echo Variables: !_var_count! [+!_new_count!/~!_changed_count!/-!_deleted_count!]
exit /b 0
:watchvar.format_hex
set "_hex= !_hex! $"
set "_hex=!_hex:  = !"
set "_hex=!_hex:0D 0A=EOL!"
set "_hex=!_hex: 3D =#_!"
set "_hex=!_hex: =!"
set _hex=!_hex:EOL= 0D0A^
%=REQURED=%
!
for /f "tokens=1* delims=#" %%a in ("!_hex!") do (
    if "%%b" == "" (
        set "_hex=%%a"
    ) else (
        set "_hex=%%a 3D %%b"
        set "_hex=!_hex:#=3d!"
        set "_hex=!_hex:_=!"
    )
    if /i "!_hex:~-4,4!" == "0D0A" echo !_hex!
)
if /i "!_hex:~-4,4!" == "0D0A" set "_hex=$"
if not "!_hex:~7680!" == "" (
    < nul set /p "=!_hex:~0,-3!"
    set "_hex=!_hex:~-3,3!"
)
set "_hex=!_hex:~0,-1!"
exit /b

rem ================================ check_admin() ================================
$ Function env check_admin


:check_admin.__demo__
echo Check for administrator privilege
echo=
echo Note:
echo - Function will set errorlevel to 0 if administrator privilege is detected
echo - Function will set errorlevel to 1 if no administrator privilege is detected
echo=
call :check_admin && (
    echo Administrator privilege detected
) || echo No administrator privilege detected
goto :EOF


:check_admin
(net session || openfiles) > nul 2> nul || exit /b 1
exit /b 0

rem ================================ check_eol() ================================
$ Function env check_eol


:check_eol.__demo__
echo Check EOL type of current script
echo=
echo Options:
echo -C, --check-exist      Returns 0 if function exist / is callable
echo=
echo Note:
echo - In rare cases, the script cannot find the function, but it fixed by 
echo   moving the function few lines away from where you initially put it.
echo - Can be used to detect if script was downloaded 
echo   from GitHub, since uses linux EOL (LF)
echo=
call :check_eol && (
    echo EOL is windows
) || echo EOL is Linux
goto :EOF


rem Fix EOL (LF to CRLF)
@call :check_eol --check-exist && @(
    call :check_eol || @(
        echo Converting EOL...
        type "%~f0" | more /t4 > "%~f0.tmp" && (
            move "%~f0.tmp" "%~f0" > nul && goto __module__.__main__.reload
        )
        echo warn: Convert EOL failed
    )
) || @echo warn: Cannot check EOL
rem Done


:check_eol
for %%f in ("-c" "--check-exist") do if /i "%1" == "%%~f" exit /b 0
@call :check_eol.test 2> nul && exit /b 0 || exit /b 1
rem  1  DO NOT REMOVE THIS COMMENT SECTION, IT IS IMPORTANT FOR THIS FUNCTION TO WORK CORRECTLY                               #
rem  2  DO NOT MODIFY THIS COMMENT SECTION IF YOU DON'T KNOW WHAT YOU ARE DOING, THIS IS DESIGNED CAREFULLY                   #
rem  3                                                                                                                        #
rem  4  Length of this comment section should be at most 4095 characters if EOL is LF only (Unix)                             #
rem  5  Comment could contain anything, but it is best to set it to empty space                                               #
rem  6  so your code editor won't slow down when scrolling through this section                                               #
rem  7                                                                                                                        #
rem  8                                                                                                                        #
rem  9                                                                                                                        #
rem 10                                                                                                                        #
rem 11                                                                                                                        #
rem 12                                                                                                                        #
rem 13                                                                                                                        #
rem 14                                                                                                                        #
rem 15                                                                                                                        #
rem 16                                                                                                                        #
rem 17                                                                                                                        #
rem 18                                                                                                                        #
rem 19                                                                                                                        #
rem 20                                                                                                                        #
rem 21                                                                                                                        #
rem 22                                                                                                                        #
rem 23                                                                                                                        #
rem 24                                                                                                                        #
rem 25                                                                                                                        #
rem 26                                                                                                                        #
rem 27                                                                                                                        #
rem 28                                                                                                                        #
rem 29                                                                                                                        #
rem 30                                                                                                                        #
rem 31                                                                                                                        #
rem 32  LAST LINE, should be 1 character shorter than the rest                                              DO NOT MODIFY -> #
:check_eol.test
@exit /b 0

rem ================================ capchar() ================================
$ Function io capchar


:capchar.__demo__
echo Capture control characters
echo=
echo var    Hex     Name
echo ------------------------------
echo CR     0D      Carriage Return
echo LF     0A      Line Feed
echo BS     07      Backspace
echo ESC    1B      Escape
echo=
echo var    Description
echo ------------------------------
echo NL     Set new line in variables
echo DEL    Delete previous character (in console)
echo _      Allows SET /P to start with whitespace character
echo DQ     Allows ECHO to print special characters without caret (^^)
echo=
echo =========================================================
call :capchar *
echo Hello^^!LF^^!World^^!CR^^!.
echo Clean^^!BS^^!r
echo %%DQ%%^|No^&Escape^|^^^<Characters^>^^
echo ^^!ESC^^![44m Windows 10 ^^!ESC^^![0m
< nul set /p "=^!_^!   Whitespace first"
echo=
echo =========================================================
echo Hello!LF!World!CR!.
echo Clean!BS!r
echo %DQ%|No&Escape|^<Characters>^
echo !ESC![44m Windows 10 !ESC![0m
< nul set /p "=!_!   Whitespace first"
echo=
goto :EOF


:capchar   character1  [character2 [...]]
rem Capture everything
if "%~1" == "*" call :capchar BS ESC CR LF NL DEL _ DQ
rem Capture backspace character
if /i "%~1" == "BS" for /f %%a in ('"prompt $h & for %%b in (1) do rem"') do set "BS=%%a"
rem Capture escape character
if /i "%~1" == "ESC" for /f %%a in ('"prompt $E & for %%b in (1) do rem"') do set "ESC=%%a"
rem Capture Carriage Return character
if /i "%~1" == "CR" for /f %%a in ('copy /z "%ComSpec%" nul') do set "CR=%%a"
rem Capture Line Feed character (2 empty lines requred)
if /i "%~1" == "LF" set LF=^
%=REQURED=%
%=REQURED=%
rem Create macro for new line
if /i "%~1" == "NL" call :capchar "LF" & set "NL=^^!LF!!LF!^^"
rem Create macro for erasing character from display
if /i "%~1" == "DEL" call :capchar "BS" & set "DEL=!BS! !BS!"
rem Create base for set /p "=" because it cannot start with a white space character
if /i "%~1" == "_" call :capchar "BS" & set "_=_!BS! !BS!"
rem Create macro for displaying invisible double quote, must be used as %DQ%, not !DQ!
if /i "%~1" == "DQ" call :capchar "BS" & set DQ="!BS! !BS!
rem Shift parameter
shift /1
if not "%1" == "" goto capchar
exit /b 0


rem New Line (DisableDelayedExpansion)
set ^"NL=^^^%LF%%LF%^%LF%%LF%^"

rem Other characters
set DQ="
set "EM=^!"
set EM=^^!

rem ================================ hex2char() ================================
.$ Function io hex2char


:hex2char.__demo__
echo Generate characters from hex code
echo=
echo Used to generate extended characters
echo=
call :hex2char
goto :EOF


:hex2char   return_var1:char_hex1  [return_var2:char_hex2 [...]]
setlocal EnableDelayedExpansion
if not defined temp_path set "temp_path=!temp!"
if not exist "!temp_path!" md "!temp_path!"
certutil
for /f "tokens=*" %%f in ("!_result!") do (
    endlocal
    calL "%%r"
)
exit /b 0


rem ================================ color2seq() ================================
$ Function io color2seq


:color2seq.__demo__
echo Convert hexadecimal color to ANSI escape sequence
echo Used for color print in windows 10
echo=
call :Input_string hexadecimal_color
call :color2seq color_code "!hexadecimal_color!"
echo=
echo Sequence: !color_code!
echo Color print: !ESC!!color_code!Hello World!ESC![0m
goto :EOF


:color2seq   return_var  <background><foreground>
set "%~1=%~2"
set "%~1=[!%~1:~0,1!;!%~1:~1,1!m"
for %%t in (
    0.40.30  1.44.34  2.42.32  3.46.36 
    4.41.31  5.45.35  6.43.33  7.47.37
    8.100.90  9.104.94  A.102.92  B.106.96
    C.101.91  D.105.95  E.103.93  F.107.97
) do for /f "tokens=1-3 delims=." %%a in ("%%t") do (
    set "%~1=!%~1:[%%a;=[%%b;!"
    set "%~1=!%~1:;%%am=;%%cm!"
)
exit /b 0

rem ================================ setup_clearline() ================================
$ Function io setup_clearline


:setup_clearline.__demo__
echo Create a variable to clear current line
echo=
echo Note:
echo - Text should not reach the end of the line
echo - Requires: capchar(CR, DEL)
echo - Based on: get_con_size(), get_os()
echo=
call :setup_clearline
echo=
echo First test: end of the line not reached
< nul set /p "=Press any key to clear this line"
for /l %%n in (34,1,!console_width!) do < nul set /p "=."
pause > nul
< nul set /p "=!CL!Line cleared"
echo=
echo=
echo Second test: end of the line reached
< nul set /p "=Press any key to clear this line"
for /l %%n in (33,1,!console_width!) do < nul set /p "=."
pause > nul
< nul set /p "=!CL!Clear line failed"
goto :EOF


:setup_clearline
setlocal EnableDelayedExpansion
set "_index=0"
for /f "usebackq tokens=2 delims=:" %%a in (`mode con`) do (
    set /a "_index+=1"
    if "!_index!" == "2" set /a "_width=%%a"
)
for /f "tokens=4 delims=. " %%v in ('ver') do (
    endlocal
    set "CL="
    if %%v GEQ 10 (
        for /l %%n in (1,1,%_width%) do set "CL=!CL! "
        set "CL=_!CR!!CL!!CR!"
    ) else for /l %%n in (1,1,%_width%) do set "CL=!CL!!DEL!"
)
exit /b 0

rem ================================ color_print() ================================
$ Function io color_print


:color_print.__demo__
echo Print text with color (in hexadecimal format)
echo See COLOR /? for more info 
echo=
echo    0 = Black       8 = Gray
echo    1 = Blue        9 = Light Blue
echo    2 = Green       A = Light Green
echo    3 = Aqua        B = Light Aqua
echo    4 = Red         C = Light Red
echo    5 = Purple      D = Light Purple
echo    6 = Yellow      E = Light Yellow
echo    7 = White       F = Bright White
echo=
echo Note:
echo - Function does not support printing special characters: "<>|?*:\/
echo - Requires: capchar(BS)
echo=
call :Input_string text
call :Input_string foreground_color
call :Input_string background_color
echo=
call :color_print "!background_color!!foreground_color!" "!text!" && (
    echo !LF!Print Success
) || echo !LF!Print Failed. Characters not supported, or external error occured
goto :EOF


:color_print   color  text
(
    pushd "!temp_path!" || exit /b 1
     < nul set /p "=!DEL!!DEL!" > "%~2_"
    findstr /l /v /a:%~1 "." "%~2_" nul
    del /f /q "%~2_" > nul
    popd
) 2> nul
exit /b 0

rem ================================ parse_args(!) ================================
$ Function fw parse_args


:parse_args.__demo__
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
call :Input_string parameter
echo=
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
set "param_attributes="
set "param_filename="
echo ===== Parse result =====
call :parse_args !parameter! > nul || exit /b 1
set "param_"
goto :EOF


:parse_args.Debug.setup
rem    ^ /:/: case_sensitive!LF!^
set _parse_args=!LF!^
    ^ A:attrib.s    :param_attributes!LF!^
    ^ B:bttrib.s    :param_bttributes!LF!^
    ^ E:subdir.m    :param_include_subdir!LF!^
    ^ H:hidden.f    :param_include_hidden!LF!^
    ^ P:prompt.f    :param_prompt_user!LF!^
    ^ -:overwrite.f :param_prompt_overwrite!LF!^
    ^ -:-.m         :param_sources!LF!^
    ^ -:-.s         :param_destination
set debug_param=-a aaa -b "biass" --subdir:s1asd + s2qwe /hidden "1asd" + 2qwe "3zxc" --overwrite
goto :EOF


:parse_args.Debug.single_after
set "param_"
goto :EOF

:parse_args   %*  [_parse_args]
if not defined LF 1>&2 echo fatal: line feed character is missing & exit /b -1
for %%v in (_parse_cs _option_args _required_vars _first_error _current_arg _to_fill) do set "%%v="
for /f "tokens=1,2* delims=: " %%a in ("!_parse_args!") do (
    if /i "%%~c" == "" 1>&2 echo fatal: argument %%a has no storage variable & exit /b -1
    if /i "%%a%%b" == "//" for %%p in (%%c) do (
        if "%%p" == "case_sensitive" set "_parse_cs=true"
    ) else (
        if /i "%%~xb" == "" 1>&2 echo fatal: argument %%c has no type & exit /b -1

        if "%%a:%%~nb" == "-:-" (
            set "_required_vars=!_required_vars! %%c%%~xb"
        ) else set "_option_args=!_option_args!%%a:%%b:%%c!LF!"
        if /i "%%~xb" == ".f" set "%%c=false"
    )
)
:parse_args.next
set "_prev_arg=!_current_arg!"
set "_current_arg=%1"
shift
if not defined _current_arg goto parse_args.cleanup
set "_value=!_current_arg!"
set "_is_option="
for %%s in ("/" "-") do if "!_current_arg:~0,1!" == "%%~s" set "_is_option=true"
if defined _is_option (
    if defined _to_fill for %%a in ("!_to_fill!") do if not "%%~xa" == ".m" (
        if not defined _first_error set "_first_error=invalid parameter: !_prev_arg!"
    )
    set "_to_fill="
    for /f "tokens=1* delims=:" %%s in ("!_current_arg!") do (
        for /f "tokens=1,2* delims=: " %%a in ("!_option_args!") do if not defined _to_fill (
            set "_possible_syntax=/%%a -%%a"
            if not "%%~nb" == "" set "_possible_syntax=!_possible_syntax! /%%~nb --%%~nb"

            for %%p in (!_possible_syntax!) do if defined _parse_cs (
                if "%%s" == "%%p" set "_to_fill=%%c%%~xb"
            ) else if /i "%%s" == "%%p" set "_to_fill=%%c%%~xb"
        )
        if not defined _to_fill (
            if not defined _first_error set "_first_error=unknown parameter: !_current_arg!"
            goto parse_args.next
        )
        set "_value=%%t"
    )
) else for %%a in ("!_to_fill!") do if "%%~xa" == ".m" if not defined _expect_more (
    for %%s in ("+") do if "!_value!" == "%%~s" set "_expect_more=true"
    if defined _expect_more goto parse_args.next
    set "_to_fill="
)
if not defined _to_fill (
    if defined _required_vars (
        for /f "tokens=1* delims= " %%v in ("!_required_vars!") do (
            set "_to_fill=%%v"
            set "_required_vars=%%w"
        )
    ) else if not defined _first_error set "_first_error=too many arguments"
)
for %%a in ("!_to_fill!") do (
    if "%%~xa" == ".f" (
        set "%%~na=true"
        set "_to_fill="
        if defined _value (
            if not defined _first_error set "_first_error=parameter not expecting values: !_current_arg!"
        )
    )
    if "%%~xa" == ".s" if defined _value (
        set "%%~na=!_value!"
        call :strip_dquotes %%~na
        set "_to_fill="
    )
    if "%%~xa" == ".m" if defined _value (
        set "%%~na=!%%~na! !_value!"
        set "_expect_more="
    )
)
goto parse_args.next
:parse_args.cleanup
if defined _required_vars (
    if not defined _first_error set "_first_error=too few arguments"
)
for %%v in (
    _parse_cs _required_vars _current_arg _prev_arg _value
    _is_option _to_fill _no_compare _possible_syntax _expect_more
) do set "%%v="
if defined _first_error (
    echo=!_first_error!
    set "_first_error="
    exit /b 1
)
exit /b 0

rem USAGE:
set _parse_args=!LF!^
    [^ /:/: parsing_options!LF!^]
    ^ short_name:[long_name].type:storage_variable[!LF!^]

rem Case sensitive parsing
set _parse_args=!LF!^
    ^ /:/: case_sensitive!LF!^
    ^ P:prompt.f:prompt_first!LF!^
    ^ -:input.m:input_files!LF!^
    ^ -:output.s:output_files
call :parse_args -P --input asd + qwe /output zxc

rem Case insensitive parsing with 2 required arguments
set _parse_args=!LF!^
    ^ P:prompt.f:prompt_first!LF!^
    ^ -:-.m:input_files!LF!^
    ^ -:-.s:output_files
call :parse_args -p asd + qwe zxc

rem parsing_options
rem case_sensitive  : case sensitive parameters

rem short_name
rem letter  : options (/o -o --options)
rem '-'     : (none)

rem long_name
rem words   : word for parameter (no space)
rem '-'     : (none)

rem .type
rem - .f    : flag (true or false)
rem - .s    : single string parameter
rem - .m    : multiple strings, seperated by '+' symbol
rem storage_variable    : words (no space)
rem !LF!    : seperator
rem ^       : for multiple lines
goto :EOF

rem Alternative usage:
call :parse_args %* > nul || exit /b 1

rem single-valued flag support
call :function --optional --exist -f
set "_argc=1"
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in ("-o" "--optional") do   if /i "%%a" == "%%~f" set "_set_cmd=_is_optional=true"
    for %%f in ("-e" "--exist") do      if /i "%%a" == "%%~f" set "_set_cmd=_require_exist=true"
    for %%f in ("-n" "--not-exist") do  if /i "%%a" == "%%~f" set "_set_cmd=_require_exist=false"
    for %%f in ("-f" "--file") do       if /i "%%a" == "%%~f" set "_set_cmd=_require_attrib=-"
    for %%f in ("-d" "--directory") do  if /i "%%a" == "%%~f" set "_set_cmd=_require_attrib=d"
    if defined _set_cmd (
        set "!_set_cmd!"
        shift /!_argc!
    ) else set /a "_argc+=1"
)
set /a "_argc-=1"
rem multiple-valued flag support
call :function -oed
set "_argc=0"
for %%a in (%*) do (
    set /a "_argc+=1"
    set "_args=%%a "
    if "!_args:~0,1!" == "-" (
        set "_unknown_args=!_args!"
        for %%o in (
            "$:_is_optional" "O:true"
            "$:_require_attrib" "D:d" "F:-"
            "$:_require_exist" "E:true" "N:false"
        ) do for /f "tokens=1* delims=:" %%b in ("%%~o") do if "%%b" == "$" (
            set "_option=%%c"
        ) else if not "!_args:%%b=!" == "!_args!" (
            set "!_option!=%%c"
            set "_args=!_args:%%b=!"
        )
        if not "!_args!" == "- " 1>&2 echo error: unknown argument !_args! & exit /b 1
        shift /!_argc!
    )
)

rem ================================ dynamenu(!) ================================
$ Function fw dynamenu


:dynamenu.__demo__
echo Dynamic Menu Creator
echo=
echo Reading menu entries...
call :dynamenu.read
echo Done
echo=
set "used_time=!time!"
set /a "odd=!used_time:~7,1! %% 2"
echo Time: !used_time!
echo=
call :dynamenu options list
goto :EOF

:dynamenu.read
for /f "usebackq tokens=1,2 delims= " %%a in ("%~f0") do (
    if "%%~xa" == ".dynamenu" if not "%%~b" == "" set "dynamenu_%%b=!dynamenu_%%b! %%~na"
)
exit /b 0


:dynamenu   menu_name  number|list
if not defined dynamenu_%~1 exit /b 1
set "selected_menu="
set "_menu_count=0"
for %%m in (!dynamenu_%~1!) do call %%m.dynamenu && (
    set /a "_menu_count+=1"
    if /i "%2" == "list" (
        set "_menu_count=   !_menu_count!"
        echo !_menu_count:~-3,3!. !dynamenu_text!
    ) else if "%~2" == "!_menu_count!" set "selected_menu=%%m"
)
set "dynamenu_text="
if not defined selected_menu exit /b 1
call !selected_menu!
exit /b 0

call :dynamenu.read
call :dynamenu menu_type list
call :dynamenu menu_type 1


:menulabel_even.dynamenu   options
rem Menu condition here
if "!odd!" == "1" exit /b 1
set "dynamenu_text=This will show on seconds that is a even number"
exit /b 0
:menulabel
echo Hello Even Menu
exit /b 0


:menulabel_odd.dynamenu   options
rem Menu condition here
if "!odd!" == "0" exit /b 1
set "dynamenu_text=This will show on seconds that is a odd number"
exit /b 0
:menulabel
echo Hello Odd Menu
exit /b 0

rem ================================ bcom ================================
rem Still under development

:bcom.init
set "bcom_name=!SOFTWARE_NAME!"
set "bcom_file=%~dp0\bcom_.bat"

set "bcom_name=.!bcom_name!"
set "bcom_name=!bcom_name: =_!"
set "bcom_name=!bcom_name:~1!"
set "bcom_id=!bcom_name!.!MODULE_NAME!"
call :expand_path bcom_file "!bcom_file!"
if not exist "!bcom_fileDP!" md "!bcom_fileDP!"
goto :EOF


:bcom.send   bcom_id
set "_bcom_send_date=!date!"
set "_bcom_send_time=!time!"
(
    echo=
    echo=
    echo call :^^^!bcom_sender^^^! ^& goto :EOF
    echo :!bcom_id!
    echo=!bcom_msg!
    echo=
    echo set "_bcom_send_date=!_bcom_send_date!"
    echo set "_bcom_send_time=!_bcom_send_time!"
    echo goto :EOF
) > "!bcom_fileDP!\!bcom_fileN!%~1!bcom_fileX!"
exit /b 0


:bcom.receive   bcom_id
set "bcom_sender=%~1"
set "_bcom_send_date="
set "_bcom_send_time="
ver > nul & rem set errorlevel 0
for %%f in ("!bcom_fileDP!\!bcom_fileN!!bcom_id!!bcom_fileX!") do (
    if not exist "%%~f" exit /b 2
    call "!bcom_fileDP!\!bcom_fileN!!bcom_id!!bcom_fileX!" || exit /b 1
)
exit /b 0


:bcom.ping   bcom_id
set bcom_msg=set "bcom_signal=ping"
set "_respond=false"
call :bcom.send "%~1"
set "_bcom_ping_time=!_bcom_send_time!"
timeout /t 2 /nobreak > nul
set "bcom_signal="
call :bcom.receive "%~1"
if defined _bcom_send_time (
    call :difftime !_bcom_send_time! !_bcom_ping_time!
    if !return! LSS 30000 set "_respond=true"
)
if /i "!_respond!" == "false" exit /b 1
exit /b 0


:bcom.respond   bcom_id
set "bcom_signal="
call :bcom.receive "%~1"
set "_respond=true"
if defined bcom_last_respond_time (
    call :difftime !_bcom_send_time! !bcom_last_respond_time!
    if !return! GEQ 30000 set "_respond="
)
set "bcom_last_respond_time=!time!"
if defined _respond (
    for %%r in (!bcom_signal!) do (
        if /i "%%r" == "ping" (
            echo [!time!] Got a ping request from "%~1" @!_bcom_send_time!
            set "bcom_msg="
            call :bcom.send "%~1"
        )
    )
)
exit /b 0

rem ========================================================================

rem ======================================== Framework ========================================
:_.FRAMEWORK._     Core of the script

rem ================================ Input Number ================================
$ Function fw Input_number


:Input_number.__demo__
echo Input number within a specified range, multiple range supported
echo=
echo Note:
echo - Valid number range: -2147483647 ~ 2147483647
echo - Leading zeros are will be trimmed before evaluation
echo - Hexadecimal is supported
echo - Octal is not supported
echo=
call :Input_number your_integer "" "-0xf0~-0xff, -99~9, 0x100~0x200, 0x16,555"
echo Your input: !your_integer!
goto :EOF


:Input_number   variable_name  [description]  [num|min~max[,num|,min~max [...]]]
setlocal EnableDelayedExpansion
set "_temp=%~3"
if not defined _temp set "_temp=0x80000001~0x7fffffff"
set "range="
for %%r in (!_temp!) do for /f "tokens=1,2 delims=~ " %%a in ("%%~r") do (
    for %%n in (%%a %%b) do (
        set "_evaluated="
        set /a "_evaluated=%%n" || ( 1>&2 echo error: invalid range '%%n' & exit /b 1 )
        set /a "_evaluated=!_evaluated!" || ( 1>&2 echo error: invalid range '%%n' & exit /b 1 )
        set "range=!range!!_evaluated!~"
    )
    set "range=!range:~0,-1!, "
)
if not defined range 1>&2 echo error: invalid range & exit /b 1
set "range=!range:~0,-2!"
:Input_number.input
set "user_input="
echo=
if "%~2" == "" (
    set /p "user_input=Input %~1 [!range!]: "
) else set /p "user_input=%~2"
call :Input_number.check || goto Input_number.input
for /f "tokens=*" %%c in ("!user_input!") do (
    endlocal
    set "%~1=%%c"
)
exit /b
:Input_number.check
if not defined user_input exit /b 1
for /f "tokens=1-3 delims= " %%a in ("a !user_input!") do (
    if "%%b" == "" exit /b 1
    if not "%%c" == "" exit /b 1
)
set "user_input=!user_input: =!"
set "_temp=!user_input! "
set "user_input="
if "!_temp:~0,1!" == "-" (
    set "_temp=!_temp:~1!"
    set "user_input=-"
)
if /i "!_temp:~0,2!" == "0x" (
    set "_temp=!_temp:~2!"
    if not "!_temp:~9!" == "" exit /b 1
    set "user_input=!user_input!0x"
    set "valid_values=0 1 2 3 4 5 6 7 8 9 A B C D E F"
) else set "valid_values= 0 1 2 3 4 5 6 7 8 9"
if "!_temp!" == " " exit /b 1
for /f "tokens=1* delims=0" %%a in ("a0!_temp!") do set "_temp=%%b"
if "!_temp!" == " " set "_temp=0 "
set "user_input=!user_input!!_temp!"
for %%c in (!valid_values!) do set "_temp=!_temp:%%c=!"
if not "!_temp!" == " " exit /b 1
set "_evaluated="
set /a "_evaluated=!user_input!" || exit /b 1
set /a "user_input=!_evaluated!" || exit /b 1
for %%r in (!range!) do for /f "tokens=1,2 delims=~ " %%a in ("%%~r") do (
    if "%%b" == "" if "!user_input!" == "%%a" exit /b 0
    set "_invalid="
    if %%b LSS 0 if !user_input! GEQ 0 set "_invalid=true"
    if %%a GEQ 0 if !user_input! LSS 0 set "_invalid=true"
    if !user_input! LSS %%a set "_invalid=true"
    if !user_input! GTR %%b set "_invalid=true"
    if not defined _invalid exit /b 0
)
exit /b 1


rem Comparison v2
if %%b LSS 0 if !user_input! GEQ 0 exit /b 1
if %%a GEQ 0 if !user_input! LSS 0 exit /b 1
if !user_input! LSS %%a exit /b 1
if !user_input! GTR %%b exit /b 1


rem Comparison v1
if !min! LEQ !user_input! (
    if !user_input! LEQ !max! exit /b 0
    if !max! GEQ 0 if !user_input! LSS 0 exit /b 0
)
if !min! LSS 0 if !user_input! GEQ 0 (
    if !user_input! LEQ !max! exit /b 0
    if !max! GEQ 0 if !user_input! LSS 0 exit /b 0
)

rem ================================ Input String ================================
$ Function fw Input_string


:Input_string.__demo__
echo Input text
echo=
echo Note:
echo - Function will set errorlevel to 1 if input is undefined
echo=
call :Input_string your_text "Enter anything: "
echo Your input: !your_text!
goto :EOF


:Input_string   variable_name  [description]
echo=
set "%~1="
if "%~2" == "" (
    echo Input %~1:
) else echo=%~2
set /p "%~1="
if not defined %~1 exit /b 1
exit /b 0

rem ================================ Input yes/no ================================
$ Function fw Input_yesno


:Input_yesno.__demo__
echo Prompt for yes or no
echo=
echo Options:
echo -b, --binary        Returns value as binary (Y: 1, N: 0)
echo -t, --truth         Returns value as truth value (Y: true, N: false)
echo -u, --unshortened   Returns value as unshortened yes/no (Y: yes, N: no)
echo -s, --sign          Returns value as sign (Y: +, N: -)
echo -d, --defined       Returns value as defined/undefined (Y: Y, N: <undefined>)
echo                     Can be combined with other arguments. Eg: -t -d (Y: true, N: <undefined>)
echo=
echo Note:
echo - Function will set errorlevel to 0 if user enters 'Y'
echo - Function will set errorlevel to 1 if user enters 'N'
echo=
call :Input_yesno your_ans "Do you like programming? Y/N? " && (
    echo Its a yes^^!
) || echo Its a no...
echo Your input: !your_ans!

call :Input_yesno -t your_ans "Is it true? Y/N? "
echo Your input (truth value): !your_ans!

call :Input_yesno -u your_ans "Do you like to eat? Y/N? "
echo Your input (unshortened): !your_ans!

call :Input_yesno -b your_ans "Do you excercise? Y/N? "
echo Your input (binary value): !your_ans!

call :Input_yesno -u -d your_ans "Is this defined? Y/N? "
echo Your input (unshortened + defined): !your_ans!
goto :EOF


:Input_yesno   [-b|-t|-u|-s] [-d]  variable_name  [description]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_truth  _binary  _unshortened _sign _defined) do set "%%v="
set "_argc=1"
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in ("-b" "--binary") do         if /i "%%a" == "%%~f" set "_set_cmd=_binary=true"
    for %%f in ("-t" "--truth") do          if /i "%%a" == "%%~f" set "_set_cmd=_truth=true"
    for %%f in ("-u" "--unshortened") do    if /i "%%a" == "%%~f" set "_set_cmd=_unshortened=true"
    for %%f in ("-s" "--sign") do           if /i "%%a" == "%%~f" set "_set_cmd=_sign=true"
    for %%f in ("-d" "--defined") do        if /i "%%a" == "%%~f" set "_set_cmd=_defined=true"
    if defined _set_cmd (
        set "!_set_cmd!"
        shift /!_argc!
    ) else set /a "_argc+=1"
)
set /a "_argc-=1"
:Input_yesno.input
echo=
if "%~2" == "" (
    set /p "user_input=%~1? Y/N? "
) else set /p "user_input=%~2"
if /i "!user_input!" == "Y" goto Input_yesno.convert
if /i "!user_input!" == "N" goto Input_yesno.convert
goto Input_yesno.input
:Input_yesno.convert
set "_result=!user_input!"
if defined _binary (
    if /i "!user_input!" == "Y" set "_result=1"
    if /i "!user_input!" == "N" set "_result=0"
)
if defined _truth (
    if /i "!user_input!" == "Y" set "_result=true"
    if /i "!user_input!" == "N" set "_result=false"
)
if defined _unshortened (
    if /i "!user_input!" == "Y" set "_result=yes"
    if /i "!user_input!" == "N" set "_result=no"
)
if defined _sign (
    if /i "!user_input!" == "Y" set "_result=+"
    if /i "!user_input!" == "N" set "_result=-"
)
if defined _defined (
    if /i "!user_input!" == "N" set "_result="
)
for /f "tokens=1* delims=_" %%a in ("Z_!_result!") do (
    endlocal
    set "%~1=%%b"
    if /i "%user_input%" == "Y" exit /b 0
)
exit /b 1

rem ================================ Input Path ================================
$ Function fw Input_path


:Input_path.__demo__
echo Input file/folder path
echo=
echo Options:
echo -e, --exist         Target must exist
echo -n, --not-exist     Target must not exist
echo -d, --directory     Target must be a folder (if exist)
echo -f, --file          Target must be a file (if exist)
echo -o, --optional      Input is optional
echo=
echo Note:
echo - This function does not expand variables (e.g.: %appdata%)
echo - Requires: check_path()
echo=
echo Press any key to try it...
pause > nul
echo=
call :Input_path config_file --exist --file  "Input an existing file: "
echo Result: !config_file!
pause
call :Input_path --optional folder -d "Input an existing folder or a new folder name: "
echo Result: !folder!
pause
call :Input_path new_name -o --not-exist "Input a non-existing file/folder: "
echo Result: !new_name!
pause
goto :EOF


:Input_path  [-o] [-e|-n] [-d|-f] [-p] variable_name  [description]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_is_optional  _require_attrib  _require_exist _prompt_only) do set "%%v="
set "_options= "
set "_argc=1"
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in ("-o" "--optional") do   if /i "%%a" == "%%~f" set "_set_cmd=_is_optional=true"
    for %%f in ("-e" "--exist") do      if /i "%%a" == "%%~f" set "_set_cmd=_require_exist=true"
    for %%f in ("-n" "--not-exist") do  if /i "%%a" == "%%~f" set "_set_cmd=_require_exist=false"
    for %%f in ("-f" "--file") do       if /i "%%a" == "%%~f" set "_set_cmd=_require_attrib=-"
    for %%f in ("-d" "--directory") do  if /i "%%a" == "%%~f" set "_set_cmd=_require_attrib=d"
    if defined _set_cmd (
        set "!_set_cmd!"
        set "_options=!_options!%%a "
        shift /!_argc!
    ) else set /a "_argc+=1"
)
set /a "_argc-=1"
set "_options=!_options: -o = !"
set "_options=!_options: --optional = !"
:Input_path.input
set "user_input="
cls
echo Current directory:
echo=!cd!
echo=
if defined last_used.file (
    echo Previous input:
    echo=!last_used.file!
    echo=
)
if defined last_used.file           echo :P     Use previous input
if defined _is_optional             echo :S     Skip / use default
echo=
if "%~2" == "" (
    echo Input %~1:
) else echo=%~2
set /p "user_input="
echo=
if not defined user_input goto Input_path.input
if defined last_used.file   if /i "!user_input!" == ":P" set "user_input=!last_used.file!"
if defined _is_optional     if /i "!user_input!" == ":S" set "user_input="
if defined user_input call :check_path user_input !_options! || (
    pause
    goto Input_path.input
)
for /f "tokens=*" %%c in ("!user_input!") do (
    endlocal
    set "%~1=%%c"
    set "last_used.file=%%c"
)
exit /b 0

rem ================================ Input IPv4 ================================
$ Function fw Input_ipv4


:Input_ipv4.__demo__
echo Input a valid IPv4
echo=
echo Options:
echo -w, --allow-wildcard   Allow wildcards in IPv4 address
echo=
call :Input_ipv4 -w your_ip
echo Your input: !your_ip!
goto :EOF


:Input_ipv4   [-w]  variable_name  [description]
setlocal EnableDelayedExpansion EnableExtensions
set "_allow_wildcard="
set "_argc=1"
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in ("-w" "--allow-wildcard") do if /i "%%a" == "%%~f" set "_set_cmd=_allow_wildcard=true"
    if defined _set_cmd (
        set "!_set_cmd!"
        shift /!_argc!
    ) else set /a "_argc+=1"
)
set /a "_argc-=1"
:Input_ipv4.input
if "%~2" == "" (
    if defined _allow_wildcard (
        set /p "user_input=Input %~1 (Wildcard allowed, 0. Back): "
    ) else set /p "user_input=Input %~1 (0. Back): "
) else set /p "user_input=%~2"
echo=
if not defined user_input goto Input_ipv4.input
if "!user_input!" == "0" exit /b 1
if not "!user_input:..=!" == "!user_input!" goto Input_ipv4.input
for /f "tokens=5 delims=." %%a in ("!user_input!") do if not "%%a" == "" goto Input_ipv4.input
set _temp=!user_input:.=^
%=REQURED=%
!
set "user_input="
for /f "tokens=*" %%n in ("!_temp!") do (
    if "%%n" == "*" (
        if not defined _allow_wildcard goto Input_ipv4.input
    ) else (
        set "_evaluated="
        set /a "_evaluated=%%n" 2> nul || goto Input_ipv4.input
        set /a "_num=!_evaluated!" 2> nul || goto Input_ipv4.input
        if not "!_num!" == "%%n" goto Input_ipv4.input
        if %%n LSS 0    goto Input_ipv4.input
        if %%n GTR 255  goto Input_ipv4.input
    )
    set "user_input=!user_input!.%%n"
)
set "user_input=!user_input:~1!"
for /f "tokens=*" %%c in ("!user_input!") do (
    endlocal
    set "%~1=%%c"
)
exit /b 0

rem ================================ Module.detect() ================================
$ Function fw Module.detect


:Module.detect.__demo__
echo Enable module detection when running script
echo Used for scripts that needs multiple windows / parallel execution
echo=
echo Press any key to start another window...
pause > nul
@echo on
start "" "%~f0" --module:2nd_window_demo   test arg Here
@echo off
echo=
echo Done
goto :EOF


:__module__.2nd_window_demo
@echo off
setlocal EnableDelayedExpansion
title Second Window
echo Hello! I am the second window.
echo=
echo Arguments  : %*
echo=
pause
exit


:Module.detect
@for /f "tokens=1,2 delims=:" %%a in ("%1") do @if /i "%%a" == "--module" @(
    for /f "tokens=1* delims= " %%c in ("%*") do @call :__module__.%%b %%d
    exit /b
)
@goto __module__.__main__

rem ================================ Module.updater() ================================
$ Function fw Module.updater


:Module.updater.__demo__
echo Update this batch script from GitHub (PowerShell hybrid)
echo=
echo At __setup__():
echo - Set the DOWNLOAD_URL to the GitHub raw gist link
echo=
echo Note:
echo - Requires:
echo    - Module.detect()
echo    - __module__.lib()
echo    - __setup__()
echo    - Module.check_support()
echo    - download()
echo    - diffdate()
echo=
echo Options:
echo - set "temp_path=C:\path\to\download"
echo=
echo Then, this function can automatically detect updates,
echo download them, and update script
echo=
call :Module.updater check "%~f0" || goto :EOF
echo=
echo Note:
echo - Updating will REPLACE current script with the newer version
call :Input_yesno user_input "Update now? Y/N? " || goto :EOF
call :Module.updater upgrade "%~f0"
goto :EOF


:Module.updater   <check|upgrade>  script_path
setlocal EnableDelayedExpansion
set "_set_cmd="
if /i "%1" == "check" set "_set_cmd=_show=true"
if /i "%1" == "upgrade" set "_set_cmd=_upgrade=true"
if defined _set_cmd (
    set "!_set_cmd!"
    shift /1
)
set "_metadata=NAME DESCRIPTION VERSION RELEASE URL DOWNLOAD_URL"
echo Checking requirements...
call :Module.check_support "%~1" || ( 1>&2 echo script does not support call as 'Module' & exit /b 1 )
for %%v in (!_metadata!) do set "_module.%%v="
call "%~1" --module:lib :__setup__ _module. || ( 1>&2 echo error: module call failed & exit /b 1 )
if not defined _module.DOWNLOAD_URL 1>&2 echo error: script DOWNLOAD_URL is undefined & exit /b 1
echo Downloading updates...
call :download _downloaded "!_module.DOWNLOAD_URL!"
if not exist "!_downloaded!" 1>&2 echo error: download failed & exit /b 1
for %%f in ("!_downloaded!") do (
    if exist "%%~ff.bat" del /f /q "%%~ff.bat"
    ren "%%~ff" "%%~nxf.bat"
    set "_downloaded=!_downloaded!.bat"
)
echo Checking compatibility...
call :Module.check_support "!_downloaded!" || ( 1>&2 echo error: update script does not support call as 'Module' & exit /b 2 )
for %%v in (!_metadata!) do set "_downloaded.%%v="
call "!_downloaded!" --module:lib :__setup__ _downloaded. || ( 1>&2 echo error: module call failed & exit /b 2 )
if not defined _downloaded.VERSION 1>&2 echo error: downloaded VERSION is undefined & exit /b 2
if /i not "!_downloaded.NAME!" == "!_module.NAME!" 1>&2 echo warn: script name mismatch
call :Module.is_newer "!_module.VERSION!"  "!_downloaded.VERSION!" || ( echo No updates available & exit /b 3 )
call :diffdate update_age !date:~4! !_downloaded.RELEASE!
echo !_downloaded.DESCRIPTION! !_downloaded.VERSION! is now available (!update_age! days ago)
if not defined _upgrade exit /b 0
echo Updating script...
move "!_downloaded!" "%~f1" > nul && (
    echo Update success
    echo Script will exit
    pause
    exit
) || ( 1>&2 echo error: update failed & exit /b 1 )
exit /b 0


:Module.is_newer   first_version  second_version
setlocal EnableDelayedExpansion
set "_first=%~1"
set "_second=%~2"
for %%n in (_first _second) do for /f "tokens=1,2 delims=-" %%a in ("!%%n!") do (
    for /f "tokens=1-3 delims=." %%c in ("%%a") do (
        set "%%n._MAJOR=%%c"
        set "%%n._MINOR=%%d"
        set "%%n._PATCH=%%e"
    )
    for /f "tokens=1-2 delims=." %%c in ("%%b") do (
        set "%%n._PRE_ID=%%c"
        set "%%n._PRE_INC=%%d"
    )
)
for %%v in (_MAJOR _MINOR _PATCH) do (
    if !_second.%%v! LSS !_first.%%v! exit /b 1
    if !_second.%%v! GTR !_first.%%v! exit /b 0
)
if defined _first._PRE_ID (
    if not defined _second._PRE_ID exit /b 0
) else if defined _second._PRE_ID exit /b 1
for %%v in (_PRE_ID _PRE_INC) do (
    if !_second.%%v! LSS !_first.%%v! exit /b 1
    if !_second.%%v! GTR !_first.%%v! exit /b 0
)
exit /b 2

rem ================================ Module.check_support() ================================
$ Function fw Module.check_support


:Module.check_support.__demo__
echo Detect if a script supports call as module
echo=
echo Detect if script contains:
echo :Module.detect
echo :__module__.lib
echo :__setup__
echo=
echo This could prevent script from calling another batch file that does not
echo understand call as module and cause undesired result
echo=
pause
call :Input_path script_to_check
echo=
set "start_time=!time!"
call :Module.check_support "!script_to_check!" && (
    echo Script supports call as module
) || echo Script does not support call as module
call :difftime time_taken !time! !start_time!
call :ftime time_taken !time_taken!
echo=
echo Done in !time_taken!
goto :EOF


:Module.check_support   file_path
setlocal EnableDelayedExpansion
set /a "_missing=0xF"
for /f "usebackq tokens=* delims=@ " %%a in ("%~f1") do (
    for /f "tokens=1-2 delims= " %%b in ("%%a") do (
        if /i "%%b %%c" == "goto Module.detect" set /a "_missing&=~0x1"
        if /i "%%b" == ":Module.detect"         set /a "_missing&=~0x2"
        if /i "%%b" == ":__module__.lib"        set /a "_missing&=~0x4"
        if /i "%%b" == ":__setup__"             set /a "_missing&=~0x8"
    )
)
if not "!_missing!" == "0" exit /b 1
set "_callable="
for %%x in (.bat .cmd) do if "%~x1" == "%%x" set "_callable=true"
if not defined _callable exit /b 2
exit /b 0

rem ================================ endlocal() ================================
$ Function fw endlocal


:endlocal.__demo__
echo Make variables survive endlocal
echo=
echo Note:
echo - Variables that contains Line Feed are not supported
echo=
@echo on
set "var_del=This variable will be deleted"
set "var_keep=This variable will keep its content"
setlocal
set "var_del="
set "var_keep=Attempting to change it"
set "var_hello=I am a new variable^!"
@echo off
echo call :endlocal  var_del var_hello:var_new_name
call :endlocal var_del var_hello:var_new_name
echo=
echo Variables after endlocal:
set var_
goto :EOF


:endlocal   old_name:new_name  [old_name:new_name [...]]
setlocal EnableDelayedExpansion
set LF=^
%=REQURED=%
%=REQURED=%
set "_content="
for %%v in (%*) do for /f "tokens=1,2 delims=:" %%a in ("%%~v:%%~v") do (
    set "_var=!%%a! "
    call :endlocal.to_ede
    set "_content=!_content!%%b=!_var:~0,-1!!LF!"
)
set "_content"
for /f "tokens=1* delims==" %%a in ("!_content!") do (
    if defined _content (
        goto 2> nul
        endlocal
    )
    set "%%a=%%b"
    if "!!" == "" (
        set "%%a=!%%a:~1!"
    ) else (
        setlocal EnableDelayedExpansion
        set "_var=!%%a!"
        call :endlocal.to_dde
        set "_var=!_var:~1!"
        for /f "delims=" %%c in ("!_var!") do (
            endlocal
            set "%%a=%%c"
        )
    )
)
exit /b 0
:endlocal.to_ede
set "_var=^!!_var:^=^^^^!"
set "_var=%_var:!=^^^!%"
exit /b
:endlocal.to_dde
set "_var=%_var%"
exit /b

rem ======================================== End of Script ========================================
:_.END_OF_SCRIPT._     Anything beyond this are not part of the code
rem ================================================================================

rem error levels: https://www.keycdn.com/support/nginx-error-log
rem debug - Useful debugging information to help determine where the problem lies.
rem info - Informational messages that aren't necessary to read but may be good to know.
rem notice - Something normal happened that is worth noting.
rem warn - Something unexpected happened, however is not a cause for concern.
rem error - Something was unsuccessful.
rem crit - There are problems that need to be critically addressed.
rem alert - Prompt action is required.
rem emerg - The system is in an unusable state and requires immediate attention.

rem ======================================== Other Function ========================================
:_.OTHER_FUNCTIONS._     Actually working functions but not listed

rem ================================ Change Console Size ================================

[require]
call :get_con_size
call :setup_clearline


:change_con_size   width  height
mode %~1,%~2
call :get_con_size console_width console_height
call :setup_clearline
goto :EOF

rem ================================ list_ip() ================================


:list_ip.__demo__
echo List interface IP address
echo Does not show interfaces with no IPv4 address
echo=
echo=
call :list_ip
goto :EOF

:list_ip
set "interface_count=0"
for /f "tokens=* usebackq" %%o in (`ipconfig /all`) do (
    set "output=%%o"
    if "!output:~-1,1!" == ":" (
        if not "!interface_count!" == "0" if defined interface_ipv4 call :list_ip.output
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
if not "!interface_count!" == "0" if defined interface_ipv4 call :list_ip.output
exit /b 0
:list_ip.output
echo [!interface_type!] !interface_name!:
echo Desc        : !interface_desc!
echo IPv4        : !interface_ipv4!
if defined interface_dhcp_server echo DHCP Server : !interface_dhcp_server!
echo=
goto :EOF

rem ================================ others (wip) ================================
rem Note: some functions below are not ready to use yet

rem Make: Copy / Move / Sync


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


:del_tempvar
for /f "usebackq tokens=1 delims==" %%v in (`set`) do (
    for /f "tokens=* delims=_" %%t in ("%%v") do (
    if not "%%v" == "%%t" set "%%v="
)
exit /b

rem ======================================== Notes ========================================
:_.NOTES._     Useful stuffs worth looking at


rem ======================================== Notes (General) ========================================

::: Doc comment
for /f "tokens=* delims=:" %%A in ('findstr "^:::" "%~f0"') do @echo( %%A

rem Copy to clipboard
< nul set /p "=No new line"
echo This text is copied to clipboard | clip

rem Write to stderr
echo message 1>&2
1>&2 echo message

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
rem Display each line of the file + tokens skip delims
for /f "usebackq tokens=* skip=40 delims= " %%a in ("your file here") do echo Output: %%a

rem Multi SET (Arithmetic only)
set /a var5=5 , var6=7+2
set /a var7=var8=7+8

rem Multi line command
set msg=!LF!^
    ^ Hello!LF!^
    ^ Batch!LF!^
    ^ Script

rem Case insensitive comparison
if /i NOT "asd" == "ASD" echo This wont display

rem Detect special symbols
for %%c in (">" "<" "|" ":" ^"^"^") do for /f "delims=" %%s in ("%%~c") do set "string=!string:%%s=!"

rem Delay 1s
ping localhost -n 2 > nul

rem Set errorlevel
cmd /c "exit /b 0"

rem Clean error state (use at end of block)
( call )

rem Execute powershell commands
powershell -Command "echo HELLO"

rem Date and Time
set "date_time=!date:~10!-!date:~4,2!-!date:~7,2!_!time:~0,2!!time:~3,2!!time:~6,2!"
set "date_time_mini=!date:~10!!date:~4,2!!date:~7,2!_!time:~0,2!!time:~3,2!!time:~6,2!"
for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined mydate set mydate=%%x

rem GUI Stuffs
chcp 437
chcp 1252

rem Box characters
rem             ANSI   UTF8     KEYBOARD
set "hLine=     CE94    C4      ALT+0196
set "vLine=     C2B3    B3      ALT+0179
set "cLine=     CE95    C5      ALT+0197
set "hBorder=   CE9D    CD      ALT+0205
set "vBorder=   CE8A    BA      ALT+0186
set "cBorder=   CE9E    CE      ALT+0206
set "uEdge=     CE9B    CB      ALT+0203
set "dEdge=     CE9A    CA      ALT+0202
set "lEdge=     CE9C    CC      ALT+0204
set "rEdge=     CE89    B9      ALT+0185
set "ulCorner=  CE99    C9      ALT+0201
set "urCorner=  C2BB    BB      ALT+0187
set "dlCorner=  CE98    C8      ALT+0200
set "drCorner=  CE8C    BC      ALT+0188

rem ======================================== Notes (File I/O) ========================================

rem Get available drives
set "available_drives="
for %%l in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do vol %%l: > nul 2> nul && set "available_drives=!available_drives! %%l"

rem Read third line of file
(
    for /l %%n in (1,1,3) do set /p "a="
) < "%~f0"

rem Create 0-byte file
call 2> "File.txt"

rem File Lock/Unlocked State

rem Create State
echo File is in locked state
(
    pause > nul
) >> "!file_path!"
echo File is in unlocked state

rem Detect State
2> nul (
  call >> "!file_path!"
) && (
    echo File is in unlocked state
) || (
    echo File is in locked state
)

rem Merge multiple files
call 2> "!outputFile!"
copy /d "!inputFile!" "!outputFile!"

rem Count numeber of lines of a file (include empty lines)
for /f "delims=" %%n in ('type FILENAME ^| find "" /v /c') do set "lines=%%n"

rem Encode / Decode
certutil -encode inFile outFile
certutil -decode inFile outFile
certutil -encodehex inFile outFile
certutil -decodehex inFile outFile

rem to unicode
rem 0xFF 0xFE
cmd /u /c type ascii.txt > unicode.txt

rem download_in_progress
dir dl
type dl > nul
dir dl

rem ======================================== Notes (Data Collection) ========================================

rem Get registry value
for /f "tokens=3" %%v in ('reg query !regKeyName! /v !regVarName! ^| findstr !regVarName!') do set "regValue=%%v"

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

rem set file association
assoc

rem Others
driverquery
gpresult
telnet




