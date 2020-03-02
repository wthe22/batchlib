:__init__ > nul 2> nul
@goto module.entry_point


rem ======================================== Metadata ========================================

:__metadata__   [return_prefix]
set "%~1name=batchlib"
set "%~1version=2.1-a.13"
set "%~1author=wthe22"
set "%~1license=The MIT License"
set "%~1description=Batch Script Library"
set "%~1release_date=02/28/2020"   :: mm/dd/YYYY
set "%~1url=https://winscr.blogspot.com/2017/08/function-library.html"
set "%~1download_url=https://gist.github.com/wthe22/4c3ad3fd1072ce633b39252687e864f7/raw"
exit /b 0


:about
setlocal EnableDelayedExpansion
call :__metadata__
echo A collection of functions/snippets for batch script
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
call :config.!__name__!
call :config.preferences
exit /b 0


:config.default
rem Default/common configurations for this script
set "temp_path=!temp!\BatchScript\!SOFTWARE.name!\!__name__!"

rem Macros to call external module (use absolute paths)
set "!SOFTWARE.name!= "
set "!SOFTWARE.name!.abspath=%~f0"

rem Variables below are not used here, but for reference only
rem set "data_path=data\batchlib"
rem set "default_console_width=80"
rem set "default_console_height=25"
rem set "console_width=!default_console_width!"
rem set "console_height=!default_console_height!"
rem set "ping_timeout=750"
rem set "debug_mode=false"
exit /b 0


:config.main
rem Specific config for 'scirpt.main'
exit /b 0


:config.min
rem Specific config for 'scirpt.min'

rem Macros to call external module (use absolute paths)
set !SOFTWARE.name!="%~f0" --module=lib %=END=%
exit /b 0


:config.preferences
rem Define your preferences or config modifications here

rem Macros to call external module (use absolute paths)
rem set batchlib="%~dp0batchlib-min.bat" --module=lib %=END=%
exit /b 0


rem ======================================== Changelog ========================================

:changelog
echo    Core
echo    - Added __init__() label as the UTF-8-BOM guard so it can be
echo      extracted using extract_func()
echo    - Added method to specify different config for each entry point
echo    - Added scripts.lib-noecho() to call script without echoing
echo    - Added documentation_menu() for more documentation options
echo    - Added unittest for script compatibility check
echo    - Added 'core' package for core functions / the "back-end"
echo    - Added labels for packages
echo    - Renamed 'shortcuts.*' to 'shortcut.*'
echo    - Renamed 'test.*' to 'tests.*'
echo    - Renamed the category 'Formatting' to 'Console'
echo    - Renamed  metadata() to __metadata__()
echo    - Changed __main__() exit to 'exit /b' to prevent console from terminating
echo    - Added a new category 'Packaging'
echo    - scripts.main():
echo        - Prompt message are now preserved after running this script
echo        - Now it only remove its own temp_path, instead of removing
echo          temp_path of all modules.
echo    - Replaced 'goto :EOF' with 'exit /b 0'
echo    - Function.read() no longer reads category definition
echo    - Category definition and its functions are now written in Category.init()
echo    - Improved format of internal category listing
echo    - Fixed batch script creating ']' file on startup if EOL is Linux (!)
echo    - script_cli(): added support for multi line commands
echo=
echo    Library
echo    - Added bytes2size(), size2bytes(), extract_func(), ping_test(), is_echo_on(),
echo      fdate(), epoch2time(), resolve_dependency(), extract_ns_func()
echo    - Added unittest() framework, this replaces the tester() framework.
echo    - Added is_number(), is_in_range(), this replaces check_number().
echo    - Added updater(), this replaces module.updater().
echo    - Added find_label(), this replaces tester.find_tests().
echo    - Added parse_version(), this replaces module.version_compare().
echo    - Added dependency listing
echo    - Fixed demo of several functions that uses Input.number()
echo    - Merged 'shortcut' and 'framework' into 'lib'
echo    - Removed expand_path(). Using FOR directly is more preferable.
echo    - Renamed check_admin() to is_admin()
echo    - Renamed '*.__demo__' to 'demo.*'
echo    - capchar(): Added capturing of TAB character
echo    - check_ipv4(): Added ability to check wildcard IP
echo    - check_ipv4(): Fixed error not checking octet count if it is less than 4
echo    - check_path(): Fixed incorrect parameter description
echo    - diffbin(): Fixed error if temp_path is not defined.
echo    - diffdate(): Simplified calculations
echo    - difftime(): Renamed parameter '-n' to '--no-fix'
echo    - extract_func():
echo        - Added join mark '#+++' for 'should include' labels
echo        - Removed implicit EOL 'rem ==='
echo        - Greatly improved extraction speed
echo        - Extraction order is now according to parameter (previously according
echo          to occurrence in file)
echo    - get_os(): Renamed parameter '-n' to '--name'
echo    - get_pid(): Added required positional argument 'unique_id'. Previously,
echo    - get_ext_ip(): Used 'temp_path' as the temporary download path
echo      this ID is automatically generated in the function using PowerShell.
echo    - Input.*(): Renamed parameters '-d, --description' to '-m, --message'
echo    - Input.ipv4(): Fixed function not returning value after a successful input
echo    - Input.path(): Fixed parameter conflict
echo    - Input.yesno(): Accepts anything that starts with 'Y' as yes, and
echo      anything that starts with 'N' as no
echo    - module.entry_point(): Fixed script quitting unexpectedly
echo      if first parameter is quoted and contains special characters
echo    - module.read_metadata():
echo        - No longer checks if file is a module
echo        - Addedd 'install_requires' in metadata
echo    - parse_args():
echo        - Added 'append_const' data type
echo        - Arguments is now case sensitive
echo        - Renamed type 'flag' to 'store_const'
echo        - Renamed type 'var' to 'store'
echo    - pow(): Added error message if integer is too large
echo    - randw(): Weights are now read from %~1 instead of %*.
echo      Now weights needs to be surrounded by quotes.
echo    - setup_clearline(): piped 'mode con' to prevent input stream from
echo      being discarded
echo    - wait():
echo        - Now the function needs to be setup using wait.setup()
echo        - Macro version is now available
echo    - wait.calibrate(): Prevented function from causing infinite loop if
echo      the initial calibration value is too fast
echo    - watchvar():
echo        - Renamed parameter '-l, --list' to '-n, --name'
echo        - Added 'temp_path' fallback value to 'temp'
echo    - what_day(): Renamed parameter '-n' to '--number', '-s' to '--short'
echo=
echo    Minified Script
echo    - Included 'tests.*', changelog(), help(), scripts.lib-noecho()
echo    - Added an interactive ui: script_cli()
echo    - Script now uses scripts.min() as its main entry point
echo    - The help message in main() has been moved to help(). This is significantly
echo      makes help message easier to maintain.
echo    - Removed unittest for save_minified(), instead the minified script
echo      have a copy of the tests and it is able to run unittest too.
echo=
echo    Tests
echo    - Migrated unit testing framework/syntax from tester() to unittest().
echo    - Added unittest for: Input.ipv4, pow, prime, gcf, bin2int, check_ipv4, wait
echo    - New functions with unittest: bytes2size(), size2bytes(), unittest(),
echo      updater(), find_label(), parse_version(), fdate(), epoch2time(),
echo      extract_func(), resolve_dependency(), extract_ns_func()
echo    - Improved unittest for: Input.number(), module.entry_point()
echo    - Removed hex conversion test from watchvar()
echo    - Added unittest for capturing of function arguments
echo=
echo    Documentation
echo    - Split '*.__demo__' into '*.__doc__' and 'demo.*'. Now users can see
echo      documentation without running the demo.
echo    - *.__doc__() now uses man page style of documentation
echo    - Improved demo of several functions
echo    - Added help() to display usage help
echo    - Added (missing) parameter description of several functions
echo    - batchlib-min now accepts '-h, --help'
echo    - Changed example of lib usage to use absolute paths
echo    - Improved parameter description of several functions
echo    - Removed changelog history for reduced log size. Only latest changelog
echo      will be included. See Git for earlier changelog history.
echo    - Updated guides on the library section
exit /b 0


:changelog.dev
echo    - Split extract_dependency() to resolve_dependency() and extract_ns_func()
echo    - Reworked resolve_dependency() to support listing multiple functions in
echo      the parameter
echo    - Added unittest for extract_func(), resolve_dependency(), extract_ns_func()
echo    - Fixed unittest of unittest() not included in tests
echo    - Removed parse_args() dependency in extract_func() since it is unused
exit /b 0


:changelog.todo
echo    - consider adding prefix in parse_version()
echo    - add params to save_minified()
echo    - read usage of double underscore: https://docs.python.org/3/reference/datamodel.html
echo    - check if all return var is empty if error happens
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
@exit /b %errorlevel%


rem ======================================== Scripts/Entry points ========================================

:scripts
:scripts.__init__
rem Entry points of the script
@exit /b 0


rem ================================ library script ================================

rem Call script as library module and call the function
call your_file_name.bat --module=lib <function> [arg1 [arg2 [...]]]

rem Example:
call batchlib-min.bat --module=lib pow result 2 16
call batchlib-min.bat --module=lib :Input.number age --message "Input your age: " --range 0~200

rem Set macro and call as external module (use absolute paths)
set batchlib="%~dp0batchlib-min.bat" --module=lib %=END=%
call %batchlib%:Input.number age --message "Input your age: " --range 0~200


:scripts.lib
@call :%*
@exit /b %errorlevel%


:scripts.lib-noecho
@call :is_echo_on && @goto scripts.lib-noecho._no_echo
@call :%*
@exit /b %errorlevel%
#+++

:scripts.lib-noecho._no_echo
@echo off
@call :%*
@echo on
@exit /b %errorlevel%


:scripts.lib-noecho.__metadata__
set %~1install_requires= ^
    ^ is_echo_on
exit /b 0


rem ================================ main script ================================

:scripts.main
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
set "__name__=main"
prompt $$
call :__metadata__ SOFTWARE.
title !SOFTWARE.description! !SOFTWARE.version!
cls
echo Loading script...

for %%n in (1 2) do call :fix_eol.alt%%n
call :config

for %%v in (no_cleanup) do set "%%v="
set parse_args.args= ^
    ^ "-n, --no-cleanup :store_const:no_cleanup=true"
call :parse_args %*

for %%p in (
    temp_path
) do if not exist "!%%p!" md "!%%p!"

call :Category.init
call :Function.read
set "last_used.function="
call %batchlib%:capchar *
call %batchlib%:get_con_size console_width console_height
call :main_menu
if not defined no_cleanup rd /s /q "!temp_path!" > nul 2> nul
@exit /b %errorlevel%


:scripts.main.reload
endlocal
goto scripts.main


rem ================================ minified script ================================

:scripts.min
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
set "__name__=min"
prompt $$
call :__metadata__ SOFTWARE.

for %%n in (1 2) do call :fix_eol.alt%%n
call :config

set "action=script_cli"
set parse_args.args= ^
    ^ "-h, --help   :store_const:action=help"
call :parse_args %*

for %%p in (
    temp_path
) do if not exist "!%%p!" md "!%%p!"

call :!action!
@exit /b 0


rem ======================================== User Interfaces ========================================

:ui
:ui.__init__
rem User Interfaces
exit /b 0


rem ================================ Main Menu ================================

:main_menu
set "user_input="
cls
echo 1. Browse documentation
echo 2. Use command line
echo 3. Generate minified version
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
    call :documentation_menu
    goto main_menu
)
if "!user_input!" == "2" (
    call :script_cli
    goto main_menu
)
if "!user_input!" == "3" (
    call :Input.path save_dir --exist --directory ^
        ^ --message "Input save folder for the minified script: "
    set "minified_script=!save_dir!\!SOFTWARE.name!-min.bat"
    cls
    echo Save path:
    echo !minified_script!
    echo=
    echo Extracting...
    set "start_time=!time!"
    call :save_minified "!minified_script!"
    call :difftime time_taken !time! !start_time!
    call :ftime time_taken !time_taken!
    echo=
    echo Done in !time_taken!
    pause
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
    echo !SOFTWARE.name! !SOFTWARE.version! ^(!SOFTWARE.release_date!^)
    echo=
    call :changelog
    echo=
    pause
    goto main_menu
)
if /i "!user_input!" == "T" (
    cls
    echo Metadata:
    set "SOFTWARE."
    echo=
    start "" /i /wait /b cmd /c ^" ^
        ^   "%~f0" --module=lib-noecho :unittest -v ^
        ^ ^" ^
        ^ || (
        echo=
        echo Test module ended earlier than expected
    )
    echo=
    pause
    goto main_menu
)
if /i "!user_input!" == "DT" (
    cls
    echo Metadata:
    set "SOFTWARE."
    echo=
    start "" /i /wait /b cmd /c ^" ^
        ^   "%~f0" --module=lib-noecho ^
        ^       ^ :unittest --pattern "tests.debug.*.main" --failfast --verbose ^
        ^ ^" ^
        ^ || (
        echo=
        echo Test module ended earlier than expected
    )
    echo=
    pause
    goto main_menu
)
goto main_menu


rem ================================ Documentation Menu ================================

:documentation_menu
set "user_input="
cls
for %%f in (!selected.function!) do echo !Function_%%f.args!
echo=
echo 1. View documentation
echo 2. Demo function
echo=
echo 0. Back
echo=
echo What do you want to do?
set /p "user_input="
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" (
    cls
    call :!selected.function!.__doc__
    echo=
    pause
    goto documentation_menu
)
if "!user_input!" == "2" (
    call :start_demo !selected.function!
    goto documentation_menu
)
goto documentation_menu


rem ================================ Select Function ================================

:select_function
set "selected.function="
:select_function.category
set "user_input="
cls
call :Category.get_item list
echo=
if defined last_used.function echo L. Last used function
echo S. Search function
echo 0. Exit
echo=
echo Which function do you want to use?
set /p "user_input="
if "!user_input!" == "0" exit /b 0
if defined last_used.function if /i "!user_input!" == "L" (
    set "selected.function=!last_used.function!"
    exit /b 0
)
if /i "!user_input!" == "S" goto select_function.search
call :Category.get_item "!user_input!" && goto select_function.name
goto select_function.category


:select_function.search
set "search_keyword="
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
    exit /b 0
)
goto select_function.name


rem ================================ Start Demo ================================

:start_demo
setlocal EnableDelayedExpansion EnableExtensions
cls
call :%~1.__doc__
echo=
echo ================================ START OF DEMO ================================
call :demo.%~1
echo=
echo ================================ END OF DEMO ================================
echo=
pause
endlocal
exit /b 0


rem ================================ CLI script ================================

:script_cli
@cls
@echo !SOFTWARE.name! !SOFTWARE.version! (!SOFTWARE.release_date!)
@echo Type 'call :help', 'call :about' or 'call :license' for more information, 'exit /b' to quit.
@echo=
@call :script_cli._loop
@exit /b %errorlevel%
#+++

:script_cli._loop
@set "user_input="
@set /p "user_input=$"
if "!user_input:~-1,1!" == "^" call :script_cli._loop._more
%user_input%
@echo=
@goto script_cli._loop
#+++

:script_cli._loop._more
@set "more="
@set /p "_more=More? "
set "user_input=!user_input!!_more!"
if not "!_more:~-1,1!" == "^" exit /b 0
goto script_cli._loop._more

rem ================================ Help text ================================

:help
setlocal EnableDelayedExpansion EnableExtensions
call :__metadata__ SOFTWARE.
call :Category.init
call :Function.read

echo !SOFTWARE.description! !SOFTWARE.version!
echo=
echo Usage: batchlib --module=lib :^<function^> [parameters]
echo        batchlib --help
echo=
for %%c in (!Category.list!) do (
    echo !Category_%%c.name! functions:
    for %%f in (!Category_%%c.functions!) do (
        echo     !Function_%%f.args!
    )
    echo=
)
echo Some functions MUST be embedded into your script to work correctly
echo=
echo Example:
echo     call batchlib-min.bat --module=lib :Input.number age ^^
echo        ^^ --message "Input your age: " --range 0~200
echo=
echo Set macro and call as external package:
echo     set batchlib="C:\absolute\path\to\batchlib-min.bat" --module=lib %%=END=%%
echo     call %%batchlib%%:Input.number age --message "Input your age: " --range 0~200
exit /b 0


rem ======================================== Tests ========================================

:tests
:tests.__init__
rem Things to do before any running any tests
exit /b 0


rem ================================ auto_input ================================

:tests.auto_input.main
> "in\ignore_n_quit" (
    echo ignore1
    echo ignore2
    echo ignore3
    echo 0
)
> "out\ignore_n_quit" 2>&1 (
    start "" /i /wait /b cmd /c ""%~f0" --no-cleanup" < "in\ignore_n_quit"
) && (
    exit /b 0
) || (
    call %unittest%.fail
    exit /b 0
)
exit /b 1


rem ================================ time_format ================================

:tests.core.time_format.main
rem Check time format compatibility
set "digits=0 1 2 3 4 5 6 7 8 9"
set "seperators=!time!"
set "seperators=!seperators: =!"
for /l %%n in (0,1,9) do set "seperators=!seperators:%%n=!"
if not "!seperators!" == "::." (
    call %unittest%.fail "Incompatible time format"
)
exit /b 0


rem Date (DD/MM/YYYY)   : 09/10/2019
rem Time (HH.MM.SS,CC)  : 16.11.08,72


rem ================================ Function arguments ================================

:tests.core.capture_function_arguments.main
call :Category.init
call :Function.read
for %%f in (!Category_all.functions!) do (
    if not defined Function_%%f.args (
        call %unittest%.fail "Cannot capture arguments for function '%%f'"
    )
)
exit /b 0


rem ======================================== Utilities ========================================

:utils
:utils.__init__
rem Utility Functions
exit /b 0


:Category.get_item   list|number
set "_count=0"
set "selected.category="
for %%v in (all !Category.list!) do (
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
    if not "!_temp:%%k=!" == "!_temp!" (
        set "Category_search.functions=!Category_search.functions! %%f"
    )
)
exit /b 1


rem ======================================== Core Functions ========================================

:core
:core.__init__
rem Core Functions
exit /b 0


:Category.init
set "Category.list=shortcut number string time file net env console packaging framework"

set "Category_shortcut.name=Shortcut"
set Category_shortcut.functions= ^
    ^ Input.number Input.string Input.yesno ^
    ^ Input.path Input.ipv4
set "Category_number.name=Number"
set Category_number.functions= ^
    ^ rand randw ^
    ^ yroot pow ^
    ^ prime gcf ^
    ^ bin2int int2bin int2oct int2hex ^
    ^ int2roman roman2int ^
    ^ is_number is_in_range
set "Category_string.name=String"
set Category_string.functions= ^
    ^ strlen strval ^
    ^ to_upper to_lower to_capital ^
    ^ strip_dquotes shuffle
set "Category_time.name=Date and Time"
set Category_time.functions= ^
    ^ difftime ftime ^
    ^ diffdate fdate what_day ^
    ^ time2epoch epoch2time ^
    ^ timeleft wait %=sleep=%
set "Category_file.name=File and Folder"
set Category_file.functions= ^
    ^ check_path combi_wcdir wcdir ^
    ^ bytes2size size2bytes ^
    ^ hexlify unzip ^
    ^ checksum diffbin  ^
    ^ find_label extract_func ^
    ^ fix_eol check_win_eol
set "Category_net.name=Network"
set Category_net.functions= ^
    ^ check_ipv4 expand_link ^
    ^ get_ext_ip ping_test ^
    ^ download_file
set "Category_env.name=Environment"
set Category_env.functions= ^
    ^ get_con_size get_sid get_os get_pid ^
    ^ watchvar is_admin is_echo_on
set "Category_console.name=Console"
set Category_console.functions= ^
    ^ capchar setup_clearline %=hex2char=% ^
    ^ color2seq color_print
set "Category_packaging.name=Packaging"
set Category_packaging.functions= ^
    ^ module module.entry_point module.read_metadata module.is_module ^
    ^ parse_version updater resolve_dependency extract_ns_func
set "Category_framework.name=Framework"
set Category_framework.functions= ^
    ^ unittest dynamenu ^
    ^ parse_args endlocal
set "Category_others.name=Others"
set Category_others.functions= ^
    ^ %=None=%
exit /b 0


:Function.read
set "Category_all.functions="
for %%c in (!Category.list!) do (
    set "Category_all.functions=!Category_all.functions! !Category_%%c.functions!"
)
for %%c in (all !Category.list! others) do (
    set "Category_%%c.item_count=0"
    set "_temp="
    for %%f in (!Category_%%c.functions!) do (
        set /a "Category_%%c.item_count+=1"
        set "_temp=!_temp! %%f"
    )
    set "Category_%%c.functions=!_temp!"
)
for /f "usebackq tokens=*" %%a in ("%~f0") do (
    for /f "tokens=1" %%b in ("%%a") do for /f "tokens=1-2 delims=:" %%c in ("%%b") do (
        if /i ":%%c" == "%%b" if /i "%%d" == "" (
            for %%f in (!Category_all.functions!) do if "%%c" == "%%f" (
                set "_temp=%%a"
                set "Function_%%f.args=!_temp:~1!"
            )
        )
    )
)
set "Category_all.name=All"
set "Category.list=!Category.list!"
for %%v in (_temp _category _function _handled) do set "%%v="
if not "!Category_others.item_count!" == "0" set "Category.list=!Category.list! others"
exit /b 0


:save_minified   output_path
setlocal EnableDelayedExpansion EnableExtensions
call :Function.read
set "border_line="
for /l %%n in (1,1,40) do set "border_line=!border_line!="
set "test_functions="
for %%c in (core lib debug) do (
    call :find_label result -p "tests.%%c.*"
    set "test_functions=!test_functions!!result!"
)
set "_successful=true"
3> "%~f1" (
    for %%s in (
        "(none): __init__"
        "Metadata: __metadata__ about"
        "License: license"
        "Configurations:  config config.default config.min config.preferences"
        "Changelog: changelog"
        "Scripts/Entry points: scripts.__init__ scripts.lib scripts.lib-noecho scripts.min"
        "User Interfaces: ui.__init__ script_cli help"
        "Core: core.__init__ Category.init Function.read"
        "Batch Script Library: lib.__init__ !Category_all.functions!"
        "Test: tests.__init__ !test_functions!"
    ) do for /f "tokens=1* delims=:" %%a in (%%s) do (
        echo %%a: %%b
        >&3 (
            if /i not "%%a" == "(none)" (
                echo rem !border_line:~0,40! %%a !border_line:~0,40!
                echo=
            )
            call :extract_func "%~f0" "%%b" || set "_successful="
        )
    )
    >&3 (
        echo :__main__
        echo @call :scripts.min %%*
        echo @exit /b %%errorlevel%%
        echo=
        echo=

        call :extract_func "%~f0" "EOF" || set "_successful="
    )
)
if not defined _successful ( 1>&2 echo error: minify failed & exit /b 1 )
exit /b 0


rem ======================================== Library Functions ========================================

:lib
:lib.__init__
rem Functions/snippets from libraries
exit /b 0


:lib.__metadata__
rem set %~1install_requires= ^
rem     ^ your_function_label_here ^
rem     ^ another_function_label_here
exit /b 0


rem ================================ GUIDES ================================

rem Variable names: [A-Za-Z_][A-Za-z0-9_.][A-Za-z0-9]
rem - Starts with an alphabet or underscore
rem - Only use alphabets, numbers, underscores, dashes, and dots
rem - Ends with an alphabet, underscore, or number
rem - Use variable names as a namespace

rem Note:
rem - Most functions assumes that the syntax is valid
rem - external: something that is stored in other files
rem - library functions MUST NOT have external dependencies
rem   (e.g. this is not allowed: call %batchlib%:rand 1 9)
rem - Functions that may have external dependencies:
rem     - 'demo.*'
rem     - 'tests.*' (It is recommended that the function to test itself
rem         is not an external dependency)

rem ========================================================================

rem ================================ Input.number() ================================

rem ======================== documentation ========================

:Input.number.__doc__
echo NAME
echo    Input.number - read a number from standard input
echo=
echo SYNOPSIS
echo    Input.number   return_var  [-m message]  [--range range]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo OPTIONS
echo    -r RANGE, --range RANGE
echo        Specify the valid values. Use '~' to specify a range. The syntax
echo        of RANGE is "<number|min~max> [...]". Hexadecimal and octal are
echo        also supported. If this option is not specified, it defaults to
echo        "-2147483647~2147483647".
echo=
echo    -m MESSAGE, --message MESSAGE
echo        Use MESSAGE as the prompt message.
echo        By default, the message is generated automatically.
exit /b 0


:Input.number.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ is_number ^
    ^ is_in_range
exit /b 0


rem ======================== demo ========================

:demo.Input.number
call %batchlib%:Input.number your_integer --range "-0xf0~-0xff, -99~9, 0x100~0x200,0x16 555"
echo Your input: !your_integer!
exit /b 0


rem ======================== tests ========================

:tests.lib.Input.number.main
> "in\boundaries" (
    echo=
    echo abcdef
    echo *
    echo -2147483648
    echo -2147483647
    echo 2147483647
    echo -65536
    echo 65535
    echo -100
    echo 100
    echo -1
    echo 1
    echo 0
)
for %%a in (
    "100:   0~200   :in\boundaries"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    < "%%d" > nul 2>&1 (
        call :Input.number result --range %%c
    )
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:Input.number   return_var  [-m message]  [-r range]
setlocal EnableDelayedExpansion
for %%v in (_message _range) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message        :store:_message" ^
    ^ "-r, --range          :store:_range"
call :parse_args %* || exit /b 1
if not defined _message (
    if defined _range (
        set "_message=Input %~1 [!_range!]: "
    ) else set "_message=Input %~1: "
)
call :Input.number._loop
for /f "tokens=*" %%r in ("!user_input!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0
#+++

:Input.number._loop
set "user_input="
echo=
set /p "user_input=!_message!"
call :is_number "!user_input!" || goto Input.number._loop
call :is_in_range "!user_input!" "!_range!" || goto Input.number._loop
exit /b 0


rem ================================ Input.string() ================================

rem ======================== documentation ========================

:Input.string.__doc__
echo NAME
echo    Input.string - read a string from standard input
echo=
echo SYNOPSIS
echo    Input.string   return_var  [-m message]  [-f]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo OPTIONS
echo    -f, --filled
echo        The string must not be an empty string.
echo=
echo    -m MESSAGE, --message MESSAGE
echo        Use MESSAGE as the prompt message.
echo        By default, the message is generated automatically.
echo=
echo EXIT STATUS
echo    0:  - Input is not empty.
echo    1:  - Input is an empty string.
exit /b 0


:Input.string.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.Input.string
call %batchlib%:Input.string your_text --message "Enter anything: "
echo Your input: "!your_text!"
call %batchlib%:Input.string your_text --filled --message "Enter something: "
echo Your input: "!your_text!"
exit /b 0


rem ======================== tests ========================

:tests.lib.Input.string.main
> "in\empty" (
    echo=
    echo hello
    echo   world
)
> "in\spaced" (
    echo   world  %=END=%
)
> "in\semicolon" (
    echo ; pass
    echo fail
)
set "evaluate_result=call :tests.lib.Input.string.evaluate_result"

< "in\empty" > nul 2>&1 (
    set "expected_result="
    call :Input.string result
) & !evaluate_result! "null"

< "in\spaced" > nul 2>&1 (
    set "expected_result=  world  "
    call :Input.string result
) & !evaluate_result! "keep spaces"

< "in\semicolon" > nul 2>&1 (
    set "expected_result=; pass"
    call :Input.string result
) & !evaluate_result! "ignore semicolon EOL"

< "in\empty" > nul 2>&1 (
    set "expected_result=hello"
    call :Input.string result --filled
) & !evaluate_result! "ignore null"

REM < "in\spaced" > nul 2>&1 (
    REM set "expected_result=world"
    REM call :Input.string result --trim
REM ) & !evaluate_result! "trim spaces [WIP]"

exit /b 0
#+++

:tests.lib.Input.string.evaluate_result
if not "!result!" == "!expected_result!" (
    call %unittest%.fail %1
)
exit /b


rem ======================== function ========================

:Input.string   return_var  [-m message]  [-f]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_message _require_filled) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message    :store:_message" ^
    ^ "-f, --filled     :store_const:_require_filled=true"
call :parse_args %* || exit /b 1
if not defined _message set "_message=Input %~1: "
call :Input.string._loop
for /f tokens^=*^ delims^=^ eol^= %%c in ("_!user_input!_") do (
    endlocal
    set "%~1=%%~c"
    set "%~1=!%~1:~1,-1!"
    if not defined %~1 exit /b 1
)
exit /b 0
#+++

:Input.string._loop
echo=
set "user_input="
echo=!_message!
set /p "user_input="
if defined _require_filled if not defined user_input goto Input.string._loop
exit /b 0


rem ======================== notes ========================

if defined _trim_spaces (
    set "user_input=!user_input!."
    for /f tokens^=*^ eol^= %%a in ("!user_input!") do set "user_input=%%a"
    rem for /l %%a in (1,1,100) do if "!input:~-1!"==" " set input=!input:~0,-1!
    set "user_input=!user_input:~0,-1!"
)

rem Trimming
set "user_input=!user_input!."
rem Process string / trim
for /f "tokens=* delims= " %%a in ("!user_input!") do (
    endlocal
    set "%~1=%%b"
    if /i "%user_input%" == "Y" exit /b 0
)

rem ================================ Input.yesno() ================================

rem ======================== documentation ========================

:Input.yesno.__doc__
echo NAME
echo    Input.yesno - read a yes/no from standard input
echo=
echo SYNOPSIS
echo    Input.yesno   return_var  [-m message]  [-y value]  [-n value]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo OPTIONS
echo    -y VALUE, --yes VALUE
echo        Returns VALUE if user enters any string that starts with 'Y'.
echo        By default, it is 'Y'.
echo=
echo    -n VALUE, --no VALUE
echo        Returns VALUE if user enters any string that starts with 'N'.
echo        By default, it is 'N'.
echo=
echo    -m MESSAGE, --message MESSAGE
echo        Use MESSAGE as the prompt message.
echo        By default, the message is generated automatically.
echo=
echo EXIT STATUS
echo    0:  - User enters any string that starts with 'Y'.
echo    1:  - User enters any string that starts with 'N'.
exit /b 0


:Input.yesno.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.Input.yesno
call %batchlib%:Input.yesno your_ans --message "Do you like programming? Y/N? " && (
    echo Its a yes^^!
) || echo Its a no...
echo Your input: !your_ans!

call %batchlib%:Input.yesno your_ans --message "Is it true? Y/N? " --yes "true" --no "false"
echo Your input ("true", "false"): !your_ans!

call %batchlib%:Input.yesno your_ans --message "Do you like to eat? Y/N? " --yes="Yes" --no="No"
echo Your input ("Yes", "No"): !your_ans!

call %batchlib%:Input.yesno your_ans --message "Do you excercise? Y/N? " -y "1" -n "0"
echo Your input ("1", "0"): !your_ans!

call %batchlib%:Input.yesno your_ans --message "Is this defined? Y/N? " -y="Yes" -n=""
echo Your input ("Yes", ""): !your_ans!
exit /b 0


rem ======================== function ========================

:Input.yesno   return_var  [-m message]  [-y value]  [-n value]
setlocal EnableDelayedExpansion EnableExtensions
set "_message=Y/N? "
set "_yes_value=Y"
set "_no_value=N"
set parse_args.args= ^
    ^ "-m, --message        :store:_message" ^
    ^ "-y, --yes            :store:_yes_value" ^
    ^ "-n, --no             :store:_no_value"
call :parse_args %*
call :Input.yesno._loop
set "_result="
if /i "!user_input:~0,1!" == "Y" set "_result=!_yes_value!"
if /i "!user_input:~0,1!" == "N" set "_result=!_no_value!"
if defined _result (
    for /f tokens^=*^ delims^=^ eol^= %%a in ("!_result!") do (
        endlocal
        set "%~1=%%a"
        if /i "%user_input:~0,1%" == "Y" exit /b 0
    )
) else (
    endlocal
    set "%~1="
    if /i "%user_input:~0,1%" == "Y" exit /b 0
)
exit /b 1
#+++

:Input.yesno._loop
echo=
set /p "user_input=!_message!"
if /i "!user_input:~0,1!" == "Y" exit /b 0
if /i "!user_input:~0,1!" == "N" exit /b 0
goto Input.yesno._loop


rem ================================ Input.path() ================================

rem ======================== documentation ========================

:Input.path.__doc__
echo NAME
echo    Input.path - read a path string from standard input
echo=
echo SYNOPSIS
echo    Input.path   return_var  [-m message]  [-e^|-n]  [-f^|-d]  [-o]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the absolte path of the file/folder.
echo=
echo OPTIONS
echo    -e, --exist
echo        Target must exist. Mutually exclusive with '--not-exist'.
echo=
echo    -n, --not-exist
echo        Target must not exist. Mutually exclusive with '--exist'.
echo=
echo    -f, --file
echo        Target must be a file (if exist). Mutually exclusive with '--directory'.
echo=
echo    -d, --directory
echo        Target must be a folder (if exist). Mutually exclusive with '--file'.
echo=
echo    -o, --optional
echo        Input is optional and could be skipped.
echo=
echo    -m MESSAGE, --message MESSAGE
echo        Use MESSAGE as the prompt message.
echo        By default, the message is generated automatically.
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    1:  - User skips the input.
exit /b 0


:Input.path.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ check_path
exit /b 0


rem ======================== demo ========================

:demo.Input.path
call %batchlib%:Input.path config_file --exist --file --message "Input an existing file: "
echo Result: !config_file!
pause

call %batchlib%:Input.path save_folder --optional --directory ^
    ^ --message "Input an existing folder or a new folder name: "
echo Result: !save_folder!
pause

call %batchlib%:Input.path new_name --optional --not-exist ^
    ^ --message "Input a non-existing file/folder: "
echo Result: !new_name!
exit /b 0


rem ======================== function ========================

:Input.path   return_var  [-m message]  [-e|-n]  [-f|-d]  [-o]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_message _is_optional _check_options) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message    :store:_message" ^
    ^ "-o, --optional   :store_const:_is_optional=true" ^
    ^ "-e, --exist      :append_const:_check_options= -e" ^
    ^ "-n, --not-exist  :append_const:_check_options= -n" ^
    ^ "-f, --file       :append_const:_check_options= -f" ^
    ^ "-d, --directory  :append_const:_check_options= -d"
call :parse_args %*
if not defined _message set "_message=Input %~1: "
call :Input.path._loop
for /f "tokens=* eol= delims=" %%c in ("!user_input!") do (
    endlocal
    set "%~1=%%c"
    set "last_used.file=%%c"
)
exit /b 0
#+++

:Input.path._loop
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
echo !_message!
set /p "user_input="
echo=
if not defined user_input goto Input.path._loop
if defined last_used.file   if /i "!user_input!" == ":P" set "user_input=!last_used.file!"
if defined _is_optional     if /i "!user_input!" == ":S" set "user_input="
if defined user_input call :check_path user_input !_check_options! || (
    pause
    goto Input.path._loop
)
exit /b 0


rem ================================ Input.ipv4() ================================

rem ======================== documentation ========================

:Input.ipv4.__doc__
echo NAME
echo    Input.ipv4 - read an IPv4 from standard input
echo=
echo SYNOPSIS
echo    Input.ipv4   return_var  [-m message]  [-w]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo OPTIONS
echo    -w, --allow-wildcard
echo        Allow wildcards in the IPv4 address.
echo=
echo    -m MESSAGE, --message MESSAGE
echo        By default, the message is generated automatically.
exit /b 0


:Input.ipv4.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ check_ipv4
exit /b 0


rem ======================== demo ========================

:demo.Input.ipv4
call %batchlib%:Input.ipv4 -w user_input --message "Input an IPv4 (wildcard allowed): "
echo Your input: !user_input!
exit /b 0


rem ======================== tests ========================

:tests.lib.Input.ipv4.main
> "in\case1" (
    echo=
    echo 0
    echo a.b.c.d
    echo *.*.*.*
    echo 0.0.0.0
)
set "evaluate_result=call :tests.lib.Input.ipv4.evaluate_result"

< "in\case1" > nul 2>&1 (
    set "expected_result=0.0.0.0"
    call :Input.ipv4 result
) & !evaluate_result! "default"

< "in\case1" > nul 2>&1 (
    set "expected_result=*.*.*.*"
    call :Input.ipv4 result --allow-wildcard
) & !evaluate_result! "allow wildcard"

exit /b 0
#+++

:tests.lib.Input.ipv4.evaluate_result
if not "!result!" == "!expected_result!" (
    call %unittest%.fail %1
)
exit /b


rem ======================== function ========================

:Input.ipv4   return_var  [-m message]  [-w]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_message _allow_wildcard _check_options) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message        :store:_message" ^
    ^ "-w, --allow-wildcard :store_const:_allow_wildcard=true"
call :parse_args %*
if defined _allow_wildcard set "_check_options= --wildcard"
if not defined _message (
    if defined _allow_wildcard (
        set "_message=Input %~1 (Wildcard allowed): "
    ) else set "_message=Input %~1: "
)
call :Input.ipv4._loop
for /f "tokens=*" %%r in ("!user_input!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0
#+++

:Input.ipv4._loop
set /p "user_input=!_message!"
echo=
call :check_ipv4 "!user_input!" !_check_options! && exit /b 0
goto Input.ipv4._loop


rem ================================ rand() ================================

rem ======================== documentation ========================

:rand.__doc__
echo NAME
echo    rand - generate random number within a range
echo=
echo SYNOPSIS
echo    rand   return_var  minimum  maximum
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    minimum
echo        Minimum value (inclusive) of the random number.
echo=
echo    maximum
echo        Maximum value (inclusive) of the random number.
echo=
echo LIMITATIONS
echo    rand() does not generate uniform random numbers. Its simplicity comes
echo    along with the modulo bias. Do not use this for statistical computation.
exit /b 0


:rand.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.rand
call %batchlib%:Input.number minimum --range "0~2147483647"
call %batchlib%:Input.number maximum --range "0~2147483647"
call %batchlib%:rand random_int !minimum! !maximum!
echo=
echo Random Number  : !random_int!
exit /b 0


rem ======================== function ========================

:rand   return_var  minimum  maximum
set /a "%~1=((!random!<<16) + (!random!<<1) + (!random!>>14)) %% ((%~3)-(%~2)+1) + (%~2)"
exit /b 0


rem ======================== notes ========================

rem Generate random number from -2^31 to 2^31-1:
set /a "%~1=(!random!<<17 + !random!<<2 + !random!>>13) %% ((%~3)-(%~2)+1) + (%~2)"

rem ================================ randw() ================================

rem ======================== documentation ========================

:randw.__doc__
echo NAME
echo    randw - select random option based on weights
echo=
echo SYNOPSIS
echo    randw   return_var  weights
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result. It returns the index number of the
echo        option (i.e. the first option is 0, the second option is 1).
echo=
echo    weight
echo        The weight of the option. The syntax of RANGE is "weight [...]".
echo        There should be at least 1 weight.
echo=
echo NOTES
echo    - Based on: rand()
echo=
echo LIMITATIONS
echo    randw() does not generate uniform random numbers. Its simplicity comes
echo    along with the modulo bias. Do not use this for statistical computation.
exit /b 0


:randw.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.randw
call %batchlib%:Input.string weights
call %batchlib%:randw random_int "!weights!"
echo=
echo Random Number  : !random_int!
exit /b 0


rem ======================== function ========================

:randw   return_var  weights
set "%~1="
setlocal EnableDelayedExpansion
set "_sum=0"
for %%n in (%~2) do set /a "_sum+=%%~n"
set /a "_rand=((!random!<<16) + (!random!<<1) + (!random!>>14)) %% !_sum!"
set "_sum=0"
set "_index=0"
set "_result="
for %%n in (%~2) do if not defined _result (
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

rem ======================== documentation ========================

:yroot.__doc__
echo NAME
echo    yroot - calculate y root of x
echo=
echo SYNOPSIS
echo    yroot   return_var  integer  power
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result (rounded down to the nearest integer).
echo=
echo    integer
echo        The number to yroot (i.e. the 'x').
echo=
echo    power
echo        The power of the root (i.e. the 'y').
echo=
echo NOTES
echo    - In case someone needs it: yroot of x to the power of 0 does not exist.
exit /b 0


:yroot.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.yroot
call %batchlib%:Input.number number --range "0~2147483647"
call %batchlib%:Input.number power --range "0~2147483647"
call %batchlib%:yroot result !number! !power!
echo=
echo Root to the power of !power! of !number! is !result!
echo Result is round down
exit /b 0


rem ======================== tests ========================

:tests.lib.yroot.main
for /l %%p in (1,1,31) do for %%n in (0 1) do (
    call :yroot result %%n %%p
    if not "!result!" == "%%n" (
        call %unittest%.fail "%%n: %%n %%p"
    )
)

for %%a in (
    "2147483647:    2147483647 1"
    "46340:         2147395600 2"
    "1290:          2146689000 3"
    "215:           2136750625 4"
    "73:            2073071593 5"
    "35:            1838265625 6"
    "21:            1801088541 7"
    "4:             1073741824 15"
    "2:             1073741824 30"
    "1:             1 31"

    "2147483647:    2147483647 1"
    "46340:         2147483647 2"
    "1290:          2147483647 3"
    "215:           2147483647 4"
    "73:            2147483647 5"
    "35:            2147483647 6"
    "21:            2147483647 7"
    "4:             2147483647 15"
    "2:             2147483647 30"
    "1:             2147483647 31"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :yroot result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail
    )
)
exit /b 0


rem ======================== function ========================

:yroot   return_var  integer  power
set "%~1="
setlocal EnableDelayedExpansion
set "_result=0"
for /l %%b in (31,-1,0) do (
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

rem ======================== documentation ========================

:pow.__doc__
echo NAME
echo    pow - calculate x to the power of y
echo=
echo SYNOPSIS
echo    pow   return_var  integer  power
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    integer
echo        The base number (i.e. the 'x').
echo=
echo    power
echo        How many times to multiply (i.e. the 'y').
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    1:  - The result is too large (^> 2147483647).
echo        - The integer is too large (^> 2147483647).
exit /b 0


:pow.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.pow
call %batchlib%:Input.number number --range "0~2147483647"
call %batchlib%:Input.number power --range "0~2147483647"
call %batchlib%:pow result !number! !power!
echo=
echo !number! to the power of !power! is !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.pow.main
for %%a in (
    "2147483647:    2147483647 1"
    "2147395600:    46340 2"
    "2146689000:    1290 3"
    "2136750625:    215 4"
    "2073071593:    73 5"
    "1838265625:    35 6"
    "1801088541:    21 7"
    "1073741824:    4 15"
    "1073741824:    2 30"
    "1:             1 31"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :pow result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)

for %%a in (
    "2147483648 1"
    "2147483647 2"
    "46340 3"
    "1290 4"
    "215 5"
    "73 6"
    "35 7"
    "21 8"
    "4 16"
    "2 31"
) do (
    call :pow result %%~a 2> nul && call %unittest%.fail "unexpected success: %%~a"
)
exit /b 0


rem ======================== function ========================

:pow   return_var  integer  power
set "%~1="
setlocal EnableDelayedExpansion
set "_result=1"
set "_limit=0x7FFFFFFF"
for /l %%p in (1,1,%~3) do (
    set /a "_result*=%~2" || ( 1>&2 echo error: integer is too large & exit /b 1 )
    set /a "_limit/=%~2"
)
if "!_limit!" == "0" ( 1>&2 echo error: result is too large & exit /b 1 )
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ================================ prime() ================================

rem ======================== documentation ========================

:prime.__doc__
echo NAME
echo    prime - check if a number is a prime number
echo=
echo SYNOPSIS
echo    prime   return_var  integer
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the smallest factor.
echo=
echo    integer
echo        The number to test for prime.
echo=
echo BEHAVIOR
echo    - If it is a prime number, the same number is returned, since
echo      the smallest factor of a prime number is itself.
echo    - If it is a composite number, the smallest factor is returned.
echo    - If it is neither a prime nor a composite number, 0 is returned.
echo=
echo NOTES
echo    - Based on: yroot()
exit /b 0


:prime.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.prime
call %batchlib%:Input.number number --range "0~2147483647"
call %batchlib%:prime factor !number!
echo=
if "!factor!" == "!number!" (
    echo !number! is a prime number
) else if "!factor!" == "0" (
    echo !number! is not a prime number nor a composite number
) else (
    echo !number! is a composite number. It is divisible by !factor!
)
exit /b 0


rem ======================== tests ========================

:tests.lib.prime.main
for %%a in (
    "2147483647:    2147483647"
    "2:             2147483646"
    "5:             2147483645"
    "3:             2147483643"
    "2699:          2147483641"
    "46337:         2147117569"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :prime result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


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

rem ======================== documentation ========================

:gcf.__doc__
echo NAME
echo    gcf - calculate the greatest common factor of two numbers
echo=
echo SYNOPSIS
echo    gcf   return_var  integer1  integer2
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    integer
echo        The numbers to calculate its GCF.
exit /b 0


:gcf.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.gcf
call %batchlib%:Input.number number1 --range "0~2147483647"
call %batchlib%:Input.number number2 --range "0~2147483647"
call %batchlib%:gcf result !number1! !number2!
echo=
echo GCF of !number1! and !number2! is !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.gcf.main
for %%a in (
    "1:             1836311903 1134903170"
    "28657:         1836311903 1134903171"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :gcf result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


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

rem ======================== documentation ========================

:bin2int.__doc__
echo NAME
echo    bin2int - convert binary to decimal
echo=
echo SYNOPSIS
echo    bin2int   return_var  unsigned_binary
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    unsigned_binary
echo        The unsigned binary to convert. The maximum length supported is 31.
exit /b 0


:bin2int.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.bin2int
call %batchlib%:Input.string binary
call %batchlib%:bin2int result !binary!
echo=
echo The decimal value is !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.bin2int.main
for %%a in (
    "0:     0"
    "1:     1"
    "0:     00"
    "1:     01"
    "2:     10"
    "3:     11"
    "536870910:     0011111111111111111111111111110"
    "1073741820:    0111111111111111111111111111100"
    "2147483647:    1111111111111111111111111111111"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :bin2int result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


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

rem ======================== documentation ========================

:int2bin.__doc__
echo NAME
echo    int2bin - convert decimal to unsigned binary
echo=
echo SYNOPSIS
echo    int2bin   return_var  positive_integer
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    positive_integer
echo        The positive integer to convert.
exit /b 0


:int2bin.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.int2bin
call %batchlib%:Input.number decimal --range "0~2147483647"
call %batchlib%:int2bin result !decimal!
echo=
echo The binary value is !result!
exit /b 0


rem ======================== function ========================

:int2bin   return_var  positive_integer
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
for /l %%i in (0,1,31) do (
    set /a "_bits=(%~2>>%%i) & 0x1"
    set "_result=!_bits!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Q0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0


rem ================================ int2oct() ================================

rem ======================== documentation ========================

:int2oct.__doc__
echo NAME
echo    int2oct - convert decimal to octal
echo=
echo SYNOPSIS
echo    int2oct   return_var  positive_integer
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    positive_integer
echo        The positive integer to convert.
exit /b 0


:int2oct.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.int2oct
call %batchlib%:Input.number decimal --range "0~2147483647"
call %batchlib%:int2oct result !decimal!
echo=
echo The octal value is !result!
exit /b 0


rem ======================== function ========================

:int2oct   return_var  positive_integer
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
for /l %%i in (0,3,31) do (
    set /a "_bits=(%~2>>%%i) & 0x7"
    set "_result=!_bits!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Q0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0


rem ================================ int2hex() ================================

rem ======================== documentation ========================

:int2hex.__doc__
echo NAME
echo    int2hex - convert decimal to hexadecimal
echo=
echo SYNOPSIS
echo    int2hex   return_var  positive_integer
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    positive_integer
echo        The positive integer to convert.
exit /b 0


:int2hex.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.int2hex
call %batchlib%:Input.number decimal --range "0~2147483647"
call %batchlib%:int2hex result !decimal!
echo=
echo The hexadecimal value is !result!
exit /b 0


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
for /f "tokens=1* delims=0" %%a in ("Q0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0


rem ================================ int2roman() ================================

rem ======================== documentation ========================

:int2roman.__doc__
echo NAME
echo    int2roman - convert number to roman numeral
echo=
echo SYNOPSIS
echo    int2roman   return_var  integer
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    integer
echo        The integer to convert. The valid range is from 1 to 4999.
exit /b 0


:int2roman.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.int2roman
call %batchlib%:Input.number number --range "1~4999"
call %batchlib%:int2roman result !number!
echo=
echo The roman numeral value is !result!
exit /b 0


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

rem ======================== documentation ========================

:roman2int.__doc__
echo NAME
echo    roman2int - convert roman numeral to number
echo=
echo SYNOPSIS
echo    roman2int   return_var  roman_numeral
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    roman_numeral
echo        The string that contains roman numeral (IVXLCDM). Case-insensitive.
exit /b 0


:roman2int.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.roman2int
call %batchlib%:Input.string roman_numeral
call %batchlib%:roman2int result !roman_numeral!
echo=
echo The decimal value is !result!
exit /b 0


rem ======================== function ========================

:roman2int   return_var  roman_numeral
set "%~1=%~2"
for %%r in (
    IV.4 XL.40 CD.400 IX.9 XC.90 CM.900 I.1 V.5 X.10 L.50 C.100 D.500 M.1000
) do set "%~1=!%~1:%%~nr=+%%~xr!"
set /a "%~1=!%~1:.=!"
exit /b 0


rem ================================ is_number() ================================

rem ======================== documentation ========================

:is_number.__doc__
echo NAME
echo    is_number - check if a string is a number
echo=
echo SYNOPSIS
echo    is_number   input_string
echo=
echo DESCRIPTION
echo    Check if a string only contains a number; no words or other symbols.
echo=
echo POSITIONAL ARGUMENTS
echo    input_string
echo        The string to check.
echo=
echo EXIT STATUS
echo    0:  - The string contains a number/hexadecimal/octal between
echo          -2147483647 to 2147483647.
echo    1:  - The string contains an invalid number or other symbols.
echo=
echo NOTES
echo    - Hexadecimal and octal are supported
echo    - Hexadecimal must start with '0x' (case insensitive)
echo    - Octal must start with '0'
exit /b 0


:is_number.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.is_number
call %batchlib%:Input.string string
call %batchlib%:is_number "!string!" && (
    echo It is a number
) || echo It is not a number
exit /b 0


rem ======================== tests ========================

:tests.lib.is_number.main
set "return.true=0"
set "return.false=1"
for %%a in (
    "true: 1"
    "true: 0"
    "true: +1"
    "true: -1"
    "true: 2147483647"
    "true: -2147483647"

    "true: 00"
    "true: 010"
    "true: -07"

    "true: 0x0"
    "true: 0x10"
    "true: 0xabcdef"

    "false: -"
    "false: x"
    "false: 0x"
    "false: x0"
    "false: -0x"

    "false: abcdef"
    "false: 08"
    "false: +"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :is_number %%c 2> nul
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "!return.%%b!" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:is_number   input_string
setlocal EnableDelayedExpansion
set "_input=%~1"
for /f "tokens=1-3" %%a in ("x !_input!") do (
    if "%%b" == "" exit /b 1
    if not "%%c" == "" exit /b 1
    set "_input=%%b"
)
for /f "tokens=1-2 delims=+-" %%a in ("x+!_input!") do set "_input=%%b"
if "!_input!" == "0" exit /b 0
if not defined _input exit /b 1
set "_input=!_input!_"
set "_valid_chars=0 1 2 3 4 5 6 7 8 9"
if /i "!_input:~0,2!" == "0x" (
    set "_input=!_input:~2!"
    if not "!_input:~9!" == "" exit /b 1
    set "_valid_chars=0 1 2 3 4 5 6 7 8 9 A B C D E F"
) else if "!_input:~0,1!" == "0" (
    set "_input=!_input:~1!"
    if not "!_input:~11!" == "" exit /b 1
    set "_valid_chars=0 1 2 3 4 5 6 7"
)
if "!_input!" == "_" exit /b 1
for %%c in (!_valid_chars!) do set "_input=!_input:%%c=!"
if not "!_input!" == "_" exit /b 1
set "_input="
set /a "_input=%~1" || exit /b 1
set /a "_input=!_input!" || exit /b 1
exit /b 0


rem ================================ is_in_range() ================================

rem ======================== documentation ========================

:is_in_range.__doc__
echo NAME
echo    is_in_range - check if a number is within the specified range
echo=
echo SYNOPSIS
echo    is_in_range   number  range
echo=
echo POSITIONAL ARGUMENTS
echo    number
echo        The number to check. Hexadecimal and octal are also supported.
echo=
echo    range
echo        Specify the valid values. Use '~' to specify a range. The syntax
echo        of RANGE is "<number|min~max> [...]". Hexadecimal and octal are
echo        also supported. If this option is not specified, it defaults to
echo        "-2147483647~2147483647".
echo=
echo EXIT STATUS
echo    0:  - The number is within the specified range.
echo    1:  - The number is not within the specified range.
echo        - The number is invalid.
echo    2:  - The range is invalid.
exit /b 0


:is_in_range.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.is_in_range
call %batchlib%:Input.number number
call %batchlib%:Input.string range
echo=
call %batchlib%:is_in_range "!number!" "!range!" && (
    echo Number is within range
) || echo Number is not within range
exit /b 0


rem ======================== tests ========================

:tests.lib.is_in_range.main
set "return.true=0"
set "return.false=1"
for %%a in (
    "false: "
    "false: -2147483648"
    "true: -2147483647"
    "true: 2147483647"
    "true: -2"
    "true: 2"
    "true: -1"
    "true: 1"
    "true: -0"
    "true: 0"
    "true: 10 10"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :is_in_range %%c 2> nul
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "!return.%%b!" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:is_in_range   number  range
setlocal EnableDelayedExpansion
set "_evaluated="
set /a "_evaluated=%~1" || ( 1>&2 echo error: failed to evaluate number & exit /b 1 )
set /a "_input=!_evaluated!" || ( 1>&2 echo error: failed to evaluate number & exit /b 1 )
if !_input! GEQ 0 (
    set "_input.sym=+"
) else set "_input.sym=-"
set "_range=%~2"
if not defined _range set "_range=-2147483647~2147483647"
for %%r in (!_range!) do for /f "tokens=1,2 delims=~ " %%a in ("%%~r") do (
    set "_min=%%a"
    set "_max=%%b"
    if not defined _max set "_max=!_min!"
    for %%v in (_min _max) do (
        set "_evaluated="
        set /a "_evaluated=!%%v!" || ( 1>&2 echo error: invalid range '!%%v!' & exit /b 2 )
        set /a "%%v=!_evaluated!" || ( 1>&2 echo error: invalid range '!%%v!' & exit /b 2 )
        if !%%v! GEQ 0 (
            set "%%v.sym=+"
        ) else set "%%v.sym=-"
    )
    set "_invalid=true"
    for %%v in (_min _max) do if "!_input.sym!" == "!%%v.sym!" set "_invalid="
    if "!_input.sym!" == "!_min.sym!" if !_input! LSS !_min! set "_invalid=true"
    if "!_input.sym!" == "!_max.sym!" if !_input! GTR !_max! set "_invalid=true"
    if not defined _invalid exit /b 0
)
exit /b 1


rem ================================ strlen() ================================

rem ======================== documentation ========================

:strlen.__doc__
echo NAME
echo    strlen - calculate length of a string
echo=
echo SYNOPSIS
echo    strlen   return_var  input_var
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    input_var
echo        The input variable name.
echo=
echo NOTES
echo    - strlen uses binary search for calculating the string length
echo      so it is significantly fast.
exit /b 0


:strlen.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.strlen
call %batchlib%:Input.string string
call %batchlib%:strlen length string
echo=
echo The length of the string is !length! characters
exit /b 0


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


rem ================================ strval() ================================

rem ======================== documentation ========================

:strval.__doc__
echo NAME
echo    strval - determine the integer value of a string
echo=
echo SYNOPSIS
echo    strval   return_var  input_var
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    input_var
echo        The input variable name.
echo=
exit /b 0


:strval.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.strval
call %batchlib%:Input.string string
call %batchlib%:strval result string
echo=
echo Integer value : !result!
exit /b 0


rem ======================== function ========================

:strval   return_var  input_var
set /a "%~1=0x80000000"
for /l %%i in (31,-1,0) do (
    set /a "%~1+=0x1<<%%i"
    if !%~2! LSS !%~1! set /a "%~1-=0x1<<%%i"
)
exit /b 0


rem ======================================= to_upper() ================================

rem ======================== documentation ========================

:to_upper.__doc__
echo NAME
echo    to_upper - convert string to uppercase
echo=
echo SYNOPSIS
echo    to_upper   input_var
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
exit /b 0


:to_upper.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.to_upper
call %batchlib%:Input.string string
call %batchlib%:to_upper string
echo=
echo Uppercase:
echo=!string!
exit /b 0


rem ======================== function ========================

:to_upper   input_var
set "%1= !%1!"
for %%a in (
    A B C D E F G H I J K L M
    N O P Q R S T U V W X Y Z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0


rem ======================================= to_lower() ================================

rem ======================== documentation ========================

:to_lower.__doc__
echo NAME
echo    to_lower - convert string to lowercase
echo=
echo SYNOPSIS
echo    to_lower   input_var
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
exit /b 0


:to_lower.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.to_lower
call %batchlib%:Input.string string
call %batchlib%:to_lower string
echo=
echo Lowercase:
echo=!string!
exit /b 0


rem ======================== function ========================

:to_lower   input_var
set "%1= !%1!"
for %%a in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0


rem ======================================= to_capital() ================================

rem ======================== documentation ========================

:to_capital.__doc__
echo NAME
echo    to_capital - convert string to capital case
echo=
echo SYNOPSIS
echo    to_capital   input_var
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
exit /b 0


:to_capital.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.to_capital
call %batchlib%:Input.string string
call %batchlib%:to_capital string
echo=
echo Capitalcase:
echo=!string!
exit /b 0


rem ======================== function ========================

:to_capital   input_var
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

rem ======================== documentation ========================

:strip_dquotes.__doc__
echo NAME
echo    strip_dquotes - remove surrounding double quotes in a variable
echo=
echo SYNOPSIS
echo    strip_dquotes   input_var
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
echo=
echo NOTES
echo    - Double quotes are stripped only if both ends of the string is a
echo      double quote character.
exit /b 0


:strip_dquotes.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.strip_dquotes
call %batchlib%:Input.string string
call %batchlib%:strip_dquotes string
echo=
echo Stripped : !string!
exit /b 0


rem ======================== function ========================

:strip_dquotes   input_var
if "!%~1:~0,1!!%~1:~-1,1!" == ^"^"^"^" set "%~1=!%~1:~1,-1!"
exit /b 0


rem ================================ shuffle() ================================

rem ======================== documentation ========================

:shuffle.__doc__
echo NAME
echo    shuffle - shuffle characters in a string
echo=
echo SYNOPSIS
echo    shuffle   input_var
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
exit /b 0


:shuffle.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ strlen
exit /b 0


rem ======================== demo ========================

:demo.shuffle
call %batchlib%:Input.string text
call %batchlib%:shuffle text
echo=
echo Shuffled string:
echo=!text!
exit /b 0


rem ======================== function ========================

:shuffle   input_var
if defined %~1 (
    setlocal EnableDelayedExpansion
    set "_result=!%~1!"
    call :strlen _length _result
    for /l %%s in (0,1,!_length!) do (
        set /a "_rand=((!random!<<0x10) + (!random!<<0x1) + (!random!>>0xE)) %% (!_length! - %%s + 1)"
        set /a "_index=!_rand!+%%s"
        for %%r in (!_rand!) do for %%i in (!_index!) do (
            set "_result=!_result:~0,%%s!!_result:~%%i!!_result:~%%s,%%r!"
        )
    )
    for /f "tokens=*" %%a in ("!_result!") do (
        endlocal
        set "%~1=%%a"
    )
)
exit /b 0


rem ================================ difftime() =======================================

rem ======================== documentation ========================

:difftime.__doc__
echo NAME
echo    difftime - calculate time difference in centiseconds
echo=
echo SYNOPSIS
echo    difftime   return_var  end_time  [start_time] [--no-fix]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    end_time
echo        The end time. The hour is zero padded.
echo=
echo    start_time
echo        The start time. By default, it is '00:00:00.00'. Supports
echo        hours that are padded with spaces and zeros.
echo=
echo OPTIONS
echo    --no-fix
echo        Don't fix negative centiseconds. This must be placed
echo        as the fourth argument.
echo=
echo NOTES
echo    - The format of the time is 'HH:MM:SS.CC'.
exit /b 0


:difftime.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem (!) Add support for time format: 'HH.MM.SS,CC'

rem ======================== demo ========================

:demo.difftime
call %batchlib%:Input.string start_time
call %batchlib%:Input.string end_time
call %batchlib%:difftime time_taken !end_time! !start_time!
echo=
echo Time difference: !time_taken! centiseconds
exit /b 0


rem ======================== function ========================

:difftime   return_var  end_time  [start_time] [--no-fix]
set "%~1=0"
for %%t in (%~2:00:00:00:00 %~3:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
    set /a "%~1+=24%%a %% 24 *360000 +1%%b*6000 +1%%c*100 +1%%d -610100"
    set /a "%~1*=-1"
)
if /i not "%4" == "--no-fix" if "!%~1:~0,1!" == "-" set /a "%~1+=8640000"
exit /b 0


rem ================================ ftime() ================================

rem ======================== documentation ========================

:ftime.__doc__
echo NAME
echo    ftime - convert time to human readable time
echo=
echo SYNOPSIS
echo    ftime   return_var  centiseconds
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result. The hour is zero padded.
echo=
echo    centiseconds
echo        The time in centiseconds (1/100 second).
echo=
echo NOTES
echo    - The format of the time is 'HH:MM:SS.CC'.
exit /b 0


:ftime.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.ftime
call %batchlib%:Input.string time_in_centisecond
call %batchlib%:ftime time_taken !time_in_centisecond!
echo=
echo Formatted time : !time_taken!
exit /b 0


rem ======================== function ========================

:ftime   return_var  centiseconds
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

rem ======================== documentation ========================

:diffdate.__doc__
echo NAME
echo    diffdate - calculate date difference in days
echo=
echo SYNOPSIS
echo    diffdate   return_var  end_date  [start_date]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    end_date
echo        The end date.
echo=
echo    start_date
echo        The start date. By default, it is epoch (1/01/1970).
echo=
echo NOTES
echo    - This function uses Gregorian calendar system.
echo    - The date format used is 'mm/dd/YYYY'.
exit /b 0


:diffdate.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.diffdate
call %batchlib%:Input.string start_date
call %batchlib%:Input.string end_date
call %batchlib%:diffdate difference !end_date! !start_date!
echo=
echo Difference : !difference! Days
exit /b 0


rem ======================== tests ========================

:tests.lib.diffdate.main
for %%a in (
    "0:       01/01/1970"
    "30:      01/31/1970"

    "31:      02/01/1970"
    "58:      02/28/1970"

    "59:      03/01/1970"
    "90:      04/01/1970"
    "120:     05/01/1970"
    "151:     06/01/1970"
    "181:     07/01/1970"
    "212:     08/01/1970"
    "243:     09/01/1970"
    "273:     10/01/1970"
    "304:     11/01/1970"
    "334:     12/01/1970"

    "364:     12/31/1970"
    "365:     01/01/1971"   "423:     02/28/1971"   "424:     03/01/1971"   "729:     12/31/1971"
    "730:     01/01/1972"   "789:     02/29/1972"   "790:     03/01/1972"   "1095:    12/31/1972"
    "1096:    01/01/1973"

    "10956:   12/31/1999"
    "10957:   01/01/2000"   "11016:   02/29/2000"   "11017:   03/01/2000"   "11322:   12/31/2000"
    "47482:   01/01/2100"   "47540:   02/28/2100"   "47541:   03/01/2100"   "47846:   12/31/2100"
    "157054:  01/01/2400"   "157113:  02/29/2400"   "157114:  03/01/2400"   "157419:  12/31/2400"

    "10957:   01/01/2000"
    "10988:   02/01/2000"
    "11015:   02/28/2000"
    "11017:   03/01/2000"

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
        call %unittest%.fail %%a
    )
)
exit /b 0


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
    set /a "_difference+=(%%c-1970)*365 + (%%c/4 - %%c/100 + %%c/400 - 477) + (336 * (%%a-1) + 7) / 11 + %%b - 2"
    if %%a LEQ 2 set /a "_difference+=2-(((%%c %% 4)-8)/-8)*((((%%c %% 400)-512)/-512)+((((%%c %% 100)-128)/-128)-1)/-1)"
    set /a "_difference*=-1"
)
for /f "tokens=*" %%r in ("!_difference!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ======================== notes ========================

rem Days from month formula
rem
rem         days_from_month = (336 * (%%a-1) + 7) / 11
rem
rem     In this formula we assume february to be 30 days, so we need to fix it:
rem
rem         if month > 2:
rem             days_from_month -= 2
rem
rem Leap year detection
rem
rem         is_zero = (( (your_value_here) -max_value)/-max_value)
rem         is_divisible_by_4 = (((year %% 4)-8)/-8)
rem         is_divisible_by_100 = (((year %% 100)-128)/-128)
rem         is_divisible_by_400 = (((year %% 400)-512)/-512)
rem         is_leap_year = is_divisible_by_4 * (is_divisible_by_400 + (is_divisible_by_100 - 1)/-1)
rem         is_leap_year = is_divisible_by_4 AND (is_divisible_by_400 OR (NOT is_divisible_by_100))
rem
rem     In here, 1 means it is true and 0 means it is false.

rem ================================ fdate() ================================

rem ======================== documentation ========================

:fdate.__doc__
echo NAME
echo    fdate - convert days since epoch to human readable date
echo=
echo SYNOPSIS
echo    fdate   return_var  days_since_epoch
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    days_since_epoch
echo        The number of days since epoch (January 1, 1970).
echo=
echo NOTES
echo    - This function uses Gregorian calendar system.
echo    - The format of the date is 'mm/dd/YYYY'.
exit /b 0


:fdate.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.fdate
call %batchlib%:Input.string days_since_epoch
call %batchlib%:fdate result !days_since_epoch!
echo=
echo Formatted date : !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.fdate.main
for %%a in (
    "01/01/1970:       0"
    "01/31/1970:      30"

    "02/01/1970:      31"
    "02/28/1970:      58"

    "03/01/1970:      59"
    "04/01/1970:      90"
    "05/01/1970:     120"
    "06/01/1970:     151"
    "07/01/1970:     181"
    "08/01/1970:     212"
    "09/01/1970:     243"
    "10/01/1970:     273"
    "11/01/1970:     304"
    "12/01/1970:     334"

    "12/31/1970:     364"
    "01/01/1971:     365"   "02/28/1971:     423"   "03/01/1971:     424"   "12/31/1971:     729"
    "01/01/1972:     730"   "02/29/1972:     789"   "03/01/1972:     790"   "12/31/1972:    1095"
    "01/01/1973:    1096"

    "12/31/1999:   10956"
    "01/01/2000:   10957"   "02/29/2000:   11016"   "03/01/2000:   11017"   "12/31/2000:   11322"
    "01/01/2100:   47482"   "02/28/2100:   47540"   "03/01/2100:   47541"   "12/31/2100:   47846"
    "01/01/2400:  157054"   "02/29/2400:  157113"   "03/01/2400:  157114"   "12/31/2400:  157419"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :fdate result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:fdate   return_var  days_since_epoch
set "%~1="
setlocal EnableDelayedExpansion
set /a "_dso=%~2 + 135140 - 60"
set /a "_era=!_dso! / 146097"
set /a "_doe=!_dso! - !_era! * 146097"
set /a "_yoe=(!_doe! - !_doe!/1460 + !_doe!/36524 - !_doe!/146096) / 365"
set /a "_year=!_yoe! + !_era! * 400 + 1600"
set /a "_doy=!_doe! - (!_yoe!*365 + !_yoe!/4 - !_yoe!/100)"
set /a "_mp=(5 * !_doy! + 2) / 153"
set /a "_day=!_doy! - (153 * !_mp! + 2) / 5 + 1"
if !_mp! LSS 10 (
    set /a "_month=!_mp! + 3"
) else set /a "_month=!_mp! - 9"
if !_month! LEQ 2 set /a "_year+=1"
for %%v in (_month _day) do (
    set "%%v=0!%%v!"
    set "%%v=!%%v:~-2,2!"
)
set "_result=!_month!/!_day!/!_year!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ======================== notes ========================

rem Implementation details:
rem http://howardhinnant.github.io/date_algorithms.html

rem ================================== what_day() ==================================

rem ======================== documentation ========================

:what_day.__doc__
echo NAME
echo    what_day - determine what day is a date
echo=
echo SYNOPSIS
echo    what_day   return_var  date  [--number^|--short]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    date
echo        The input date.
echo=
echo OPTIONS
echo    --number
echo        Returns number value (0: Sunday, 1: Monday). This must be placed as
echo        the third argument. Mutually exclusive with '--short'.
echo=
echo    --short
echo        Returns short date name (first 3 letters). This must be placed as
echo        the third argument. Mutually exclusive with '--number'.
echo=
echo NOTES
echo    - This function uses Gregorian calendar system.
exit /b 0


:what_day.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ diffdate
exit /b 0


rem ======================== demo ========================

:demo.what_day
call %batchlib%:Input.string a_date || set "a_date=!date:* =!"
call %batchlib%:what_day day "!a_date!"
echo=
echo That day is !day!
exit /b 0


rem ======================== tests ========================

:tests.lib.what_day.main
for %%a in (
    "Saturday:      1/01/1583"
    "Monday:        1/01/1923"
    "Thursday:      1/01/1970"
    "Saturday:      1/01/2000"

    "Sat:   1/01/2000 --short"
    "6:   1/01/2000 --number"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :what_day result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:what_day   return_var  date  [--number|--short]
set "%~1="
setlocal EnableDelayedExpansion
call :diffdate _day "%~2" 1/01/1583
set /a _day=(!_day! + 6) %% 7
if /i not "%3" == "--number" (
    if "!_day!" == "0" set "_day=Sunday"
    if "!_day!" == "1" set "_day=Monday"
    if "!_day!" == "2" set "_day=Tuesday"
    if "!_day!" == "3" set "_day=Wednesday"
    if "!_day!" == "4" set "_day=Thursday"
    if "!_day!" == "5" set "_day=Friday"
    if "!_day!" == "6" set "_day=Saturday"
    if /i "%3" == "--short" set "_day=!_day:~0,3!"
)
for /f "tokens=*" %%r in ("!_day!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ================================== time2epoch() ==================================

rem ======================== documentation ========================

:time2epoch.__doc__
echo NAME
echo    time2epoch - convert human readable date and time to epoch time
echo=
echo SYNOPSIS
echo    time2epoch   return_var  date_time
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    date_time
echo        The input date and time.
echo=
echo NOTES
echo    - The date time format is 'mm/dd/YYYY_HH:MM:SS'.
exit /b 0


:time2epoch.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ diffdate ^
    ^ difftime
exit /b 0


rem ======================== demo ========================

:demo.time2epoch
call %batchlib%:Input.string date_time || set "date_time=!date:* =!_!time!"
call %batchlib%:time2epoch result !date_time!
echo=
echo Epoch time : !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.time2epoch.main
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
        call %unittest%.fail %%a
    )
)
exit /b 0


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

rem ======================== documentation ========================

:epoch2time.__doc__
echo NAME
echo    epoch2time - convert epoch time to human readable date and time
echo=
echo SYNOPSIS
echo    epoch2time   return_var  epoch_time
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    epoch_time
echo        The number of seconds since epoch (January 1, 1970 00:00:00).
echo=
echo NOTES
echo    - The date time format is 'mm/dd/YYYY_HH:MM:SS'.
exit /b 0


:epoch2time.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ fdate ^
    ^ ftime
exit /b 0


rem ======================== demo ========================

:demo.epoch2time
call %batchlib%:Input.string seconds_since_epoch
call %batchlib%:epoch2time result !seconds_since_epoch!
echo=
echo Formatted time: !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.epoch2time.main
for %%a in (
    "01/01/1970_00:00:00# 0"

    "12/31/1999_23:59:59# 946684799"
    "01/01/2000_00:00:00# 946684800"
    "12/31/2003_23:59:59# 1072915199"
    "01/01/2004_00:00:00# 1072915200"

    "03/28/2000_23:59:59# 954287999"
    "03/01/2000_00:00:00# 951868800"
    "03/28/2003_23:59:59# 1048895999"
    "03/01/2003_00:00:00# 1046476800"
    "03/28/2004_23:59:59# 1080518399"
    "03/01/2004_00:00:00# 1078099200"

    "01/19/2038_03:14:07# 2147483647"
) do for /f "tokens=1* delims=#" %%b in (%%a) do (
    call :epoch2time result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:epoch2time   return_var  epoch_time
set "%~1="
setlocal EnableDelayedExpansion
set /a "_days=%~2 / 86400"
set /a "_time=(%~2 %% 86400) * 100"
call :ftime _time "!_time!"
call :fdate _days "!_days!"
set "_result=!_days!_!_time:~0,-3!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ================================== timeleft() ==================================

rem ======================== documentation ========================

:timeleft.__doc__
echo NAME
echo    timeleft - calculate the estimated time remaining for a task
echo=
echo SYNOPSIS
echo    timeleft    return_var  start_time_cs  current_progress  total_progress
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the time remaining. The time format is 'HH:MM:SS.CC'.
echo=
echo    start_time_cs
echo        The start time of the task (centiseconds since '00:00:00.00').
echo=
echo    current_progress
echo        Current iteration of the task.
echo=
echo    total_progress
echo        The total number of iterations to complete the task.
echo=
echo NOTES
echo    - Based on: difftime(), ftime()
echo    - Put the function below (not above) where you need it,
echo      because it is much faster.
echo    - If performance is still an issue, just integrate it
echo      in your script (~4x faster).
exit /b 0


:timeleft.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.timeleft
set "total_test=1000"
for %%c in (without called integrated) do (
    echo Simulate Primality Test [1 - !total_test!] %%c timeleft
    set "start_time=!time!"
    call %batchlib%:difftime start_time_cs !start_time!

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

            if /i "%%c" == "called" call %batchlib%:timeleft time_remaining !start_time_cs! %%i !total_test!

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

    call %batchlib%:difftime time_taken !time! !start_time!
    if /i "%%c" == "without" set "base_time=!time_taken!"
    set /a "overhead_time+=!time_taken! - !base_time!"
    call %batchlib%:ftime time_taken !time_taken!
    call %batchlib%:ftime overhead_time !overhead_time!
    echo=
    echo Actual time taken  : !time_taken!
    echo Overhead time      : !overhead_time!
    echo=
    echo=
)
exit /b 0


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

rem ======================== documentation ========================

:wait.__doc__
echo NAME
echo    wait - delay for n milliseconds
echo=
echo SYNOPSIS
echo    wait.calibrate   [delay_target]
echo    wait.setup
echo    wait   delay
echo    for %%t in (delay) do %%wait%%
echo=
echo POSITIONAL ARGUMENTS
echo    delay
echo        The number of milliseconds to delay. Supports delay up to 21474 milliseconds.
echo=
echo    delay_target
echo        The delay (in milliseconds) to use for calibration. This is used to adjust the
echo        calibration time. By default, it is automatically adjusted according
echo        to the result of each calibration.
echo=
echo ENVIRONMENT
echo    wait._increment
echo        The increment speed for wait(). This value is set by wait.calibrate().
echo=
echo NOTES
echo    - wait.calibrate():
echo        - Based on: difftime()
echo    - wait() have high CPU usage
echo    - Using %%wait%% macro is more preferable than calling the function
echo      because it has more consistent results
echo    - wait.calibrate() calibrates up to 12 times before exiting.
rem echo - Alternative for better CPU usage for long delays is sleep()
exit /b 0


:wait.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.wait
call :wait.setup
call %batchlib%:wait.calibrate
echo=
call %batchlib%:Input.number time_in_milliseconds --range "0~10000"
echo=
echo Wait for !time_in_milliseconds! milliseconds...
set "start_time=!time!"

rem Using macro
for %%t in (!time_in_milliseconds!) do %wait%

rem Called
rem call %batchlib%:wait !time_in_milliseconds!

call %batchlib%:difftime time_taken !time! !start_time!
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
exit /b 0


rem ======================== tests ========================

:tests.lib.wait.main
rem threshold: percentage of inaccuracy that is indicated as a failure
rem It is purposely set to a very high value so we only mark the test as failure
rem only if we have a high confidence that it is a failure.
rem e.g.: An error occured when trying to call wait() so it is expected that it
rem       would end almost immediately and have an inaccuracy of more than 90%
rem       when the delay is 1.25s
set "threshold=70"
set "test_delay=1250"

call :wait.setup
call :wait.calibrate > nul || (
    call %unittest%.fail "Calibration failed"
    exit /b 0
)
for %%m in (macro call) do (
    set "start_time=!time!"
    call :tests.lib.wait.using_%%m
    call %batchlib%:difftime time_taken !time! !start_time!
    set /a "inaccuracy=!time_taken!*10 - !test_delay!"
    set /a "fail=!inaccuracy! * !inaccuracy! * ((100 * 100) / (!threshold! * !threshold!)) / (!test_delay!*!test_delay!)"
    if not "!fail!" == "0" (
        call %unittest%.fail "Abnormal amount of inaccuracy in delay using %%m: expected !test_delay!s, got !inaccuracy!s"
    )
)
exit /b 0


:tests.lib.wait.using_macro
for %%t in (!test_delay!) do %wait%
exit /b 0


:tests.lib.wait.using_call
call :wait !test_delay!
exit /b 0


rem ======================== function ========================

:wait   delay
for %%t in (%~1) do %wait%
exit /b 0
#+++

:wait.calibrate   [delay_target]
setlocal EnableDelayedExpansion
echo Calibrating wait()
call :wait.setup
set "wait._increment=100000"
if not "%~1" == "" set /a "_delay_target=%~1" || exit /b 1
set "_time_taken=-1"
for /l %%i in (1,1,12) do if not "!wait._increment!" == "-1" if not "!_time_taken!" == "!_delay_target!" (
    if "%~1" == "" set "_delay_target=!wait._increment:~0,3!"
    set "_start_time=!time!"
    for %%t in (!_delay_target!) do %wait%
    set "_time_taken=0"
    for %%t in (!time!:00:00:00:00 !_start_time!:00:00:00:00) do for /f "tokens=1-4 delims=:." %%a in ("%%t") do (
        set /a "_time_taken+=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"
        set /a "_time_taken*=0xffffffff"
    )
    if "!_time_taken:~0,1!" == "-" set /a "_time_taken+=0x83D600"
    set /a "_time_taken*=10"
    echo Calibration #%%i: !wait._increment!, !_delay_target! -^> ~!_time_taken! milliseconds
    set /a "_next=!wait._increment! * !_time_taken! / !_delay_target!"
    if "!_next!" == "0" (
        set /a "wait._increment=!wait._increment! / 10"
    ) else set "wait._increment=!_next!"
    if !wait._increment! LEQ 0 set "wait._increment=-1"
)
echo Calibration done: !wait._increment!
for /f "tokens=*" %%r in ("!wait._increment!") do (
    endlocal
    set "wait._increment=%%r"
)
if "!wait._increment!" == "-1" exit /b 1
exit /b 0
#+++

:wait.setup
set wait=for /l %%w in (0,^^!wait._increment^^!,%%t00000) do call
exit /b 0


rem ================================ sleep(WIP) ================================

rem ======================== documentation ========================

:sleep.__doc__
echo NAME
echo    sleep - delay for n milliseconds (WIP)
echo=
echo SYNOPSIS
echo    sleep   milliseconds
echo=
echo POSITIONAL ARGUMENTS
echo    milliseconds
echo        The number of milliseconds to delay.
echo=
echo ENVIRONMENT
echo    wait._increment
echo        The increment speed for sleep(). This value is set by wait.calibrate().
echo=
echo NOTES
echo    - Based on: difftime()
echo    - This function have high CPU usage for maximum of 2 seconds on each call.
exit /b 0


rem ======================== demo ========================

:demo.sleep
call %batchlib%:wait.calibrate 500
echo=
call %batchlib%:Input.number time_in_milliseconds --range "0~2147483647"
echo=
echo Sleep for !time_in_milliseconds! milliseconds...
set "start_time=!time!"
call %batchlib%:sleep !time_in_milliseconds!
call %batchlib%:difftime time_taken !time! !start_time!
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
exit /b 0


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


rem ================================ check_ipv4() ================================

rem ======================== documentation ========================

:check_ipv4.__doc__
echo NAME
echo    check_ipv4 - check if a string is an IPv4
echo=
echo SYNOPSIS
echo    check_ipv4   string  [--wildcard]
echo=
echo POSITIONAL ARGUMENTS
echo    string
echo        The string to be checked.
echo=
echo OPTIONS
echo    --wildcard
echo        Allow wildcard in the IPv4 address. This must be placed
echo        as the second argument.
exit /b 0


:check_ipv4.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.check_ipv4
call %batchlib%:Input.string ip_address
echo=
call %batchlib%:check_ipv4 "!ip_address!" && (
    echo IP is valid
) || echo IP is invalid
exit /b 0


rem ======================== tests ========================

:tests.lib.check_ipv4.main
set "return.true=0"
set "return.false=1"
for %%a in (
    "false: "
    "false: 0"
    "false: 0.0.0.0.0"

    "true:  0.0.0.0"
    "true:  255.255.255.255"

    "false: *.*.*.*"
    "true:  *.*.*.* --wildcard"

    "false: 0.0.0.-1"
    "false: 0.0.0.256"
    "false: 0.0.0.2147483647"
    "false: 0.0.0.-2147483647"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :check_ipv4 %%c
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "!return.%%b!" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:check_ipv4   string  [--wildcard]
setlocal EnableDelayedExpansion
set "_allow_wildcard="
if "%~2" == "--wildcard" set "_allow_wildcard=true"
set "_input= %~1"
if not "!_input:..=!" == "!_input!" exit /b 1
for /f "tokens=1,5,6 delims=." %%a in ("a.!_input!") do (
    if "%%b" == "" exit /b 1
    if not "%%c" == "" exit /b 1
)
set "_input=!_input:~1!"
set _input=!_input:.=^
%=REQUIRED=%
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

rem ======================== documentation ========================

:check_path.__doc__
echo NAME
echo    check_path - check if a path satisfies the given requirements
echo=
echo SYNOPSIS
echo    check_path   path_var  [-e^|-n]  [-f^|-d]
echo=
echo POSITIONAL ARGUMENTS
echo    path_var
echo        Variable that contains a path.
echo=
echo OPTIONS
echo    -e, --exist
echo        Target must exist.
echo=
echo    -n, --not-exist
echo        Target must not exist.
echo=
echo    -f, --file
echo        Target must be a file (if exist).
echo=
echo    -d, --directory
echo        Target must be a folder (if exist).
echo=
echo EXIT STATUS
echo    0:  - The path satisfy the requirements.
echo    1:  - The path does not satisfy the requirements.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of the path in path_var if relative path is given.
echo=
echo NOTES
echo    - Variables in path will not be expanded (e.g.: %%appdata%%).
exit /b 0


:check_path.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.check_path
call %batchlib%:Input.string config_file  --message "Input an existing file: "
call %batchlib%:check_path --exist --file config_file && (
    echo Your input is valid
) || echo Your input is invalid

call %batchlib%:Input.string folder  --message "Input an existing folder or a new folder name: "
call %batchlib%:check_path --directory folder && (
    echo Your input is valid
) || echo Your input is invalid

call %batchlib%:Input.string new_name  --message "Input an existing folder or a new folder name: "
call %batchlib%:check_path --not-exist new_name && (
    echo Your input is valid
) || echo Your input is invalid
exit /b 0


rem ======================== function ========================

:check_path   path_var  [-e|-n]  [-f|-d]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_require_attrib  _require_exist) do set "%%v="
set parse_args.args= ^
    ^ "-e, --exist      :store_const:_require_exist=true" ^
    ^ "-n, --not-exist  :store_const:_require_exist=false" ^
    ^ "-f, --file       :store_const:_require_attrib=-" ^
    ^ "-d, --directory  :store_const:_require_attrib=d"
call :parse_args %*
set "_path=!%~1!"
if "!_path:~0,1!!_path:~-1,1!" == ^"^"^"^" set "_path=!_path:~1,-1!"
if "!_path:~-1,1!" == ":" set "_path=!_path!\"
for /f tokens^=1-2*^ delims^=?^"^<^>^| %%a in ("Q?_!_path!_") do if not "%%c" == "" ( 1>&2 echo Invalid path & exit /b 1 )
for /f "tokens=1-2* delims=*" %%a in ("Q*_!_path!_") do if not "%%c" == "" ( 1>&2 echo Wildcards are not allowed & exit /b 1 )
if "!_path:~1,1!" == ":" (
    if not "!_path::=!" == "!_path:~0,1!!_path:~2!" ( 1>&2 echo Invalid path & exit /b 1 )
) else if not "!_path::=!" == "!_path!" ( 1>&2 echo Invalid path & exit /b 1 )
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

rem (!) Drive letter checking can be improved maybe?

rem ================================ combi_wcdir() ================================

rem ======================== documentation ========================

:combi_wcdir.__doc__
echo NAME
echo    combi_wcdir - find files/folders that matches the wildcard paths
echo                  within the search paths
echo=
echo SYNOPSIS
echo    combi_wcdir   return_var  [-f^|-d]  [-s]  search_paths  wildcard_paths
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the results. By default, each path is seperated
echo        by a Line Feed (hex code '0A').
echo=
echo    search_paths
echo        String that contains the base paths of wildcard_paths, each seperated
echo        by a semicolon ';'. May contain multiple wildcards.
echo=
echo    wildcard_paths
echo        String that contains the wildcard paths to find, each seperated by a
echo        semicolon ';'. May contain multiple wildcards.
echo=
echo OPTIONS
echo    -f, --file
echo        Search for file only.
echo=
echo    -d, --directory
echo        Search for directory only.
echo=
echo    -s, --semicolon
echo        Results are semicolon seperated, instead of line feed (LF).
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of the search if the combination of
echo        search path and wildcard path is a relative path.
echo=
echo NOTES
echo    - Variables in path will not be expanded (e.g.: %%appdata%%).
exit /b 0


:combi_wcdir.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ wcdir ^
    ^ capchar
exit /b 0


rem ======================== demo ========================

:demo.combi_wcdir
rem Satisfy dependencies
call :capchar LF

call %batchlib%:Input.string search_paths || set "search_paths=C:\Windows\System32;C:\Windows\SysWOW64"
call %batchlib%:Input.string wildcard_paths || set "wildcard_paths=*script.exe"
call %batchlib%:combi_wcdir result "!search_paths!" "!wildcard_paths!"
echo=
echo Search paths:
echo !search_paths:;=^
%=REQUIRED=%
!
echo=
echo Wildcard paths:
echo !wildcard_paths:;=^
%=REQUIRED=%
!
echo=
echo Found List:
echo=!result!
exit /b 0


rem ======================== function ========================

:combi_wcdir   return_var  [-f|-d]  [-s]  search_paths  wildcard_paths
setlocal EnableDelayedExpansion EnableExtensions
set "_list_dir=true"
set "_list_file=true"
set "_seperator=LF"
set parse_args.args= ^
    ^ "-f, --file       :store_const:_list_dir=" ^
    ^ "-d, --directory  :store_const:_list_file=" ^
    ^ "-s, --semicolon  :store_const:_seperator=;"
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
    call :wcdir._find "%%a\%%b"
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
        if "%_seperator%" == "LF" (
            set "%~1=!%~1!%%r!LF!"
        ) else set "%~1=!%~1!%%r;"
    )
) else (
    endlocal
    set "%~1="
)
exit /b 0


rem ================================ wcdir() ================================

rem ======================== documentation ========================

:wcdir.__doc__
echo NAME
echo    wcdir - find files/folders that matches the wildcard path
echo=
echo SYNOPSIS
echo    wcdir   return_var  wildcard_path  [-f^|-d]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result. Each path is seperated
echo        by a Line Feed (hex code '0A').
echo=
echo    wildcard_path
echo        The wildcard path to find. May contain multiple wildcards.
echo=
echo OPTIONS
echo    -f, --file
echo        Search for files only.
echo=
echo    -d, --directory
echo        Search for directories only.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of wildcard_path if relative path is given.
echo=
echo NOTES
echo    - Variables in path will not be expanded (e.g.: %%appdata%%).
exit /b 0


:wcdir.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ capchar
exit /b 0


rem ======================== demo ========================

:demo.wcdir
rem Satisfy dependencies
call :capchar LF

call %batchlib%:Input.string wildcard_path || set "wildcard_path=C:\Windows\System32\*script.exe"
call %batchlib%:strip_dquotes wildcard_path
call %batchlib%:wcdir result "!wildcard_path!"
echo=
echo Wildcard path:
echo !wildcard_path!
echo=
echo Found List:
echo=!result!
exit /b 0


rem ======================== function ========================

:wcdir   return_var  wildcard_path  [-f|-d]
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
call :wcdir._find "!_args!"
for /f "tokens=* delims=" %%r in ("!_result!") do (
    if not defined %~1 endlocal
    set "%~1=!%~1!%%r!LF!"
)
exit /b 0
#+++

:wcdir._find   wildcard_path
for /f "tokens=1* delims=\" %%a in ("%~1") do if "%%a" == "*:" (
    for %%l in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do pushd "%%l:\" 2> nul && call :wcdir._find "%%b"
) else if "%%b" == "" (
    if defined _list_dir dir /b /a:d "%%a" > nul 2> nul && ( for /d %%f in ("%%a") do set "_result=!_result!%%~ff!LF!" )
    if defined _list_file dir /b /a:-d "%%a" > nul 2> nul && ( for %%f in ("%%a") do set "_result=!_result!%%~ff!LF!" )
) else for /d %%f in ("%%a") do pushd "%%f\" 2> nul && call :wcdir._find "%%b"
popd
exit /b


rem ================================ bytes2size() ================================

rem ======================== documentation ========================

:bytes2size.__doc__
echo NAME
echo    bytes2size - convert bytes to human readable size
echo=
echo SYNOPSIS
echo    bytes2size   return_var  bytes
echo=
echo  POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    bytes
echo        The size (in bytes) to convert.
echo=
echo NOTES
echo    - Only 3 significant figures will be shown.
exit /b 0


:bytes2size.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.bytes2size
call %batchlib%:Input.string bytes
call %batchlib%:bytes2size size "!bytes!"
echo=
echo The human readable form is !size!
exit /b 0


rem ======================== tests ========================

:tests.lib.bytes2size.main
for %%a in (
    "1.00 GB:   1076892679"
    "1.00 GB:   1073741824"
    "100 MB:    104857600"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :bytes2size result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:bytes2size   return_var  bytes
set "%~1="
setlocal EnableDelayedExpansion
set "_result="
set "_remainder=0"
for %%c in (
    30.GB 20.MB 10.KB 0.bytes
) do if not defined _result (
    set /a "_digits=(%~2) / (1<<%%~nc)"
    if not "!_digits!" == "0" (
        set "_result=!_digits!"
        if not "%%~nc" == "0" (
            set /a "_digits=(%~2) / (1<<(%%~nc - 10)) %% 1024 * 100 / 1024"
            set "_remainder=00!_remainder!"
            set "_remainder=!_remainder:~-2,2!"
            set "_result=!_result!.!_remainder!"
            set "_result=!_result:~0,4!"
        )
        set "_result=!_result! %%~xc"
    )
)
if not defined _result set "_result=0 bytes"
set "_result=!_result: .= !"
set "_result=!_result:. = !"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ================================ size2bytes() ================================

rem ======================== documentation ========================

:size2bytes.__doc__
echo NAME
echo    size2bytes - convert human readable size to bytes
echo=
echo SYNOPSIS
echo    size2bytes   return_var  readable_size
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    readable_size
echo        The human readable size to convert. Support calculations
echo        and the letter 'B' (for bytes) is optional.
echo=
echo EXAMPLE
echo    call :size2bytes   result  "1G + 720 MB"
echo    call :size2bytes   result  "1KB-5"
echo    call :size2bytes   result  "1M * 3 / 2"
exit /b 0


:size2bytes.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.size2bytes
call %batchlib%:Input.string size
call %batchlib%:size2bytes bytes "!size!"
echo=
echo The size is !bytes! bytes
exit /b 0


rem ======================== tests ========================

:tests.lib.size2bytes.main
for %%a in (
    "1076892679:    1G+3M+5K+7"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :size2bytes result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:size2bytes   return_var  readable_size
set "%~1="
setlocal EnableDelayedExpansion
set "_result=%~2"
set "_result=!_result:B=!"
for %%c in (
    K.10 M.20 G.30
) do set "_result=!_result:%%~nc=*(1<<%%~xc)!"
set /a "_result=!_result:.=!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ================================ hexlify() ================================

rem ======================== documentation ========================

:hexlify.__doc__
echo NAME
echo    hexlify - convert a file to hex file
echo=
echo SYNOPSIS
echo    hexlify   input_file  output_file  [--eol hex]
echo=
echo POSITIONAL ARGUMENTS
echo    input_file
echo        Path of the input file.
echo=
echo    output_file
echo        Path of the output file.
echo=
echo OPTIONS
echo    --eol HEX
echo        The EOL of the source file. Each time hexlify encounters HEX, a new
echo        line is created at the output file. By default, '0d 0a' is used.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of input_file and output_file
echo        if relative path is given.
echo=
echo    temp_path
echo        Path to store the temporary conversion result.
echo=
echo    temp
echo        Fallback path for temp_path if temp_path does not exist
exit /b 0


:hexlify.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.hexlify
call %batchlib%:Input.path --exist --file source_file
call %batchlib%:Input.path --not-exist destination_file
echo=
echo Converting to hex...
call %batchlib%:hexlify "!source_file!" "!destination_file!" --eol "0d 0a"
echo Done
exit /b 0


rem ======================== tests ========================

:tests.lib.hexlify.main
call :hexlify "%~f0" "hexlify.hex"
if exist "hexlify.rebuild" del /f /q "hexlify.rebuild"
certutil -decodehex "hexlify.hex" "hexlify.rebuild" > nul
call %batchlib%:diffbin offset "%~f0" "hexlify.rebuild"
for %%v in (hex rebuild) do del /f /q "hexlify.%%v"
if not "!offset!" == "-" call %unittest%.fail "difference detected"
exit /b 0


rem ======================== function ========================

:hexlify   input_file  output_file  [--eol hex]
setlocal EnableDelayedExpansion EnableExtensions
set "_eol=0d 0a"
set parse_args.args= ^
    ^ "-e, --eol    :store:_eol"
call :parse_args %*
set "_eol_len=2"
if /i "!_eol!" == "0d 0a" set "_eol_len=5"

set "raw_hex_file=raw_hex"
pushd "!temp_path!" && (
    for %%f in ("!raw_hex_file!") do set "raw_hex_file=%%~ff"
    popd
)
if exist "!raw_hex_file!" del /f /q "!raw_hex_file!"
certutil -encodehex "%~f1" "!raw_hex_file!" > nul || exit /b 1
rem Group hex according to EOL
> "%~f2" (
    set "_hex="
    for /f "usebackq tokens=1*" %%a in ("!raw_hex_file!") do (
        set "_input=%%b"
        set "_hex=!_hex! !_input:~0,48!"
        if not "!_hex:~7680!" == "" call :hexlify._format
    )
    call :hexlify._format
    echo=!_hex!
    set "_hex="
)
exit /b 0

:hexlify._format
set "_hex=!_hex!$"
set "_hex=!_hex:  = !"
set _hex=!_hex:%_eol%=%_eol%^
%=REQUIRED=%
!
for /f "tokens=*" %%a in ("!_hex!") do (
    set "_hex=%%a"
    if /i "!_hex:~-%_eol_len%,%_eol_len%!" == "%_eol%" echo !_hex!
)
if not "!_hex:~7680!" == "" (
    < nul set /p "=!_hex:~0,-3!"
    set "_hex=!_hex:~-3,3!"
)
set "_hex=!_hex:~0,-1!"
exit /b


rem ================================ unzip() ================================

rem ======================== documentation ========================

:unzip.__doc__
echo NAME
echo    unzip - extract files from a zip file
echo=
echo SYNOPSIS
echo    unzip   zip_file  destination_folder
echo=
echo POSITIONAL ARGUMENTS
echo    zip_file
echo        Path of the zip file to extract.
echo=
echo    destination_folder
echo        The folder path to extract to.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of zip_file and destination_folder
echo        if relative path is given.
echo=
echo    temp
echo        Path to write the temporary VBScript file.
echo=
echo NOTES
echo    - VBScript is used to extract the zip file.
echo    - Variables in path will not be expanded (e.g.: %%appdata%%).
exit /b 0


:unzip.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.unzip
call %batchlib%:Input.path --exist --file zip_file
call %batchlib%:Input.path --directory destination_folder
echo=
call %batchlib%:unzip "!zip_file!" "!destination_folder!" && (
    echo Unzip successful
) || (
    echo Unzip failed
)
exit /b 0


rem ======================== function ========================

:unzip   zip_file  destination_folder
if not exist "%~1" ( 1>&2 echo error: zip file does not exist & exit /b 1 )
if not exist "%~2" md "%~2" || ( 1>&2 echo error: create folder failed & exit /b 2 )
for %%s in ("!temp!\unzip.vbs") do (
    > "%%~s" (
        echo zip_file = WScript.Arguments(0^)
        echo dest_path = WScript.Arguments(1^)
        echo=
        echo set ShellApp = CreateObject("Shell.Application"^)
        echo set content = ShellApp.NameSpace(zip_file^).items
        echo ShellApp.NameSpace(dest_path^).CopyHere(content^)
    )
    cscript //nologo "%%~s" "%~f1" "%~f2"
    del /f /q "%%~s"
)
exit /b 0


rem ================================ checksum() ================================

rem ======================== documentation ========================

:checksum.__doc__
echo NAME
echo    checksum - calculate checksum of a file
echo=
echo SYNOPSIS
echo    checksum   return_var  input_file  [hash]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    input_file
echo        Path of the input file.
echo=
echo OPTIONS
echo    --HASH
echo        The algorithm of the hash. Possible values for HASH are:
echo        MD2, MD4, MD5, SHA1, SHA256, SHA512. This option is case-insensitive.
echo        By default, it is '--SHA1'.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of input_file if relative path is given.
exit /b 0


:checksum.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.checksum
call %batchlib%:Input.path file_path
call %batchlib%:Input.string checksum_type
if defined checksum_type set "checksum_type=--!checksum_type!"
call %batchlib%:checksum checksum !checksum_type! "!file_path!"
echo=
echo Checksum: !checksum!
exit /b 0


rem ======================== function ========================

:checksum   return_var  input_file  [hash]
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

rem (!) Improve argument parsing ?

rem ================================ diffbin() ================================

rem ======================== documentation ========================

:diffbin.__doc__
echo NAME
echo    diffbin - get the offset of the first difference between two files
echo=
echo SYNOPSIS
echo    diffbin   return_var  input_file1  input_file2
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result (in bytes).
echo=
echo    input_file
echo        Path of the input file.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of input_file if relative path is given.
echo=
echo    temp_path
echo        Path to store the temporary output.
echo=
echo    temp
echo        Fallback path for temp_path if temp_path does not exist
exit /b 0


:diffbin.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.diffbin
call %batchlib%:Input.path --exist --file file1
call %batchlib%:Input.path --exist --file file2
echo=
call %batchlib%:diffbin offset "!file1!" "!file2!"
echo=
if "!offset:~0,1!" == "-" (
    if "!offset!" == "-" echo Both files are the same
    if "!offset!" == "-1" echo No content difference, but file 1 is longer
    if "!offset!" == "-2" echo No content difference, but file 2 is longer
) else set /a "!offset!" 2> nul && (
        echo First difference at offset !offset! bytes
) || echo unknown result: !offset!
exit /b 0


rem ======================== tests ========================

:tests.lib.diffbin.main
< nul set /p "=planet" > source
< nul set /p "=plan" > shorter
< nul set /p "=planet" > equal
< nul set /p "=planetarium" > longer
< nul set /p "=plants" > different

for %%a in (
    "-:     equal"
    "-1:    shorter"
    "-2:    longer"
    "4:    different"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :diffbin result source %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:diffbin   return_var  input_file1  input_file2
setlocal EnableDelayedExpansion
set "file1=%~f2"
set "file2=%~f3"
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "_result="
fc /b "!file1!" "!file2!" > "fc_diff"
for /f "usebackq skip=1 tokens=1* delims=:" %%a in ("fc_diff") do (
    if not defined _result (
        set "_result=%%a: %%b"
        if /i "%%a" == "FC" (
            if /i "%%b" == " !file1! longer than !file2!" set "_result=-1"
            if /i "%%b" == " !file2! longer than !file1!" set "_result=-2"
            if /i "%%b" == " no differences encountered" set "_result=-"
        ) else set /a "_result=0x%%a"
    )
)
del /f /q "fc_diff"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ============================ find_label() ============================

rem ======================== documentation ========================

:find_label.__doc__
echo NAME
echo    find_label - find labels that matches the specified pattern
echo=
echo SYNOPSIS
echo    find_label   return_var  [-p pattern]  [-f input_file]
echo=
echo DESCRIPTION
echo    Find all labels that matches the pattern in the input file.
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the results, each seperated by space.
echo=
echo OPTIONS
echo    -p PATTERN, --pattern PATTERN
echo        Pattern of the function label to match. Supports up to 4 wildcards '*'.
echo        It uses path pattern matching sytle. By default, it is '*'.
echo=
echo    -f INPUT_FILE, --file INPUT_FILE
echo        Path of the input file. By default, it is the current file.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of input_file if relative path is given.
echo=
echo NOTES
echo    - The label of the function MUST only be preceeded by either nothing or
echo      spaces (i.e.: space indentation only)
echo    - Does not support labels that have:
echo        - '^^' or '*' in label name
echo    - Only Windows EOL is supported.
exit /b 0


:find_label.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.find_label
call :Input.string pattern
call :Input.path input_file --file --exist
call :find_label label_match --pattern "!pattern!" --file "!input_file!"
echo=
echo Found match:
set "match_count=0"
for %%l in (!label_match!) do (
    set /a "match_count+=1"
    set "match_count=   !match_count!"
    set "match_count=!match_count:~-3,3!"
    echo !match_count!. %%l
)
exit /b 0


rem ======================== tests ========================

:tests.lib.find_label.main
> "in\labels" (
    echo :
    echo : invalid
    echo :normal_label
    echo :normal_label.main
    echo :$dollar_label
    echo :\$escaped_dollar_label
    echo :tests.main
    echo :tests..main
    echo :tests.a.main
    echo :tests.bb.main
    echo :tests.ccc.main
    echo :tests.normal_label.main
    echo :tests.dotted.label.main
    echo    :tests.indented_label.main
    echo :tests.normal_label.main.extra
    echo ::comment
    echo ::tests.comment.main
)
call %batchlib%:capchar LF
set test_cases= ^
    ^ 13:   -f "in\labels" !LF!^
    ^ 13:   -f "in\labels" -p "*" !LF!^
    ^ 9:    -f "in\labels" -p "tests.*" !LF!^
    ^ 9:    -f "in\labels" -p "*.main" !LF!^
    ^ 7:    -f "in\labels" -p "tests.*.main" !LF!^
    ^ 7:    -f "in\labels" -p "*o*" !LF!^
    ^ 2:    -f "in\labels" -p "*$*" !LF!^
    ^ 0:    -f "in\labels" -p ""
for /f "tokens=*" %%a in ("!test_cases!") do (
    for /f "tokens=1* delims=:" %%b in ("%%a") do (
        call :find_label labels %%c
        set "labels_count=0"
        for %%l in (!labels!) do set /a "labels_count+=1"
        if not "!labels_count!" == "%%b" (
            call %unittest%.fail %%a
        )
    )
)
exit /b 0


rem ======================== function ========================

:find_label   return_var  [-p pattern]  [-f input_file]
setlocal EnableDelayedExpansion EnableExtensions
set "_pattern=*"
set "_input_file=%~f0"
set parse_args.args= ^
    ^ "-p, --pattern    :store:_pattern" ^
    ^ "-f, --file       :store:_input_file"
call :parse_args %*
for %%c in (\ . $ [ ]) do set "_pattern=!_pattern:%%c=\%%c!"
rem Replace asterisks with contents of %%p
for /f "delims=" %%p in ("[^^^^: ]*") do (
    for /f "tokens=1-4* delims=*" %%a in ("_!_pattern!_") do (
        set "_pattern=%%a"
        if not "%%b" == "" set "_pattern=!_pattern!%%p%%b"
        if not "%%c" == "" set "_pattern=!_pattern!%%p%%c"
        if not "%%d" == "" set "_pattern=!_pattern!%%p%%d"
        if not "%%e" == "" set "_pattern=!_pattern!%%p%%e"
        set "_pattern=!_pattern:~1,-1!"
    )
)
set "_result="
for /f "delims=" %%p in ("^^^^[ ]*:!_pattern!") do (
    for /f "tokens=1" %%a in ('findstr /r /c:"%%p$" /c:"%%p .*$" "!_input_file!"') do (
        for /f "tokens=1 delims=:" %%b in ("%%a") do set "_result=!_result! %%b"
    )
)
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ================================ extract_func() ================================

rem ======================== documentation ========================

:extract_func.__doc__
echo NAME
echo    extract_func - extract batch script functions from a file
echo=
echo SYNOPSIS
echo    extract_func   input_file  labels
echo=
echo POSITIONAL ARGUMENTS
echo    input_file
echo        Path of the input (batch) file.
echo=
echo    labels
echo        The function labels to extract. The syntax is "label1 [...]".
echo=
echo DEFINITION
echo    join mark
echo        A line that solely consist of '#+++'.
echo=
echo EXTRACTION
echo    A matching label tells extract_func() to start extracting starting from
echo    the current line. For a function to be detected, the label of the function
echo    MUST only be preceeded by either nothing, or spaces and/or tabs.
echo=
echo    Two empty lines tells extract_func() that the function ends here and
echo    it will stop extraction of the lines below it until it finds another
echo    matching label.
echo=
echo    Functions that have multiple subroutines SHOULD end each subroutine with
echo    the join mark (see DEFINITION).
echo=
echo EXIT STATUS
echo    0:  - Extraction is successful.
echo    1:  - Some labels are not found.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of input_file if relative path is given.
echo=
echo NOTES
echo    - The order of the function will be based on the order of occurrence
echo      in the parameter.
echo    - Results are ECHOed to stdout and it can be redirected to file.
exit /b 0


:extract_func.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.extract_func
call %batchlib%:Input.string function_labels || set "function_labels=extract_func"
echo=
call %batchlib%:extract_func "%~f0" "!function_labels!" && (
    echo Extract successful
) || echo Extract failed
exit /b 0


rem ======================== tests ========================

:tests.lib.extract_func.main
for %%a in (
    "873b7b424821d520f2a8fe38e00cc5151bcefcec: special_characters"
    "ea8a9a50a7516ad813cdad8466ec917863ee1b97: join_mark"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "params="
    for %%d in (%%c) do set "params=!params! tests.lib.extract_func.%%d"
    call :extract_func "%~f0" "!params!" > extracted 2> nul
    call :checksum result "extracted"
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


:tests.lib.extract_func.special_characters   arg_1a|arg_1b  arg2 [arg3]
    @call & echo %% !a! %* > nul 2> nul
< nul ( call ) || exit /b 1
exit /b 0


:tests.lib.extract_func.join_mark
exit /b 0
#+++

:tests.lib.extract_func.join_mark.joined
exit /b 0


rem ======================== function ========================

:extract_func   source_file  labels
setlocal EnableDelayedExpansion EnableExtensions
set "_source_file=%~f1"
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "_to_extract= %~2 "
set "_not_found= "
for %%l in (!_to_extract!) do set "_not_found=!_not_found!%%l "
set "_label_ranges=!_not_found!"
set "_joins="
set "_label="
set "_index="
set "_expected_index="
set "_signal="
findstr /n "^^" "!_source_file!" > "numbered"
findstr /n /r ^
    ^ /c:"^^$" ^
    ^ /c:"^^#+++$" ^
    ^ /c:"^^[ ]*:[^^: ]*$" ^
    ^ /c:"^^[ ]*:[^^: ]* .*$" ^
    ^ "!_source_file!" > "label_n_marks"
for /f "usebackq tokens=*" %%a in ("label_n_marks") do for /f "tokens=1 delims=:" %%n in ("%%a") do (
    set "_line=%%a"
    set "_line=!_line:*:=!"
    for /f "tokens=1" %%b in ("!_line!") do for /f "tokens=1 delims=:" %%c in ("%%b") do (
        if ":%%c" == "%%b" (
            for %%l in (!_not_found!) do if "%%c" == "%%l" (
                if defined _label (
                    set "_joins=!_joins!%%l "
                ) else (
                    set "_label=%%l"
                    set /a "_index=%%n-1"
                )
                set "_not_found=!_not_found: %%c = !"
            )
        )
    )
    if defined _label (
        if not "%%n" == "!_expected_index!" set "_signal="
        set /a "_expected_index=%%n+1"
        set "_mark="
        if not defined _line set "_mark=EOL"
        if "!_line!" == "#+++" set "_mark=JOIN"
        if defined _mark (
            set "_signal=!_signal! !_mark!"
            for %%p in (
                " EOL EOL"
            ) do if "!_signal!" == %%p set "_signal=END"
            if "!_signal!" == "END" for %%l in (!_label!) do (
                set "_index=!_index!:%%n"
                for %%n in (!_index!) do set "_label_ranges=!_label_ranges: %%l = %%n !"
                set "_label="
                set "_index="
            )
        ) else set "_signal="
    )
)
if defined _label for %%l in (!_label!) do (
    for %%n in (!_index!) do set "_label_ranges=!_label_ranges: %%l = %%n: !"
)
set "_leftover=!_not_found: =!"
if defined _leftover ( 1>&2 echo warning: label not found: !_not_found! )
for %%l in (!_not_found! !_joins!) do set "_label_ranges=!_label_ranges: %%l = !"
for %%a in (!_label_ranges!) do for /f "tokens=1-2 delims=:" %%b in ("%%a") do (
    call :extract_func.extract %%b %%c
)
del /f /q "numbered"
if defined _leftover exit /b 1
exit /b 0
#+++

:extract_func.extract   start  end
setlocal DisableDelayedExpansion
if "%1" == "0" (
    set "_skip="
) else set "_skip=skip=%1"
for /f "usebackq %_skip% tokens=*" %%o in ("numbered") do (
    set "_line=%%o"
    setlocal EnableDelayedExpansion
    set "_line=!_line:*:=!"
    echo(!_line!
    endlocal
    for /f "tokens=1 delims=:" %%n in ("%%o") do if "%%n" == "%2" exit /b 0
)
exit /b 0


rem ================================ fix_eol() ================================

rem ======================== documentation ========================

:fix_eol.__doc__
echo NAME
echo    fix_eol, fix_eol.alt1, fix_eol.alt2 - convert EOL of the script to CRLF
echo=
echo SYNOPSIS
echo    fix_eol
echo=
echo EXIT STATUS
echo    0:  - EOL conversion is not necessary.
echo        - EOL conversion is successful.
echo    1:  - EOL conversion failed.
echo=
echo BEHAVIOR
echo    - Script will EXIT if EOL conversion is successful.
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
echo    - Can be used to detect and fix script EOL if it was downloaded
echo      from GitHub, since uses Unix EOL (LF).
exit /b 0


:fix_eol.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ check_win_eol
exit /b 0


rem ======================== demo ========================

:demo.fix_eol
echo Fixing EOL...
for %%n in (1 2) do call :fix_eol.alt%%n && (
    echo [fix_eol.alt%%n] Fix not necessary
) || echo [fix_eol.alt%%n] Fix failed
exit /b 0


rem ======================== function ========================

:fix_eol
rem The label below is an alternative label if the main label cannot be found
:fix_eol.alt1
rem THIS IS REQUIRED
:fix_eol.alt2
for %%n in (1 2) do call :check_win_eol.alt%%n --check-exist 2> nul && (
    call :check_win_eol.alt%%n || (
        echo Converting EOL...
        type "%~f0" | more /t4 > "%~f0.tmp" && (
            move "%~f0.tmp" "%~f0" > nul && (
                echo Convert EOL done
                echo Script will exit. Press any key to continue...
                pause > nul
                exit 0
            )
        )
        ( 1>&2 echo warning: Convert EOL failed )
        exit /b 1
    )
    exit /b 0
)
( 1>&2 echo error: failed to call check_win_eol^(^) )
exit /b 1


rem ================================ check_win_eol() ================================

rem ======================== documentation ========================

:check_win_eol.__doc__
echo NAME
echo    check_win_eol, check_win_eol.alt1, check_win_eol.alt1
echo    - check EOL type of current script
echo=
echo SYNOPSIS
echo    check_win_eol   [--check-exist]
echo=
echo OPTIONS
echo    -c, --check-exist
echo        Check if function exist / is callable.
echo=
echo EXIT STATUS
echo    0:  - EOL is Windows (CRLF)
echo        - '-c' is specified, and the function is callable.
echo    1:  - EOL is Unix (LF)
echo        - The function is uncallable.
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
echo    - If EOL is Mac (CR), this script would probably have crashed
echo      in the first place.
exit /b 0


:check_win_eol.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.check_win_eol
for %%n in (1 2) do call :check_win_eol.alt%%n --check-exist 2> nul && (
    call :check_win_eol.alt%%n && (
        echo [check_win_eol.alt%%n] EOL is Windows 'CRLF'
    ) || echo [check_win_eol.alt%%n] EOL is Unix 'LF'
)
exit /b 0


rem ======================== function ========================

:check_win_eol   [--check-exist]
rem The label below is an alternative label if the main label cannot be found
:check_win_eol.alt1
rem THIS IS REQUIRED
:check_win_eol.alt2
for %%f in (-c, --check-exist)do if /i "%1" == "%%f" exit /b 0
@call :check_win_eol._test 2> nul && exit /b 0 || exit /b 1
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
:check_win_eol._test
@exit /b 0


rem ================================ expand_link() ================================

rem ======================== documentation ========================

:expand_link.__doc__
echo NAME
echo    expand_link - expands a given URL to several smaller pieces
echo=
echo SYNOPSIS
echo    expand_link   return_prefix  link
echo=
echo POSITIONAL ARGUMENTS
echo    return_prefix
echo        The prefix of the variable to store the results.
echo=
echo    link
echo        The string of the link to expand.
echo=
echo EXAMPLE
echo    [U] URL        https://blog.example.com:80/1970/01/news.html?page=1#top
echo    [S] Scheme     https
echo                        ://
echo    [H] Hostname           blog.example.com
echo                                           :
echo    [P] Port                                80
echo    [D] Path                                  /1970/01/
echo    [N] Filename                                       news
echo    [X] Extension                                          .html
echo                                                                ?
echo    [Q] Query                                                    page=1
echo                                                                       #
echo    [F] Fragment                                                        top
echo=
echo NOTES
echo    - IPv6 URLs are not supported (yet).
exit /b 0


:expand_link.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0

rem (!) improve naming?

rem ======================== demo ========================

:demo.expand_link
call %batchlib%:Input.string web_url || set "web_url=https://blog.example.com:80/1970/01/news.html?page=1#top"
call %batchlib%:expand_link web_url "!web_url!"
set web_url
exit /b 0


rem ======================== function ========================

:expand_link   return_prefix  link
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

rem ======================== documentation ========================

:get_ext_ip.__doc__
echo NAME
echo    get_ext_ip - get the external IP address of this computer
echo=
echo SYNOPSIS
echo    get_ext_ip   return_var
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo ENVIRONMENT
echo    temp_path
echo        Path to store the temporary output.
echo=
echo    temp
echo        Fallback path for temp_path if temp_path does not exist
echo=
echo NOTES
echo    - PowerShell is used to download the information file.
exit /b 0


:get_ext_ip.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.get_ext_ip
call %batchlib%:get_ext_ip ext_ip
echo=
echo External IP    : !ext_ip!
exit /b 0


rem ======================== function ========================

:get_ext_ip   return_var
setlocal EnableDelayedExpansion
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
> nul 2> nul (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('http://ipecho.net/plain', 'ipv4')"
) || exit /b 1
for /f "usebackq tokens=*" %%o in ("ipv4") do set "%~1=%%o"
del /f /q "ipv4"
exit /b 0


rem ================================ ping_test() ================================

rem ======================== documentation ========================

:ping_test.__doc__
echo NAME
echo    ping_test - Test if an host/IP responds to a ping test (WIP)
echo=
echo SYNOPSIS
echo    ping_test   return_prefix  host  [ping_params]
echo=
echo POSITIONAL ARGUMENTS
echo    return_prefix
echo        Prefix of the variable to store the metadata.
echo        Variables (as seen in PING command) includes:
echo        - Packet: sent, received, lost, loss,
echo        - Ping: min, max, avg.
echo=
echo    host
echo        Hostname or IP of the target.
echo=
echo    ping_params
echo        Parameters to use in ping test. By default, it is empty.
echo=
echo EXIT STATUS
echo    0:  - Ping test receives response (at least once).
echo    1:  - Ping test failed.
exit /b 0


:ping_test.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.ping_test
call :Input.string host || set "host=google.com"
echo=
echo Ping: !host!
call %batchlib%:ping_test ping. !host! && (
    echo Ping Successful
) || echo Ping Failed
echo=
set ping.
exit /b 0


rem ======================== function ========================

:ping_test   return_prefix  host  [ping_params]
set "_index=0"
for /f "usebackq tokens=1-8 delims=(:=, " %%a in (`ping %~2 %~3 `) do (
    if "%%a, %%b, %%d, %%f" == "Packets, Sent, Received, Lost" (
        set "%~1packet_sent=%%c"
        set "%~1packet_received=%%e"
        set "%~1packet_lost=%%g"
        set "%~1packet_loss=%%h"
        set "%~1packet_loss=!%~1packet_loss:~0,-1!"
    )
    if "%%a, %%c, %%e" == "Minimum, Maximum, Average" (
        set "%~1min=%%b"
        set "%~1max=%%d"
        set "%~1avg=%%f"
        for %%v in (min max avg) do set "%~1%%v=!%~1%%v:~0,-2!"
    )
)
if "!~1loss!" == "100" exit /b 1
exit /b 0


rem ================================ download_file() ================================

rem ======================== documentation ========================

:download_file.__doc__
echo NAME
echo    download_file - download file from the internet
echo=
echo SYNOPSIS
echo    download_file   link  save_path
echo=
echo POSITIONAL ARGUMENTS
echo    link
echo        The download link.
echo=
echo    save_path
echo        The save location of the downloaded file.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of save_path if relative path is given.
echo=
echo NOTES
echo    - PowerShell is used to download the information file.
echo    - Download is buffered to disk.
echo    - Follows redirects automatically.
echo    - Overwrites existing file.
exit /b 0


:download_file.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.download_file
echo For this demo, file will be saved to "!cd!"
echo Enter nothing to download laravel v4.2.11 (41 KB)
echo=
call %batchlib%:Input.string download_url || set "download_url=https://codeload.github.com/laravel/laravel/zip/v4.2.11"
call %batchlib%:Input.string save_path || set "save_path=downloaded.zip"
echo=
echo Download url:
echo=!download_url!
echo=
echo Save path:
echo=!save_path!
echo=
echo Downloading file...
call %batchlib%:download_file "!download_url!" "!save_path!" || echo Download failed
exit /b 0


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

rem ======================== documentation ========================

:get_con_size.__doc__
echo NAME
echo    get_con_size - get console screen buffer size
echo=
echo SYNOPSIS
echo    get_con_size   width_return_var  height_return_var
echo=
echo POSITIONAL ARGUMENTS
echo    width_return_var
echo        Variable to store the console width.
echo=
echo    height_return_var
echo        Variable to store the console height.
exit /b 0


:get_con_size.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.get_con_size
call %batchlib%:get_con_size console_width console_height
echo=
echo Screen buffer size    : !console_width!x!console_height!
exit /b 0


rem ======================== function ========================

:get_con_size   width_return_var  height_return_var
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


rem ================================ notes ================================

rem Executing 'mode con' causes input stream to be flushed.
rem This could cause tests that uses file as input stream to fail.
rem Calling it asynchronously from pipe will prevent this.

rem ================================ get_sid() ================================

rem ======================== documentation ========================

:get_sid.__doc__
echo NAME
echo    get_sid - get currect user's SID
echo=
echo SYNOPSIS
echo    get_sid   return_var
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
exit /b 0


:get_sid.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.get_sid
call %batchlib%:get_sid result
echo=
echo User SID : !result!
exit /b 0


rem ======================== function ========================

:get_sid   return_var
set "%~1="
for /f "tokens=2" %%s in ('whoami /user /fo table /nh') do set "%~1=%%s"
exit /b 0


rem ================================ get_os() ================================

rem ======================== documentation ========================

:get_os.__doc__
echo NAME
echo    get_os - get the OS version of this computer
echo=
echo SYNOPSIS
echo    get_os   return_var  [--name]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo OPTIONS
echo    --name
echo        Returns the OS name instead of the OS version number.
exit /b 0


:get_os.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.get_os
call %batchlib%:get_os result --name
echo Your OS is !result!
exit /b 0


rem ======================== function ========================

:get_os   return_var  [--name]
for /f "tokens=4-5 delims=. " %%i in ('ver') do set "%~1=%%i.%%j"
if /i "%~2" == "--name" (
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

rem ======================== documentation ========================

:get_pid.__doc__
echo NAME
echo    get_pid - get process ID of the current script
echo=
echo SYNOPSIS
echo    get_pid   return_var  [unique_id]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    unique_id
echo        A string that is uniquely identifies the running batch script.
echo        The string should only contain these characters: A-Z, a-z, 0-9,
echo        underscore '_', dot '.', and hyphen '-'. By default, it uses %%random%%.
echo=
echo NOTES
echo    - PowerShell can be used to generate an unique id for current batch script.
echo      Use it if you have multiple batch script that starts at the same time and
echo      also calls get_pid() at the same time.
exit /b 0


:get_pid.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.get_pid
set "start_time=!time!"
call %batchlib%:get_pid result
call :difftime time_taken !time! !start_time!
echo Using random number
echo PID        : !result!
echo Time taken : !time_taken!
echo=

set "start_time=!time!"
for /f %%g in ('powershell -command "$([guid]::NewGuid().ToString())"') do call %batchlib%:get_pid result %%g
call :difftime time_taken !time! !start_time!
echo Using PowerShell GUID
echo PID        : !result!
echo Time taken : !time_taken!
exit /b 0


rem ======================== function ========================

:get_pid   return_var  [unique_id]
for /f "usebackq tokens=*" %%a in (
    `wmic process where "name='cmd.exe' and CommandLine like '%% get_pid %random% %~1 %%'" get ParentProcessID`
) do for %%b in (%%a) do set "%~1=%%b"
exit /b 0


rem ================================ watchvar() ================================

rem ======================== documentation ========================

:watchvar.__doc__
echo NAME
echo    watchvar - monitor variable changes in the current script
echo=
echo SYNOPSIS
echo    watchvar   [-i]  [-n]
echo=
echo POSITIONAL ARGUMENTS
echo    -i, --initialize
echo        Initialize variable list.
echo=
echo    -n, --name
echo       Display variable names.
echo=
echo ENVIRONMENT
echo    temp_path
echo        Path to store the variable data.
echo=
echo    temp
echo        Fallback path for temp_path if temp_path does not exist
echo=
echo NOTES
echo    - For variables that contains very long strings, only changes
echo      in the first 3840 characters is can be detected
exit /b 0


:watchvar.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ hexlify
exit /b 0


rem ======================== demo ========================

:demo.watchvar
call %batchlib%:watchvar --initialize
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
    call %batchlib%:watchvar --name
)
exit /b 0


rem ======================== tests ========================

:tests.lib.watchvar.main
for %%t in (
    "simulate   0 0 0"
    "simulate   2 0 0"
    "simulate   0 2 0"
    "simulate   0 0 2"
    "simulate   3 2 1"
) do call :tests.lib.watchvar.%%~t || (
    call %unittest%.fail %%t
)
exit /b 0


:tests.lib.watchvar.simulate   added  changed  deleted
for /l %%n in (1,1,%~1) do set "simulate.added.%%n="
for /l %%n in (1,1,%~2) do set "simulate.changed.%%n=old"
for /l %%n in (1,1,%~3) do set "simulate.deleted.%%n=old"
set "var_count=0"
for /f "usebackq tokens=1 delims==" %%v in (`set`) do set /a "var_count+=1"
call :watchvar --initialize > "out\initialize"
for /l %%n in (1,1,%~1) do set "simulate.added.%%n=new"
for /l %%n in (1,1,%~2) do set "simulate.changed.%%n=changed"
for /l %%n in (1,1,%~3) do set "simulate.deleted.%%n="
call :watchvar > "out\changes"
for /f "usebackq tokens=1* delims=:" %%a in ("out\initialize") do (
    for /f "tokens=* delims= " %%c in ("%%b") do set "var_count=%%c"
)
for /f "usebackq tokens=1* delims=:" %%a in ("out\changes") do (
    for /f "tokens=1* delims= " %%c in ("%%b") do (
        set "result_count=%%c"
        set "changes=%%d"
    )
)
set /a "var_count+=%~1 - %~3"
if not "!result_count!" == "!var_count!" exit /b 1
if not "!changes!" == "[+%~1/~%~2/-%~3]" exit /b 1
exit /b 0


rem ======================== function ========================

:watchvar   [-i]  [-n]
setlocal EnableDelayedExpansion EnableExtensions
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
for %%d in ("watchvar") do (
    if not exist "%%~d" md "%%~d"
    cd /d "%%~d"
)
for %%x in (txt hex) do (
    if exist "old.%%x" del /f /q "old.%%x"
    if exist "latest.%%x" ren "latest.%%x" "old.%%x"
)
(
    endlocal
    set > "%cd%\latest.txt"
    setlocal EnableDelayedExpansion EnableExtensions
    cd /d "%cd%"
)
for %%v in (_init_only  _list_names) do set "%%v="
set parse_args.args= ^
    ^ "-i, --initialize :store_const:_init_only=true" ^
    ^ "-n, --name       :store_const:_list_names=true"
call :parse_args %*

rem Convert to hex and format
call :hexlify "latest.txt" "latest.tmp"
> "latest.hex" (
    for /f "usebackq tokens=*" %%o in ("latest.tmp") do (
        set "_hex=%%o"
        set "_hex=!_hex:3d=#_!"
        set "_hex=!_hex: =!"
        for /f "tokens=1* delims=#" %%a in ("!_hex!") do (
            set "_hex=%%a 3d %%b"
            set "_hex=!_hex:#=3d!"
            set "_hex=!_hex:_=!"
        )
        echo=!_hex!
    )
)

rem Count variable
set "_var_count=0"
for /f "usebackq tokens=*" %%o in ("latest.hex") do set /a "_var_count+=1"

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
> "changes.hex" (
    for /f "usebackq tokens=1-3 delims= " %%a in ("latest.hex") do (
        set "_old_value="
        for /f "usebackq tokens=1-3 delims= " %%x in ("old.hex") do if "%%a" == "%%x" set "_old_value=%%z"
        if defined _old_value (
            if not "%%c" == "!_old_value!" (
                set /a "_changed_count+=1"
                echo !_changed_hex!20 %%a 0D0A
            )
        ) else (
            echo !_new_hex_!20 %%a 0D0A
            set /a "_new_count+=1"
        )
    )
    for /f "usebackq tokens=1 delims= " %%a in ("old.hex") do (
        set "_value_found="
        for /f "usebackq tokens=1 delims= " %%x in ("latest.hex") do if "%%a" == "%%x" set "_value_found=true"
        if not defined _value_found (
            echo !_deleted_hex!20 %%a 0D0A
            set /a "_deleted_count+=1"
        )
    )
)
if exist "changes.txt" del /f /q "changes.txt"
certutil -decodehex "changes.hex" "changes.txt" > nul

if defined _list_names (
    echo Variables: !_var_count!
    for %%s in (!_states!) do if not "!_%%s_count!" == "0" (
         < nul set /p "=[!_%%s_sym!!_%%s_count!] "
        for /f "usebackq tokens=1* delims= " %%a in ("changes.txt") do (
            if "%%a" == "%%s" < nul set /p "=%%b "
        )
        echo=
    )
) else echo Variables: !_var_count! [+!_new_count!/~!_changed_count!/-!_deleted_count!]
exit /b 0


rem ================================ is_admin() ================================

rem ======================== documentation ========================

:is_admin.__doc__
echo NAME
echo    is_admin - check for administrator privilege
echo=
echo SYNOPSIS
echo    is_admin
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo EXIT STATUS
echo    0:  - Administrator privilege is detected.
echo    1:  - No administrator privilege is detected.
exit /b 0


:is_admin.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.is_admin
call %batchlib%:is_admin && (
    echo Administrator privilege detected
) || echo No administrator privilege detected
exit /b 0


rem ======================== function ========================

:is_admin
( net session || openfiles || exit /b 1 ) > nul 2> nul
exit /b 0


rem ================================ is_echo_on() ================================

rem ======================== documentation ========================

:is_echo_on.__doc__
echo NAME
echo    is_echo_on - check if echo is on
echo=
echo SYNOPSIS
echo    is_echo_on
echo=
echo NOTES
echo    - Temporary file is used in this function.
echo    - This function produces no output, even if error is encountered.
exit /b 0


:is_echo_on.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.is_echo_on
call %batchlib%:is_echo_on && (
    echo Echo is on
) || echo Echo is off
exit /b 0


rem ======================== function ========================

:is_echo_on
@(
    echo > "%temp%\echo_test"
    type "%temp%\echo_test" | find /i "on" && exit /b 0
) > nul 2>&1
@exit /b 1


rem ================================ endlocal() ================================

rem ======================== documentation ========================

:endlocal.__doc__
echo NAME
echo    endlocal - make variables survive ENDLOCAL
echo=
echo SYNOPSIS
echo    endlocal   old_name:new_name  [old_name:new_name [...]]
echo=
echo POSITIONAL ARGUMENTS
echo    old_name
echo        Variable name to keep (before endlocal).
echo=
echo    new_name
echo        Variable name to use (after endlocal).
echo=
echo NOTES
echo    - Variables that contains Line Feed character are not supported and it
echo      could cause unexpected errors.
exit /b 0


:endlocal.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.endlocal
@echo on
set "var_del=This variable will be deleted"
set "var_keep=This variable will keep its content"
setlocal
set "var_del="
set "var_keep=Attempting to change it"
set "var_hello=I am a new variable^!"
(
    @echo off
    call %batchlib%:endlocal var_del var_hello:var_new_name
    @echo on
)
set var_
@echo off
exit /b 0


rem ======================== tests ========================

:tests.lib.endlocal.main
set "old_vars=01 02"
set "new_vars=01"
set "conv_vars=01:01 02:03 03:02"
set expected_result= ^
    ^ 01:new ^
    ^ 02: ^
    ^ 03:old

for %%v in (!old_vars!) do set "%%v=old"
setlocal
for %%v in (!new_vars!) do set "%%v=new"
call :endlocal %conv_vars% quotes

for %%c in (!expected_result!) do (
    for /f "tokens=1* delims=:" %%a in ("%%~c") do (
        if not "!%%a!" == "%%b" (
            call %unittest%.fail %%a
        )
    )
)
exit /b 0


rem (!) Needs more test cases
rem test if variable starts with equal sign

rem ======================== function ========================

:endlocal   old_name:new_name  [old_name:new_name [...]]
setlocal EnableDelayedExpansion
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set "_content="
for %%v in (%*) do for /f "tokens=1,2 delims=:" %%a in ("%%~v:%%~v") do (
    set "_var=!%%a! "
    call :endlocal._to_ede
    set "_content=!_content!%%b=!_var:~0,-1!!LF!"
)
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
        call :endlocal._to_dde
        set "_var=!_var:~1!"
        for /f "delims=" %%c in ("!_var!") do (
            endlocal
            set "%%a=%%c"
        )
    )
)
exit /b 0
#+++

:endlocal._to_ede
set "_var=^!!_var:^=^^^^!"
set "_var=%_var:!=^^^!%"
exit /b
#+++

:endlocal._to_dde
set "_var=%_var%"
exit /b


rem ================================ capchar() ================================

rem ======================== documentation ========================

:capchar.__doc__
echo NAME
echo    capchar - capture control characters
echo=
echo SYNOPSIS
echo    capchar   character1  [character2 [...]]
echo=
echo POSITIONAL ARGUMENTS
echo    character
echo        The character to capture. See 'LIST OF CHARACTERS'
echo        and 'LIST OF MACROS' for list of valid options.
echo=
echo LIST OF CHARACTERS
echo    var     Hex     Name
echo    ------------------------------
echo    BS      07      Backspace
echo    TAB     09      Tab
echo    LF      0A      Line Feed
echo    CR      0D      Carriage Return
echo    ESC     1B      Escape
echo=
echo LIST OF MACROS
echo    var     Description
echo    ------------------------------
echo    _       'Base' for SET /P so it can start with whitespace characters
echo    DEL     Delete previous character (in console)
echo    DQ      'Invisible' double quote to print special characters
echo            without using caret (^^). Must be used as %%DQ%%, not ^^!DQ^^!.
echo    NL      Set new line in variables
exit /b 0


:capchar.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.capchar
echo Capture control characters
echo=
echo ======================== CODE ========================
call %batchlib%:capchar *
echo Hello^^!LF^^!World^^!CR^^!.
echo Clean^^!BS^^!r
echo %%DQ%%^|No^&Escape^|^^^<Characters^>^^
echo ^^!ESC^^![104;97m Windows 10 ^^!ESC^^![0m
< nul set /p "=^!_^!   Whitespace first"
echo=
echo T^^!TAB^^!A^^!TAB^^!B
echo ======================== RESULT ========================
echo Hello!LF!World!CR!.
echo Clean!BS!r
echo %DQ%|No&Escape|^<Characters>^
echo !ESC![104;97m Windows 10 !ESC![0m
< nul set /p "=!_!   Whitespace first"
echo=
echo T!TAB!A!TAB!B
exit /b 0


rem ======================== function ========================

:capchar   character1  [character2 [...]]
if "%~1" == "*" call :capchar BS TAB LF CR ESC _ DEL DQ NL
if /i "%~1" == "BS" for /f %%a in ('"prompt $h & for %%b in (1) do rem"') do set "BS=%%a"
if /i "%~1" == "TAB" for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
if /i "%~1" == "LF" set LF=^
%=REQUIRED=%
%=REQUIRED=%
if /i "%~1" == "CR" for /f %%a in ('copy /z "%ComSpec%" nul') do set "CR=%%a"
if /i "%~1" == "ESC" for /f %%a in ('"prompt $E & for %%b in (1) do rem"') do set "ESC=%%a"
if /i "%~1" == "_" call :capchar "BS" & set "_=_!BS! !BS!"
if /i "%~1" == "DEL" call :capchar "BS" & set "DEL=!BS! !BS!"
if /i "%~1" == "DQ" call :capchar "BS" & set DQ="!BS! !BS!
if /i "%~1" == "NL" call :capchar "LF" & set "NL=^^!LF!!LF!^^"
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

rem ======================== documentation ========================

:hex2char.__doc__
echo NAME
echo    hex2char - generate characters from hex code (WIP)
echo=
echo SYNOPSIS
echo    hex2char   return_var1:hex1  [return_var2:hex2 [...]]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    hex
echo        The hexadecimal representation of the character.
exit /b 0


:hex2char.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.hex2char
call %batchlib%:hex2char
exit /b 0


rem ======================== function ========================

:hex2char   return_var1:char_hex1  [return_var2:char_hex2 [...]]
setlocal EnableDelayedExpansion
certutil
for /f "tokens=* delims=" %%f in ("!_result!") do (
    endlocal
    calL "%%r"
)
exit /b 0


rem ================================ color2seq() ================================

rem ======================== documentation ========================

:color2seq.__doc__
echo NAME
echo    color2seq - convert hexadecimal color to ANSI escape sequence
echo=
echo SYNOPSIS
echo    color2seq   return_var  color
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    color
echo        The hexadecimal representation of the color.
echo        The format of the color is '^<background^>^<foreground^>'.
echo=
echo COLORS
echo    0 = Black       8 = Gray
echo    1 = Blue        9 = Light Blue
echo    2 = Green       A = Light Green
echo    3 = Aqua        B = Light Aqua
echo    4 = Red         C = Light Red
echo    5 = Purple      D = Light Purple
echo    6 = Yellow      E = Light Yellow
echo    7 = White       F = Bright White
echo=
echo NOTES
echo    - Used for color print in windows 10 or any other console that supports
echo      ANSI escape sequence.
exit /b 0


:color2seq.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.color2seq
call %batchlib%:Input.string hexadecimal_color
call %batchlib%:color2seq color_code "!hexadecimal_color!"
echo=
echo Sequence: !color_code!
echo Color print: !ESC!!color_code!Hello World!ESC![0m
exit /b 0


rem ======================== function ========================

:color2seq   return_var  color
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

rem ======================== documentation ========================

:setup_clearline.__doc__
echo NAME
echo    setup_clearline - create a macro to clear current line
echo=
echo SYNOPSIS
echo    setup_clearline   return_var
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the macro.
echo=
echo NOTES
echo    - Based on: get_con_size(), get_os()
echo    - Text should not reach the end of the line.
exit /b 0


:setup_clearline.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ capchar
exit /b 0


rem ======================== demo ========================

:demo.setup_clearline
rem Satisfy dependencies
call :capchar CR DEL

call %batchlib%:setup_clearline CL
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
exit /b 0


rem ======================== function ========================

:setup_clearline   return_var
setlocal EnableDelayedExpansion
set "_index=0"
for /f "usebackq tokens=2 delims=:" %%a in (`call ^| mode con`) do (
    set /a "_index+=1"
    if "!_index!" == "2" set /a "_width=%%a"
)
for /f "tokens=4 delims=. " %%v in ('ver') do (
    endlocal
    set "%~1="
    if %%v GEQ 10 (
        for /l %%n in (1,1,%_width%) do set "%~1=!%~1! "
        set "%~1=_!CR!!%~1!!CR!"
    ) else for /l %%n in (1,1,%_width%) do set "%~1=!%~1!!DEL!"
)
exit /b 0


rem ================================ color_print() ================================

rem ======================== documentation ========================

:color_print.__doc__
echo NAME
echo    color_print - print text with color
echo=
echo SYNOPSIS
echo    color_print   color  text
echo=
echo POSITIONAL ARGUMENTS
echo    color
echo        The hexadecimal representation of the color.
echo        The format of the color is '^<background^>^<foreground^>'.
echo=
echo    text
echo        The text to display in colors.
echo=
echo COLORS
echo    0 = Black       8 = Gray
echo    1 = Blue        9 = Light Blue
echo    2 = Green       A = Light Green
echo    3 = Aqua        B = Light Aqua
echo    4 = Red         C = Light Red
echo    5 = Purple      D = Light Purple
echo    6 = Yellow      E = Light Yellow
echo    7 = White       F = Bright White
echo=
echo ENVIRONMENT
echo    temp_path
echo        Path to store the temporary text file.
echo=
echo NOTES
echo    - Based on: get_con_size(), get_os()
echo    - Printing special characters (the invalid path characters: '"<>|?*:\/')
echo      are not supported.
exit /b 0


:color_print.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ capchar
exit /b 0


rem ======================== demo ========================

:demo.color_print
rem Satisfy dependencies
call :capchar BS

call %batchlib%:Input.string text
call %batchlib%:Input.string hexadecimal_color
echo=
call %batchlib%:color_print "!hexadecimal_color!" "!text!" && (
    echo !LF!Print Success
) || echo !LF!Print Failed. Characters not supported, or external error occured
exit /b 0


rem ======================== function ========================

:color_print   color  text
2> nul (
    pushd "!temp_path!" || exit /b 1
     < nul > "%~2_" set /p "=!DEL!!DEL!"
    findstr /l /v /a:%~1 "." "%~2_" nul
    del /f /q "%~2_" > nul
    popd
)
exit /b 0


rem ======================== notes ========================

rem This is significantly faster

:colorPrint
pushd "!tempPath!"
(
    set /p "=!DEL!!DEL!" < nul > "%~2_"
    findstr /l /v /a:%~1 "." "%~2_" nul
    del /f /q "%~2_" > nul
) 2> nul
popd
goto :EOF


rem ================================ parse_version() ================================

rem ======================== documentation ========================

:parse_version.__doc__
echo NAME
echo    parse_version - versions parser for comparing versions
echo=
echo SYNOPSIS
echo    parse_version   return_var  version
echo=
echo DESCRIPTION
echo    Abstracts handling of project version. This function is inspired by Python
echo    PEP 440 and packaging.version.parse(). parse_version() returns a string
echo    representation of the version that can be used to compare different versions
echo    using simple IF statements.
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    version
echo        The version of the script. Syntax of the version follows Python PEP 440,
echo        except for the no Epoch support. A common example for the syntax is
echo        '[major[.minor[.patch]][-{a^|b^|rc}[.number]]'. If the version is
echo        undefined, it is assumed to be '0'.
echo=
echo ALIASES
echo    a   : a, alpha
echo    b   : b, beta
echo    rc  : rc, c, pre, preview
echo    post: r, post
echo    dev : dev
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    1:  - Invalid version.
echo=
echo EXAMPLE
echo    call :parse_version version1 "1.4.1"
echo    call :parse_version version2 "1.4.1-a.2"
echo    if "%%version1%%" GEQ "%%version2%%" echo True
echo=
echo NOTES
echo    - Support for version numbers is only up to 3 digits of integer.
echo      (e.g.: 999.999, 1.2.3.dev999)
echo    - Numbers longer than 3 digits is truncated. (e.g.: 1.dev2345 -^> 1.dev345)
exit /b 0


:parse_version.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.parse_version
call %batchlib%:Input.string version1
call %batchlib%:Input.string version2
call %batchlib%:Input.string comparison || set "comparison=LSS"
echo=
call :parse_version version1.parsed !version1!
call :parse_version version2.parsed !version2!
echo "!version1!" %comparison% "!version2!"?
if "!version1.parsed!" %comparison% "!version2.parsed!" (
    echo True
) else echo False
exit /b 0


rem ======================== tests ========================

:tests.lib.parse_version.main
call :tests.lib.parse_version.representation
call :tests.lib.parse_version.comparison
exit /b 0


:tests.lib.parse_version.representation
for %%a in (
    "C: "
    "C: 0"
    "C: 0.0"
    "E001C: 1"
    "E001C: 1.0"
    "E001C: 1.0.0"

    "A000C: .dev"
    "A000C: _dev"
    "A000C: -dev"
    "A001C: dev1"
    "A001C: dev.1"

    "Ba000C: .a"
    "Ba000C: _a"
    "Ba000C: -a"
    "Ba001C: a1"
    "Ba001C: a.1"

    "D000C: .r"
    "D000C: _r"
    "D000C: -r"
    "D001C: r1"
    "D001C: r.1"

    "A000C: dev"
    "Ba000C: a"
    "Ba000C: alpha"
    "Bb000C: b"
    "Bb000C: beta"
    "Bc000C: c"
    "Bc000C: rc"
    "Bc000C: pre"
    "Bc000C: preview"
    "D000C: r"
    "D000C: rev"
    "D000C: post"

    "A001C: dev1"
    "Ba002C: a2"
    "Bb003C: b3"
    "Bc004C: c4"
    "D005C: r5"

    "C+A: +"
    "C+Aa: +a"
    "C+A2a: +2a"
    "C+B0000000000: +0"

    "E001E002C: 1.2"
    "E001E002E003C: 1.2.3"
    "E001E002E003E004C: 1.2.3.4"

    "E001E000E003C: 1.0.3"
    "E001E000E000E004C: 1.0.0.4"

    "E001E000E002Ba000C+A123abc: 1.0.2a+123abc"
    "E001Ba000D000A000C+A: 1.0.0a.post.dev+"
    "E001E000E002Ba003D004A005C+B0000000001: 1.0.2-a3.post4.dev5+1"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :parse_version result %%c
    if not "!result!" == "%%b" call %unittest%.fail %%a
)
exit /b 0


:tests.lib.parse_version.comparison
set "return.true=0"
set "return.false=1"
for %%a in (
    "true:  1 EQU 1.0"
    "true:  1 EQU 1.0.0"
    "true:  1.1 EQU 1.1.0"
    "true:  1.0-a EQU 1.0-a.0"

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

    "true:  0.dev LEQ 0+"
    "true:  0 LEQ 0+"
    "true:  0.post GTR 0+"

    "true:  0+1 GTR 0+"
    "true:  0+a GTR 0+"
    "true:  0+1 GTR 0+a"
    "true:  0+1 GTR 0+2a"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :tests.lib.parse_version.comparison.compare %%c
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "!return.%%b!" (
        call %unittest%.fail %%a
    )
)
exit /b 0
#+++

:tests.lib.parse_version.comparison.compare   version1  comparison  version2
call :parse_version version1 "%~1"
call :parse_version version2 "%~3"
if "!version1!" %~2 "!version2!" exit /b 0
exit /b 1


rem ======================== function ========================

:parse_version   return_var  version
set "%~1="
setlocal EnableDelayedExpansion
set "_version=#%~2"
set "_version=!_version:+=+#!"
for /f "tokens=1* delims=+" %%a in ("!_version!") do (
    set "_public=%%a"
    set "_local=+%%b"
    if "!_local!" == "+" (
        set "_local="
    ) else set "_local=!_local:+#=+!"
)
for %%t in (
    " ="
    ".= " "-=" "_="
    "alpha=a"
    "beta=b"
    "preview=c" "pre=c" "rc=c"
    "post=p" "rev=p" "r=p"
    "dev=d"
) do set "_public=!_public:%%~t!"
for %%s in (a b c p d) do (
    set "_public=!_public:%%s= %%s!"
    set "_public=!_public:%%s =%%s!"
)
set "_public=!_public:~1!"
set "_result="
set "_buffer="
for %%s in (!_public!) do (
    set "_segment=%%s"
    set "_type="
    set "_number="
    if "!_segment:~0,1!" GTR "9" (
        for %%t in (
            "D:p"
            "Ba:a" "Bb:b" "Bc:c"
            "A:d"
        ) do for /f "tokens=1-2 delims=:" %%a in (%%t) do (
            if "!_segment:~0,1!" == "%%b" set "_type=%%a"
        )
        set "_number=!_segment:~1!"
    )
    if not defined _type (
        set "_type=E"
        set "_number=!_segment!"
    )
    if not defined _number set "_number=0"
    set "_evaluated="
    set /a "_evaluated=!_number!" || ( 1>&2 echo error: failed to evaluate number & exit /b 1 )
    set /a "_number=!_evaluated!" || ( 1>&2 echo error: failed to evaluate number & exit /b 1 )
    set "_number=000!_number!"
    set "_number=!_number:~-3,3!"
    if not "!_type!" == "E" set "_buffer="
    set "_buffer=!_buffer!!_type!!_number!"
    if not "!_type!,!_number!" == "E,000" (
        set "_result=!_result!!_buffer!"
        set "_buffer="
    )
)
set "_result=!_result!C"
if defined _local (
    set "_local=!_local:~1!"
    set "_is_number="
    if defined _local (
        set "_temp=_!_local!"
        for %%c in (
            a b c d e f g h i j k l m
            n o p q r s t u v w x y z
            0 1 2 3 4 5 6 7 8 9 .
        ) do set "_temp=!_temp:%%c=!"
        if not "!_temp!" == "_" ( 1>&2 echo error: invalid local version identifier & exit /b 1 )

        set "_temp=_!_local!"
        for /l %%n in (0,1,9) do set "_temp=!_temp:%%n=!"
        if "!_temp!" == "_" set "_is_number=true"
    )
    if defined _is_number (
        for %%p in (10) do (
            for /l %%n in (1,1,%%p) do set "_local=0!_local!"
            set "_local=!_local:~-%%p,%%p!"
        )
        set "_local=B!_local!"
    ) else set "_local=A!_local!"
    set "_result=!_result!+!_local!"
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


rem ================================ module ================================

rem ======================== documentation ========================

:module.__doc__
echo Module Framework
echo=
echo DESCRIPTION
echo    module allow scripts to execute modules as scripts. With module framework,
echo    a script can call function of another script as if they exist in the
echo    caller's file. This also enable scripts to have multiple entry points.
echo    A common example is to use module framework to start multiple batch
echo    script windows.
echo=
echo FUNCTIONS
echo    - module.entry_point()
echo    - module.read_metadata()
echo    - module.is_module()
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
exit /b 0


:module.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ module.entry_point ^
    ^ module.read_metadata ^
    ^ module.is_module
exit /b 0


:demo.module
echo Demo is unavailable.
exit /b 0


:module
rem Module Framework
exit /b 0


rem ============================ .entry_point() ============================

rem ======================== documentation ========================

:module.entry_point.__doc__
echo NAME
echo    module.entry_point - determine the script entry point and GOTO the label
echo=
echo SYNOPSIS
echo    module.entry_point   [--module=name]  [args]
echo=
echo POSITIONAL ARGUMENTS
echo    args
echo        The parameters for the script/entry point.
echo=
echo OPTIONS
echo    --module=NAME
echo        Specify the entry point of the script. The entry point will be called
echo        with the arguments and exit code will be preserved upon exit.
echo        If this option is not set, the function will 'GOTO __main__'.
echo=
echo ENTRY POINTS
echo    An entry point is a label follows the pattern ':scripts.NAME'.
echo    For a entry point to be detected, the label of the function MUST
echo    be preceeded by either nothing, or spaces and/or tabs.
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
echo=
echo USAGE
echo    The first command on the script should be '@goto module.entry_point'
exit /b 0


:module.entry_point.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.module.entry_point
echo Reads the argument to determine which script/entry point to GOTO
echo Used for scripts that has multiple entry points
echo=
echo Press any key to start another window...
pause > nul
@echo on
start "" /i cmd /c ""%~f0" --module=2nd_window_demo   test "arg" Here"
@echo off
echo=
echo 'cmd /c' is required to make sure the new window closes
echo if it exits using the 'exit /b' command
exit /b 0
#+++

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


rem ======================== tests ========================

:tests.lib.module.entry_point.main
call %batchlib%:extract_func "%~f0" "__init__ module.entry_point " > "test_entry_point.bat"
call %batchlib%:extract_func "%~f0" "tests.lib.module.entry_point.capture_args" > "capture_args"

>> "test_entry_point.bat" (
    echo :__main__
    echo @call :scripts.main %%*
    echo @exit /b %%errorlevel%%

    for %%e in (main second) do (
        echo :scripts.%%e
        echo set "entry_point=%%e"
        < nul set /p "=@rem "
        type "capture_args"
    )
)

call %batchlib%:capchar LF
set test_cases= ^
    ^ "no args"         :main:       !LF!^
    ^ "quoted --module" :main:       "--module" second !LF!^
    ^ "second module"   :second:     --module second
for /f "tokens=*" %%a in ("!test_cases!") do (
    for /f "tokens=1-2* delims=:" %%b in ("%%a") do (
        set "entry_point="
        call "test_entry_point.bat" %%d > nul
        set "exit_code=!errorlevel!"
        if not "!entry_point!/!exit_code!" == "%%c/!expected_exit_code!" (
            echo "!entry_point!/!exit_code!" == "%%c/!expected_exit_code!"
            call %unittest%.fail %%b
        )
    )
)
exit /b 0
#+++

:tests.lib.module.entry_point.capture_args
set args=%*
set "expected_exit_code=%random%"
echo Arguments: %*
exit /b %expected_exit_code%


rem ======================== function ========================

:module.entry_point   [--module=<name>]  [args]
@if /i not "%~1" == "--module" @goto __main__
@if /i #%1 == #"%~1" @goto __main__
@setlocal DisableDelayedExpansion
@set module.entry_point.args=%*
@setlocal EnableDelayedExpansion
@for /f "tokens=1* delims== " %%a in ("!module.entry_point.args!") do @(
    endlocal
    endlocal
    call :scripts.%%b
)
@exit /b %errorlevel%


rem ============================ .read_metadata() ============================

rem ======================== documentation ========================

:module.read_metadata.__doc__
echo NAME
echo    module.read_metadata - read metadata of a script
echo=
echo SYNOPSIS
echo    module.read_metadata   return_prefix  input_file
echo=
echo POSITIONAL ARGUMENTS
echo    return_prefix
echo        Prefix of the variable to store the metadata.
echo        Generally metadata includes: name, version, author, license,
echo        description, release_date, url, download_url.
echo=
echo    input_file
echo        Path of the input (batch) file.
exit /b 0


:module.read_metadata.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.module.read_metadata
call %batchlib%:Input.path script_to_check
call :module.is_module "!script_to_check!" || (
    echo Script does not support call as module
    echo Please choose another script that supports call as module
    exit /b 0
)
echo=
echo Metadata:
call :module.read_metadata script. "!script_to_check!"
set "script."
exit /b 0


rem ======================== function ========================

:module.read_metadata   return_prefix  script_path
for %%v in (
    name version
    author license
    description release_date
    url download_url
    install_requires
) do set "%~1%%v="
call "%~2" --module=lib :__metadata__ "%~1" || exit /b 1
exit /b 0


rem ============================ .is_module() ============================

rem ======================== documentation ========================

:module.is_module.__doc__
echo NAME
echo    module.is_module - check if a given file is a batch script module
echo=
echo SYNOPSIS
echo    module.is_module   input_file
echo=
echo DESCRIPTION
echo    This function checks if a script contains:
echo    - 'GOTO module.entry_point'
echo    - module.entry_point()
echo    - scripts.lib()
echo    - __metadata__()
echo=
echo    This could prevent script from calling another batch file that does not
echo    contain the module() framework and cause undesired results.
echo=
echo POSITIONAL ARGUMENTS
echo    input_file
echo        Path of the input file.
exit /b 0


:module.is_module.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.module.is_module
call %batchlib%:Input.path script_to_check
echo=
set "start_time=!time!"
call :module.is_module "!script_to_check!" && (
    echo Script supports call as module
) || echo Script does not support call as module
call %batchlib%:difftime time_taken !time! !start_time!
call %batchlib%:ftime time_taken !time_taken!
echo=
echo Done in !time_taken!
exit /b 0


rem ======================== function ========================

:module.is_module   input_file
setlocal EnableDelayedExpansion
set /a "_missing=0xF"
for /f "usebackq tokens=* delims=@ " %%a in ("%~f1") do (
    for /f "tokens=1-2 delims= " %%b in ("%%a") do (
        if /i "%%b %%c" == "goto module.entry_point" set /a "_missing&=~0x1"
        if /i "%%b" == ":module.entry_point" set /a "_missing&=~0x2"
        if /i "%%b" == ":__metadata__" set /a "_missing&=~0x4"
        if /i "%%b" == ":scripts.lib" set /a "_missing&=~0x8"
    )
)
if not "!_missing!" == "0" exit /b 1
set "_callable="
for %%x in (.bat .cmd) do if "%~x1" == "%%x" set "_callable=true"
if not defined _callable exit /b 2
exit /b 0


rem ================================ unittest() ================================

rem ======================== documentation ========================

:unittest.__doc__
echo NAME
echo    unittest - unit testing framework
echo=
echo SYNOPSIS
echo    unittest   [module]  [-l test_list^|-p pattern]  [-v^|-q]  [-f]
echo    unittest.skip   [msg]
echo    unittest.fail   [msg]
echo    unittest.error   [msg]
echo    unittest.stop
echo=
echo DESCRIPTION
echo    unittest() is a unit testing framework for batch script. It search for
echo    labels that match the pattern in the module file and run the tests.
echo=
echo    In unittest(), test cases that is successful is indicated by not calling
echo    unittest.skip(), unittest.fail(), unittest.error(), and return exit code 0.
echo=
echo    Use unittest.skip(), unittest.fail(), unittest.error() to indicate test
echo    needs to be skipped, failed, or error, respectively. Functions with [msg]
echo    in the argument can be used to specify the message/reason why it occured.
echo    If an important test failed, use unittest.stop() to stop the test early.
echo=
echo POSITIONAL ARGUMENTS
echo    module
echo        Path of the batch script that contains the test functions.
echo=
echo OPTIONS
echo    -v, --verbose
echo        Show more results of the tests. Mutually exclusive with '--quiet'.
echo=
echo    -q, --quiet
echo        Quiet output. Mutually exclusive with '--verbose'.
echo=
echo    -f, --failfast
echo        Stop on first fail or error.
echo=
echo    -p PATTERN, --pattern PATTERN
echo        Pattern to match in tests labels ('tests.*.main' default).
echo        Mutually exclusive with '--label'.
echo=
echo    -l LABELS, --label LABELS
echo        Labels to test. The syntax is "label [...]".
echo        Mutually exclusive with '--pattern'.
echo=
echo ENVIRONMENT
echo    temp_path
echo        Path to store the temporary test results.
echo=
echo    temp
echo        Fallback path for temp_path if temp_path does not exist
echo=
echo NOTES
echo    - unittest() will call tests.__init__() first before running any tests
echo    - If both label and pattern options are specified, it will use label.
echo    - The variable name 'unittest' and variable names that starts with
echo      'unittest.*' are reserved for unittest().
echo    - Using reserved variables in your tests might break unittest().
exit /b 0


:unittest.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ find_label ^
    ^ difftime ftime
exit /b 0


rem ======================== demo ========================

:demo.unittest
call :tests.lib.unittest.init_vars
set "expected.success.list=success"
set "expected.failures.list=failure multi_fail"
set "expected.errors.list=error"
set "expected.skipped.list=skip"
call :tests.lib.unittest.make_expectation

call :unittest -v -l "!test_list!" -v
exit /b 0


rem ======================== function ========================

:unittest   [module]  [-l test_list|-p pattern]  [-v|-q]  [-f]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (fail_fast test_list pattern) do set "unittest.%%v="
set "unittest.verbosity=1"
set parse_args.args= ^
    ^ "-v, --verbose    :store_const:unittest.verbosity=2" ^
    ^ "-f, --failfast   :store_const:unittest.fail_fast=true" ^
    ^ "-p, --pattern    :store:unittest.pattern" ^
    ^ "-l, --label      :store:unittest.test_list"
call :parse_args %*
set "unittest.test_module=%~f1"
if not defined unittest.test_module set "unittest.test_module=%~f0"

rem Setup test directory
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
for %%d in (unittest) do (
    if not exist "%%~d" md "%%~d"
    cd /d "%%~d"
)
for %%p in (
    in out log
) do if not exist "%%~p" md "%%~p"

rem Setup test list
if not defined unittest.pattern set "unittest.pattern=tests.*.main"
if not defined unittest.test_list (
    call :find_label unittest.test_list -p "!unittest.pattern!" -f "!unittest.test_module!"
)
set "unittest.tests_count=0"
for %%t in (!unittest.test_list!) do set /a "unittest.tests_count+=1"

rem Setup display
set "_temp=!unittest.tests_count!"
set "_num_digits=0"
set "_num_padding="
for /l %%n in (1,1,4) do if not "!_temp!" == "0" (
    set /a "_temp/=10"
    set "_num_digits=%%n"
    set "_num_padding=!_num_padding! "
)

rem Setup context
set unittest="%~f0" --module=lib :unittest
if not "!unittest.test_module!" == "%~f0" (
    set unittest.test_context="!unittest.test_module!" --module=lib %=END=%
)

rem Reset test results
for %%c in (failures errors skipped) do set "unittest.%%c="
set "unittest.tests_run=0"
set "unittest.should_stop="

rem Setup test
call :tests.__init__

set "start_time=!time!"
for %%t in (!unittest.test_list!) do if not defined unittest.should_stop (
    set /a "unittest.tests_run+=1"
    if "!unittest.verbosity!" == "2" (
        call %batchlib%:difftime _elapsed_time !time! !start_time!
        call %batchlib%:ftime _elapsed_time !_elapsed_time!
        set "unittest.tests_run=%_num_padding%!unittest.tests_run!"
        set "unittest.tests_run=!unittest.tests_run:~-%_num_digits%,%_num_digits%!"
        echo !_elapsed_time! [!unittest.tests_run!/!unittest.tests_count!] %%t
    )
    call :unittest._run  %%t
)
set "stop_time=!time!"
call :difftime time_taken !stop_time! !start_time!
call :ftime time_taken !time_taken!
echo=
echo ----------------------------------------------------------------------
echo Ran !unittest.tests_run! test!s! in !time_taken!
echo=

set "unittest.was_successful=true"
for %%c in (failures errors) do (
    if defined unittest.%%c set "unittest.was_successful="
)
for %%c in (failures errors skipped) do (
    set "unittest.%%c_count=0"
    for %%t in (!unittest.%%c!) do (
        set /a "unittest.%%c_count+=1"
    )
)

set "infos= "
if defined unittest.was_successful (
    < nul set /p "=OK "
) else (
    < nul set /p "=FAILED "
    if defined unittest.failures set "infos=!infos! failures=!unittest.failures_count!"
    if defined unittest.errors set "infos=!infos! errors=!unittest.errors_count!"
)
if defined unittest.skipped set "infos=!infos! skipped=!unittest.skipped_count!"
set "infos=!infos:~2!"
if defined infos < nul set /p "=(!infos!)"
echo=
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
rd /s /q "unittest" > nul 2> nul
if not defined unittest.was_successful exit /b 1
exit /b 0
#+++

:unittest._run   label
call 2> "log\outcome.bat"
set "unittest.current_test_name=%~1"
setlocal EnableDelayedExpansion EnableExtensions
call %unittest.test_context%:%~1
endlocal & set "_exit_code=%errorlevel%"
if not "!_exit_code!" == "0" (
    >> "log\outcome.bat" (
        echo call %%unittest%%._add_outcome error "Test function did not exit correctly [exit code !_exit_code!]."
    )
)
set "unittest.current_outcome=success"
call "log\outcome.bat"
call :unittest._add_result !unittest.current_outcome! %1
call :%~1.cleanup 2> nul
exit /b 0
#+++

:unittest.skip   reason
>> "log\outcome.bat" (
    echo call %%unittest%%._add_outcome skip %1
)
exit /b 0
#+++

:unittest.fail   msg
>> "log\outcome.bat" (
    echo call %%unittest%%._add_outcome failure %1
)
exit /b 0
#+++

:unittest.error   msg
>> "log\outcome.bat" (
    echo call %%unittest%%._add_outcome error %1
)
exit /b 0
#+++

:unittest.stop
>> "log\outcome.bat" (
    echo set "unittest.should_stop=true"
)
exit /b 0
#+++

:unittest._add_outcome   {failure|error|skip}  [msg]
set "unittest.test.!unittest.current_test_name!.%~1_msg=%~2"
for %%c in (skip failure error) do (
    for %%o in (!unittest.current_outcome! %~1) do (
        if "%%c" == "%%o" set "unittest.current_outcome=%%o"
    )
)
if "!unittest.verbosity!" == "2" (
    echo [%~1] %~2
)
exit /b 0
#+++

:unittest._add_result   {success|failure|error|skip}  test  [msg]
set "_list_name="
set "_mark=?"
set "_msg=test %~1 has unknown result"
if /i "%~1" == "success" (
    set "_list_name="
    set "_mark=."
    rem set "_msg=ok"
    set "_msg="
)
if /i "%~1" == "failure" (
    set "_list_name=failures"
    set "_mark=F"
    rem set "_msg=FAIL"
    set "_msg=test %~2 failed"
)
if /i "%~1" == "error" (
    set "_list_name=errors"
    set "_mark=E"
    rem set "_msg=ERROR"
    set "_msg=test %~2 failed -- an error occurred"
)
if /i "%~1" == "skip" (
    set "_list_name=skipped"
    set "_mark=s"
    rem set "_msg=skipped '!unittest.test.%unittest.current_test_name%.skip_msg!'"
    set "_msg=test %~2 skipped '!unittest.test.%unittest.current_test_name%.skip_msg!'"
)
if defined _list_name (
    for %%c in (!_list_name!) do set "unittest.%%c=!unittest.%%c! %~2"
)
if "!unittest.verbosity!" == "1" < nul set /p "=!_mark!"
if "!unittest.verbosity!" == "2" if defined _msg echo !_msg!
exit /b 0


rem ======================== tests ========================

:tests.framework.unittest.main
set "parent_unittest_path=!cd!"
set "temp_path=!cd!"
call :tests.lib.unittest.init_vars
set "expected.success.list=success"
set "expected.failures.list=failure multi_fail"
set "expected.errors.list=error"
set "expected.skipped.list=skip"
call :tests.lib.unittest.make_expectation

rem Test running internal unittest
call :unittest -p "!test_prefix!*" -v > nul
rem Test running unittest for external module
call :unittest "%~f0" -p "!test_prefix!*" -v > nul
exit /b 0


:tests.lib.unittest.init_vars
set "test_prefix=tests.lib.unittest.test_"
set "expected_skip.msg=Not implemented yet..."
set "expected_failure.msg=Test failure single"
set "expected_error.exit_code=1"
set "expected_error.msg=Test function did not exit correctly [exit code !expected_error.exit_code!]."
exit /b 0


:tests.lib.unittest.make_expectation
set "test_list="
for %%o in (success failures errors skipped) do (
    set "expected.%%o="
    for %%n in (!expected.%%o.list!) do (
        set "expected.%%o=!expected.%%o! !test_prefix!%%n"
        set "test_list=!test_list! !test_prefix!%%n"
    )
)
exit /b 0


:tests.lib.unittest.test_success
rem Do nothing
exit /b 0


:tests.lib.unittest.test_skip
call %unittest%.skip "!expected_skip.msg!"
exit /b 0


:tests.lib.unittest.test_failure
call %unittest%.fail "!expected_failure.msg!"
exit /b 0


:tests.lib.unittest.test_multi_fail
rem Note: unittest can't record multiple failures in a test (yet?)
call %unittest%.fail "Test failure multiple 1"
call %unittest%.fail "Test failure multiple 2"
exit /b 0


:tests.lib.unittest.test_error
exit /b %expected_error.exit_code%


:tests.lib.unittest.test_unittest
cd /d "!parent_unittest_path!"
for %%o in (skip failure error) do for %%n in (!test_prefix!%%o) do (
    if not "!unittest.test.%%n.%%o_msg!" == "!expected_%%o.msg!" (
        call %unittest%.fail "Failed to set expected message on test_%%o"
    )
)
for %%o in (failures errors skipped) do (
    if not "!unittest.%%o!" == "!expected.%%o!" (
        call %unittest%.fail "The %%o list does not match the expected values"
    )
)
exit /b 0


rem ================================ parse_args() ================================

rem ======================== documentation ========================

:parse_args.__doc__
echo NAME
echo    parse_args - parse command line arguments
echo=
echo SYNOPSIS
echo    parse_args   %%*
echo=
echo DESCRIPTION
echo    parse_args() is a argument parser for batch script. All arguments is passed
echo    to parse_args() by calling it using '%%*' and it will read the parsing
echo    options defined in the variable 'parse_args.args' to extract the data.
echo    Arguments that does not match any of the options remains as positional
echo    arguments.
echo=
echo=   Each parsing option consist of 3 parts:
echo=
echo        "FLAGS:ACTION:VARIABLE[=CONST]"
echo=
echo    FLAGS       Flags to match.
echo    ACTION      How to handle this argument.
echo    VARIABLE    Variable to store/append the value
echo    CONST       The constant/value to store/append to VARIABLE.
echo=
echo    There are few types of actions:
echo        store
echo            Stores the next argument into VARIABLE.
echo            E.g.: "--message    :store:message"
echo            will do: set "message={next argument}"
echo=
echo        store_const
echo            Set value according to VARIABLE and CONST.
echo            E.g.: "-q, --quiet  :store_const:quite_mode=true"
echo            will do: set "quite_mode=true"
echo=
echo        append_const
echo            Append CONST to the VARIABLE.
echo            E.g.: "--add_one    :append_const:value= +1"
echo                will do: set "value=^!value^! +1"
echo=
echo EXAMPLE
echo    set parse_args.args= ^^
echo        ^^ "-q, --quite     :store_const:quite_mode=true" ^^
echo        ^^ "-m, --module    :store:module_name" ^^
echo        ^^ "-0, --zero      :store:binary=0" ^^
echo        ^^ "-1, --one       :store:binary=1"
echo    call :parse_args -m calc -q -0 hello --one --zero -1 world
echo=
echo    - quite_mode will be set to 'true'
echo    - module_name will be set to 'calc'
echo    - binary will be set to '0101'
echo    - %%1 will be 'hello'
echo    - %%2 will be 'world'
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    1:  - Invalid parameter of 'parse_args.args'.
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
exit /b 0


:parse_args.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.parse_args
echo A calculator that speaks the result of an expression
echo Usage: talking_calculator   expression  [-s text]  [-b] [-h] [-p]
echo=
echo POSITIONAL ARGUMENTS
echo    expression             The mathematical expression to answer
echo=
echo POSITIONAL ARGUMENTS
echo    expression
echo        The expression to calculate.
echo=
echo OPTIONS
echo    -s, --say TEXT
echo        Print TEXT before showing the result.
echo=
echo    -b, --binary
echo        Show result in the form of binary.
echo=
echo    -h, --hex
echo        Show result in the form of hexadecimal.
echo=
echo    -p, --plus
echo        Add one to the result. Can be used multiple times.
echo=
call %batchlib%:Input.string parameters
echo=
call :talking_calculator !parameters!
exit /b 0
#+++

:talking_calculator
for %%v in (_say _binary _hex) do set "%%v="
set parse_args.args= ^
    ^ "-s, --say        :store:_args._say" ^
    ^ "-b, --binary     :store_const:_args._binary=true" ^
    ^ "-h, --hex        :store_const:_args._hex=true" ^
    ^ "-p, --plus       :append_const:_args._plus= +1"
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
set /a "_result+=0 !_args._plus!"
if defined _args._binary call %batchlib%:int2bin _result !_result!
if defined _args._hex (
    call %batchlib%:int2hex _result !_result!
    set "_result=0x!_result!"
)
if not defined _args._say set "_args._say=The answer is"
echo !_args._say! !_result!
exit /b 0


rem ======================== tests ========================

:tests.lib.parse_args.main
for %%a in (alpha bravo charlie hotel tango x-ray zulu) do (
    set "_char=%%a"
    set "_char=!_char:~0,1!"
    for %%c in (!_char!) do set "p_arg_%%c=-%%c, --%%a"
)
call :tests.lib.parse_args.test_no_args || exit /b 0
call :tests.lib.parse_args.test_invalid_args --hello || exit /b 0
for %%t in (store_const store append_const) do (
    call :tests.lib.parse_args.test_%%t --bravo "--alpha" -t -c -h --x-ray zulu  || exit /b 0
)
call :tests.lib.parse_args.test_special_chars "" --colon ":" --semicolon ";" ^
    ^ --question-mark "?" --askterisk "*" --caret "^" --ampersand "&" ^
    ^ || exit /b 0
call :tests.lib.parse_args.test_behavior  -c || exit /b 0
exit /b 0


:tests.lib.parse_args.test_no_args
setlocal EnableDelayedExpansion EnableExtensions
set "parse_args.args="
call :parse_args %* || (
    call %unittest%.fail "test_no_args: exit state must be successful"
    exit /b 1
)
exit /b 0


:tests.lib.parse_args.test_invalid_args
setlocal EnableDelayedExpansion EnableExtensions
set parse_args.args= ^
    ^ "--hello  :this_is_invalid:hello=true"
call :parse_args %* 2> nul && (
    call %unittest%.fail "test_invalid_args: type error not detected"
    exit /b 1
)
set parse_args.args= ^
    ^ "--hello  :store_const:"
call :parse_args %* 2> nul && (
    call %unittest%.fail "test_invalid_args: attribute error not detected"
    exit /b 1
)
exit /b 0


:tests.lib.parse_args.test_store_const
for %%v in (b a t c h x z) do set "arg_%%v="
set "parse_args.args="
for %%c in (b a c x z) do set parse_args.args=!parse_args.args! "!p_arg_%%c!:store_const:arg_%%c=true"
call :parse_args %* || ( call %unittest%.error "test_store_const: invalid test arguments" & exit /b 1 )
if not "!arg_received!" == "!arg_expected!" ( call %unittest%.fail "test_store_const: positional arguments" & exit /b 1 )
for %%v in (b c x) do (
    if not defined arg_%%v ( call %unittest%.fail "test_store_const: false negative: %%v" & exit /b 1 )
)
for %%v in (a z) do (
    if defined arg_%%v ( call %unittest%.fail "test_store_const: false positive: %%v" & exit /b 1 )
)
exit /b 0


:tests.lib.parse_args.test_store
for %%v in (b a t c h x z) do set "arg_%%v="
set "parse_args.args="
for %%c in (a t c x z) do set parse_args.args=!parse_args.args! "!p_arg_%%c!:store:arg_%%c"
call :parse_args %* || ( call %unittest%.error "test_store: invalid test arguments" & exit /b 1 )
set arg_received=[%1, %2, %3, %4]
set arg_expected=[--bravo, "--alpha", -h, ]
if not "!arg_received!" == "!arg_expected!" ( call %unittest%.fail "test_store: positional arguments" & exit /b 1 )
for %%v in (a c h z) do (
    if defined arg_%%v ( call %unittest%.fail "test_store: false positive: %%v" & exit /b 1 )
)
if not "!arg_t!" == "-c" ( call %unittest%.fail "test_store: keyword '-t'" & exit /b 1 )
if not "!arg_x!" == "zulu" ( call %unittest%.fail "test_store: keyword '-x'" & exit /b 1 )
exit /b 0


:tests.lib.parse_args.test_append_const
for %%v in (b a t c h x z) do set "arg_%%v="
set "parse_args.args="
for %%c in (b a t c h x) do set parse_args.args=!parse_args.args! "!p_arg_%%c!:append_const:word=%%c"
call :parse_args %* || ( call %unittest%.fail "append_const: invalid test arguments" & exit /b 1 )
set arg_received=[%1, %2, %3]
set arg_expected=["--alpha", zulu, ]
if not "!arg_received!" == "!arg_expected!" ( call %unittest%.fail "test_store: positional arguments" & exit /b 1 )
if not "!word!" == "btchx" ( call %unittest%.fail "append_const: incorrect result" & exit /b 1 )
exit /b 0


:tests.lib.parse_args.test_special_chars
for %%v in (question_mark asterisk colon semicolon caret) do set "%%v="
set parse_args.args= ^
    ^ "--question-mark  :store:question_mark" ^
    ^ "--askterisk      :store:asterisk" ^
    ^ "--colon          :store:colon" ^
    ^ "--semicolon      :store:semicolon" ^
    ^ "--caret          :store:caret" ^
    ^ "--ampersand      :store:ampersand"
call :parse_args %* || ( call %unittest%.error "test_special_chars: invalid test arguments" & exit /b 1 )
if not "%1" == ^"^"^"^" ( call %unittest%.fail "test_special_chars: parsing of empty string" & exit /b 1 )
if not "!question_mark!" == "?" ( call %unittest%.fail "test_special_chars: parsing of question mark" & exit /b 1 )
if not "!asterisk!" == "*" ( call %unittest%.fail "test_special_chars: parsing of asterisk" & exit /b 1 )
if not "!colon!" == ":" ( call %unittest%.fail "test_special_chars: parsing of colon" & exit /b 1 )
if not "!semicolon!" == ";" ( call %unittest%.fail "test_special_chars: parsing of semicolon" & exit /b 1 )
if not "!caret!" == "^" ( call %unittest%.fail "test_special_chars: parsing of caret" & exit /b 1 )
if not "!ampersand!" == "&" ( call %unittest%.fail "test_special_chars: parsing of ampersand" & exit /b 1 )
exit /b 0


:tests.lib.parse_args.test_behavior
for %%v in (_lowercase _uppercase) do set "%%v="
set parse_args.args= ^
    ^ "-c   :store_const:_lowercase=true" ^
    ^ "-C   :store_const:_uppercase=true"
call :parse_args %* || ( call %unittest%.error "test_store_const: invalid test arguments" & exit /b 1 )
if defined _uppercase ( call %unittest%.fail "test_behavior: keyword argument is not case sensitive" & exit /b 1 )
exit /b 0


rem ======================== function ========================

:parse_args   %*
for %%a in (!parse_args.args!) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    set "_valid="
    for %%t in (store store_const append_const) do if /i "%%c" == "%%t" set "_valid=true"
    if not defined _valid ( 1>&2 echo error: invalid argument type '%%c' for '%%b' & exit /b 1 )
    if "%%d" == "" ( 1>&2 echo error: variable name not defined for '%%b' & exit /b 1 )
)
set "_store_var="
set "parse_args.argc=1"
set "parse_args.shift="
call :parse_args._loop %* || exit /b 1
set /a "parse_args.argc-=1"
set "parse_args._store_var="
set "parse_args._value="
(
    goto 2> nul
    for %%n in (!parse_args.shift!) do shift /%%n
    for %%v in (args shift) do set "parse_args.%%v="
    ( call )
)
exit /b 1
#+++

:parse_args._loop
set _value=_%1
set "_value=!_value:^^^^^^^^=^!"
set "_value=!_value:~1!"
if not defined _value exit /b 0
set "_shift="
if defined parse_args._store_var (
    if "!_value:~0,1!!_value:~-1,1!" == ^"^"^"^" set "_value=!_value:~1,-1!"
    set "!parse_args._store_var!=!_value!"
    set "parse_args._store_var="
    set "_shift=true"
) else (
    for %%o in (!parse_args.args!) do for /f "tokens=1-2* delims=:" %%b in (%%o) do (
        for %%f in (%%b) do if "!_value!" == "%%f" (
            if /i "%%c" == "store" set "parse_args._store_var=%%d"
            if /i "%%c" == "store_const" set "%%d"
            if /i "%%c" == "append_const" (
                for /f "tokens=1* delims==" %%v in ("%%d") do set "%%v=!%%v!%%w"
            )
            set "_shift=true"
        )
    )
)
if defined _shift (
    set "parse_args.shift=!parse_args.shift! !parse_args.argc!"
) else set /a "parse_args.argc+=1"
shift /1
goto parse_args._loop


rem ======================== debug ========================

rem Stripped down version, to be embedded in function
rem - Supports 'store_const' and 'append_const' action only
rem - Cannot handle special characters
:parse_args.store_const   %*
rem This part can be removed once parameters in 'parse_args.args' are correct
for %%a in (!parse_args.args!) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    set "_valid="
    for %%t in (store_const append_const) do if /i "%%c" == "%%t" set "_valid=true"
    if not defined _valid ( 1>&2 echo error: invalid argument type '%%c' for '%%b' & exit /b 1 )
    if "%%d" == "" ( 1>&2 echo error: variable name not defined for '%%b' & exit /b 1 )
)
%= [function] parse_args.store_const =% (
    goto 2> nul & rem Remove this line if you are copying it to your function
    set "parse_args.argc=1"
    for %%a in (%*) do (
        set "_shift="
        for %%o in (!parse_args.args!) do for /f "tokens=1-2* delims=:" %%b in (%%o) do (
            for %%f in (%%b) do if "%%a" == "%%f" (
                if /i "%%c" == "store_const" set "%%d"
                if /i "%%c" == "append_const" (
                    for /f "tokens=1* delims==" %%v in ("%%d") do set "%%v=!%%v!%%w"
                )
                set "_shift=true"
            )
        )
        if defined _shift (
            shift /!parse_args.argc!
        ) else set /a "parse_args.argc+=1"
    )
    set /a "parse_args.argc-=1"
    set "parse_args.args="
)
exit /b 0


rem ============================ updater() ============================

rem ======================== documentation ========================

:updater.__doc__
echo NAME
echo    updater - update a batch script from the internet
echo=
echo SYNOPSIS
echo    updater   script_path  [-f]  [-u]  [-d url]
echo=
echo DESCRIPTION
echo    This function can detect updates, download them, and update the script.
echo    The 'download_url' in __metadata__() needs to be added.
echo=
echo POSITIONAL ARGUMENTS
echo    script_path
echo        Path of the (batch) file.
echo=
echo OPTIONS
echo    -u, --upgrade
echo        Perform an upgrade on the script (REPLACES the current file).
echo=
echo    -V, --skip-verification
echo        Skip verification of module name and version of downloaded update file.
echo        Use this only if the update is not backward compatible.
echo=
echo    -d, --download-url
echo        Use this url instead of the download_url at the script's __metadata__().
echo=
echo ENVIRONMENT
echo    temp_path
echo        Path to store the update file.
echo=
echo    temp
echo        Fallback path for temp_path if temp_path does not exist
echo=
echo DEPENDENCIES
echo    Extras:
echo        - diffdate()
echo=
echo    Script file:
echo        - __metadata__()
echo        - module()
echo        - scripts.lib()
echo=
echo NOTES
echo    - Do not set your script version to '0.dev0' equivalent values.
echo      Your script will unconditionally fail the unittest.
echo    - Undefined script version is allowed.
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    1:  - Failed to get download url.
echo    2:  - Failed to get update.
echo    3:  - Failed to read update information.
echo    4:  - The update file does not pass the verification.
echo    5:  - No update is available.
echo    6:  - Update failed.
exit /b 0


:updater.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ download_file ^
    ^ parse_version ^
    ^ module.is_module ^
    ^ module.read_metadata
exit /b 0


rem ======================== demo ========================

:demo.updater
echo Checking for updates...
call :updater "%~f0" || exit /b 0
echo=
echo Note:
echo - Updating will REPLACE current script with the newer version
echo=
call %batchlib%:Input.yesno user_input --message "Update now? Y/N? " || exit /b 0
echo=
call :updater --upgrade "%~f0" && (
    echo Upgrade successful. Script will exit.
    pause
    exit 0
)
exit /b 0


rem ======================== tests ========================

:tests.lib.updater.main
(
    call :module.is_module "%~f0" ^
    && call :__metadata__ SOFTWARE.
) || ( call %unittest%.error "Cannot read metadata of this script" & exit /b 0 )

set "no_internet=true"
for %%n in (1,1,3) do for %%h in (google.com baidu.com) do (
    if defined no_internet call :ping_test _ %%h "-n 1" && set "no_internet="
)
if defined no_internet call %unittest%.skip "Cannot connect to the internet" & exit /b 0

set updater= ^
    ^   updater ^
    ^   download_file parse_version parse_args diffdate ^
    ^   module.entry_point module.read_metadata module.is_module
call %batchlib%:extract_func "%~f0" ^
    ^ ^"__init__ scripts.lib ^
    ^   !updater! ^
    ^   tests.lib.updater.simulate ^
    ^   tests.lib.updater.setup_metadata ^
    ^   tests.lib.updater.make_metadata ^" ^
    ^ > "cache"
>> "cache" (
    echo :__main__
    echo @call :scripts.main %%*
    echo @exit /b %%errorlevel%%
    echo=
    echo=

    echo :__metadata__
    < nul set /p "=@rem "
    call %batchlib%:extract_func "cache" "tests.lib.updater.make_metadata"

    echo :scripts.main
    < nul set /p "=@rem "
    call %batchlib%:extract_func "cache" "tests.lib.updater.simulate"
)
call %batchlib%:extract_func "cache" ^
    ^ ^"__init__ __main__ scripts.lib ^
    ^   !updater! ^
    ^   __metadata__ ^
    ^   scripts.main ^
    ^   tests.lib.updater.setup_metadata ^" ^
    ^ > "test_with_metadata"
for %%a in (
    "0: --upgrade --skip-verification"
    "0: --upgrade : version_lower"
    "1: --upgrade : download_url_undefined"
    "2: --upgrade : download_url_invalid"
    "4: --upgrade : name_different"
    "5: --upgrade : "
    "5: --upgrade : version_higer"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    copy /y test_with_metadata test_updater.bat > nul
    start "" /wait /b cmd /c ""test_updater.bat" "%%c" "%%d"" > nul 2> nul ^
    || ( call %unittest%.error "Cannot start test update" & exit /b 0 )
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


:tests.lib.updater.simulate   update_params  condition
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :tests.lib.updater.setup_metadata %2
(
    call :updater %~1 "%~f0"
    exit /b !errorlevel!
)
exit /b %errorlevel%


:tests.lib.updater.setup_metadata   parameters
set "metadata_variables=name version release_date download_url"
for %%v in (!metadata_variables!) do (
    set "given.%%v=!SOFTWARE.%%v!"
)
for %%a in (%~1) do (
    if "%%a" == "name_different" set "given.name=.test!random!!random!!random!"

    if "%%a" == "version_lower" set "given.version=.dev"
    if "%%a" == "version_higer" set "given.version=999"

    if "%%a" == "date_older" set "given.release_date=1/1/1970"
    if "%%a" == "date_newer" set "given.release_date=12/31/9999"

    if "%%a" == "download_url_undefined" set "given.download_url="
    if "%%a" == "download_url_invalid" set "given.download_url=256.256.256.256"
)
exit /b 0


:tests.lib.updater.make_metadata   [return_prefix]
for %%a in (!metadata_variables!) do set "%~1%%a=!given.%%a!"
exit /b 0


rem ======================== function ========================

:updater   script_path  [-f]  [-u]  [-d url]
setlocal EnableDelayedExpansion
for %%v in (_upgrade _download_url) do set "%%v="
set "_verify=true"
set parse_args.args= ^
    ^ "-V, --skip-verification  :store_const:_verify=" ^
    ^ "-u, --upgrade            :store_const:_upgrade=true" ^
    ^ "-d, --download-url       :store:_download_url"
call :parse_args %*
set "_part=%~f1"
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "_other=!cd!\latest.bat"
(
    call :module.is_module "!_part!" ^
    && call :module.read_metadata _part. "!_part!" ^
    && if not defined _download_url set "_download_url=!_part.download_url!" ^
    && if not defined _download_url ( exit /? > nul )
) || ( 1>&2 echo error: failed to get download url & exit /b 1 )
call %batchlib%:download_file "!_download_url!" "!_other!" || ( 1>&2 echo error: failed to get update & exit /b 2 )
if defined _verify (
    (
        call :module.is_module "!_other!" ^
        && call :module.read_metadata _other. "!_other!" ^
        && if not defined _other.version ( exit /? > nul )
    ) || ( 1>&2 echo error: failed to read update information & exit /b 3 )
    if /i not "!_other.name!" == "!_part.name!" ( 1>&2 echo error: module name does not match & exit /b 4 )
    call :parse_version _part.parsed_version "!_part.version!"
    call :parse_version _other.parsed_version "!_other.version!"
    if "!_other.parsed_version!" EQU "!_part.parsed_version!" ( echo You are using the latest version & exit /b 5 )
    if "!_other.parsed_version!" LSS "!_part.parsed_version!" ( echo No update is available & exit /b 5 )
    call %batchlib%:diffdate update_age !date:~4! !_other.release_date! 2> nul && (
        echo !_other.description! !_other.version! is now available ^(!update_age! days ago^)
    ) || echo !_other.description! !_other.version! is now available ^(since !_other.release_date!^)
)
if not defined _upgrade (
    del /f /q "!_other!"
    exit /b 0
)
move "!_other!" "!_part!" > nul || ( 1>&2 echo error: upgrade failed & exit /b 6 )
exit /b 0


rem ================================ resolve_dependency() ================================

rem ======================== documentation ========================

:extract_ns_func.__doc__
echo NAME
echo    extract_ns_func - extract function in a given namespace/context
echo=
echo SYNOPSIS
echo    extract_ns_func  "context:label [...]"
echo=
echo DESCRIPTION
echo    This function extracts labels from multiple module files. Function
echo    listing also follows order of occurrence in the parameter.
echo    Dependencies are ECHOed to stdout and it can be redirected to file.
echo=
echo POSITIONAL ARGUMENTS
echo    context
echo        The context name of the function. This can also be the name of a module.
echo=
echo    label
echo        The function name to resolve for dependency.
echo=
echo EXIT STATUS
echo    0:  - Extraction is successful.
echo    1:  - Label conflict detected
echo        - Namespace abspath not defined.
echo        - Some labels are not found.
exit /b 0


:extract_ns_func.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.extract_ns_func
call :Input.string function_name || set "function_name=batchlib:extract_ns_func"
echo=
echo Function: !function_name!
echo=
call :extract_ns_func "!function_name!"
exit /b 0


rem ======================== tests ========================

:tests.lib.extract_ns_func.main
set "batchlib.abspath=%~f0"
set "dummy.abspath=!cd!\dummy.bat"
for %%m in (batchlib dummy) do set %%m="!%%m.abspath!" --module=lib %=END=%

set test_args= ^
    ^ ^"1a4061706ebf2211b523ec21aa17dd50d42be8c2: ^
    ^   batchlib:join_mark ^
    ^   dummy:special_characters ^"
for %%a in (!test_args!) do ( rem
) & for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "_to_extract="
    set "_dummy_extract="
    for %%d in (%%c) do ( rem
    ) & for /f "tokens=1* delims=:" %%e in ("%%d") do (
        set "_to_extract=!_to_extract! %%e:tests.lib.extract_ns_func.%%f"
        if "%%e" == "dummy" set "_dummy_extract=!_dummy_extract! tests.lib.extract_ns_func.%%f"
    )
    call :extract_func "%~f0" "!_dummy_extract!" > "!dummy.abspath!"
    call :extract_ns_func "!_to_extract!" > extracted
    call :checksum result "extracted"
    if not "!result!" == "%%b" (
        call %unittest%.fail "extraction failed: %%b"
    )
)
exit /b 0


:tests.lib.extract_ns_func.special_characters   arg_1a|arg_1b  arg2 [arg3]
    @call & echo %% !a! %* > nul 2> nul
< nul ( call ) || exit /b 1
exit /b 0


:tests.lib.extract_ns_func.join_mark
exit /b 0
#+++

:tests.lib.extract_ns_func.join_mark.joined
exit /b 0


rem ======================== function ========================

:extract_ns_func  "context:label [...]"
setlocal EnableDelayedExpansion
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "_raw_extract_order=%~1"
set "_to_extract= "
set "_extract_order= "
for %%a in (!_raw_extract_order!) do for /f "tokens=1-2 delims=:" %%b in ("%%a") do (
    if "!_to_extract: %%b:'=!" == "!_to_extract!" (
        if not defined %%b.abspath (
            ( 1>&2 echo error: module '%%b' abspath not defined & exit /b 1 )
        )
        set "_to_extract=!_to_extract!%%b:' ' "
    )
    if not "!_to_extract: %%c =!" == "!_to_extract!" (
        ( 1>&2 echo error: label conflict detected: '%%c' & exit /b 1 )
    )
    set "_to_extract=!_to_extract: %%b:' = %%b:' %%c !"
    set "_extract_order=!_extract_order!%%c "
)
set _to_extract=!_to_extract:'="!
> "unsorted" (
    for %%a in (!_to_extract!) do ( rem
    ) & for /f "tokens=1* delims=:" %%b in ("%%a") do (
        call :extract_func "!%%b.abspath!"  %%c
    )
)
call :extract_func "unsorted" "!_extract_order!"
exit /b 0


rem ================================ resolve_dependency() ================================

rem ======================== documentation ========================

:resolve_dependency.__doc__
echo NAME
echo    resolve_dependency - resolve dependency for a function
echo=
echo SYNOPSIS
echo    resolve_dependency   return_var  base_context  "[context:]label [...]"
REM echo                         --include-root
echo=
echo DESCRIPTION
echo    This function recursively generates dependency list of a function.
echo    Function listing also follows order of occurrence in each install_requires.
echo    Due to nature of batch script, calling a functions that is located below
echo    the CALL is much faster than if it is located above the CALL. So functions
echo    as many as possible are defined after they are used. Functions are listed
echo    from the ones with most dependencies to the ones with no dependencies.
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    base_context
echo        The name of the context. This value is used as default context name for
echo        labels with no context specified in that module file.
echo=
echo    context
echo        The context name of the function. This can also be the name of a module.
echo        By default, it is set to base_context.
echo=
echo    label
echo        The function name to resolve for dependency.
echo=
REM echo OPTIONS
REM echo    --include-root (!)
REM echo        Include the functions in the aguments in the list of dependencies.
REM echo        This must be placed as the fourth argument.
REM echo=
echo EXIT STATUS
echo    0:  - Success.
echo    1:  - Cyclic dependencies detected.
echo        - Namespace error / not defined.
echo        - Failed to resolve dependency of a (sub)module.
exit /b 0


:resolve_dependency.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.resolve_dependency
call :Input.string function_name || set "function_name=unittest"
echo=
echo Function: !function_name!
echo=
call :resolve_dependency result  batchlib !function_name!
echo Dependencies: !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.resolve_dependency.main
set "batchlib.abspath=%~f0"
set "dummy.abspath=!cd!\dummy.bat"
for %%m in (batchlib dummy) do set %%m="!%%m.abspath!" --module=lib %=END=%

call :extract_func "%~f0" ^
    ^ ^"__init__ ^
    ^   scripts.lib ^
    ^   module.entry_point ^" ^
    ^ > "base"

for %%a in (
    external
) do (
    call :tests.lib.resolve_dependency.%%a
    > "!dummy.abspath!" (
        type "base"
        call :extract_func "%~f0" "tests.lib.resolve_dependency.%%a !to_extract!"
    )
    set "temp=!expected!"
    set "expected= "
    for %%a in (!temp!) do set "expected=!expected!%%a "
    call :resolve_dependency result dummy tests.lib.resolve_dependency.%%a
    if not "!result!" == "!expected!" (
        call %unittest%.fail "%%a dependency check failed"
    )
)
exit /b 0


:tests.lib.resolve_dependency.external
set "to_extract="
set expected= ^
    ^ dummy:tests.lib.resolve_dependency.external ^
    ^ b:time2epoch b:diffdate ^
    ^ b:module b:module.entry_point ^
    ^ b:unittest b:find_label b:difftime b:ftime ^
    ^ b:updater b:parse_args b:download_file b:parse_version ^
    ^ b:module.is_module b:module.read_metadata
set "expected=!expected: b:= batchlib:!"
exit /b 0
#+++

:tests.lib.resolve_dependency.external.__metadata__
set %~1install_requires= ^
    ^ batchlib:difftime ^
    ^ batchlib:^" ^
    ^   time2epoch ^
    ^   module ^
    ^   unittest ^
    ^   updater ^"
exit /b 0


rem ======================== function ========================

:resolve_dependency   return_var  base_context  "[context:]label [...]"
setlocal EnableDelayedExpansion
set "_base_module=%~2"
set "_visited= "
set "_stack= "
set "install_requires=%~3"
call :resolve_dependency._resolve !_params! || set "_visited="
for /f "tokens=1*" %%a in ("Q !_visited!") do (
    endlocal
    set "%~1=%%b"
    if defined %~1 (
        set "%~1= !%~1!"
    ) else exit /b 1
)
exit /b 0
#+++

:resolve_dependency._resolve
set "_normalized="
for %%a in (!install_requires!) do ( rem
) & for /f "tokens=1* delims=:" %%b in ("%%a") do ( rem
) & for /f "tokens=1-2 delims=:" %%b in ("%%c:%%b:!_module!:!_base_module!") do (
    for %%d in (%%~b) do (
        set "_normalized=%%c:%%d !_normalized!"
    )
)
for %%a in (!_normalized!) do ( rem
) & for /f "tokens=1* delims=:" %%b in ("%%a") do (
    if not "!_stack: %%b:%%c =!" == "!_stack!" (
        ( 1>&2 echo error: cyclic dependencies detected: '%%b:%%c' & exit /b 1 )
    )
    set "_stack= %%b:%%c!_stack!"
    set "_module=%%b"
    set "_context=!%%b!"
    set "_label=%%c"
    if not defined _context ( 1>&2 echo error: context for module '%%b' is not defined & exit /b 1 )
    call :resolve_dependency._read_metadata
    if defined install_requires call :resolve_dependency._resolve
    if "!_visited: %%a =!" == "!_visited!" set "_visited= %%a!_visited!"
    for /f "tokens=1* delims= " %%a in ("!_stack!") do set "_stack= %%b"
)
exit /b 0
#+++

:resolve_dependency._read_metadata
set "install_requires="
call %_context%:%_label%.__metadata__ || (
    ( 1>&2 echo error: cannot resolve dependency for '!_module!:!_label!' & exit /b 1 )
)
exit /b 0


rem ================================ dynamenu(!) ================================

rem ======================== documentation ========================

:dynamenu.__doc__
echo Dynamic Menu Creator
echo=
echo FUNCTIONS
echo    - dynamenu.read()
echo    - dynamenu()
echo=
echo Documentation not available yet.
exit /b 0


:dynamenu.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo =======================

:demo.dynamenu
echo Reading menu entries...
call :dynamenu.read
echo Done
echo=
set "used_time=!time!"
set /a "odd=!used_time:~7,1! %% 2"
echo Time: !used_time!
echo=
call :dynamenu options list
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


rem ======================== function ========================

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
#+++

:dynamenu.read
for /f "usebackq tokens=1,2 delims= " %%a in ("%~f0") do (
    if "%%~xa" == ".dynamenu" if not "%%~b" == "" set "dynamenu_%%b=!dynamenu_%%b! %%~na"
)
exit /b 0


rem ================================ bcom(WIP) ================================

rem ======================== documentation ========================

:bcom.__doc__
echo Batch script interprocess communication (IPC). (WIP)
echo=
echo Still under development.
echo=
echo Documentation not available yet.
exit /b 0


rem ======================== function ========================

:bcom.init
for %%v in (_unique) do set "%%v="
set parse_args.args= ^
    ^ "-u, --unique     :store_const:_unique=true"
call :parse_args %*
set "bcom.name=!SOFTWARE.name!.!__name__!"
set "bcom.id=!bcom.name!.!random!"
exit /b 0
#+++

:bcom.send   id
set "_bcom_send_date=!date!"
set "_bcom_send_time=!time!"
> "!temp_path!\!bcom.name!" (
    echo=
    echo call :^^^!bcom_sender^^^! ^& exit /b 0
    echo :!bcom.id!
    echo=!bcom_msg!
    echo=
    echo set "_bcom_send_date=!_bcom_send_date!"
    echo set "_bcom_send_time=!_bcom_send_time!"
    echo exit /b 0
)
exit /b 0
#+++

rem Jump to last msg concept?
::sender_id
(
    goto 2> nul
    call :sender_id 2> nul
    echo Do stuffs here...
    ( call )
)
exit /b 0
#+++

:bcom.receive   id
for /f "usebackq tokens=1 delims==" %%v in (`set bcom.packet. 2^> nul`) do set "%%v="
set "bcom.file=!temp_path!\bcom.bat"
for %%f in ("!bcom.file!") do (
    if not exist "%%~f" exit /b 2
    call "!bcom.file!" || exit /b 1
)
exit /b 0
#+++

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
#+++

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

:assets
:assets.__init__
rem Additional data to bundle
exit /b 0


rem ======================================== End of Script ========================================

:EOF
rem May be needed if command extenstions are disabled
rem Anything beyond this are not part of the code
exit /b %errorlevel%


rem ======================================== Other Function ========================================
:notes.other_functions     Actually working functions but not listed

rem ================================ make_dummy() ================================

:make_dummy   filename  kilobytes
set /a "_result=%~2 + 0"
if "!_result!" == "0" (
    call 2> "%~1"
    exit /b 0
)
set "_child_name=_dummy!random!"
call 2> "!_child_name!"
echo=|set /p "=." > "%~1"
for /l %%n in (1,1,10) do type "%~1" >> "%~1"
for /l %%n in (0,1,31) do if not "!_result!" == "0" (
    set /a "_remainder=!_result! %% 2"
    set /a "_result/=2"
    if "!_result!" == "0" (
        copy /b "%~1" + "!_child_name!" "%~1" > nul
    ) else (
        if "!_remainder!" == "1" type "%~1" >> "!_child_name!"
        type "%~1" >> "%~1"
    )
)
del /f /q "!_child_name!"
exit /b 0


rem ================================ list_ip() ================================

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
exit /b 0


rem ================================ others (wip) ================================
rem Note: some functions below are not ready to use yet

rem Make: Copy / Move / Sync


:move   source  destination_folder
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
exit /b 0


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
set msg= !LF!^
    ^ Hello !LF!^
    ^ Batch !LF!^
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

rem Backup data?
ROBOCOPY "C:\folder" "C:\new_folder" /mir

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

rem Lock Folder
CACLS "YOURPATH" /E /P everyone:N

rem Unlock Folder
CACLS "YOURPATH" /E /P everyone:F

rem Do not lock C:\ OR Operating System drive using this trick
rem otherwise Windows will not boot next time

rem ======================================== Notes (File I/O) ========================================

rem Get available drives
set "available_drives="
for %%l in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do vol %%l: > nul 2> nul && (
    set "available_drives=!available_drives! %%l"
)

rem Read third line of file
< "%~f0" (
    for /l %%n in (1,1,3) do set /p "a="
)

rem Create 0-byte file
call 2> "File.txt"

rem File Lock/Unlocked State

rem Create State
echo File is in locked state
>> "!file_path!" (
    pause > nul
)
echo File is in unlocked state

rem Detect State
2> nul (
  call >> "!file_path!"
) && (
    echo File is in unlocked state
)

rem ======================================== Unsorted Notes ========================================

rem ======================== notes ========================

rem https://medium.com/@sdboyer/so-you-want-to-write-a-package-manager-4ae9c17d9527

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

::metadata
rem https://setuptools.readthedocs.io/en/latest/setuptools.html
rem https://pypi.org/classifiers/
set "name="
set "version="
set "packages=scripts ui tests utils shortcut lib framework assets"
set "scripts="
set install_requires= ^
    ^ "parse_args GEQ 1"
set "package_data={}"

set "author="
set "author_email="
set "description="
set "keywords="
set "url=" homepage of project / url to GithHub page
set "project_urls={}"
set "classifiers="

set "tests_require="
set "extras_require="

set "dependency_links="
set "include_package_data=true"
set "exclude_package_data={}"
rem python -m

rem ENV VARS
rem https://docs.python.org/3.3/using/cmdline.html
set "PYTHONHOME=location of standard libraries"
set "PYTHONPATH=installation path"
set "PYTHONDEBUG=-d"
exit /b 0
