@rem UTF-8-BOM guard > nul 2> nul
@goto module.entry_point

rem ======================================== Metadata ========================================

:metadata   [prefix]
set "%~1name=batchlib"
set "%~1version=2.0-b.3"
set "%~1author=wthe22"
set "%~1license=The MIT License"
set "%~1description=Batch Script Library"
set "%~1release_date=06/24/2019"   :: MM/dd/yyyy
set "%~1url=https://winscr.blogspot.com/2017/08/function-library.html"
set "%~1download_url=https://gist.github.com/wthe22/4c3ad3fd1072ce633b39252687e864f7/raw"
exit /b 0


:about
setlocal EnableDelayedExpansion
call :metadata
echo A collection of functions for batch script
echo Created to make batch scripting easier
echo=
echo Updated on !release_date!
echo=
echo Feel free to use, share, or modify this script for your projects :)
echo Visit http://winscr.blogspot.com/ for more scripts^^!
echo=
echo=
echo Copyright (C) 2019 by !author!
echo Licensed under !license!
endlocal
exit /b 0

rem ======================================== License ========================================

:license
echo Copyright 2019 wthe22
echo=
echo Permission is hereby granted, free of charge, to any person obtaining a 
echo copy of this software and associated documentation files (the "Software"), 
echo to deal in the Software without restriction, including without limitation 
echo the rights to use, copy, modify, merge, publish, distribute, sublicense, 
echo and/or sell copies of the Software, and to permit persons to whom the 
echo Software is furnished to do so, subject to the following conditions:
echo=
echo The above copyright notice and this permission notice shall be included in 
echo all copies or substantial portions of the Software.
echo=
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
echo OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
echo FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
echo DEALINGS IN THE SOFTWARE.
exit /b 0

rem ======================================== Configurations ========================================

:config
call :config.default
call :config.preferences
exit /b 0


:config.default
set "temp_path=!temp!\BatchScript\"

rem Macros to call external module (use absolute paths)
set "batchlib="

rem Variables below are not used here, but for reference only
rem set "data_path=data\Functions\"
rem set "default_console_width=80"
rem set "default_console_height=25"
rem set "console_width=!default_console_width!"
rem set "console_height=!default_console_height!"
rem set "ping_timeout=750"
rem set "debug_mode=false"
exit /b 0


:config.preferences
rem Define your preferences or config modifications here

rem Macros to call external module (use absolute paths)
rem set batchlib="%~dp0batchlib.bat" --module=lib 
exit /b 0

rem ======================================== Changelog ========================================

:changelog
for /f "usebackq tokens=1-2* delims=." %%a in ("%~f0") do (
    if /i "%%a.%%b" == ":changelog.text" (
        echo batchlib %%c
        call :changelog.text.%%c
        echo=
    )
)
exit /b 0


:changelog.latest
for /f "usebackq tokens=1-2* delims=." %%a in ("%~f0") do (
    if /i "%%a.%%b" == ":changelog.text" (
        echo batchlib %%c
        call :changelog.text.%%c
        exit /b 0
    )
)
exit /b 0


:changelog.text.2.0-b.3 (2019-07-20)
echo    Concept
echo    - changed function styles from 'underscores style' to 'namespace structure'
echo    - changed error handling to exception based
echo=
echo    Internal
echo    - renamed function '__setup__' to 'metadata'
echo    - renamed function 'Module.*' to 'module.*'
echo    - renamed function 'download' to 'download_file'
echo    - renamed function 'check_eol' to 'check_win_eol'
echo    - metadata variable renamed from 'release' to 'release_date'
echo=
echo    Documentation
echo    - changed documentation structures
echo    - each version now has its own label
echo=
echo    Features
echo    - Changed diffdate() default start date to epoch time (1/01/1970)
echo    - Added testing automation framework: tester
echo    - Added tests for some function
echo    - reworked parse_args(), parameters are now simplified and more robust
echo    - Added check_number(), check_ipv4(), time2epoch()
echo    - added a UTF-8-BOM guard line at beginning of file to prevent errors
echo      if script is encoded in UTF-8-BOM
echo=
echo    Backward Incompatibilities
echo    - changed arguments for download() 
echo    - download() no longer gets download name automatically
exit /b 0

:changelog.text.2.0-b.2 (2019-04-27)
echo    Features
echo    - added new parameter '--filled' for Input.string
echo    - added combination version of wcdir: combi_wcdir(), but not included in demo
echo    - changed __error__.assertion() to __error__() to allow generic error messages
echo    - user can now see changelog without looking at the source code
echo=
echo    Bug Fixes
echo    - wcdir():
echo        - fixed spaces handling when using wildcard drive path
echo        - fixed folder listing when last item exist and does not contain wildcard
echo=
echo    Behavior
echo    - improved wcdir() search speed (~5x faster)
echo    - added warning message for unknown tags when reading function
echo    - changed title in about
echo    - added fallback display to Module.updater when diffdate() is not found
echo    - changed default prompt from '>' to '$ '
echo    - disabled echo when converting EOL
exit /b 0

:changelog.text.2.0-b.1 (2019-03-25)
echo    Bug Fixes
echo    - fixed Module.updater() not upgrading script
exit /b 0

:changelog.text.2.0-b (2019-03-25)
echo    Major update
echo=
echo    Bug Fixes
echo    - fixed parameter when calling script as lib module
echo    - fixed a rare display error of watchvar()
echo    - fixed error in unzip() if path ends with slash
echo    - fixed error when capturing Carriage Return using capchar() if script is set to read-only
echo    - fixed endlocal() not copying empty variables
echo    - fixed incorrect EOL format if script is downloaded from GitHub
echo    - fixed expand_link(), and now it can work with incomplete urls (e.g.: no scheme defined)
echo=
echo    Features
echo    - improved demo of download()
echo    - wcdir() can now search for both file and directory at the same time
echo    - expand_link can now seperate query ('?') and fragment ('#') in url
echo    - added path_check(), check_eol(), color2seq()
echo    - added assertion for debugging
echo=
echo    Behavior
echo    - re-factored several functions (no feature change)
echo    - removed get_os() /b flag, it is now the default option
echo    - wcdir() search file/directory only now requires additional parameter
echo    - Module.detect() no longer set __name__
echo    - Module.detect() now changes %* argument
echo=
echo    Deprecations
echo    - removed unnecessary watchvar -w flag, since it can be done using ^>^> redirection
echo=
echo    Internal
echo    - regrouped category and functions
echo    - reworking sleep(), still unavailable for now
exit /b 0

rem ======================================== Debug functions ========================================

:exception.raise
@echo=
@echo=
@for %%t in (%*) do @ 1>&2 echo %%~t
@echo=
@echo Press any key to exit...
@pause > nul
@exit

rem ======================================== Main ========================================

:__main__
@call :scripts.main %*
@exit %errorlevel%

rem ======================================== Scripts/Entry points  ========================================
:scripts.__init__
@exit /b 0

rem ================================ library script ================================

rem Call script as library module and call the function
call your_file_name.bat --module=lib <function> [arg1 [arg2 [...]]]

rem Example:
call batchlib.bat --module=lib pow result 2 16
call batchlib.bat --module=lib :Input.number age "Input your age: " 0~200

rem Set as macro and call as external package
set "batchlib=batchlib.bat --module=lib "
call %batchlib%:Input.number age "Input your age: " 0~200


:scripts.lib
@call :%*
@exit /b

rem ================================ main script ================================

:scripts.main
@set "__name__=__main__"
@echo off
prompt $$ 
setlocal EnableDelayedExpansion EnableExtensions
call :metadata SOFTWARE.
title !SOFTWARE.description! !SOFTWARE.version!
cls
echo Loading script...

for %%n in (1 2) do call :fix_eol.alt%%n scripts.main.reload
call :config

for %%p in (
    %= Add your path here =%
) do if not exist "!%%p!" md "!%%p!"

call :Function.read
set "last_used.function="
call :capchar *
call :get_con_size console_width console_height
call :main_menu
exit /b


:scripts.main.reload
endlocal
goto scripts.main

rem ================================ test script ================================

:scripts.test
cls
@echo off
prompt $$ 
setlocal EnableDelayedExpansion EnableExtensions
call :metadata SOFTWARE.
title !SOFTWARE.description! !SOFTWARE.version!
cls
echo Loading script...

call :config

cls
echo Metadata:
set "SOFTWARE."
echo=
echo Running test...
echo=
call :tester.init
call :tester.find_tests tests
call :tester.run_tests
exit /b 0

rem ================================ debug tests script ================================

:scripts.debug_tests
cls
@echo off
prompt $$ 
setlocal EnableDelayedExpansion EnableExtensions
call :metadata SOFTWARE.
title !SOFTWARE.description! !SOFTWARE.version!
cls
echo Loading script...

call :config

cls
echo Metadata:
set "SOFTWARE."
echo=
echo Running test...
echo=
call :tester.init
call :tester.find_tests debug
call :tester.run_tests -vv --failfast
exit /b 0

rem ======================================== User Interfaces ========================================
:ui.__init__     User Interfaces
exit /b 0

rem ================================ Main Menu ================================

:main_menu
set "user_input=dt"
cls
echo 1. Demo a function
echo 2. Use command line
echo=
echo A. About script
echo C. Change Log
echo T. Test script
echo 0. Exit
echo=
echo What do you want to do?
set /p "user_input="
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" (
    call :select_function
    if not defined selected.function goto main_menu
    call :start_function !selected.function!
    goto main_menu
)
if /i "!user_input!" == "2" (
    call :script_cli
    goto main_menu
)
if /i "!user_input!" == "A" (
    cls
    title !SOFTWARE.description! !SOFTWARE.version!
    call :about
    echo=
    pause
    goto main_menu
)
if /i "!user_input!" == "C" (
    cls
    call :changelog
    echo=
    pause
    goto main_menu
)
if /i "!user_input!" == "T" (
    start "" /i /wait /b cmd /c "%~f0" --module=test || (
        echo=
        echo Test module ended earlier than expected
    )
    echo=
    pause
    goto main_menu
)
if /i "!user_input!" == "DT" (
    start "" /i /wait /b cmd /c "%~f0" --module=debug_tests || (
        echo=
        echo Test module ended earlier than expected
    )
    echo=
    pause
    goto main_menu
)
goto main_menu

rem ================================ Select Function ================================

:select_function
set "selected.function="
:select_function.category
set "search_keyword="
set "user_input="
cls
call :Category.get_item list
echo=
if defined last_used.function echo L. Last used function
echo S. Search function
echo 0. Exit
echo=
echo Which tool do you want to use?
set /p "user_input="
if "!user_input!" == "0" goto :EOF
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
set "search_keyword=!user_input!"
call :Function.search "!search_keyword!"
set "selected.category=search"
set "Category_search"
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

rem ================================ Start Function ================================

:start_function
setlocal EnableDelayedExpansion EnableExtensions
title !SOFTWARE.description! !SOFTWARE.version! - %~1
cls
echo !Function_%~1.args!
echo=
call :%~1.__demo__
echo=
echo ================================ END OF FUNCTION ===============================
title !SOFTWARE.description! !SOFTWARE.version!
echo=
pause
endlocal
exit /b 0

rem ================================ Script CLI ================================

:script_cli
cls
echo Script Command Line Interface
echo Be careful with special characters
echo Enter 'exit /b' to quit
echo=
:script_cli.loop
@set /p "user_input=$ "
%user_input%
@echo=
@goto script_cli.loop

rem ======================================== Tests ========================================
:tests.__init__     Test the scripts
exit /b 0

rem ================================ auto_input ================================

:tests.auto_input.main
rem Test whether the concept of "auto input" is possible
(
    echo d
    echo d
    echo d
    echo d
    echo d
    echo 0
) > "!tester.input!"
(
    start "" /i /wait /b cmd /c "%~f0" < "!tester.input!"
) > "!tester.output!" 2>&1 && (
    exit /b !tester.exit.passed!
) || exit /b !tester.exit.failed!
exit /b !tester.exit.failed!

rem ======================================== Utilities ========================================
:utils.__init__     Utility Functions
exit /b 0


:Function.read
for /f "usebackq tokens=1 delims==" %%v in (`set Category_ 2^> nul`) do set "%%v="
set "Category.list="
set "Category_all.name=All"
set "Category_all.functions="
set "Category_all.item_count=0"
set "Category_others.name=Others"
set "Category_others.functions="
set "Category_others.item_count=0"
set "_function="
for /f "usebackq tokens=*" %%a in ("%~f0") do for /f "tokens=1-3* delims= " %%b in ("%%a") do (
    if "%%b" == "$" (
        set "_handled="
        if /i "%%c" == "Category" (
            set "_handled=true"
            if not defined Category_%%d.name (
                set "Category.list=!Category.list! %%d"
                set "Category_%%d.name=%%~e"
                set "Category_%%d.functions="
                set "Category_%%d.item_count=0"
            )
        )
        if /i "%%c" == "Function" (
            set "_handled=true"
            set "_category=%%d"
            if not defined Category_%%d.name set "_category=others"
            for %%n in (all !_category!) do (
                set "Category_%%n.functions=!Category_%%n.functions! %%e"
                set /a "Category_%%n.item_count+=1"
            )
            set "_function=%%e"
        )
        if not defined _handled 1>&2 echo warning: Function.read: unhandled: %%a
    )
    if /i "%%b" == ":!_function!" (
        set "_temp=%%a"
        set "Function_!_function!.args=!_temp:~1!"
    )
)
for %%v in (_temp _category _function _handled) do set "%%v="
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


:Function.search   keyword
set "Category_search.functions="
for /f "delims=" %%k in (%*) do for %%f in (!Category_all.functions!) do (
    set "_temp= !Function_%%f.args!"
    if not "!_temp:%%k=!" == "!_temp!" set "Category_search.functions=!Category_search.functions! %%f"
)
exit /b 1

rem ================================ Categories ================================
:Category.init
exit /b 0


$ Category  shortcuts   Shortcuts
$ Category  math        Math
$ Category  string      String
$ Category  time        Date and Time
$ Category  file        File and Folder
$ Category  net         Network
$ Category  env         Environment
$ Category  formatting  Formatting
$ Category  framework   Framework


rem ======================================== Shortcuts ========================================
:shortcuts.__init__     Shortcuts to type less codes
exit /b 0

rem ================================ Input Number ================================
$ Function shortcuts Input.number

rem ======================== demo ========================

:Input.number.__demo__
echo Input number within a specified range, multiple range supported
echo=
echo Note:
echo - Valid number range: -2147483647 ~ 2147483647
echo - Leading zeros are will be trimmed before evaluation
echo - Hexadecimal is supported
echo - Octal is not supported
echo=
call :Input.number your_integer --range "-0xf0~-0xff, -99~9, 0x100~0x200, 0x16,555"
echo Your input: !your_integer!
goto :EOF

rem ======================== function ========================

:Input.number   variable_name  [--description "text"]  [--range "num|min~max[, ...]"]
setlocal EnableDelayedExpansion
for %%v in (_description _range) do set "%%v="
set parse_args.args= ^
    "-d --description   :var:_description" ^
    "-r --range         :var:_range"
call :parse_args %* || exit /b 1
if not defined _description (
    if defined _range (
        set "_description=Input %~1 [!_range!]: "
    ) else set "_description=Input %~1: "
)
:Input.number.loop
set "user_input="
echo=
set /p "user_input=!_description!"
call :check_number "!user_input!" "!_range!" || goto Input.number.loop
for /f "tokens=*" %%r in ("!user_input!") do (
    endlocal
    set "%~1=%%r"
)
exit /b

rem ================================ Input String ================================
$ Function shortcuts Input.string

rem ======================== demo ========================

:Input.string.__demo__
echo Input text
echo=
echo Options:
echo -f, --filled       Value must be filled
rem echo -t, --trim         Trim leading and trailing space (' ')
echo=
echo Note:
echo - Function will set errorlevel to 1 if input is undefined
echo=
call :Input.string your_text --description "Enter anything: "
echo Your input: "!your_text!"
call :Input.string your_text --filled --description "Enter something: "
echo Your input: "!your_text!"
goto :EOF

rem ======================== tests ========================

:tests.lib.Input.string.main
set "errors=0"
(
    echo=
    echo hello
    echo   world  
) > "!tester.input!.empty"
(
    echo   world  
) > "!tester.input!.spaced"
(
    echo ; pass
    echo fail
) > "!tester.input!.semicolon"
set "evaluate_result=call :tests.lib.Input.string.evaluate_result"

< "!tester.input!.empty" > nul 2>&1 (
    set "expected_result="
    call :Input.string result
) & !evaluate_result! "null"

< "!tester.input!.spaced" > nul 2>&1 (
    set "expected_result=  world  "
    call :Input.string result
) & !evaluate_result! "keep spaces"

< "!tester.input!.semicolon" > nul 2>&1 (
    set "expected_result=; pass"
    call :Input.string result
) & !evaluate_result! "ignore semicolon EOL"

< "!tester.input!.empty" > nul 2>&1 (
    set "expected_result=hello"
    call :Input.string result --filled
) & !evaluate_result! "ignore null"

REM < "!tester.input!.spaced" > nul 2>&1 (
    REM set "expected_result=world"
    REM call :Input.string result --trim
REM ) & !evaluate_result! "trim spaces [WIP]"

if not "!errors!" == "0" exit /b !tester.exit.failed!
exit /b !tester.exit.passed!


:tests.lib.Input.string.evaluate_result
if not "!result!" == "!expected_result!" (
    echo [failed] %~1   "!result!" == "!expected_result!"
    set /a "errors+=1"
)
exit /b

rem ======================== function ========================

:Input.string   variable_name  [description]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_require_filled _trim_spaces) do set "%%v="
set "_description=Input %~1: "
set parse_args.args= ^
    "-d --description   :var:_description" ^
    "-f --filled        :flag:_require_filled=true"
rem     "-t --trim      :flag:_trim_spaces=true"
call :parse_args %* || exit /b 1
:Input.string.loop
echo=
set "user_input="
echo=!_description!
set /p "user_input="
if defined _trim_spaces (
    set "user_input=!user_input!."
    for /f tokens^=*^ eol^= %%a in ("!user_input!") do set "user_input=%%a"
    rem for /l %%a in (1,1,100) do if "!input:~-1!"==" " set input=!input:~0,-1!
    set "user_input=!user_input:~0,-1!"
)
if defined _require_filled if not defined user_input goto Input.string.loop
for /f tokens^=*^ delims^=^ eol^= %%c in ("!user_input!") do (
    endlocal
    set "%~1=%%~c"
    if not defined %~1 exit /b 1
)
exit /b 0

rem ======================== notes ========================

rem Trimming
set "user_input=!user_input!."
rem Process string / trim
for /f "tokens=* delims= " %%a in ("!user_input!") do (
    endlocal
    set "%~1=%%b"
    if /i "%user_input%" == "Y" exit /b 0
)

rem ================================ Input yes/no ================================
$ Function shortcuts Input.yesno

rem ======================== demo ========================

:Input.yesno.__demo__
echo Prompt for yes or no
echo=
echo Options:
echo -y, --yes ^<value^>        Value to return if user enters 'Y'
echo -n, --no  ^<value^>        Value to return if user enters 'N'
echo=
echo Behavior:
echo - If -y is not specified, it defaults to 'Y'
echo - If -n is not specified, it defaults to 'N'
echo=
echo Note:
echo - Function will set errorlevel to 0 if user enters 'Y'
echo - Function will set errorlevel to 1 if user enters 'N'
echo=
call :Input.yesno your_ans --description "Do you like programming? Y/N? " && (
    echo Its a yes^^!
) || echo Its a no...
echo Your input: !your_ans!

call :Input.yesno your_ans --description "Is it true? Y/N? " --yes "true" --no "false"
echo Your input ("true", "false"): !your_ans!

call :Input.yesno your_ans --description "Do you like to eat? Y/N? " --yes="Yes" --no="No"
echo Your input ("Yes", "No"): !your_ans!

call :Input.yesno your_ans --description "Do you excercise? Y/N? " -y "1" -n "0"
echo Your input ("1", "0"): !your_ans!

call :Input.yesno your_ans --description "Is this defined? Y/N? " -y="Yes" -n=""
echo Your input ("Yes", ""): !your_ans!
goto :EOF

rem ======================== function ========================

:Input.yesno   variable_name  [--description=<description>]  [--yes=<value>]  [--no=<value>]
setlocal EnableDelayedExpansion EnableExtensions
set "_description=Y/N? "
set "yes.value=Y"
set "no.value=N"
set parse_args.args= ^
    "-d --description   :var:_description" ^
    "-y --yes           :var:yes.value" ^
    "-n --no            :var:no.value"
call :parse_args %*
:Input.yesno.loop
echo=
set /p "user_input=!_description!"
if /i "!user_input!" == "Y" goto Input.yesno.convert
if /i "!user_input!" == "N" goto Input.yesno.convert
goto Input.yesno.loop
:Input.yesno.convert
set "_result="
if /i "!user_input!" == "Y" set "_result=!yes.value!"
if /i "!user_input!" == "N" set "_result=!no.value!"
if defined _result (
    for /f tokens^=*^ delims^=^ eol^= %%a in ("!_result!") do (
        endlocal
        set "%~1=%%a"
        if /i "%user_input%" == "Y" exit /b 0
    )
) else (
    endlocal
    set "%~1="
    if /i "%user_input%" == "Y" exit /b 0
)
exit /b 1

rem ======================== function old ========================

:Input.yesnoa   [-b|-t|-u|-s] [-d]  variable_name  [description]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_truth  _binary  _unshortened _sign _defined) do set "%%v="
set parse_args.args= ^
    "-b --binary        :flag:_binary=true" ^
    "-t --truth         :flag:_truth=true" ^
    "-u --unshortened   :flag:_unshortened=true" ^
    "-s --sign          :flag:_sign=true" ^
    "-d --defined       :flag:_defined=true"
call :parse_args %*
:Input.yesno.loopa
echo=
if "%~2" == "" (
    set /p "user_input=%~1? Y/N? "
) else set /p "user_input=%~2"
if /i "!user_input!" == "Y" goto Input.yesno.convert
if /i "!user_input!" == "N" goto Input.yesno.convert
goto Input.yesno.loop
:Input.yesno.converta
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
$ Function shortcuts Input.path

rem ======================== demo ========================

:Input.path.__demo__
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
call :Input.path config_file --exist --file  "Input an existing file: "
echo Result: !config_file!
pause
call :Input.path --optional folder -d "Input an existing folder or a new folder name: "
echo Result: !folder!
pause
call :Input.path new_name -o --not-exist "Input a non-existing file/folder: "
echo Result: !new_name!
pause
goto :EOF

rem ======================== function ========================

:Input.path  [-o] [-e|-n] [-d|-f] [-p] variable_name  [description]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_is_optional  _require_attrib  _require_exist _prompt_only) do set "%%v="
set parse_args.args= ^
    "-o --optional      :flag:_is_optional=true" ^
    "-e --exist         :flag:_require_exist=true" ^
    "-n --not-exist     :flag:_require_exist=false" ^
    "-f --file          :flag:_require_attrib=-" ^
    "-d --directory     :flag:_require_attrib=d"
call :parse_args %*
set "_options="
if /i "!_require_exist!"  == "true" set "_options=!_options! -e"
if /i "!_require_exist!"  == "false" set "_options=!_options! -n"
if /i "!_require_attrib!"  == "-" set "_options=!_options! -f"
if /i "!_require_attrib!"  == "d" set "_options=!_options! -d"
:Input.path.loop
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
if not defined user_input goto Input.path.loop
if defined last_used.file   if /i "!user_input!" == ":P" set "user_input=!last_used.file!"
if defined _is_optional     if /i "!user_input!" == ":S" set "user_input="
if defined user_input call :check_path user_input !_options! || (
    pause
    goto Input.path.loop
)
for /f "tokens=* eol= delims=" %%c in ("!user_input!") do (
    endlocal
    set "%~1=%%c"
    set "last_used.file=%%c"
)
exit /b 0

rem ================================ Input IPv4 ================================
$ Function shortcuts Input.ipv4

rem ======================== demo ========================

:Input.ipv4.__demo__
echo Input a valid IPv4
echo=
echo Options:
echo -w, --allow-wildcard   Allow wildcards in IPv4 address
echo=
call :Input.ipv4 -w your_ip
echo Your input: !your_ip!
goto :EOF

rem ======================== function ========================

:Input.ipv4   [-w]  variable_name  [description]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_allow_wildcard) do set "%%v="
set parse_args.args= ^
    "-w --allow-wildcard    :flag:_allow_wildcard=true"
call :parse_args %*
:Input.ipv4.loop
if "%~2" == "" (
    if defined _allow_wildcard (
        set /p "user_input=Input %~1 (Wildcard allowed, 0. Back): "
    ) else set /p "user_input=Input %~1 (0. Back): "
) else set /p "user_input=%~2"
echo=
if not defined user_input goto Input.ipv4.loop
if "!user_input!" == "0" exit /b 1
call :check_ipv4 "!user_input!" || exit /b 1
exit /b 0

rem ======================================== Batch Script Library ========================================
:lib.__init__     Collection of Functions
exit /b 0

rem ================================ GUIDES ================================

rem Variable names: [A-Za-Z_][A-Za-z0-9_.][A-Za-z0-9]
rem - Starts with an alphabet or underscore
rem - Only use alphabets, numbers, underscores, dashes, and dots
rem - Ends with an alphabet, underscore, or number
rem - Use variable names as a namespace

rem What parameter means:
rem variable_name: the name of variable of the input
rem return_var: the name of variable to write the result
rem variable: also refers to variable_name
rem integer: whole number from -2147483647 to 2147483647, no decimals '.' allowed
rem          sometimes hexadecimal and octal can be used
rem minimum/min: integer, usually for range
rem maximum/max: integer, usually for range
rem power: integer, usually for math functions (e.g.: 2^n)
rem time: formatted as HH:mm:ss.CC (C means 1/100 of a second or called centiseconds)
rem date: formatted as MM/dd/yyyy
rem milliseconds: unit of time, stored as integer
rem charset: character set or list of characters
rem external: something that is stored in other files

rem Note:
rem - Most functions assumes that the syntax is valid
rem - library functions MUST NOT have external dependencies
rem   (e.g. this is not allowed: call %batchlib%:rand 1 9)
rem - framework functions may have external dependencies
rem   (e.g. this is allowed: call %batchlib%:rand 1 9)

rem ========================================================================

rem ================================ rand() ================================
$ Function math rand

rem ======================== function ========================

:rand.__demo__
echo Generate random number within a range
echo=
echo Note:
echo - Does not generate uniform random numbers (modulo bias)
echo=
call :Input.number minimum "" "0~2147483647"
call :Input.number maximum "" "0~2147483647"
call :rand random_int !minimum! !maximum!
echo=
echo Random Number  : !random_int!
goto :EOF

rem ======================== function ========================

:rand   return_var  minimum  maximum
set /a "%~1=((!random!<<16) + (!random!<<1) + (!random!>>14)) %% ((%~3)-(%~2)+1) + (%~2)"
exit /b 0

rem ======================== notes ========================

rem Generate random number from -2^31 to 2^31-1:
set /a "%~1=(!random!<<17 + !random!<<2 + !random!>>13) %% ((%~3)-(%~2)+1) + (%~2)"

rem ================================ randw() ================================
$ Function math randw

rem ======================== demo ========================

:randw.__demo__
echo Generate random number based on weights
echo Random number generated is index number (starts from 0)
echo=
echo Note:
echo - Based on: rand()
echo - Does not generate uniform random numbers (modulo bias)
echo=
call :Input.string weights
call :randw !weights!
echo=
echo Random Number  : !return!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:yroot.__demo__
echo Calculate y root of x
echo=
call :Input.number number "" "0~2147483647"
call :Input.number power "" "0~2147483647"
call :yroot result !number! !power!
echo=
echo Root to the power of !power! of !number! is !result!
echo Result is round down
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:pow.__demo__
echo Calculate x to the power of n
echo=
echo Behavior:
echo - It will set errorlevel to 1 if result is too large (^> 2147483647)
echo=
call :Input.number number "" "0~2147483647"
call :Input.number power "" "0~2147483647"
call :pow result !number! !power!
echo=
echo !number! to the power of !power! is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:prime.__demo__
echo Test for prime number, returns factor if number is composite
echo Prime numbers: 2, 3, 5, 7, ..., 2147483587, 2147483629, 2147483647
echo=
echo Note:
echo - Based on: yroot()
echo=
call :Input.number number "" "0~2147483647"
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

rem ======================== function ========================

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

rem ======================== demo ========================

:gcf.__demo__
echo Calculate greatest common factor (GCF) of 2 numbers
echo=
echo Two largest number with GCF of 1: 1134903170 1836311903
echo=
call :Input.number number1 "" "0~2147483647"
call :Input.number number2 "" "0~2147483647"
call :gcf result !number1! !number2!
echo=
echo GCF of !number1! and !number2! is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:bin2int.__demo__
echo Convert binary to decimal
echo=
call :Input.string binary
call :bin2int result !binary!
echo=
echo The decimal value is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:int2bin.__demo__
echo Convert decimal to unsigned binary
echo=
call :Input.number decimal "" "0~2147483647"
call :int2bin result !decimal!
echo=
echo The binary value is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:int2oct.__demo__
echo Convert decimal to octal
echo=
call :Input.number decimal "" "0~2147483647"
call :int2oct result !decimal!
echo=
echo The octal value is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:int2hex.__demo__
echo Convert decimal to hexadecimal
echo=
call :Input.number decimal "" "0~2147483647"
call :int2hex result !decimal!
echo=
echo The hexadecimal value is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:int2roman.__demo__
echo Convert number to roman numeral
echo=
call :Input.number number "" "0~4999"
call :int2roman result !number!
echo=
echo The roman numeral value is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:roman2int.__demo__
echo Convert roman numeral to number
echo=
call :Input.string roman_numeral
call :roman2int result !roman_numeral!
echo=
echo The decimal value is !result!
goto :EOF

rem ======================== function ========================

:roman2int   return_var  roman_numeral
set "%~1=%~2"
for %%r in (
    IV.4 XL.40 CD.400 IX.9 XC.90 CM.900 I.1 V.5 X.10 L.50 C.100 D.500 M.1000
) do set "%~1=!%~1:%%~nr=+%%~xr!"
set /a "%~1=!%~1:.=!"
exit /b 0

rem ================================ strlen() ================================
$ Function string strlen

rem ======================== demo ========================

:strlen.__demo__
echo Calculate string length
echo=
call :Input.string string
call :strlen length string
echo=
echo The length of the string is !length! characters
goto :EOF

rem ======================== function ========================

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
$ Function string to_upper

rem ======================== demo ========================

:to_upper.__demo__
echo Convert string to uppercase
echo=
call :Input.string string
call :to_upper string
echo=
echo Uppercase:
echo=!string!
goto :EOF

rem ======================== function ========================

:to_upper   variable_name
set "%1= !%1!"
for %%a in (
    A B C D E F G H I J K L M
    N O P Q R S T U V W X Y Z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0

rem ======================================= to_lower() ================================
$ Function string to_lower

rem ======================== demo ========================

:to_lower.__demo__
echo Convert string to lowercase
echo=
call :Input.string string
call :to_lower string
echo=
echo Lowercase:
echo=!string!
goto :EOF

rem ======================== function ========================

:to_lower   variable_name
set "%1= !%1!"
for %%a in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0

rem ======================================= to_capital() ================================
$ Function string to_capital

rem ======================== demo ========================

:to_capital.__demo__
echo Convert string to capitalcase
echo=
call :Input.string string
call :to_capital string
echo=
echo Capitalcase:
echo=!string!
goto :EOF

rem ======================== function ========================

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
$ Function string strip_dquotes

rem ======================== demo ========================

:strip_dquotes.__demo__
echo Remove surrounding double quotes
echo=
call :Input.string string
call :strip_dquotes string
echo=
echo Stripped : !string!
goto :EOF

rem ======================== function ========================

:strip_dquotes   variable_name
if "!%~1:~0,1!!%~1:~-1,1!" == ^"^"^"^" set "%~1=!%~1:~1,-1!"
exit /b 0

rem ================================ shuffle() ================================
$ Function string shuffle

rem ======================== demo ========================

:shuffle.__demo__
echo Shuffle characters in a string
echo=
echo Dependencies:
echo - strlen()
echo=
call :Input.string text
call :shuffle text
echo=
echo Shuffled string:
echo=!text!
goto :EOF

rem ======================== function ========================

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
$ Function string strval

rem ======================== demo ========================

:strval.__demo__
echo Determine the integer value of a variable
echo=
call :Input.string string
call :strval result string
echo=
echo Integer value : !result!
goto :EOF

rem ======================== function ========================

:strval   return_var  variable_name
set /a "%~1=0x80000000"
for /l %%i in (31,-1,0) do (
    set /a "%~1+=0x1<<%%i"
    if !%~2! LSS !%~1! set /a "%~1-=0x1<<%%i"
)
goto :EOF

rem ================================ difftime() =======================================
$ Function time difftime

rem ======================== demo ========================

:difftime.__demo__
echo Calculate difference of start time and end time in centiseconds
echo If start_time is not defined then 00:00:00.00 is taken
echo=
echo Options:
echo -n     Don't fix negative centiseconds
echo=
call :Input.string start_time
call :Input.string end_time
call :difftime time_taken !end_time! !start_time!
echo=
echo Time difference: !time_taken! centiseconds
goto :EOF

rem ======================== function ========================

:difftime   return_var  end_time  [start_time] [-n]
set "%~1=0"
for %%t in (%~2:00:00:00:00 %~3:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
    set /a "%~1+=24%%a %% 24 *360000 +1%%b*6000 +1%%c*100 +1%%d -610100"
    set /a "%~1*=-1"
)
if /i not "%4" == "-n" if "!%~1:~0,1!" == "-" set /a "%~1+=8640000"
exit /b 0

rem ================================ ftime() ================================
$ Function time ftime

rem ======================== demo ========================

:ftime.__demo__
echo Convert time (in centiseconds) to HH:mm:ss.CC format
echo=
call :Input.string time_in_centisecond
call :ftime time_taken !time_in_centisecond!
echo=
echo Formatted time : !time_taken!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:diffdate.__demo__
echo Calculate difference between 2 dates in days
echo=
echo Syntax:
echo - Date format is MM/dd/yyyy
echo=
echo Behavior:
echo - If start_date is not given, it is assumed to be 1/01/1970
echo=
call :Input.string start_date
call :Input.string end_date
call :diffdate difference !end_date! !start_date!
echo=
echo Difference : !difference! Days
goto :EOF

rem ======================== tests ========================

:tests.lib.diffdate.main
set "errors=0"
for %%a in (
    "0:  1/01/1970"
    
    "11017:  3/01/2000"
    "11382:  3/01/2001"
    "12478:  3/01/2004"
    
    "1:  1/01/2000 12/31/1999"
    "1:  1/01/2100 12/31/2099"
    "1:  1/01/2004 12/31/2003"
    "2:  3/01/2000  2/28/2000"
    "2:  3/01/2004  2/28/2004"
    "1:  3/01/2001  2/28/2001"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :diffdate result %%c
    if not "!result!" == "%%b" (
        set /a "errors+=1"
        echo [failed] %%~a
    )
)
if not "!errors!" == "0" exit /b !tester.exit.failed!
exit /b !tester.exit.passed!

rem ======================== function ========================

:diffdate   return_var  end_date  [start_date]
set "%~1="
setlocal EnableDelayedExpansion
set "_difference=0"
set "_args=/%~2"
if "%~3" == "" (
    set "_args=!_args! /1/01/1970"
) else set "_args=!_args! /%~3"
set "_args=!_args:/ =/!"
set "_args=!_args:/0=/!"
for %%d in (!_args!) do for /f "tokens=1-3 delims=/" %%a in ("%%d") do (
    set /a "_difference+= (%%c-1970)*365 + (%%c/4 - %%c/100 + %%c/400 - 477) + (%%a-1)*30 + %%a/2 + %%b"
    set /a "_leapyear=%%c %% 100"
    if "!_leapyear!" == "0" (
        set /a "_leapyear=%%c %% 400"
    ) else set /a "_leapyear=%%c %% 4"
    if "!_leapyear!" == "0" if %%a LEQ 2 set /a "_difference-=1"
    if %%a GTR 8 set /a "_difference+=%%a %% 2"
    if %%a GTR 2 set /a "_difference-=2"
    set /a "_difference*=-1"
)
for /f "tokens=*" %%r in ("!_difference!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================ fdate() ================================
.$ Function time fdate

rem ======================== demo ========================

:fdate.__demo__
echo Convert days since epoch (January 1, 1970) to date (MM/dd/yyyy)
echo=
call :Input.string days_since_epoch
call :fdate result !time_in_centisecond!
echo=
echo Formatted time : !result!
goto :EOF

rem ======================== tests ========================

::fdate.__tests__
::tests.lib.fdate.main
set "errors=0"
for %%a in (
    "01/01/1970: 0"
    
    "01/31/1970:  30"
    "02/01/1970:  31"
    
    "12/31/1999:  10956"
    "01/01/2000:  10957"
    "12/31/2000:  12417"
    "01/01/2003:  12417"
    "12/31/2003:  12417"
    "01/01/2004:  12418"
    
    "02/28/2000:  11015"
    "03/01/2000:  11017"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :fdate result %%c
    if not "!result!" == "%%b" (
        set /a "errors+=1"
        echo [failed] %%~a
    )
)
if not "!errors!" == "0" exit /b !tester.exit.failed!
exit /b !tester.exit.passed!

    "02/28/2003:  12111"
    "03/01/2003:  12112"
    "02/28/2004:  12476"
    "03/01/2004:  12478"
    "02/28/2100:  47540"
    "03/01/2100:  47541"
    "02/28/2400: 157112"
    "03/01/2400: 157114"

rem ======================== function ========================

:fdate   return_var  days_since_epoch
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
set /a "_era=(%~2 + 135140) / 146097"
set /a "_doe=(%~2 + 135140) %% 146097"
set /a "_yoe=(!_doe! - !_doe!/1460 + !_doe!/36524 - !_doe!/146096) / 365"
set /a "_doy=!_doe! - !_yoe!*365 - (!_yoe!/4 - !_yoe!/100)"
set /a "_year=!_yoe! + !_era! * 400 + 1600"
set /a "_month=(!_doy! - !_doy!/30 + !_doy!/36524 - !_doy!/146096) / 30 + 1"
echo e: !_era! doe: !_doe! yoe: !_yoe! ### doy: !_doy!
echo Y: !_year! M: !_month!
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ======================== notes ========================

rem Month
(%%a-1)*30 + %%a/2 + %%b"
set /a "_leapyear=%%c %% 100"
if %%a GTR 8 set /a "_difference+=%%a %% 2"
if %%a GTR 2 set /a "_difference-=2"
set /a "_difference*=-1"

rem (!) WIP
rem http://howardhinnant.github.io/date_algorithms.html

rem ================================== what_day() ==================================
$ Function time what_day

rem ======================== demo ========================

:what_day.__demo__
echo Determine what day is a date
echo=
echo= Options:
echo= -n    Returns number value (0: Sunday, 1: Monday)
echo= -s    Returns short date name (first 3 letters)
echo=
echo Note:
echo - Requires: diffdate()
echo=
call :Input.string a_date
call :what_day day !a_date!
echo=
echo That day is !day!
goto :EOF

rem ======================== function ========================

:what_day   return_var  date  [-n|-s]
set "%~1="
setlocal EnableDelayedExpansion
call :diffdate _day "%~2" 1/01/1970
set /a _day=(!_day! + 4) %% 7
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

rem ================================== time2epoch() ==================================
$ Function time time2epoch

rem ======================== demo ========================

:time2epoch.__demo__
echo Calculate number of seconds since epoch (January 1, 1970)
echo=
echo Syntax:
echo - Time format is expressed as MM/dd/yyyy_HH:mm:ss
echo=
call :Input.string date_time
call :time2epoch result !date_time!
echo=
echo Seconds since epoch : !result! seconds
goto :EOF

rem ======================== tests ========================

:tests.lib.time2epoch.main
set "errors=0"
for %%a in (
    "0: 1/01/1970_00:00:00"
    
    "946684799:     12/31/1999_23:59:59"
    "946684800:      1/01/2000_00:00:00"
    "1072915199:    12/31/2003_23:59:59"
    "1072915200:     1/01/2004_00:00:00"
    
    "954287999:      3/28/2000_23:59:59"
    "951868800:      3/01/2000_00:00:00"
    "1048895999:     3/28/2003_23:59:59"
    "1046476800:     3/01/2003_00:00:00"
    "1080518399:     3/28/2004_23:59:59"
    "1078099200:     3/01/2004_00:00:00"
    
    "2147483647:     1/19/2038_03:14:07"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :time2epoch result %%c
    if not "!result!" == "%%b" (
        set /a "errors+=1"
        echo [failed] %%~a
    )
)
if not "!errors!" == "0" exit /b !tester.exit.failed!
exit /b !tester.exit.passed!

rem ======================== function ========================

:time2epoch   return_var  date_time
set "%~1="
setlocal EnableDelayedExpansion
for /f "tokens=1-2 delims=_" %%a in ("%~2") do (
    call :diffdate _days "%%a"
    call :difftime _seconds "%%b"
)
set /a "_epoch=!_days!*86400 + !_seconds!/100"
for /f "tokens=*" %%r in ("!_epoch!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0

rem ================================== epoch2time() ==================================
.$ Function time epoch2time

rem ======================== demo ========================

:epoch2time.__demo__
echo Convert epoch time to human readable format
echo=
echo Syntax:
echo - Time format is MM/dd/yyyy_HH:mm:ss
echo=
call :Input.string seconds_since_epoch
call :epoch2time result !seconds_since_epoch!
echo=
echo Formatted time: !result!
goto :EOF

rem ======================== tests ========================

::epoch2time.__tests__
::tests.lib.epoch2time.main
set "errors=0"
for %%a in (
    " 1/01/1970_00:00:00| 0"
    
    "12/31/1999_23:59:59| 946684799"
    " 1/01/2000_00:00:00| 946684800"
    "12/31/2003_23:59:59| 1072915199"
    " 1/01/2004_00:00:00| 1072915200"
    
    " 3/28/2000_23:59:59| 954287999"
    " 3/01/2000_00:00:00| 951868800"
    " 3/28/2003_23:59:59| 1048895999"
    " 3/01/2003_00:00:00| 1046476800"
    " 3/28/2004_23:59:59| 1080518399"
    " 3/01/2004_00:00:00| 1078099200"
    
    " 1/19/2038_03:14:07| 2147483647"
) do for /f "tokens=1* delims=|" %%b in (%%a) do (
    call :epoch2time result %%c
    if not "!result!" == "%%b" (
        set /a "errors+=1"
        echo [failed] %%~a
    )
)
if not "!errors!" == "0" exit /b !tester.exit.failed!
exit /b !tester.exit.passed!

rem ======================== function ========================

:epoch2time   return_var  date_time
set "%~1="
setlocal EnableDelayedExpansion
set /a "_days=%~2 / 86400"
set /a "_time=(%~2 %% 86400) * 100"
echo A: %*
echo D: !_days! T: !_time!
call :ftime _time "!_time!"
set "_result=!_days!_!_time:~0,-3!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
echo R: !%~1!
exit /b 0

rem ================================== timeleft() ==================================
$ Function time timeleft

rem ======================== demo ========================

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

rem ======================== function ========================

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

rem ======================== demo ========================

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
call :Input.number time_in_milliseconds "" "0~10000"
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

rem ======================== function ========================

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

rem ======================== demo ========================

:sleep.__demo__
echo Delay for n milliseconds
echo This function have high CPU usage for maximum of 2 seconds on each call
echo=
echo Dependencies:
echo - wait()
echo - wait.calibrate()
echo=
echo Note:
echo - This function have high CPU usage for maximum of 2 seconds on each call
echo=
echo function unavailable: still under development (WIP)
goto :EOF
call :wait.calibrate 500
echo=
call :Input.number time_in_milliseconds "" "0~2147483647"
echo=
echo Sleep for !time_in_milliseconds! milliseconds...
set "start_time=!time!"
call :sleep !time_in_milliseconds!
call :difftime time_taken !time! !start_time!
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
goto :EOF

rem ======================== function ========================

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

rem ================================ check_number() ================================
$ Function formatting check_number

rem ======================== demo ========================

:check_number.__demo__
echo Check if a number is within the specified range
echo=
echo=
call :Input.string number
call :Input.string range
echo=
call :check_number "!number!" "!range!" && (
    echo Number is within range
) || echo Number is not within range
goto :EOF

rem ======================== function ========================

:check_number   number  ["<num|min~max>[, ...]"]
if "%~1" == "" exit /b 1
setlocal EnableDelayedExpansion
set "_temp=%~2"
if not defined _temp set "_temp=0x80000001~0x7fffffff"
set "_range="
for %%r in (!_temp!) do for /f "tokens=1,2 delims=~ " %%a in ("%%~r") do (
    for %%n in (%%a %%b) do (
        set "_evaluated="
        set /a "_evaluated=%%n" || ( 1>&2 echo error: invalid range '%%n' & exit /b 1 )
        set /a "_evaluated=!_evaluated!" || ( 1>&2 echo error: invalid range '%%n' & exit /b 1 )
        set "_range=!_range!!_evaluated!~"
    )
    set "_range=!_range:~0,-1!, "
)
if not defined _range 1>&2 echo error: invalid range & exit /b 1
set "_range=!_range:~0,-2!"
set "_input=%~1"
for /f "tokens=1-3 delims= " %%a in ("a !_input!") do (
    if "%%b" == "" exit /b 1
    if not "%%c" == "" exit /b 1
)
set "_input=!_input: =!"
set "_temp=!_input! "
set "_input="
if "!_temp:~0,1!" == "-" (
    set "_temp=!_temp:~1!"
    set "_input=-"
)
if /i "!_temp:~0,2!" == "0x" (
    set "_temp=!_temp:~2!"
    if not "!_temp:~9!" == "" exit /b 1
    set "_input=!_input!0x"
    set "valid_values=0 1 2 3 4 5 6 7 8 9 A B C D E F"
) else set "valid_values= 0 1 2 3 4 5 6 7 8 9"
if "!_temp!" == " " exit /b 1
for /f "tokens=1* delims=0" %%a in ("a0!_temp!") do set "_temp=%%b"
if "!_temp!" == " " set "_temp=0 "
set "_input=!_input!!_temp!"
for %%c in (!valid_values!) do set "_temp=!_temp:%%c=!"
if not "!_temp!" == " " exit /b 1
set "_evaluated="
set /a "_evaluated=!_input!" || exit /b 1
set /a "_input=!_evaluated!" || exit /b 1
for %%r in (!_range!) do for /f "tokens=1,2 delims=~ " %%a in ("%%~r") do (
    if "%%b" == "" if "!_input!" == "%%a" exit /b 0
    set "_invalid="
    if %%b LSS 0 if !_input! GEQ 0 set "_invalid=true"
    if %%a GEQ 0 if !_input! LSS 0 set "_invalid=true"
    if !_input! LSS %%a set "_invalid=true"
    if !_input! GTR %%b set "_invalid=true"
    if not defined _invalid exit /b 0
)
exit /b 1

rem ======================== notes ========================

rem Comparison v2
if %%b LSS 0 if !_input! GEQ 0 exit /b 1
if %%a GEQ 0 if !_input! LSS 0 exit /b 1
if !_input! LSS %%a exit /b 1
if !_input! GTR %%b exit /b 1


rem Comparison v1
if !min! LEQ !_input! (
    if !_input! LEQ !max! exit /b 0
    if !max! GEQ 0 if !_input! LSS 0 exit /b 0
)
if !min! LSS 0 if !_input! GEQ 0 (
    if !_input! LEQ !max! exit /b 0
    if !max! GEQ 0 if !_input! LSS 0 exit /b 0
)

rem ================================ check_ipv4() ================================
$ Function net check_ipv4

rem ======================== demo ========================

:check_ipv4.__demo__
echo Check if a number is within the specified range
echo=
echo=
call :Input.string ip_address
echo=
call :check_ipv4 "!ip_address!" && (
    echo IP is valid
) || echo IP is invalid
goto :EOF

rem ======================== function ========================

:check_ipv4   ipv4
setlocal EnableDelayedExpansion
set "_input=%~1"
if not "!_input:..=!" == "!_input!" exit /b 1
if not "!_input:x=!" == "!_input!" exit /b 1
for /f "tokens=5 delims=." %%a in ("!_input!") do if not "%%a" == "" exit /b 1
set _input=!_input:.=^
%=REQURED=%
!
for /f "tokens=*" %%n in ("!_input!") do (
    if "%%n" == "*" (
        if not defined _allow_wildcard exit /b 1
    ) else (
        set "_evaluated="
        set /a "_evaluated=%%n" 2> nul || exit /b 1
        set /a "_num=!_evaluated!" 2> nul || exit /b 1
        if not "!_num!" == "%%n" exit /b 1
        if %%n LSS 0    exit /b 1
        if %%n GTR 255  exit /b 1
    )
)
exit /b 0

rem ================================ check_path() ================================
$ Function file check_path

rem ======================== demo ========================

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

call :Input.string config_file "Input an existing file: "
call :check_path --exist --file config_file && (
    echo Your input is valid
) || echo Your input is invalid

call :Input.string folder "Input an existing folder or a new folder name: "
call :check_path --directory folder && (
    echo Your input is valid
) || echo Your input is invalid

call :Input.string new_name "Input an existing folder or a new folder name: "
call :check_path --not-exist new_name && (
    echo Your input is valid
) || echo Your input is invalid
goto :EOF

rem ======================== function ========================

:check_path   variable_name  [-e|-n]  [-d|-f]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_require_attrib  _require_exist) do set "%%v="
set parse_args.args= ^
    "-e --exist     :flag:_require_exist=true" ^
    "-n --not-exist :flag:_require_exist=false" ^
    "-f --file      :flag:_require_attrib=-" ^
    "-d --directory :flag:_require_attrib=d"
call :parse_args %*
set "_path=!%~1!"
if "!_path:~0,1!!_path:~-1,1!" == ^"^"^"^" set "_path=!_path:~1,-1!"
if "!_path:~-1,1!" == ":" set "_path=!_path!\"
for /f tokens^=1-2*^ delims^=?^"^<^>^| %%a in ("_?_!_path!_") do if not "%%c" == "" 1>&2 echo Invalid path & exit /b 1
for /f "tokens=1-2* delims=*" %%a in ("_*_!_path!_") do if not "%%c" == "" 1>&2 echo Wildcards are not allowed & exit /b 1
rem (!) Can be improved
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
for /f "tokens=* delims=" %%c in ("!_path!") do (
    endlocal
    set "%~1=%%c"
)
exit /b 0

rem ======================== notes ========================

rem Path invalid characters:
rem <>|?*":\/

rem if : is the 2nd character, it will add backslash after it if 3rd is not
rem if path starts with 'C:' and not followed by '\' it will replace 'C:' with the script's initial cwd
rem :"<>| are treated as normal characters
rem * and ? is treated as wildcard

rem ================================ wcdir() ================================
$ Function file wcdir

rem ======================== demo ========================

:wcdir.__demo__
echo List files/folders with wildcard path
echo=
echo Options:
echo -f     Search for file only
echo -d     Search for directory only

echo - Requires: capchar(LF)
call :Input.string wildcard_path
call :strip_dquotes wildcard_path
call :wcdir result "!wildcard_path!"
echo=
echo Found List:
echo=!result!
goto :EOF

rem ======================== variations ========================

:combi_wcdir   [-f|-d]  [-s]  return_var  file_path_part1  [file_path_part2 [...]]
setlocal EnableDelayedExpansion EnableExtensions
set "_list_dir=true"
set "_list_file=true"
set "_semicolon="
set parse_args.args= ^
    "-f --file      :flag:_list_dir=" ^
    "-d --directory :flag:_list_file=" ^
    "-s --semicolon :flag:_semicolon=true"
call :parse_args %*
set "_path1=%~2"
set "_path2=%~3"
for %%v in (_path1 _path2) do (
    set "%%v=!%%v:/=\!"
    set ^"%%v=!%%v:;=%NL%!^"
    set "_temp="
    for /f "tokens=* delims=" %%a in ("!%%v!") do (
        set "_is_listed="
        for /f "tokens=*" %%b in ("!_temp!") do if "%%a" == "%%b" set "_is_listed=true"
        if not defined _is_listed set "_temp=!_temp!%%a!LF!"
    )
    set "%%v=!_temp!"
)
set "_found="
for /f "tokens=* delims=" %%a in ("!_path1!") do for /f "tokens=* delims=" %%b in ("!_path2!") do (
    set "_result="
    pushd "!temp!"
    call :wcdir.find "%%a\%%b"
    set "_found=!_found!!_result!"
)
set "_result="
for /f "tokens=* delims=" %%a in ("!_found!") do (
    set "_is_listed="
    for /f "tokens=*" %%b in ("!_result!") do if "%%a" == "%%b" set "_is_listed=true"
    if not defined _is_listed set "_result=!_result!%%a!LF!"
)
if defined _result (
    set "%~1="
    for /f "tokens=* delims=" %%r in ("!_result!") do (
        if not defined %~1 (
            endlocal
            set "%~1="
        )
        if "%_semicolon%" == "" (
            set "%~1=!%~1!%%r!LF!"
        ) else set "%~1=!%~1!%%r;"
    )
) else (
    endlocal
    set "%~1="
)
exit /b 0

rem ======================== function ========================

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
for /f "tokens=* delims=" %%r in ("!_result!") do (
    if not defined %~1 endlocal
    set "%~1=!%~1!%%r!LF!"
)
exit /b 0
:wcdir.find
for /f "tokens=1* delims=\" %%a in ("%~1") do if "%%a" == "*:" (
    for %%l in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do pushd "%%l:\" 2> nul && call :wcdir.find "%%b"
) else if "%%b" == "" (
    if defined _list_dir dir /b /a:d "%%a" > nul 2> nul && ( for /d %%f in ("%%a") do set "_result=!_result!%%~ff!LF!" )
    if defined _list_file dir /b /a:-d "%%a" > nul 2> nul && ( for %%f in ("%%a") do set "_result=!_result!%%~ff!LF!" )
) else for /d %%f in ("%%a") do pushd "%%f\" 2> nul && call :wcdir.find "%%b"
popd
exit /b

rem ================================ expand_path() ================================
$ Function file expand_path

rem ======================== demo ========================

:expand_path.__demo__
echo Expands given path to:
echo [D]rive letter, [A]ttributes, [T]ime stamp, si[Z]e,
echo [N]ame, e[X]tension, [P]ath, [F]ull path
echo=
call :Input.string path_string
call :expand_path path_string "!path_string!"
set path_string
goto :EOF

rem ======================== function ========================

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

rem ======================== notes ========================

rem Expand multiple paths to a prefix

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

rem ======================== demo ========================

:unzip.__demo__
echo Unzip files (VBScript hybrid)
echo=
call :Input.string zip_file
echo=
call :unzip "!zip_file!" "."
echo=
echo Done
goto :EOF

rem ======================== function ========================

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

rem ======================== notes ========================

rem (!) MsgBox?

rem ================================ checksum() ================================
$ Function file checksum

rem ======================== demo ========================

:checksum.__demo__
echo Calculate checksum of file
echo=
echo Available checksums:
echo - MD2, MD4, MD5
echo - SHA1, SHA256, SHA512
echo=
echo SHA1 will be used if function called
echo without specifying checksum type
echo=
echo Press any key to try it...
pause > nul
echo=
call :Input.path file_path
call :Input.string checksum_type
if defined checksum_type set "checksum_type=--!checksum_type!"
call :checksum checksum !checksum_type! "!file_path!"
echo=
echo Checksum: !checksum!
goto :EOF

rem ======================== function ========================

:checksum   return_var  file_path  [--<MD2|MD4|MD5|SHA1|SHA256|SHA512>]
set "%~1="
setlocal EnableDelayedExpansion EnableExtensions
set "_algorithm="
set "_argc=1"
for %%a in (%*) do (
    set "_set_cmd="
    for %%f in (
        MD2 MD4 MD5
        SHA1 SHA256 SHA512
    ) do if /i "--%%f" == "%%a" set "_set_cmd=_algorithm=%%f"
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

rem ======================== notes ========================

rem (!) Improve argument parsing

rem ================================ diffbin() ================================
$ Function file diffbin

rem ======================== demo ========================

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
call :Input.path --exist --file file1
call :Input.path --exist --file file2
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

rem ======================== function ========================

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

rem ======================== demo ========================

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
call :Input.string web_url || set "web_url=https://news.example.com:80/1970/01/index.html?view=full#part2"
call :expand_link web_url "!web_url!"
set web_url
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

:get_ext_ip.__demo__
echo Get external IP address (PowerShell hybrid)
echo=
call :get_ext_ip ext_ip
echo=
echo External IP    : !return!
goto :EOF

rem ======================== function ========================

:get_ext_ip   return_var
> nul 2> nul (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('http://ipecho.net/plain', '!temp!\ip.txt')"
) || exit /b 1
for /f "usebackq tokens=*" %%o in ("!temp!\ip.txt") do set "%~1=%%o"
del /f /q "!temp!\ip.txt"
exit /b 0

rem ================================ download_file() ================================
$ Function net download_file

rem ======================== demo ========================

:download_file.__demo__
echo Download file from the internet
echo=
echo Features:
echo - PowerShell hybrid
echo - Download is buffered to disk
echo=
echo For this demo, file will be saved to "!cd!"
echo Enter nothing to download laravel v4.2.11 (41 KB)
echo=
call :Input.string download_url || set "download_url=https://codeload.github.com/laravel/laravel/zip/v4.2.11"
call :Input.string save_path || set "save_path=download"
echo=
echo Download url:
echo=!download_url!
echo=
echo Save path:
echo=!download_url!
echo=
echo Downloading file...
call :download "!download_url!" download || echo Download failed
goto :EOF

rem ======================== function ========================

:download_file   link  save_path
if exist "%~2" del /f /q "%~2"
if not exist "%~dp2" md "%~dp2"
powershell -Command "(New-Object Net.WebClient).DownloadFile('%~1', '%~2')"
if not exist "%~2" exit /b 1
exit /b 0

rem ======================== notes ========================

rem Alternative command, but blocked by windows defender
certutil -urlcache -split -f "%~2" "!_save_path!\!_filename!"

rem FTP download
ftp ftp.somesite.com
user
password

rem ================================ get_con_size() ================================
$ Function env get_con_size

rem ======================== demo ========================

:get_con_size.__demo__
echo Get console screen buffer size
call :get_con_size console_width console_height
echo=
echo Screen buffer size    : !console_width!x!console_height!
goto :EOF

rem ======================== function ========================

:get_con_size   return_var_width  return_var_height
setlocal EnableDelayedExpansion
set "_index=0"
for /f "usebackq tokens=2 delims=:" %%a in (`call ^| mode con`) do (
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

rem executing 'mode con' causes input stream to be flushed
rem this will cause tests that uses file as input stream to fail
rem calling it asynchronously from pipe will prevent this

rem ================================ get_sid() ================================
$ Function env get_sid

rem ======================== demo ========================

:get_sid.__demo__
echo Get currect user's SID
echo=
call :get_sid result
echo=
echo User SID : !result!
goto :EOF

rem ======================== function ========================

:get_sid   return_var
set "%~1="
for /f "tokens=2" %%s in ('whoami /user /fo table /nh') do set "%~1=%%s"
exit /b 0

rem ================================ get_os() ================================
$ Function env get_os

rem ======================== demo ========================

:get_os.__demo__
echo Get OS version
echo=
echo Options:
echo -n  Returns OS name
echo=
call :get_os result -n
echo Your OS is !result!
goto :EOF

rem ======================== function ========================

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

rem ======================== demo ========================

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

rem ======================== function ========================

:get_pid
for /f %%g in ('powershell -command "$([guid]::NewGuid().ToString())"') do (
    for /f "usebackq tokens=*" %%a in (
        `wmic process where "name='cmd.exe' and CommandLine like '%% get_pid %%g %%'" get ParentProcessID`
    ) do for %%b in (%%a) do set "%~1=%%b"
)
exit /b 0

rem ======================== notes ========================

rem Pure batch script version
::get_pid
for /f "usebackq tokens=*" %%a in (
    `wmic process where "name='cmd.exe' and CommandLine like '%% get_pid %random% %%'" get ParentProcessID`
) do for %%b in (%%a) do set "%~1=%%b"
exit /b 0

rem ================================ watchvar() ================================
$ Function env watchvar

rem ======================== demo ========================

:watchvar.__demo__
echo Watch for new, deleted and changed variables in batch script
echo=
echo Options:
echo -i, --initialize   Initialize variable list
echo -l, --list         Display variable names
echo=
echo Note:
echo - watchvar can only compare the first 3840 characters for very long variables
echo=
call :watchvar --initialize
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
    call :watchvar --list
    pause > nul
)
goto :EOF

rem ======================== function ========================

:watchvar   [-i]  [-l]
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
set parse_args.args= ^
    "-i --initialize    :flag:_init_only=true" ^
    "-l --list          :flag:_list_names=true"
call :parse_args %*

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

rem ======================== demo ========================

:check_admin.__demo__
echo Check for administrator privilege
echo=
echo Exit Codes:
echo    0: Administrator privilege detected
echo    1: No administrator privilege detected
echo=
call :check_admin && (
    echo Administrator privilege detected
) || echo No administrator privilege detected
goto :EOF

rem ======================== function ========================

:check_admin
(net session || openfiles) > nul 2> nul || exit /b 1
exit /b 0

rem ================================ endlocal() ================================
$ Function env endlocal

rem ======================== demo ========================

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

rem ======================== function ========================

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

rem ================================ capchar() ================================
$ Function formatting capchar

rem ======================== demo ========================

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

rem ======================== function ========================

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

rem ======================== notes ========================

rem New Line (DisableDelayedExpansion)
set ^"NL=^^^%LF%%LF%^%LF%%LF%^"

rem Other characters
set DQ="
set "EM=^!"
set EM=^^!

rem ================================ hex2char(WIP) ================================
.$ Function formatting hex2char

rem ======================== demo ========================

:hex2char.__demo__
echo Generate characters from hex code
echo=
echo Used to generate extended characters
echo=
call :hex2char
goto :EOF

rem ======================== function ========================

:hex2char   return_var1:char_hex1  [return_var2:char_hex2 [...]]
setlocal EnableDelayedExpansion
if not defined temp_path set "temp_path=!temp!"
if not exist "!temp_path!" md "!temp_path!"
certutil
for /f "tokens=* delims=" %%f in ("!_result!") do (
    endlocal
    calL "%%r"
)
exit /b 0

rem ================================ color2seq() ================================
$ Function formatting color2seq

rem ======================== demo ========================

:color2seq.__demo__
echo Convert hexadecimal color to ANSI escape sequence
echo Used for color print in windows 10
echo=
call :Input.string hexadecimal_color
call :color2seq color_code "!hexadecimal_color!"
echo=
echo Sequence: !color_code!
echo Color print: !ESC!!color_code!Hello World!ESC![0m
goto :EOF

rem ======================== function ========================

:color2seq   return_var  <background><foreground>
set "%~1=%~2"
set "%~1=[!%~1:~0,1!;!%~1:~1,1!m"
for %%t in (
    0--40-30  1--44-34  2--42-32  3--46-36 
    4--41-31  5--45-35  6--43-33  7--47-37
    8-100-90  9-104-94  A-102-92  B-106-96
    C-101-91  D-105-95  E-103-93  F-107-97
) do for /f "tokens=1-3 delims=-" %%a in ("%%t") do (
    set "%~1=!%~1:[%%a;=[%%b;!"
    set "%~1=!%~1:;%%am=;%%cm!"
)
exit /b 0

rem ================================ setup_clearline() ================================
$ Function formatting setup_clearline

rem ======================== demo ========================

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

rem ======================== function ========================

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
$ Function formatting color_print

rem ======================== demo ========================

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
call :Input.string text
call :Input.string foreground_color
call :Input.string background_color
echo=
call :color_print "!background_color!!foreground_color!" "!text!" && (
    echo !LF!Print Success
) || echo !LF!Print Failed. Characters not supported, or external error occured
goto :EOF

rem ======================== function ========================

:color_print   color  text
(
    pushd "!temp_path!" || exit /b 1
     < nul set /p "=!DEL!!DEL!" > "%~2_"
    findstr /l /v /a:%~1 "." "%~2_" nul
    del /f /q "%~2_" > nul
    popd
) 2> nul
exit /b 0

rem ================================ fix_eol() ================================
$ Function env fix_eol

rem ======================== demo ========================

:fix_eol.__demo__
echo Convert EOL of the script to CRLF
echo=
echo Exit Codes:
echo    0: Success / not necessary
echo    1: Failed
echo=
echo Note:
echo - In rare cases, the script cannot find the function, but it fixed by 
echo   moving the function few lines away from where you initially put it.
echo - Function will not work if it is put in an external file
echo=
echo Fixing EOL...
for %%n in (1 2) do call :fix_eol.alt%%n fix_eol.__demo__.success && (
    echo Fix not necessary
) else echo Fix failed
goto :EOF
:fix_eol.__demo__.success
echo EOL fixed
goto :EOF

rem ======================== function ========================

:fix_eol   goto_label
:fix_eol.alt1
rem THIS IS REQUIRED
:fix_eol.alt2
for %%n in (1 2) do call :check_win_eol.alt%%n --check-exist 2> nul && (
    call :check_win_eol.alt%%n || (
        echo Converting EOL...
        type "%~f0" | more /t4 > "%~f0.tmp" && (
            move "%~f0.tmp" "%~f0" > nul && (
                goto 2> nul
                goto %1
            )
        )
        echo warning: Convert EOL failed
        exit /b 1
    )
    exit /b 0
)
exit /b 1

rem ================================ check_win_eol() ================================
$ Function env check_win_eol

rem ======================== demo ========================

:check_win_eol.__demo__
echo Check EOL type of current script
echo=
echo Options:
echo -c, --check-exist      Returns 0 if function exist / is callable
echo=
echo Exit Codes:
echo    0: Windows (CRLF)
echo    1: Unix (LF)
echo=
echo If EOL is Mac (CR), this script would not even run at the first place
echo=
echo Note:
echo - In rare cases, the script cannot find the function, but it fixed by 
echo   moving the function few lines away from where you initially put it.
echo - Can be used to detect if script was downloaded 
echo   from GitHub, since uses Unix EOL (LF)
echo - Function will not work if it is put in an external file
echo=
for %%n in (1 2) do call :check_win_eol.alt%%n --check-exist 2> nul && (
    call :check_win_eol.alt%%n && (
        echo EOL is Windows (CRLF)
    ) || echo EOL is Unix (LF)
)
goto :EOF

rem ======================== function ========================

:check_win_eol   [--check-exist]
rem The label below is an alternative label if the main label cannot be found
:check_win_eol.alt1
rem THIS IS REQUIRED
:check_win_eol.alt2
for %%f in (-c --check-exist) do if /i "%1" == "%%f" exit /b 0
@call :check_win_eol.test 2> nul && exit /b 0 || exit /b 1
rem  1  DO NOT REMOVE THIS COMMENT SECTION, IT IS IMPORTANT FOR THIS FUNCTION TO WORK CORRECTLY                               #
rem  2  DO NOT MODIFY THIS COMMENT SECTION IF YOU DON'T KNOW WHAT YOU ARE DOING                                               #
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
rem 32  LAST LINE: should be 1 character shorter than the rest                                              DO NOT MODIFY -> #
:check_win_eol.test
@exit /b 0

rem ======================================== Framework ========================================
:framework.__init__     Framework of the script
exit /b 0

rem ================================ module ================================
rem Module Framework
rem
rem 1. Allow scripts to call functions of another script 
rem    as if they lives in the caller's file
rem
rem 2. Allow scripts to start a multiple windows with different entry points
rem
rem ============================ .entry_point() ============================
$ Function framework module.entry_point

rem ======================== demo ========================

:module.entry_point.__demo__
echo Reads the argument to determine which script/entry point to GOTO
echo Used for scripts that has multiple entry points
echo=
echo Press any key to start another window...
pause > nul
@echo on
start "" /i cmd /c "%~f0" --module=2nd_window_demo   test arg Here
@echo off
echo 'cmd /c' is required to make sure the new window closes
echo if it exits using the 'exit /b' command
goto :EOF


:scripts.2nd_window_demo
@echo off
setlocal EnableDelayedExpansion
title Second Window
echo Hello! I am the second window.
echo=
echo Arguments  : %*
echo=
pause
exit 0

rem ======================== function ========================

:module.entry_point   [--module=<name>]  [args]
@if /i "%1" == "--module" @(
    for /f "tokens=1* delims= " %%a in ("%*") do @call :scripts.%~2 %%b
    exit /b
) else @goto __main__
@exit /b

rem ============================ .updater() ============================
$ Function framework module.updater

rem ======================== demo ========================

:module.updater.__demo__
echo Update this batch script from GitHub
echo=
echo At metadata():
echo - Set the 'download_url' to the GitHub raw gist link
echo=
echo Dependencies:
echo - metadata()
echo - module.entry_point()
echo - scripts.lib()
echo - module.is_module()
echo - download_file()
echo - diffdate()
echo=
echo Options:
echo - set "temp_path=C:\path\to\download"
echo=
echo=
echo This function can automatically detect updates,
echo download them, and update script
echo=
echo Checking for updates...
call :module.updater check "%~f0" || goto :EOF
echo=
echo Note:
echo - Updating will REPLACE current script with the newer version
echo=
call :Input.yesno user_input "Update now? Y/N? " || goto :EOF
echo=
call :module.updater upgrade "%~f0"
goto :EOF

rem ======================== function ========================

:module.updater   <check|upgrade>  script_path
setlocal EnableDelayedExpansion
set "_set_cmd="
if /i "%1" == "check" set "_set_cmd=_show=true"
if /i "%1" == "upgrade" set "_set_cmd=_upgrade=true"
if defined _set_cmd (
    set "!_set_cmd!"
    shift /1
)
if not defined temp_path set "temp_path=!temp!"
set "_downloaded=!temp_path!\latest_version.bat"
call :module.read_metadata _module. "%~1"  || ( 1>&2 echo error: failed to read module information & exit /b 1 )
call %batchlib%:download_file "!_module.download_url!" "!_downloaded!" || ( 1>&2 echo error: download failed & exit /b 1 )
call :module.is_module "!_downloaded!" || ( 1>&2 echo error: failed to read update information & exit /b 2 )
call :module.read_metadata _downloaded. "!_downloaded!"  || ( 1>&2 echo error: failed to read update information & exit /b 2 )
if not defined _downloaded.version ( 1>&2 echo error: failed to read update information & exit /b 2 )
if /i not "!_downloaded.name!" == "!_module.name!" ( 1>&2 echo warning: module name does not match )
call :module.version_compare "!_downloaded.version!" EQU "!_module.version!" && ( echo You are using the latest version & exit /b 0 )
call :module.version_compare "!_downloaded.version!" GTR "!_module.version!" || ( echo No updates available & exit /b 0 )
if defined _show (
    call %batchlib%:diffdate update_age !date:~4! !_downloaded.release_date! 2> nul && (
        echo !_downloaded.description! !_downloaded.version! is now available ^(!update_age! days ago^)
    ) || echo !_downloaded.description! !_downloaded.version! is now available ^(since !_downloaded.release_date!^)
    del /f /q "!_downloaded!"
)
if not defined _upgrade exit /b 0
echo Updating script...
move "!_downloaded!" "%~f1" > nul && (
    echo Update success
    echo Script will exit
    pause
    exit
) || ( 1>&2 echo error: update failed & exit /b 1 )
exit /b 0

rem ======================== notes ========================

rem PIP
rem 1.
rem |- Collecting <package|package condition version>
rem |  |- Downloading <package_url> (?MB)
rem |  |- Using cached <package_url>
rem |- Requirement already satisfied <package|package condition version>
rem 2. Installing collected packages: <package>[, <package>[...]]
rem 3. Successfully installed <package>

rem PIP -e
rem 1. Obtaining file: <path_to_module>
rem 2. Found existing installation
rem    |- Uninstall
rem 3. Running setup.py develop

rem APT
rem 1. Reading package list
rem 2. Building dependency tree
rem 3. Reading state information

rem ============================ .read_metadata() ============================
$ Function framework module.read_metadata

rem ======================== demo ========================

:module.read_metadata.__demo__
echo Update this batch script from GitHub
echo=
echo At metadata():
echo - Set the 'download_url' to the GitHub raw gist link
echo=
echo Dependencies:
echo - metadata()
echo - module.entry_point()
echo - scripts.lib()
echo - module.is_module()
echo=
echo=
call :Input.path script_to_check
echo=
echo Metadata:
call :module.read_metadata metadata. "!script_to_check!"
set "metadata."
goto :EOF

rem ======================== function ========================

:module.read_metadata   return_var  script_path
call :module.is_module "%~2" || exit /b 1
for %%v in (
    name version
    author license 
    description release_date
    url download_url
) do set "%~1%%v="
call "%~2" --module=lib :metadata "%~1" || exit /b 1
exit /b 0

rem ============================ .is_module() ============================
$ Function framework module.is_module

rem ======================== demo ========================

:module.is_module.__demo__
echo Check if a given file is a batch script module
echo=
echo The function will check if script contains:
echo - module.entry_point()
echo - scripts.lib()
echo - metadata()
echo=
echo This could prevent script from calling another batch file that does not
echo understand call as module and cause undesired result
echo=
pause
echo=
call :Input.path script_to_check
echo=
set "start_time=!time!"
call :module.is_module "!script_to_check!" && (
    echo Script supports call as module
) || echo Script does not support call as module
call :difftime time_taken !time! !start_time!
call :ftime time_taken !time_taken!
echo=
echo Done in !time_taken!
goto :EOF

rem ======================== function ========================

:module.is_module   file_path
setlocal EnableDelayedExpansion
set /a "_missing=0xF"
for /f "usebackq tokens=* delims=@ " %%a in ("%~f1") do (
    for /f "tokens=1-2 delims= " %%b in ("%%a") do (
        if /i "%%b %%c" == "goto module.entry_point" set /a "_missing&=~0x1"
        if /i "%%b" == ":module.entry_point" set /a "_missing&=~0x2"
        if /i "%%b" == ":metadata" set /a "_missing&=~0x4"
        if /i "%%b" == ":scripts.lib" set /a "_missing&=~0x8"
    )
)
if not "!_missing!" == "0" exit /b 1
set "_callable="
for %%x in (.bat .cmd) do if "%~x1" == "%%x" set "_callable=true"
if not defined _callable exit /b 2
exit /b 0

rem ============================ .version_compare() ============================
$ Function framework module.version_compare


rem ======================== demo ========================

:module.version_compare.__demo__
echo Compare module version and return result as errorlevel
echo=
echo Version Syntax:
echo [major[.minor[.patch]]][-{a^|b^|rc}[.number]]
echo=
echo Available Comparison:
echo EQU, NEQ, GTR, GEQ, LSS, LEQ
echo=
echo Aliases:
echo    a : a, alpha
echo    b : b, beta
echo    rc: rc, c, pre, preview
echo=
echo Exit Codes:
echo    0: true
echo    1: false
echo    2: error
echo=
echo Behavior:
echo - If the version is not defined, it is assumed to be '0.0.0'
echo=
echo Example:
echo 1.4.1 GEQ 1.4.1-a.2
echo 2.0-b.1 GTR 2.0-b
echo=
call :Input.string comparison
call :module.version_compare !comparison!
echo=
echo Result: !errorlevel!
goto :EOF

rem ======================== tests ========================

:tests.lib.module.version_compare.main
set "errors=0"
set "return.true=0"
set "return.false=1"
set "return.error=2"
for %%a in (
    "true:  1 EQU 1.0"
    "true:  1 EQU 1.0.0"
    "true:  1 EQU 1.0.0"
    "true:  1.1 EQU 1.1.0"
    "true:  1.0-a EQU 1.0-a.0"
    "true:  2.1-b.1 EQU 2.1-b.1"
    
    "true:  1.0-a EQU 1.0-alpha"
    "true:  1.0-b EQU 1.0-beta"
    "true:  1.0-rc EQU 1.0-c"
    "true:  1.0-rc EQU 1.0-pre"
    "true:  1.0-rc EQU 1.0-preview"
    
    "true:  1.4.1-a.5 NEQ 2.4.1-a.5"
    "true:  1.4.1-a.5 NEQ 1.5.1-a.5"
    "true:  1.4.1-a.5 NEQ 1.4.2-a.5"
    "true:  1.4.1-a.5 NEQ 1.4.1-b.5"
    "true:  1.4.1-a.5 NEQ 1.4.1-a.6"
    "false: 1.4.1-a.5 NEQ 1.4.1-a.5"
    
    "true:  1.4.1 LSS 1.4.2"
    "true:  1.4.1-a LSS 1.4.1.-b"
    "true:  1.4.1-b LSS 1.4.1.-rc"
    "true:  1.4.1-rc LSS 1.4.1"
    "true:  1.4.1-a LSS 1.4.1-a.1"
    
    "false: 1.4.1 LSS 1.4.1"
    "false: 1.4.1-a.5 LSS 1.4.1-a.5"
    
    "true:  1.4.2 GTR 1.4.1"
    "true:  1.4.1-b GTR 1.4.1-a"
    "true:  1.4.1-rc GTR 1.4.1-b"
    "true:  1.4.1 GTR 1.4.1-rc"
    "true:  1.4.1-a.1 GTR 1.4.1-a"
    
    "false: 1.4.1 GTR 1.4.1"
    "false: 1.4.1-a.5 GTR 1.4.1-a.5"
    
    "true:  1.4.1-a.5 GEQ 1.4.1-a.5"
    "true:  1.4.1-a.5 LEQ 1.4.1-a.5"
    
    "false: 1.4.1-b.4 GEQ 1.4.1-b.5"
    "false: 1.4.1-b.5 LEQ 1.4.1-b.4"
    
    "error: EQU 1.0"
    "error: 1.0 EQU"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :module.version_compare %%c
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "!return.%%b!" (
        set /a "errors+=1"
        echo [failed] %%~a
    )
)
if not "!errors!" == "0" exit /b !tester.exit.failed!
exit /b !tester.exit.passed!

rem ======================== function ========================

:module.version_compare   version1 comparison version2
setlocal EnableDelayedExpansion
if /i "%3" == "" exit /b 2
set "_found="
for %%c in (EQU NEQ GTR GEQ LSS LEQ) do if /i "%~2" == "%%c" set "_found=true"
if not defined _found exit /b 2
set "_first=%~1"
set "_second=%~3"
for %%v in (_first _second) do for /f "tokens=1-2 delims=-" %%a in ("!%%v!") do (
    for /f "tokens=1-3 delims=." %%c in ("%%a.0.0.0") do set "%%v=%%c.%%d.%%e"
    set "_normalized="
    if "%%b" == "" set "_normalized=4.0"
    for /f "tokens=1-2 delims=." %%c in ("%%b") do (
        for %%s in (
            "1:a alpha"
            "2:b beta"
            "3:rc c pre preview"
        ) do for /f "tokens=1-2 delims=:" %%n in (%%s) do for %%i in (%%o) do (
            if /i "%%c" == "%%i" (
                if "%%d" == "" (
                    set "_normalized=%%n.0"
                ) else set "_normalized=%%n.%%d"
            )
        )
    )
    if not defined _normalized exit /b 2
    set "%%v=!%%v!.!_normalized!"
)
for %%c in (EQU NEQ) do if /i "%~2" == "%%c" if "!_first!" %~2 "!_second!" ( exit /b 0 ) else exit /b 1
for %%c in (GEQ LEQ) do if /i "%~2" == "%%c" if "!_first!" EQU "!_second!" ( exit /b 0 )
for %%c in (GTR LSS) do if /i "%~2" == "%%c" if "!_first!" EQU "!_second!" ( exit /b 1 )
for /l %%i in (1,1,5) do (
    for %%v in (_first _second) do for /f "tokens=1* delims=." %%a in ("!%%v!") do (
        set "%%v_num=%%a"
        set "%%v=%%b"
    )
    if not "!_first_num!" == "!_second_num!" (
        if !_first_num! %~2 !_second_num! (
            exit /b 0
        ) else exit /b 1
    )
)
endlocal
exit /b 2

rem ======================== backward compatibility ========================

rem goto Module.detect
rem :Module.detect
rem @goto module.entry_point
rem :__module__.lib
rem @goto scripts.lib
rem :__setup__
rem @goto metadata

rem ================================ tester ================================
rem Testing Automation Framework
rem
rem 1. Allow testing automation on batch script
rem
rem ============================ .init() ============================

:tester.init
rem Use this if the script receives input
set "tester.input=!temp!\tester_input"
rem Use this to redirect output of script/function
set "tester.output=!temp!\tester_output"
rem Do NOT use in tests; it is reserved for tester.run_tests()
set "tester.log=!temp!\tester_log"

rem Exit codes
set /a "tester.exit.passed=0x0"
set /a "tester.exit.failed=0x1"
set /a "tester.exit.skipped=0x2"
exit /b 0

rem ============================ .find_tests() ============================
$ Function framework tester.find_tests

rem ======================== demo ========================

:tester.find_tests.__demo__
echo Test automation for batch script
echo=
echo tester.find_tests() automatically find functions to test based on label patterns
echo=
echo Category of tests and its pattern:
echo    tests      :tests.*.main
echo    debug     :*.__debug_tests__
echo=
echo Press any key to demo function...
pause > nul
echo=
call :tester.init
set "tester.test_list=test_odd_seconds"
call :tester.run_tests --verbose
goto :EOF

rem ======================== function ========================

:tester.find_tests   type1 [type2 [...]]
set "tester.test_list="
if "%~1" == "" call :tester.find_tests tests
if /i "%~1" == "all" call :tester.find_tests tests debug
call :tester.find_tests.add %*
exit /b 0
:tester.find_tests.add
if "%1" == "" exit /b 0
for /f "usebackq tokens=1 delims=@ " %%a in ("%~f0") do (
    for /f "tokens=1-2 delims=:" %%b in ("%%a") do if /i ":%%b" == "%%a" if /i "%%c" == "" (
        rem Find labels that match the pattern ':*.__debug_tests__'
        if /i "%~1" == "debug" (
            if /i "%%~xb" == ".__debug_tests__" set "tester.test_list=!tester.test_list! %%b"
        )
        rem Find labels that match the pattern ':tests.*.main'
        if /i "%~1" == "tests" (
            for /f "tokens=1* delims=." %%d in ("%%b") do if /i "%%d.%%e,%%~xe" == "tests.%%e,.main" (
                set "tester.test_list=!tester.test_list! %%b"
            )
        )
    )
)
shift /1
goto tester.find_tests.add

rem ============================ .run_tests() ============================
$ Function framework tester.run_tests

rem ======================== demo ========================

:tester.run_tests.__demo__
echo Test automation for batch script
echo=
echo=
echo Options:
echo -v, --verbose      Show more results on the test run
echo -f, --failfast     Stop the test run on the first failure
echo Exit Code:
echo    0: passed
echo    1: failed
echo    2: skipped
echo=
echo Press any key to demo function...
pause > nul
echo=
call :tester.init
set "tester.test_list=test_odd_seconds"
call :tester.run_tests --verbose
goto :EOF


:test_odd_seconds
set "now_time=!time!"
set /a "odd=!now_time:~-2,2! %% 2"
if "!odd!" == "0" (
    echo Seconds of !now_time! is not an odd number
    exit /b !tester.exit.failed!
)
exit /b !tester.exit.passed!

rem ======================== function ========================

:tester.run_tests
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_fail_fast) do set "%%v="
set "_verbosity=0"
set "parse_args.argc=1"
for %%a in (%*) do (
    set "_shift="
    for %%o in (
        "-v --verbose   :_verbosity=1"
        "-vv            :_verbosity=2"
        "-f --failfast  :_fail_fast=true"
    ) do for /f "tokens=1* delims=:" %%b in (%%o) do (
        for %%f in (%%b) do if /i "%%a" == "%%f" (
            set "%%c"
            set "_shift=true"
        )
    )
    if defined _shift (
        shift /!parse_args.argc!
    ) else set /a "parse_args.argc+=1"
)
set /a "parse_args.argc-=1"

set "_stream_redirect=> nul 2>&1"
if "!_verbosity!" == "1" set _stream_redirect=^> "!tester.log!" 2^>^&1
if "!_verbosity!" == "2" set "_stream_redirect="
set "tester.tests_count=0"
for %%t in (!tester.test_list!) do set /a "tester.tests_count+=1"
for %%c in (passed failed skipped) do set "tester.tests_%%c=0"
set "tester.tests_run=0"
set "tester.start_time=!time!"
call :tester.run_tests.loop
if defined _fail_fast if not "!tester.tests_run!" == "!tester.tests_count!" (
    echo First failure encountered. Stopping the test run.
    set /a "tester.tests_skipped+=!tester.tests_count! - !tester.tests_run!"
)
call :difftime tester.time_taken !time! !tester.start_time!
call :ftime tester.time_taken !tester.time_taken!
echo=
echo=
echo Ran !tester.tests_run! tests in !tester.time_taken!
echo=
echo Passed     : !tester.tests_passed!
echo Failed     : !tester.tests_failed!
echo Skipped    : !tester.tests_skipped!
endlocal
exit /b 0
:tester.run_tests.loop
for %%t in (!tester.test_list!) do (
    call :difftime _timestamp !time! !tester.start_time!
    call :ftime _timestamp !_timestamp!
    set /a "tester.tests_run+=1"
    echo !_timestamp! [!tester.tests_run!/!tester.tests_count!] %%t
    setlocal EnableDelayedExpansion EnableExtensions
    call :%%t %_stream_redirect%
    for /f "tokens=* delims=" %%e in ("!errorlevel!") do (
        endlocal
        set "_exit_code=%%e"
    )
    if "!_exit_code!" == "!tester.exit.passed!" (
        set /a "tester.tests_passed+=1"
    )
    if "!_exit_code!" == "!tester.exit.failed!" (
        set /a "tester.tests_failed+=1"
        if "!_verbosity!" == "0" (
            echo test %%t failed -- an error occurred; run in verbose mode for details
        )
        if "!_verbosity!" == "1" (
            echo test %%t failed -- an error occurred
            type "!tester.log!"
        )
        if "!_verbosity!" == "2" (
            echo test %%t failed -- an error occurred
        )
        if defined _fail_fast exit /b 0
    )
    if "!_exit_code!" == "!tester.exit.skipped!" (
        set /a "tester.tests_skipped+=1"
        echo test %%t skipped
        type "!tester.log!"
    )
)
exit /b 0

rem ================================ parse_args() ================================
$ Function fw parse_args

rem ======================== demo ========================

:parse_args.__demo__
echo Parse arguments
echo=
echo Example function:
echo=
echo A calculator that speaks the result of an expression
echo Usage: talking_calculator   expression  [OPTIONS]
echo=
echo expression             The mathematical expression to answer
echo=
echo Options:
echo -s, --say ^<text^>     Say this text before showing the result
echo -b, --binary           Show result in the form of binary
echo -h, --hex              Show result in the form of hexadecimal
echo=
call :Input.string parameters
echo=
call :talking_calculator !parameters!
echo=
goto :EOF


:talking_calculator
for %%v in (_say _binary _hex) do set "%%v="
set parse_args.args= ^
    "-s --say       :var:_args._say" ^
    "-b --binary    :flag:_args._binary=true" ^
    "-h --hex       :flag:_args._hex=true"
call :parse_args %* || exit /b 1
echo Arguments:
set "_args."
echo=
if not "%~2" == "" (
    echo Sorry, I didn't understand the parameters. Please check again.
    exit /b 1
)
set /a "_result=%~1 + 0" 2> nul || (
    echo Sorry, the syntax of the expression is incorrect. Please check again.
    exit /b 1
)
if not defined _args._say set "_args._say=The answer is"
if defined _args._binary call :int2bin _result !_result!
if defined _args._hex (
    call :int2hex _result !_result!
    set "_result=0x!_result!"
)
echo !_args._say! !_result!
exit /b 0

rem ======================== tests ========================

:tests.lib.parse_args.main
call :tests.lib.parse_args.case1 || exit /b !tester.exit.failed!
call :tests.lib.parse_args.case2 arg1 -n asd -e --save-path qwe arg2 || exit /b !tester.exit.failed!
call :tests.lib.parse_args.case3 "" -c ":" -sc ";" -qm "?" -a "*" || exit /b !tester.exit.failed!
exit /b !tester.exit.passed!


:tests.lib.parse_args.case1
setlocal EnableDelayedExpansion EnableExtensions
set "parse_args.args="
call :parse_args %* || (
    echo [failed] case1: exit state must be successful
    exit /b 1
)
exit /b 0


:tests.lib.parse_args.case2
for %%v in (_filename _save_path _exist) do set "%%v="
set parse_args.args= ^
    "-n --name      :var:_filename" ^
    "-s --save-path :var:_save_path" ^
    "-e --exist     :flag:_exist=true" ^
    "-n --not-exist :flag:_exist=false"
call :parse_args.debug_args || exit /b 1
call :parse_args %*
if not "%1" == "arg1"  ( 2>&1 echo [failed] case2: positional argument 1 & exit /b 1 )
if not "%2" == "arg2"  ( 2>&1 echo [failed] case2: positional argument 2 & exit /b 1 )
if not "!_filename!" == "asd" ( 2>&1 echo [failed] case2: keyword argument 1 & exit /b 1 )
if not "!_save_path!" == "qwe" ( 2>&1 echo [failed] case2: keyword argument 2 & exit /b 1 )
if not "!_exist!" == "true" ( 2>&1 echo [failed] case2: flag argument 1 & exit /b 1 )
exit /b 0


:tests.lib.parse_args.case3
for %%v in (_question_mark _askterisk _colon _semicolon) do set "%%v="
set parse_args.args= ^
    "-qm    :var:_question_mark" ^
    "-a     :var:_askterisk" ^
    "-c     :var:_colon" ^
    "-sc    :var:_semicolon"
call :parse_args.debug_args || exit /b 1
call :parse_args %*
set _dq=""
if not "%1" == "!_dq!" ( 2>&1 echo [failed] case3: parsing of empty string & exit /b 1 )
if not "!_question_mark!" == "?" ( 2>&1 echo [failed] case3: parsing of question mark '?' & exit /b 1 )
if not "!_askterisk!" == "*" ( 2>&1 echo [failed] case3: parsing of askterisk '*' & exit /b 1 )
if not "!_colon!" == ":" ( 2>&1 echo [failed] case3: parsing of colon ':' & exit /b 1 )
if not "!_semicolon!" == ";" ( 2>&1 echo [failed] case3: parsing of semicolon ';' & exit /b 1 )
exit /b 0


rem ======================== function ========================

:parse_args   %*
set "_store_var="
set "parse_args.argc=1"
set "parse_args.shift="
call :parse_args.loop %*
set /a "parse_args.argc-=1"
set "parse_args._store_var="
set "parse_args._value="
(
    goto 2> nul
    for %%n in (!parse_args.shift!) do shift /%%n
    ( call )
)
exit /b 1
:parse_args.loop
set _value=%1
if not defined _value exit /b
set "_shift="
if defined parse_args._store_var (
    set "!parse_args._store_var!=%~1"
    set "parse_args._store_var="
    set "_shift=true"
)
for %%o in (!parse_args.args!) do for /f "tokens=1-2* delims=:" %%b in (%%o) do (
    for %%f in (%%b) do if /i "!_value!" == "%%f" (
        if /i "%%c" == "flag" set "%%d"
        if /i "%%c" == "var" set "parse_args._store_var=%%d"
        set "_shift=true"
    )
)
if defined _shift (
    set "parse_args.shift=!parse_args.shift! !parse_args.argc!"
) else set /a "parse_args.argc+=1"
shift /1
goto parse_args.loop

rem ======================== debug ========================

rem Check if your arguments are valid
:parse_args.debug_args
setlocal EnableDelayedExpansion
for %%o in (!parse_args.args!) do for /f "tokens=1-2* delims=:" %%b in (%%o) do (
    if "%%d" == "" ( 2>&1 echo variable to set is not defined & exit /b 1 )
    if "%%c" == "" (
        2>&1 echo error: argument type is not defined & exit /b 1
    ) else (
        set "_valid="
        if /i "%%c" == "flag" set "_valid=true"
        if /i "%%c" == "var" set "_valid=true"
        if not defined _valid ( 2>&1 echo error: argument type '%%c' is not valid & exit /b 1 )
    )
)
exit /b 0


rem Smaller version. Can only parse flags
:parse_args.flags   %*
(
    goto 2> nul
    set "parse_args.argc=1"
    for %%a in (%*) do (
        set "_shift="
        for %%o in (!parse_args.args!) do for /f "tokens=1* delims=:" %%b in (%%o) do (
            for %%f in (%%b) do if /i "%%a" == "%%f" (
                set "%%d"
                set "_shift=true"
            )
        )
        if defined _shift (
            shift /!parse_args.argc!
        ) else set /a "parse_args.argc+=1"
    )
    set /a "parse_args.argc-=1"
    set "_store_var="
)
exit /b 0


rem (!) Reference
rem https://docs.python.org/3/library/argparse.html#action

rem ================================ dynamenu(!) ================================
$ Function framework dynamenu


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

rem ================================ bcom(!) ================================
rem Still under development

:bcom.init
set "bcom.name=!__name__!"
set "bcom.file=%~dp0\bcom_.bat"

set "bcom.name=.!bcom.name!"
set "bcom.name=!bcom.name: =_!"
set "bcom.name=!bcom.name:~1!"
set "bcom.id=!bcom.name!.!MODULE_NAME!"
call :expand_path bcom.file "!bcom.file!"
if not exist "!bcom.fileDP!" md "!bcom.fileDP!"

if not defined bcom.name set "bcom.name=None"
goto :EOF


:bcom.send   id
set "_bcom_send_date=!date!"
set "_bcom_send_time=!time!"
(
    echo=
    echo=
    echo call :^^^!bcom_sender^^^! ^& goto :EOF
    echo :!bcom.id!
    echo=!bcom_msg!
    echo=
    echo set "_bcom_send_date=!_bcom_send_date!"
    echo set "_bcom_send_time=!_bcom_send_time!"
    echo goto :EOF
) > "!bcom.fileDP!\!bcom.fileN!%~1!bcom.fileX!"
exit /b 0


:bcom.receive   id
set "bcom_sender=%~1"
set "_bcom_send_date="
set "_bcom_send_time="
ver > nul & rem set errorlevel 0
for %%f in ("!bcom.fileDP!\!bcom.fileN!!bcom.id!!bcom.fileX!") do (
    if not exist "%%~f" exit /b 2
    call "!bcom.fileDP!\!bcom.fileN!!bcom.id!!bcom.fileX!" || exit /b 1
)
exit /b 0


:bcom.ping   id
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


:bcom.respond   id
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

rem ======================================== Assets ========================================
:assets.__init__     Additional data to bundle
exit /b 0

rem ======================================== End of Script ========================================
:EOF     May be needed if command extenstions are disabled
rem Anything beyond this are not part of the code
exit /b

rem ================================================================================

rem error levels: https://www.keycdn.com/support/nginx-error-log
rem debug - Useful debugging information to help determine where the problem lies.
rem info - Informational messages that aren't necessary to read but may be good to know.
rem notice - Something normal happened that is worth noting.
rem warning - Something unexpected happened, however is not a cause for concern.
rem error - Something was unsuccessful.
rem crit - There are problems that need to be critically addressed.
rem alert - Prompt action is required.
rem emerg - The system is in an unusable state and requires immediate attention.

rem ======================================== Other Function ========================================
:notes.other_functions     Actually working functions but not listed

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
for /f "usebackq tokens=1 delims==" %%v in (`set _ 2^> nul`) do set "%%v="
exit /b

rem ======================================== Notes ========================================
:notes.general     Useful stuffs worth looking at

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

rem Clean error state (use at end of block, parentheses is required)
( call )

rem return to context of caller, and exit /b after execution of block
goto 2> nul

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
)
