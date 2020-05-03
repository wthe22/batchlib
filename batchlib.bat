:__init__ > nul 2> nul
@for %%n in (1 2) do @call :module.entry_point.alt%%n %1
@exit /b 1


rem ======================================== Metadata ========================================

:__metadata__   [return_prefix]
set "%~1name=batchlib"
set "%~1version=2.1-a.31"
set "%~1author=wthe22"
set "%~1license=The MIT License"
set "%~1description=Batch Script Library"
set "%~1release_date=05/03/2020"   :: mm/dd/YYYY
set "%~1url=https://winscr.blogspot.com/2017/08/function-library.html"
set "%~1download_url=https://raw.githubusercontent.com/wthe22/batch-scripts/master/batchlib.bat"
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
echo Copyright (C) 2020 by !author!
echo Licensed under !license!
endlocal
exit /b 0


rem ======================================== License ========================================

:license
echo MIT License
echo=
echo Copyright 2020 wthe22
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
set "temp_path=data\tmp\!SOFTWARE.name!\!__name__!"

rem Macros to call external module
set "self_context=batchlib feature"
call :module.make_context batchlib "%~f0"
call :module.make_context feature "%~f0"

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


:config.cli
rem Specific config for 'scirpt.min'

rem Macros to call external module
call :module.make_context batchlib "%~f0" "lib"
exit /b 0


:config.preferences
rem Define your preferences or config modifications here

rem Macros to call external module (use absolute paths)
rem set batchlib="%~dp0batchlib-min.bat" -c %=END=%
exit /b 0


rem ======================================== Changelog ========================================

:changelog
echo    Core
echo    - Added __init__() label as the UTF-8-BOM guard so it can be
echo      extracted using extract_func()
echo    - Added method to specify different config for each entry point
echo    - Added documentation_menu() for more documentation options
echo    - Added unittest for script core functions
echo    - Added 'core' package for core functions / the "back-end"
echo    - Added labels for packages
echo    - Added a new category 'Packaging'
echo    - Added template for new scripts
echo    - Renamed 'shortcuts.*' to 'shortcut.*'
echo    - Renamed 'test.*' to 'tests.*'
echo    - Renamed the category 'Shortcut' to 'User Interface'
echo    - Renamed the category 'Framework' to 'Development Tools'
echo    - Renamed the category 'Formatting' to 'Console'
echo    - Renamed  metadata() to __metadata__()
echo    - Moved 'tests' below 'lib'
echo    - Changed __main__() exit to 'exit /b' to prevent console from terminating
echo    - scripts.main():
echo        - Prompt message are now preserved after running this script
echo        - Now it only remove its own temp_path, instead of removing
echo          temp_path of all modules.
echo    - Replaced 'goto :EOF' with 'exit /b 0'
echo    - Function.read() no longer reads category definition
echo    - Category definition and its functions are now written in Category.init()
echo    - Improved format of internal category listing
echo    - Fixed batch script creating ']' file on startup if EOL is Linux
echo    - script_cli(): added support for multi line commands
echo    - Improved category listing of functions
echo    - Reshuffled function codes according to category grouping
echo    - Changed location of temp_path to use path relative to current directory
echo    - Changed download_url to the new repo at GitHub
echo    - Added "MIT License" in license()
echo    - Added menu option to get dependencies for a script
echo=
echo    Library
echo    - Added bytes2size(), size2bytes(), extract_func(), ping_test(), is_echo_on(),
echo      fdate(), epoch2time(), desolve(), collect_func(), strip(), textrender()
echo      sleep(), timeit(), normalize_spaces(), while_range_macro(), list2set(),
echo      sprintrow()
echo    - Added unittest() framework, this replaces the tester() framework.
echo    - Added is_number(), is_in_range(), this replaces check_number().
echo    - Added updater(), this replaces module.updater().
echo    - Added find_label(), this replaces tester.find_tests().
echo    - Added parse_version(), this replaces module.version_compare().
echo    - Added dependency listing
echo    - Added VBScript and PowerShell to dependency list of functions
echo      which needs them
echo    - Added support for comma and space time seperators in difftime(),
echo      timeleft(), wait.calibrate()
echo    - Added capture of LF in: timeit.setup_macro(), combi_wcdir(), wcdir()
echo      and removed capchar() from dependencies.
echo    - Fixed demo of several functions that uses Input.number()
echo    - Merged 'shortcut' and 'framework' into 'lib'
echo    - Removed expand_path(). Using FOR directly is more preferable.
echo    - Removed dynamenu(), it is slow and some kind of impractical
echo    - capchar():
echo        - Added capturing of TAB and BEL character
echo        - Improved demo and capture speed
echo        - Fixed incorrect backspace character description at documentation
echo        - Renamed DEL to BACK to avoid confusion with the actual DEL character
echo        - Renamed _ to BASE to avoid usage conflict with temporary variables
echo        - Parameters are now read from %%~1 instead of %%*
echo        - Now parameters needs to be surrounded by quotes
echo    - check_ipv4(): Added ability to check wildcard IP
echo    - check_ipv4(): Fixed error not checking octet count if it is less than 4
echo    - check_path():
echo        - Fixed incorrect parameter description
echo        - Improved checking and consistency of path
echo    - check_admin(): Renamed to is_admin()
echo    - check_win_eol():
echo        - Fixed syntax error in code
echo        - Renamed to is_crlf()
echo    - checksum():
echo        - Changed parameters for defining hash
echo        - Fixed error when hashing 0-byte files
echo        - Added hash algorithm SHA384
echo    - diffbin(): Fixed error if temp_path is not defined.
echo    - diffdate(): Simplified calculations
echo    - difftime():
echo        - Renamed parameter '-n' to '--no-fix'
echo        - If milliseconds (or higher precision) are provided, it will be
echo          truncated to centiseconds.
echo    - expand_link():
echo        - Made return variables more readable
echo        - Renamed to expand_url()
echo    - fix_eol():
echo        - Improved control over display message
echo        - Renamed to to_crlf()
echo    - ftime(): Removed unexpected warp when time is 24 hour or more
echo    - get_os(): Renamed parameter '-n' to '--name'
echo    - get_pid(): Added required positional argument 'unique_id'. Previously,
echo    - get_ext_ip():
echo        - Remove usage of temporary file
echo        - Added fallback URLs
echo      this ID is automatically generated in the function using PowerShell.
echo    - Input.*():
echo        - Renamed parameters '-d, --description' to '-m, --message'
echo        - Improved exit status
echo        - Now function automatically quits after 100 fail inputs
echo        - Improved variable content preservation
echo        - Improved user interface
echo    - Input.ipv4(): Fixed function not returning value after a successful input
echo    - Input.path():
echo        - Fixed parameter conflict
echo        - Removed method to re-enter previous input
echo        - Added option to specify base directory before input
echo    - Input.yesno(): Accepts anything that starts with 'Y' as yes, and
echo      anything that starts with 'N' as no
echo    - module.entry_point(): Reworked and adapted the rest to the changes
echo      if first parameter is quoted and contains special characters
echo    - module.is_module(): Adjusted with changes in module.entry_point()
echo    - module.read_metadata():
echo        - No longer checks if file is a module
echo        - Addedd 'install_requires' in metadata
echo    - parse_args():
echo        - Added 'append_const' data type
echo        - Arguments is now case sensitive
echo        - Renamed type 'flag' to 'store_const'
echo        - Renamed type 'var' to 'store'
echo        - Improved parsing speed for each loop (~3x faster or more)
echo    - pow(): Added error message if integer is too large
echo    - randw():
echo        - Weights are now read from %%~1 instead of %%*
echo        - Now weights needs to be surrounded by quotes
echo    - setup_clearline():
echo        - Piped 'mode con' to prevent input stream from
echo        - Added default return_var value
echo        - Renamed to clear_line_macro()
echo      being discarded
echo    - unzip(): Added 'temp_path' as temporary script directory with 'temp'
echo      as fallback directory
echo    - wait():
echo        - Now the function needs to be setup using wait.setup_macro()
echo        - Macro version is now available
echo    - wait.calibrate(): Prevented function from causing infinite loop if
echo    - wait.setup(): Renamed to wait.setup_macro()
echo      the initial calibration value is too fast
echo    - watchvar():
echo        - Renamed parameter '-l, --list' to '-n, --name'
echo        - Added 'temp_path' fallback value to 'temp'
echo    - what_day(): Renamed parameter '-n' to '--number', '-s' to '--short'
echo=
echo    Minified Script
echo    - Included 'tests.*', changelog(), help()
echo    - Added an interactive ui: script_cli()
echo    - Script now uses scripts.cli() as its main entry point
echo    - The help message in main() has been moved to help(). This is significantly
echo      makes help message easier to maintain.
echo    - Removed unittest for save_minified(), instead the minified script
echo      have a copy of the tests and it is able to run unittest too.
echo    - Added template for minified script
echo    - Added dependency listing
echo=
echo    Tests
echo    - Migrated unit testing framework/syntax from tester() to unittest()
echo    - Added unittest for: Input.ipv4(), pow(), prime(), gcf(), bin2int(),
echo      check_ipv4(), wait(), difftime(), expand_link(), extract_func(),
echo      check_path(), wcdir(), int2roman(), roman2int(), capchar(), Input.yesno()
echo    - New functions with unittest: bytes2size(), size2bytes(), unittest(),
echo      updater(), find_label(), parse_version(), fdate(), epoch2time(),
echo      desolve(), collect_func(), strip(), textrender(), sleep()
echo    - Improved unittest for: Input.*(), module.entry_point()
echo    - Removed hex conversion test from watchvar()
echo    - Added unittest for capturing of function arguments
echo=
echo    Documentation
echo    - Split '*.__demo__' into '*.__doc__' and 'demo.*'. Now users can see
echo      documentation without running the demo.
echo    - Removed usage of macro in 'demo.*'
echo    - *.__doc__() now uses man page style of documentation
echo    - Improved demo of several functions
echo    - Added help() to display usage help
echo    - Added (missing) parameter description of several functions
echo    - batchlib-min now accepts '-h, --help'
echo    - Changed example of lib usage to use absolute paths
echo    - Changed incorrect time format in documentation
echo    - Improved parameter description of several functions
echo    - Removed changelog history for reduced log size. Only latest changelog
echo      will be included. See Git for earlier changelog history.
echo    - Updated guides on the library section
echo    - Moved notes and other unused codes to a dedicated file for notes
exit /b 0


:changelog.dev
echo    - Added menu option to get dependencies for a script
echo    - module.entry_point(): Made function backward incompatible again
echo      with version 2.1-a.24 or earlier, but legacy support codes still
echo      remains available in case someone needs it
echo    - Moved templates to assets section
echo    - Moved notes and other unused codes to a dedicated file for notes
exit /b 0


:changelog.todo
exit /b 0


rem ======================================== Main ========================================

:__main__
@call :scripts.main %*
@exit /b


rem ======================================== Entry points ========================================

:scripts
:scripts.__init__
rem Entry points of the script
@exit /b 0


rem ================================ Main script ================================

:scripts.main
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
set "__name__=main"
prompt $$$s
call :__metadata__ SOFTWARE.
title !SOFTWARE.description! !SOFTWARE.version!
cls
echo Loading script...

for %%n in (1 2) do call :to_crlf.alt%%n && (
    echo Convert EOL done
    endlocal
    goto scripts.main
)

call :config

for %%v in (no_cleanup) do set "%%v="
set parse_args.args= ^
    ^ "-n, --no-cleanup :store_const:no_cleanup=true"
call :parse_args %*

for %%p in (
    temp_path
) do if not exist "!%%p!" md "!%%p!"

for %%c in (!self_context!) do call :module.make_context %%c
call :Category.init
call :Function.read
set "last_used.function="
call :capchar *
call :get_con_size console_width console_height
call :main_menu
if not defined no_cleanup rd /s /q "!temp_path!" > nul 2> nul
@exit /b


rem ================================ minified script ================================

:scripts.cli
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
set "__name__=cli"
prompt $$$s
call :__metadata__ SOFTWARE.

for %%n in (1 2) do call :to_crlf.alt%%n
call :config

set "action=script_cli"
set parse_args.args= ^
    ^ "-h, --help   :store_const:action=help"
call :parse_args %*

for %%p in (
    temp_path
) do if not exist "!%%p!" md "!%%p!"

for %%c in (!self_context!) do call :module.make_context %%c

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
title !SOFTWARE.description! !SOFTWARE.version!
cls
echo 1. Browse documentation
echo 2. Use command line
echo 3. Generate minified version
echo 4. Generate new script template
echo 5. Get dependencies of a script
echo=
echo A. About script
echo C. Change Log
echo T. Test script
echo 0. Exit
echo=
echo What do you want to do?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" (
    call :select_function
    if not defined selected.function goto main_menu
    call :documentation_menu "!selected.function!"
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
    echo=
    echo Save path:
    echo !minified_script!
    echo=
    echo Generating...
    set "start_time=!time!"
    call :save_minified --include-tests > "!minified_script!"
    call :difftime time_taken "!time!" "!start_time!"
    call :ftime time_taken !time_taken!
    echo=
    echo Done in !time_taken!
    pause
    goto main_menu
)
if "!user_input!" == "4" (
    call :Input.path save_file --file ^
        ^ --message "Input new template file path: "
    if exist "!save_file!" (
        call :Input.yesno _ ^
            ^ --message "File already exist. Overwrite file? Y/N? "
    ) || goto main_menu
    echo=
    echo New script template path:
    echo !save_file!
    echo=
    echo Generating...
    set "start_time=!time!"
    call :make_template > "!save_file!"
    call :difftime time_taken "!time!" "!start_time!"
    call :ftime time_taken !time_taken!
    echo=
    echo Done in !time_taken!
    pause
    goto main_menu
)
if "!user_input!" == "5" (
    call :Input.path target_script --exist --file ^
        ^ --message "Input target script: "
    call :Input.path save_file --file ^
        ^ --message "Input a new or existing file to save dependencies to: "
    echo=
    echo Target script:
    echo !target_script!
    echo=
    echo Add dependencies to:
    echo !save_file!
    echo=
    echo Extracting...
    set "start_time=!time!"
    call :getlib "!target_script!" >> "!save_file!"
    call :difftime time_taken "!time!" "!start_time!"
    call :ftime time_taken !time_taken!
    echo=
    echo Done in !time_taken!
    pause
    goto main_menu
)
if /i "!user_input!" == "A" (
    cls
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
    (
        cmd /q /c ^""%~f0" -c call :unittest --verbose ^"
    ) || if not "!errorlevel!" == "2" (
        echo=
        echo An unexpected error occured while running unittest
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
    (
        cmd /q /c ^""%~f0" -c call :unittest ^
            ^ --pattern "tests.debug.*.main" --failfast --verbose ^"
    ) || if not "!errorlevel!" == "2" (
        echo=
        echo An unexpected error occured while running unittest
    )
    echo=
    pause
    goto main_menu
)
goto main_menu


rem ================================ Documentation Menu ================================

:documentation_menu   function_name
set "user_input="
for %%f in (%~1) do (
    cls
    echo !Function_%%f.args!
    echo=
    echo 1. View documentation
    echo 2. Demo function
    if defined Function_%%f.has_unittest (
        echo 3. Run unittest
    )
    echo=
    echo 0. Back
    echo=
    echo What do you want to do?
    set /p "user_input="
    echo=
    if "!user_input!" == "0" exit /b 0
    if "!user_input!" == "1" (
        cls
        call :%%f.__doc__
        echo=
        pause
        goto documentation_menu
    )
    if "!user_input!" == "2" (
        call :start_demo %%f
        goto documentation_menu
    )
    if defined Function_%%f.has_unittest ( rem
    ) & if "!user_input!" == "3" (
        (
            cmd /q /c ^""%~f0" -c call :unittest ^
                ^ --label "tests.lib.%%f.main" --verbose ^"
        ) || if not "!errorlevel!" == "2" (
            echo=
            echo An unexpected error occured while running unittest
        )
        echo=
        pause
        goto documentation_menu
    )
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

:start_demo   function_name
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
@for /f "usebackq delims=" %%h in (`hostname`) do @(
    call :script_cli._loop "!username!@%%h"
)
@exit /b
#+++

:script_cli._loop   user
@set "user_input="
@set /p "user_input=%~1:$ "
@if "!user_input:~-1,1!" == "^" @call :script_cli._loop._more
%user_input%
@goto script_cli._loop
#+++

:script_cli._loop._more
@set "more="
@set /p "_more=More? "
@set "user_input=!user_input!!_more!"
@if not "!_more:~-1,1!" == "^" @exit /b 0
@goto script_cli._loop._more


rem ================================ Help text ================================

:help
setlocal EnableDelayedExpansion EnableExtensions
call :__metadata__ SOFTWARE.
call :Category.init
call :Function.read

echo !SOFTWARE.description! !SOFTWARE.version!
echo=
echo Usage: batchlib
echo        batchlib -c ^<command^>
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
echo    call batchlib-min.bat -c call :Input.number age ^^
echo        ^^ --message "Input your age: " --range 0~200
echo=
echo Set macro and call as external package:
echo     set batchlib="C:\absolute\path\to\batchlib-min.bat" -c call %%=END=%%
echo     call %%batchlib%%:Input.number age --message "Input your age: " --range 0~200
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


:getlib   script_path
setlocal EnableDelayedExpansion
call :module.make_context script %1 "call "
call :desolve dependencies script lib || exit /b 1
call :collect_func "!dependencies!"
exit /b 0


rem ======================================== Core Functions ========================================

:core
:core.__init__
rem Core Functions
exit /b 0


:Category.init
set Category.list= ^
    ^ shortcut ^
    ^ number string time file net ^
    ^ env ^
    ^ console packaging framework ^
    ^ %=feature=%

set "Category_shortcut.name=User Interface"
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
    ^ strip_dquotes strip ^
    ^ normalize_spaces list2set ^
    ^ sprintrow ^
    ^ shuffle
set "Category_time.name=Date and Time"
set Category_time.functions= ^
    ^ difftime ftime ^
    ^ diffdate fdate what_day ^
    ^ time2epoch epoch2time ^
    ^ timeit timeleft ^
    ^ wait sleep
set "Category_file.name=File and Folder"
set Category_file.functions= ^
    ^ check_path combi_wcdir wcdir ^
    ^ bytes2size size2bytes ^
    ^ hexlify unzip ^
    ^ checksum diffbin
set "Category_net.name=Network"
set Category_net.functions= ^
    ^ check_ipv4 expand_url ^
    ^ get_ext_ip ping_test ^
    ^ download_file
set "Category_env.name=Environment"
set Category_env.functions= ^
    ^ get_con_size get_sid get_os get_pid ^
    ^ watchvar is_admin
set "Category_console.name=Console"
set Category_console.functions= ^
    ^ capchar clear_line_macro is_echo_on ^
    ^ color2seq color_print
set "Category_packaging.name=Packaging"
set Category_packaging.functions= ^
    ^ module module.entry_point module.make_context module.read_metadata module.is_module ^
    ^ find_label extract_func desolve collect_func textrender ^
    ^ parse_version updater ^
    ^ to_crlf is_crlf
set "Category_framework.name=Development Tools"
set Category_framework.functions= ^
    ^ unittest ^
    ^ parse_args while_range_macro ^
    ^ endlocal
set "Category_feature.name=Feature"
set Category_feature.functions= ^
    ^ VBScript PowerShell
set "Category_others.name=Others"
set Category_others.functions= ^
    ^ %=None=%
exit /b 0


:Function.read
set "Category_all.name=All"
set "Category_all.functions="
for %%c in (!Category.list!) do (
    set "Category_all.functions=!Category_all.functions! !Category_%%c.functions!"
)
set "to_normalize=Category.list"
for %%c in (all !Category.list! others) do (
    set "to_normalize=!to_normalize! Category_%%c.functions"
    set "Category_%%c.item_count=0"
    for %%f in (!Category_%%c.functions!) do (
        set /a "Category_%%c.item_count+=1"
    )
)
call :normalize_spaces "!to_normalize!"
for %%f in (!Category_all.functions!) do (
    set "Function_%%f.args=%%f   ***NOT_FOUND***"
    set "Function_%%f.has_unittest="
)
for /f "usebackq tokens=*" %%a in ("%~f0") do (
    for /f "tokens=1" %%b in ("%%a") do ( rem
    ) & for /f "tokens=1-2 delims=:" %%c in ("%%b") do ( rem
    ) & if /i ":%%c" == "%%b" if /i "%%d" == "" (
        if not "!Category_all.functions: %%c = !" == "!Category_all.functions!" (
            set "_temp=%%a"
            set "Function_%%c.args=!_temp:~1!"
        ) else (
            set "_temp=%%c"
            if "!_temp:~0,10!*!_temp:~-5!" == "tests.lib.*.main" (
                set "_temp=!_temp:~10,-5!"
                for %%f in (!_temp!) do (
                    if not "!Category_all.functions: %%f = !" == "!Category_all.functions!" (
                        set "Function_%%f.has_unittest=true"
                    )
                )
            )
        )
    )
)
if not "!Category_others.item_count!" == "0" set "Category.list=!Category.list! others"
exit /b 0


:save_minified
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_include_tests) do set "%%v="
set parse_args.args= ^
    ^ "-t, --include-tests      :store_const:_include_tests=true"
call :parse_args %*
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
call :Function.read
set "test_functions="
if defined _include_tests (
    for %%c in (core lib debug assets) do (
        call :find_label result -p "tests.%%c.*"
        set "test_functions=!test_functions!!result!"
    )
)
set "lib_functions="
for %%f in (
    !Category_all.functions!
    !Category_feature.functions!
) do (
    set "lib_functions=!lib_functions! %%f %%f.__metadata__"
)
call :extract_func "%~f0" "assets.templates.minified" 1 -3 > "minified_template"
call :textrender "minified_template"|| (
    ( 1>&2 echo error: minify failed & exit /b 1 )
)
exit /b 0


:make_template
setlocal EnableDelayedExpansion EnableExtensions
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
call :extract_func "%~f0" "assets.templates.base" 1 -3 > "template"
call :textrender "template"|| (
    ( 1>&2 echo error: rendering failed & exit /b 1 )
)
exit /b 0
#+++


rem ======================================== Library ========================================

:lib
:lib.__init__
rem Functions/snippets from libraries
exit /b 0


:lib.__metadata__
set "%~1install_requires="
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

rem ========================================================================

rem ================================ Input.number() ================================

rem ======================== documentation ========================

:Input.number.__doc__
echo NAME
echo    Input.number - reads an expression from standard input
echo=
echo SYNOPSIS
echo    Input.number   return_var  [-m message]  [--range range]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result. Number could be evaluated from the
echo        expression by doing 'SET /a' on the variable.
echo=
echo OPTIONS
echo    -r RANGE, --range RANGE
echo        Specify the valid values. Use '~' to specify a range. The syntax of
echo        RANGE is "<number|min~max> [...]", each number/range is seperated by a
echo        whitespace. Hexadecimal and octal are also supported. If this option is
echo        not specified, it defaults to "-2147483647~2147483647".
echo=
echo    -m MESSAGE, --message MESSAGE
echo        Use MESSAGE as the prompt message.
echo        By default, the message is generated automatically.
echo=
echo EXIT STATUS
echo    0:  - Input is successful.
echo    3:  - Input attempt reaches the 100 attempt limit.
exit /b 0


:Input.number.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ is_number ^
    ^ is_in_range
exit /b 0


rem ======================== demo ========================

:demo.Input.number
call :Input.number your_integer --range "-0xf0~-0xff, -99~9, 0x100~0x200,0x16 555"
echo Your input: !your_integer!
exit /b 0


rem ======================== tests ========================

:tests.lib.Input.number.main
> "boundaries" (
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
    "100:   0~200   :boundaries"
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
for %%v in (_msg_is_set _message _range) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message        :store_const:_msg_is_set=true" ^
    ^ "-m, --message        :store:_message" ^
    ^ "-r, --range          :store:_range"
call :parse_args %*
if not defined _msg_is_set (
    if defined _range (
        set "_message=Input %~1 [!_range!]: "
    ) else set "_message=Input %~1: "
)
call :Input.number._loop || exit /b 3
for /f "delims= eol=" %%r in ("!user_input!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0
#+++

:Input.number._loop
for /l %%_ in (1,1,10) do for /l %%_ in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!" & ( rem
    ) && call :is_number "!user_input!" && ( rem
    ) && call :is_in_range "!user_input!" "!_range!" && ( rem
    ) && exit /b 0
)
exit /b 1


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
echo    2:  - Input is an empty string.
echo    3:  - Input attempt reaches the 100 attempt limit.
exit /b 0


:Input.string.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.Input.string
call :Input.string your_text --message "Enter anything: "
echo Your input: "!your_text!"
call :Input.string your_text --filled --message "Enter something: "
echo Your input: "!your_text!"
exit /b 0


rem ======================== tests ========================

:tests.lib.Input.string.main
set "text_empty="
set "text_hello=hello"
set "text_semicolon=; semicolon"
set "text_fail=fail"
for %%a in (
    "hello: hello fail"
    "semicolon: semicolon fail"
    "empty: empty fail"
    "hello: empty hello fail: --filled"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :Input.string result %%d < "input" > nul
    if not "!result!" == "!text_%%b!" (
        call %unittest%.fail %%a
    )
)
for %%a in (
    "0: hello fail"
    "0: semicolon fail"
    "2: empty fail"
    "0: empty hello fail: --filled"
    "3: empty: --filled"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :Input.string result %%d < "input" > nul
    if not "!errorlevel!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:Input.string   return_var  [-m message]  [-f]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_msg_is_set _message _require_filled) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message    :store_const:_msg_is_set=true" ^
    ^ "-m, --message    :store:_message" ^
    ^ "-f, --filled     :store_const:_require_filled=true"
call :parse_args %*
if not defined _msg_is_set set "_message=Input %~1: "
call :Input.string._loop || exit /b 3
set "user_input=^!!user_input!"
set "user_input=!user_input:^=^^^^!"
set "user_input=%user_input:!=^^^!%"
for /f "delims= eol=" %%a in ("!user_input!") do (
    endlocal
    set "%~1=%%a"
    set "%~1=!%~1:~1!"
    if not defined %~1 exit /b 2
)
exit /b 0
#+++

:Input.string._loop
for /l %%_ in (1,1,10) do for /l %%_ in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        exit /b 0
    ) else if not defined _require_filled exit /b 0
)
exit /b 1


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
echo    2:  - User enters any string that starts with 'N'.
echo    3:  - Input attempt reaches the 100 attempt limit.
exit /b 0


:Input.yesno.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.Input.yesno
call :Input.yesno your_ans --message "Do you like programming? Y/N? " && (
    echo Its a yes^^!
) || echo Its a no...
echo Your input: !your_ans!

call :Input.yesno your_ans --message "Is it true? Y/N? " --yes "true" --no "false"
echo Your input ("true", "false"): !your_ans!

call :Input.yesno your_ans --message "Do you like to eat? Y/N? " --yes="Yes" --no="No"
echo Your input ("Yes", "No"): !your_ans!

call :Input.yesno your_ans --message "Do you excercise? Y/N? " -y "1" -n "0"
echo Your input ("1", "0"): !your_ans!

call :Input.yesno your_ans --message "Is this defined? Y/N? " -y="Yes" -n=""
echo Your input ("Yes", ""): !your_ans!
exit /b 0


rem ======================== tests ========================

:tests.lib.Input.yesno.main
for %%a in (
    "Y: y n"
    "Y: Y n"
    "Y: yes n"
    "Y: yea n"
    "N: n y"
    "N: N y"
    "N: no y"
    "N: nah y"
    "Y: a bn y n"
    "N: a by n y"
    "Y: LF y n"
    "N: LF n y"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do (
            if "%%i" == "LF" (
                echo=
            ) else echo %%i
        )
    )
    call :Input.yesno result < "input" > nul
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
for %%a in (
    "0: y n"
    "2: n y"
    "0: LF y n"
    "3: LF"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do (
            if "%%i" == "LF" (
                echo=
            ) else echo %%i
        )
    )
    call :Input.yesno result < "input" > nul
    if not "!errorlevel!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:Input.yesno   return_var  [-m message]  [-y value]  [-n value]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_msg_is_set _message) do set "%%v="
set "_yes_value=Y"
set "_no_value=N"
set parse_args.args= ^
    ^ "-m, --message    :store_const:_msg_is_set=true" ^
    ^ "-m, --message    :store:_message" ^
    ^ "-y, --yes        :store:_yes_value" ^
    ^ "-n, --no         :store:_no_value"
call :parse_args %*
if not defined _msg_is_set set "_message=Input %~1? Y/N? "
call :Input.yesno._loop || exit /b 3
set "_result="
if /i "!user_input:~0,1!" == "Y" set "_result=!_yes_value!"
if /i "!user_input:~0,1!" == "N" set "_result=!_no_value!"
set "_result=^!!_result!"
set "_result=!_result:^=^^^^!"
set "_result=%_result:!=^^^!%"
for /f "delims= eol=" %%a in ("!_result!") do (
    endlocal
    set "%~1=%%a"
    set "%~1=!%~1:~1!"
    if /i "%user_input:~0,1%" == "Y" exit /b 0
    if /i "%user_input:~0,1%" == "N" exit /b 2
)
exit /b 1
#+++

:Input.yesno._loop
for /l %%_ in (1,1,10) do for /l %%_ in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if /i "!user_input:~0,1!" == "Y" exit /b 0
    if /i "!user_input:~0,1!" == "N" exit /b 0
)
exit /b 1


rem ================================ Input.path() ================================

rem ======================== documentation ========================

:Input.path.__doc__
echo NAME
echo    Input.path - read a path string from standard input
echo=
echo SYNOPSIS
echo    Input.path   return_var  [-m message]  [-b base_dir]
echo                 [-o]  [-e^|-n]  [-f^|-d]
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the absolte path of the file/folder.
echo=
echo OPTIONS
echo    -m MESSAGE, --message MESSAGE
echo        Use MESSAGE as the prompt message.
echo        By default, the message is generated automatically.
echo=
echo    -b BASE_DIR, --base-dir BASE_DIR
echo        Function will CD to this directory first before reading input.
echo=
echo    -o, --optional
echo        Input is optional and could be skipped by entering nothing.
echo=
echo CHECK OPTIONS
echo    These options that are passed to check_path()
echo=
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
echo EXIT STATUS
echo    0:  - Input is successful.
echo    2:  - User skips the input.
echo    3:  - Input attempt reaches the 100 attempt limit.
exit /b 0


:Input.path.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ check_path
exit /b 0


rem Note:
rem - Beware of names that solely consist of whitespaces. For now, it is tested
rem   to be safe because explorer and cmd does not allow users to give file name
rem   that solely consist of whitespaces and quotes are always added when using
rem   TAB autocompletion if the file name contains whitespace

rem ======================== demo ========================

:demo.Input.path
echo Current directory: !cd!

echo=
echo=
call :Input.path target_file --base-dir "!temp!" --exist --file ^
    ^ --message "Input an existing file: "
echo Result: "!target_file!"

echo=
echo=
call :Input.path save_folder --optional --directory ^
    ^ --message "Input an existing folder or a new folder name (optional): "
echo Result: "!save_folder!"

echo=
echo=
call :Input.path new_name --optional --not-exist ^
    ^ --message "Input a non-existing file/folder (optional): "
echo Result: "!new_name!"
exit /b 0


rem ======================== test ========================

:tests.lib.Input.path.main
if exist "tree" rmdir /s /q "tree"
for %%a in (
    "ref"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!"
    call 2> "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)
for %%a in (
    "red"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)

for %%a in (
    "red:tree\red"
    "ref:tree\ref"
    "rex:tree\rex"
    "ref:tree\red ref: --file"
    "red:tree\ref red: --directory"
    "red:tree\rex red: --exist"
    "rex:tree\red rex: --not-exist"
    "red:.\ed: --base-dir tree\r"
    "ref:.\ef: --base-dir tree\r"
    "rex:.\ex: --base-dir tree\r"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do ( rem
) & for /f "tokens=1* delims=\" %%e in ("%%c") do (
    > "input" (
        for %%i in (%%f) do (
            call :tests.lib.Input.path.make_path relpath "%%e" "%%i"
            echo=!relpath!
        )
    )
    call :tests.lib.Input.path.make_path expected "!cd!\tree" "%%b"
    set "result="
    call :Input.path result %%d < "input" > nul 2> nul
    if not "!result!" == "!expected!" (
        call %unittest%.fail %%a
    )
)
for %%a in (
    "0:tree\rex"
    "0:tree\ref: --file"
    "0:tree\red: --directory"
    "0:tree\red: --exist"
    "0:tree\rex: --not-exist"
    "2:.: --file --optional"
    "3:.: --file"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do ( rem
) & for /f "tokens=1* delims=\" %%e in ("%%c") do (
    > "input" (
        for %%i in (%%f) do (
            call :tests.lib.Input.path.make_path relpath "%%e" "%%i"
            echo=!relpath!
        )
    )
    call :Input.path result %%d < "input" > nul 2> nul
    if not "!errorlevel!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


:tests.lib.Input.path.make_path   return_var  prefix  word
set "letters=%~3"
set "letters=!letters:~0,1! !letters:~1,1! !letters:~2,1!"
set "%~1=%~2"
for %%l in (!letters!) do set "%~1=!%~1!\%%l"
exit /b 0


rem ======================== function ========================

:Input.path   return_var  [-m message]  [-b base_dir]  [-e|-n]  [-f|-d]  [-o]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_msg_is_set _message _optional _base_dir _check_options) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message    :store_const:_msg_is_set=true" ^
    ^ "-m, --message    :store:_message" ^
    ^ "-b, --base-dir   :store:_base_dir" ^
    ^ "-o, --optional   :store_const:_optional=true" ^
    ^ "-e, --exist      :append_const:_check_options= -e" ^
    ^ "-n, --not-exist  :append_const:_check_options= -n" ^
    ^ "-f, --file       :append_const:_check_options= -f" ^
    ^ "-d, --directory  :append_const:_check_options= -d"
call :parse_args %*
if defined _base_dir cd /d "!_base_dir!"
if not defined _msg_is_set set "_message=Input %~1: "
call :Input.path._loop || exit /b 3
set "user_input=^!!user_input!"
set "user_input=!user_input:^=^^^^!"
set "user_input=%user_input:!=^^^!%"
for /f "delims= eol=" %%a in ("!user_input!") do (
    endlocal
    set "%~1=%%a"
    set "%~1=!%~1:~1!"
    if not defined %~1 exit /b 2
)
exit /b 0
#+++

:Input.path._loop
for /l %%_ in (1,1,10) do for /l %%_ in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        call :check_path user_input !_check_options! && exit /b 0
    ) else if defined _optional exit /b 0
)
exit /b 1


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
echo=
echo EXIT STATUS
echo    0:  - Input is successful.
echo    3:  - Input attempt reaches the 100 attempt limit.
exit /b 0


:Input.ipv4.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ check_ipv4
exit /b 0


rem ======================== demo ========================

:demo.Input.ipv4
call :Input.ipv4 -w user_input --message "Input an IPv4 (wildcard allowed): "
echo Your input: !user_input!
exit /b 0


rem ======================== tests ========================

:tests.lib.Input.ipv4.main
set "text_empty="
set "text_localhost=127.0.0.1"
set "text_all=0.0.0.0"
set "text_wildcard1234=*.*.*.*"
set "text_zero=0"
set "text_abcd=a.b.c.d"
set "text_fail=1.2.3.4"
for %%a in (
    "localhost: localhost fail"
    "all: all fail"
    "localhost: empty localhost fail"
    "localhost: zero localhost fail"
    "localhost: abcd localhost fail"
    "wildcard1234: wildcard1234 fail: --allow-wildcard"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :Input.ipv4 result %%d < "input" > nul
    if not "!result!" == "!text_%%b!" (
        call %unittest%.fail %%a
    )
)
for %%a in (
    "0: localhost"
    "0: empty localhost"
    "3: wildcard1234"
    "0: wildcard1234: --allow-wildcard"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :Input.ipv4 result %%d < "input" > nul
    if not "!errorlevel!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:Input.ipv4   return_var  [-m message]  [-w]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_msg_is_set _message _allow_wildcard _check_options) do set "%%v="
set parse_args.args= ^
    ^ "-m, --message        :store_const:_msg_is_set=true" ^
    ^ "-m, --message        :store:_message" ^
    ^ "-w, --allow-wildcard :store_const:_allow_wildcard=true"
call :parse_args %*
if defined _allow_wildcard set "_check_options= --wildcard"
if not defined _msg_is_set (
    if defined _allow_wildcard (
        set "_message=Input %~1 (Wildcard allowed): "
    ) else set "_message=Input %~1: "
)
call :Input.ipv4._loop || exit /b 3
for /f "delims= eol=" %%r in ("!user_input!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0
#+++

:Input.ipv4._loop
for /l %%_ in (1,1,10) do for /l %%_ in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    call :check_ipv4 "!user_input!" !_check_options! && exit /b 0
)
exit /b 1


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
call :Input.number minimum --range "0~2147483647"
call :Input.number maximum --range "0~2147483647"
call :rand random_int !minimum! !maximum!
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
call :Input.string weights
call :randw random_int "!weights!"
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
call :Input.number number --range "0~2147483647"
call :Input.number power --range "0~2147483647"
call :yroot result !number! !power!
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
echo    2:  - The result is too large (^> 2147483647).
echo        - The integer is too large (^> 2147483647).
exit /b 0


:pow.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.pow
call :Input.number number --range "0~2147483647"
call :Input.number power --range "0~2147483647"
call :pow result !number! !power!
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
    "0: 2147483647 1"
    "0: 46340 2"
    "0: 1290 3"
    "0: 215 4"
    "0: 73 5"
    "0: 35 6"
    "0: 21 7"
    "0: 4 15"
    "0: 2 30"
    "0: 1 31"

    "2: 2147483648 1"
    "2: 2147483647 2"
    "2: 46340 3"
    "2: 1290 4"
    "2: 215 5"
    "2: 73 6"
    "2: 35 7"
    "2: 21 8"
    "2: 4 16"
    "2: 2 31"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :pow result %%c 2> nul
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "%%b" (
        call %unittest%.fail "errorlevel: %%~a"
    )
)
exit /b 0


rem ======================== function ========================

:pow   return_var  integer  power
set "%~1="
setlocal EnableDelayedExpansion
set "_result=1"
set "_limit=0x7FFFFFFF"
for /l %%p in (1,1,%~3) do (
    set /a "_result*=%~2" || ( 1>&2 echo error: integer is too large & exit /b 2 )
    set /a "_limit/=%~2"
)
if "!_limit!" == "0" ( 1>&2 echo error: result is too large & exit /b 2 )
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
call :Input.number number --range "0~2147483647"
call :prime factor !number!
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
call :Input.number number1 --range "0~2147483647"
call :Input.number number2 --range "0~2147483647"
call :gcf result !number1! !number2!
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
call :Input.string binary
call :bin2int result !binary!
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
call :Input.number decimal --range "0~2147483647"
call :int2bin result !decimal!
echo=
echo The binary value is !result!
exit /b 0


rem ======================== function ========================

:int2bin   return_var  positive_integer
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
call :Input.number decimal --range "0~2147483647"
call :int2oct result !decimal!
echo=
echo The octal value is !result!
exit /b 0


rem ======================== function ========================

:int2oct   return_var  positive_integer
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
call :Input.number decimal --range "0~2147483647"
call :int2hex result !decimal!
echo=
echo The hexadecimal value is !result!
exit /b 0


rem ======================== function ========================

:int2hex   return_var  positive_integer
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
call :Input.number number --range "1~4999"
call :int2roman result !number!
echo=
echo The roman numeral value is !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.int2roman.main
for %%a in (
    "1111:  MCXI"
    "2222:  MMCCXXII"
    "3333:  MMMCCCXXXIII"
    "4444:  MMMMCDXLIV"
    "555:   DLV"
    "666:   DCLXVI"
    "777:   DCCLXXVII"
    "888:   DCCCLXXXVIII"
    "999:   CMXCIX"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    call :int2roman result %%b 2> nul
    if not "!result!" == "%%c" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:int2roman   return_var  integer(1-4999)
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
call :Input.string roman_numeral
call :roman2int result !roman_numeral!
echo=
echo The decimal value is !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.roman2int.main
for %%a in (
    "1111:  MCXI"
    "2222:  MMCCXXII"
    "3333:  MMMCCCXXXIII"
    "4444:  MMMMCDXLIV"
    "555:   DLV"
    "666:   DCLXVI"
    "777:   DCCLXXVII"
    "888:   DCCCLXXXVIII"
    "999:   CMXCIX"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    call :roman2int result %%c 2> nul
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
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
echo    Check if a string only contains a number/hexadecimal/octal; no words
echo    or other symbols.
echo=
echo POSITIONAL ARGUMENTS
echo    input_string
echo        The string to check.
echo=
echo EXIT STATUS
echo    0:  - The string contains a number/hexadecimal/octal between
echo          -2147483647 to 2147483647.
echo    2:  - The string contains an invalid number or other symbols.
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
call :Input.string string
call :is_number "!string!" && (
    echo It is a number
) || echo It is not a number
exit /b 0


rem ======================== tests ========================

:tests.lib.is_number.main
set "return.true=0"
set "return.false=2"
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
    if "%%b" == "" exit /b 2
    if not "%%c" == "" exit /b 2
    set "_input=%%b"
)
for /f "tokens=1-2 delims=+-" %%a in ("x+!_input!") do set "_input=%%b"
if "!_input!" == "0" exit /b 0
if not defined _input exit /b 2
set "_input=!_input!_"
set "_valid_chars=0 1 2 3 4 5 6 7 8 9"
if /i "!_input:~0,2!" == "0x" (
    set "_input=!_input:~2!"
    if not "!_input:~9!" == "" exit /b 2
    set "_valid_chars=0 1 2 3 4 5 6 7 8 9 A B C D E F"
) else if "!_input:~0,1!" == "0" (
    set "_input=!_input:~1!"
    if not "!_input:~11!" == "" exit /b 2
    set "_valid_chars=0 1 2 3 4 5 6 7"
)
if "!_input!" == "_" exit /b 2
for %%c in (!_valid_chars!) do set "_input=!_input:%%c=!"
if not "!_input!" == "_" exit /b 2
set "_input="
set /a "_input=%~1" || exit /b 2
set /a "_input=!_input!" || exit /b 2
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
echo    2:  - The number is not within the specified range.
echo        - The number is invalid.
echo    3:  - The range is invalid.
exit /b 0


:is_in_range.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.is_in_range
call :Input.number number
call :Input.string range
echo=
call :is_in_range "!number!" "!range!" && (
    echo Number is within range
) || echo Number is not within range
exit /b 0


rem ======================== tests ========================

:tests.lib.is_in_range.main
set "return.true=0"
set "return.false=2"
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
set /a "_evaluated=%~1" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
set /a "_input=!_evaluated!" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
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
        set /a "_evaluated=!%%v!" || ( 1>&2 echo error: invalid range '!%%v!' & exit /b 3 )
        set /a "%%v=!_evaluated!" || ( 1>&2 echo error: invalid range '!%%v!' & exit /b 3 )
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
exit /b 2


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
call :Input.string string
call :strlen length string
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
call :Input.string string
call :strval result string
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
call :Input.string string
call :to_upper string
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
call :Input.string string
call :to_lower string
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
call :Input.string string
call :to_capital string
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
echo    - Only one pair of double quotes are stripped.
exit /b 0


:strip_dquotes.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.strip_dquotes
call :Input.string string
call :strip_dquotes string
echo=
echo Stripped : !string!
exit /b 0


rem ======================== function ========================

:strip_dquotes   input_var
if "!%~1:~0,1!!%~1:~-1,1!" == ^"^"^"^" set "%~1=!%~1:~1,-1!"
exit /b 0


rem ================================ strip() ================================

rem ======================== documentation ========================

:strip.__doc__
echo NAME
echo    strip - remove character from beginning and end of string
echo=
echo SYNOPSIS
echo    strip   input_var  [character]
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
echo=
echo    character
echo        The character to strip. Question mark and double quotes
echo        are not supported.
exit /b 0


:strip.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.strip
call :Input.string string
call :Input.string character
call :strip string "!character!"
echo=
echo Stripped : "!string!"
exit /b 0


rem ======================== tests ========================

:tests.lib.strip.main
for %%a in (
    "first:   first   "
    "second:   second"
    "third:third   "
    "[none]:"
    "[none]:        "
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "result=%%c"
    if "%%b" == "[none]" (
        set "expected="
    ) else set "expected=%%b"
    call :strip result
    if not "!result!" == "!expected!" (
        call %unittest%.fail %%a
    )
)
for %%a in (
    " equal :=:=== equal ========"
    " hastag :#:### hastag ###"
    " ### spaced :#: ### spaced ###"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    set "result=%%d"
    if "%%b" == "[none]" (
        set "expected="
    ) else set "expected=%%b"
    call :strip result "%%c"
    if not "!result!" == "!expected!" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:strip   input_var  [character]
for /f "tokens=1* delims=?" %%c in ("%~2? ") do (
    if "%%c" == " " (
        for /f "tokens=*" %%a in ("!%~1!_") do set "%~1=%%a"
    ) else for /f "tokens=* delims=%~2" %%a in ("!%~1!_") do set "%~1=%%a"
    set "%~1=_!%~1:~0,-1!"
    for /l %%n in (1,1,8192) do if "!%~1:~-1,1!" == "%%c" (
        if not "!%~1:~-%%n,1!" == "%%c" set "%~1=!%~1:~0,-%%n!!%~1:~-%%n,1!"
    )
    set "%~1=!%~1:~1!"
)
exit /b 0


rem ================================ normalize_spaces() ================================

rem ======================== documentation ========================

:normalize_spaces.__doc__
echo NAME
echo    normalize_spaces - normalize spaces in a variable to its compact form
echo=
echo SYNOPSIS
echo    normalize_spaces   "input_var1 [input_var2 [...]]"  [--not-null]
echo=
echo DESCRIPTION
echo    Adds a single space to the beginning and the end of the string
echo    and replace multiple spaces with a single space. Maximum number
echo    of consecutive space that can be replaced to a single space is
echo    459 spaces. By default, if the resulting variable only contains
echo    one space, the variable is set to undefined/null.
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
echo=
echo OPTIONS
echo    --not-null
echo        Do not set variable to null even if the result only contains
echo        a single space. This must be placed as the second argument.
exit /b 0


:normalize_spaces.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.normalize_spaces
call :Input.string multi_space_text || (
    set "multi_space_text= hello     world,  how     are    you  ?"
)
set "result=!multi_space_text!"
call :normalize_spaces "result"
echo=
echo Original list:
echo "!multi_space_text!"
echo=
echo Normalized list:
echo "!result!"
exit /b 0


rem ======================== tests ========================

:tests.lib.normalize_spaces.main
set "spaces="
set "start=1"
set "end=125"
for %%t in (front back) do (
    set "%%t="
    set "%%t.expected= "
)
for /l %%n in (1,1,!start!) do set "spaces=!spaces! "
for /l %%n in (!start!,1,!end!) do (
    set "front=!front!%%n!spaces!"
    set "front.expected=!front.expected!%%n "
    set "back=!spaces!%%n!back!"
    set "back.expected= %%n!back.expected!"
    set "spaces=!spaces! "
)
call :normalize_spaces "front back"
for %%t in (front back) do (
    if not "!%%t!" == "!%%t.expected!" call %unittest%.fail "%%t"
)

set "spaces.input=        "
set "spaces.output="
set "undefined.input="
set "undefined.output="
set "spaces_not_null.input=        "
set "spaces_not_null.output= "
set "undefined_not_null.input="
set "undefined_not_null.output= "
for %%a in (
    "spaces"
    "undefined"
    "spaces_not_null: --not-null"
    "undefined_not_null: --not-null"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "test_lists="
    for %%l in (%%b) do (
        set "%%l.result=!%%l.input!"
        set "test_lists=!test_lists! %%l.result"
    )
    call :normalize_spaces "!test_lists!" %%c
    set "fail="
    for %%l in (%%b) do (
        if not "!%%l.result!" == "!%%l.output!" set "fail=true"
    )
    if defined fail (
        call %unittest%.fail %%a
    )
)
exit /b 0



rem ======================== function ========================

:normalize_spaces   "input_var1 [input_var2 [...]]"  [--not-null]
for %%l in (%~1) do (
    set "%%l= !%%l! "
    for %%s in (
        "                     "
        "      "
        "   "
        "  "
        "  "
    ) do set "%%l=!%%l:%%~s= !"
    if not "%2" == "--not-null" if "!%%l!" == " " set "%%l="
)
exit /b 0


rem ================================ list2set() ================================

rem ======================== documentation ========================

:list2set.__doc__
echo NAME
echo    list2set - remove duplicate items in a list
echo=
echo SYNOPSIS
echo    list2set   "input_var1 [input_var2 [...]]"  [--not-null]
echo=
echo POSITIONAL ARGUMENTS
echo    input_var
echo        The input variable name.
echo=
echo OPTIONS
echo    --not-null
echo        Do not set variable to null even if the list is empty.
echo        This must be placed as the second argument.
echo=
echo NOTES
echo    - Special characters are not supported. Using it might result in
echo      unexpected behaviors.
exit /b 0


:list2set.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.list2set
call :Input.string list_with_duplicates || (
    set list_with_duplicates= "hello" hello world? how are you *.bat
)
set "result=!list_with_duplicates!"
call :list2set "result"
echo=
echo Original list:
echo "!list_with_duplicates!"
echo=
echo Converted set:
echo "!result!"
exit /b 0


rem ======================== tests ========================

:tests.lib.list2set.main
set "basic.input=a a b c b cc ddd dd e "
set "basic.output= a b c cc ddd dd e "
set quoted.input=a "a" "b" " b " " b " c "c" c:"c"
set quoted.output= a "a" "b" " b " c "c" c:"c" %=END=%
set "spaces.input=        "
set "spaces.output="
set "undefined.input="
set "undefined.output="
set "spaces_not_null.input=        "
set "spaces_not_null.output= "
set "undefined_not_null.input="
set "undefined_not_null.output= "
for %%a in (
    "basic"
    "quoted"
    "spaces"
    "undefined"
    "spaces_not_null: --not-null"
    "undefined_not_null: --not-null"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "test_lists="
    for %%l in (%%b) do (
        set "%%l.result=!%%l.input!"
        set "test_lists=!test_lists! %%l.result"
    )
    call :list2set "!test_lists!" %%c
    set "fail="
    for %%l in (%%b) do (
        if not "!%%l.result!" == "!%%l.output!" set "fail=true"
    )
    if defined fail (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:list2set   "input_var1 [input_var2 [...]]"  [--not-null]
for %%l in (%~1) do (
    for /f "tokens=1* delims=?" %%b in ("Q?!%%l!") do (
        set "%%l= "
        for %%i in (%%c) do (
            set "%%l= %%i!%%l!"
        )
    )
    for /f "tokens=1* delims=?" %%b in ("Q?!%%l!") do (
        set "%%l= "
        for %%i in (%%c) do (
            set "%%l= %%i!%%l: %%i = !"
        )
    )
    if not "%2" == "--not-null" if "!%%l!" == " " set "%%l="
)
exit /b 0


rem ================================ sprintrow() ================================

rem ======================== documentation ========================

:sprintrow.__doc__
echo NAME
echo    sprintrow - write formatted row data to variable
echo=
echo SYNOPSIS
echo    sprintrow   buffer_var  seperator  cell_sizes  "text1" ["text2" [...]]
echo=
echo POSITIONAL ARGUMENTS
echo    buffer_var
echo        The variable name to append the results.
echo=
echo    seperator
echo        The string to seperate each cell
echo=
echo    cell_sizes
echo        Size of each cells. The maximum size is 256.
echo        - Positive    : Left justify
echo        - Negative    : Right justify
echo        - Zero        : No justify and padding
echo=
echo    text
echo        Text for each cells
exit /b 0


:sprintrow.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.sprintrow
set "row1.first_name=John"
set "row1.last_name=Doe"
set "row1.age=8"
set "row1.score=99"
set "row2.first_name=Jane"
set "row2.last_name=Doe"
set "row2.age=12"
set "row2.score=100"

echo ================ Example #1 ================
set "display="
call :sprintrow display " | " ^
    ^ "10 10 3 5" ^
    ^ "First Name" "Last Name" "Age" "Score"
echo !display!
for /l %%n in (1,1,2) do (
    set "display="
    call :sprintrow display " | " ^
        ^ "10 10 -3 -5" ^
        ^ "!row%%n.first_name!" ^
        ^ "!row%%n.last_name!" ^
        ^ "!row%%n.age!" ^
        ^ "!row%%n.score!"
    echo !display!
)
echo=

echo ================ Example #2 ================
set "column_sizes=12 2 12 12 2 12"
for /l %%n in (1,1,2) do (
    echo=
    echo Record #%%n
    set "display="
    call :sprintrow display "" ^
        ^ "!column_sizes!" ^
        ^ "First Name" ": " "!row%%n.first_name!" ^
        ^ "Last Name" ": " "!row%%n.last_name!"
    echo !display!
    set "display="
    call :sprintrow display "" ^
        ^ "!column_sizes!" ^
        ^ "Age" ": " "!row%%n.age!" ^
        ^ "Score" ": " "!row%%n.score!"
    echo !display!
)
echo=
exit /b 0


rem ======================== tests ========================

:tests.lib.sprintrow.main
set "result="
call :sprintrow result "#" ^
    ^ "3 -3 5 -5" ^
    ^ "a" "b" " c c " "dddddd"
if not "!result!" == "a  #  b# c c #ddddd" (
    call %unittest%.fail "basic"
)
exit /b 0


rem ======================== function ========================

:sprintrow   buffer_var  seperator  cell_sizes  "text1" ["text2" [...]]
setlocal EnableDelayedExpansion
set "_result="
set "_spaces= "
for /l %%n in (1,1,8) do set "_spaces=!_spaces!!_spaces!"
set "_seperator="
for %%l in (%~3) do (
    call set "_value=%%~4"
    if %%l GTR 0 (
        set "_value=!_value!!_spaces!"
        set "_value=!_value:~0,%%l!"
    ) else if %%l LSS 0 (
        set "_value=!_spaces!!_value!"
        set "_value=!_value:~%%l!"
    )
    set "_result=!_result!!_seperator!!_value!"
    if not defined _seperator set "_seperator=%~2"
    shift /4
)
for /f "tokens=*" %%a in ("!%~1!!_result!") do (
    endlocal
    set "%~1=%%a"
)
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
call :Input.string text
call :shuffle text
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
echo    - The format of the time is 'HH:MM:SS.SS'.
echo    - Supported time seperators: colon ':', dot '.', comma ',' space ' '
echo    - If milliseconds (or higher precision) are provided, it will be
echo      truncated to centiseconds.
exit /b 0


:difftime.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.difftime
call :Input.string start_time
call :Input.string end_time
call :difftime time_taken "!end_time!" "!start_time!"
echo=
echo Time difference: !time_taken! centiseconds
exit /b 0


rem ======================== tests ========================

:tests.lib.difftime.main
for %%a in (
    "0#"

    "2928808#08:08:08.08"
    "2928800#08:08:08"
    "2928000#08:08"
    "2880000#08"

    "2928808# 8:08:08.08"
    "2928808#08.08.08,08"
    "2928808#8:8:8.08"
    "2928880#8:8:8.8"
    "2928887#8:8:8.876"
) do for /f "tokens=1* delims=#" %%b in (%%a) do (
    call :difftime result "%%c"
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
for %%a in (
    "1:         00:00:00.09  00:00:00.08"
    "100:       00:00:09.00  00:00:08.00"
    "6000:      00:09:00.00  00:08:00.00"
    "360000:    09:00:00.00  08:00:00.00"

    "1:         00:00:01.00  00:00:00.99"
    "100:       00:01:00.00  00:00:59.00"
    "6000:      01:00:00.00  00:59:00.00"

    "1:         00:00:00.00  23:59:59.99"
    "8639999:   00:00:00.00  00:00:00.01"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :difftime result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:difftime   return_var  end_time  [start_time] [--no-fix]
set "%~1=0"
for %%t in ("%~2.0" "%~3.0") do for /f "tokens=1-4 delims=:., " %%a in ("%%~t.0.0.0.0") do (
    set /a "%~1+=(1%%a*2-2%%a)*360000 + (1%%b*2-2%%b)*6000 + (1%%c*2-2%%c)*100 + (1%%d*2-2%%d)*100/(2%%d-1%%d)"
    set /a "%~1*=-1"
)
if /i not "%4" == "--no-fix" if "!%~1:~0,1!" == "-" set /a "%~1+=8640000"
exit /b 0


rem ======================== function ========================

rem This is faster, assuming minutes, seconds, and centiseconds is always 2 digits
set /a "_centiseconds=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"

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
echo    - The format of the time is 'HH:MM:SS.SS'.
exit /b 0


:ftime.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.ftime
call :Input.string time_in_centisecond
call :ftime time_taken !time_in_centisecond!
echo=
echo Formatted time : !time_taken!
exit /b 0


rem ======================== tests ========================

:tests.lib.ftime.main
for %%a in (
    "00:00:00.00# 0"
    "00:00:00.01# 1"
    "00:00:01.00# 100"
    "00:01:00.00# 6000"
    "01:00:00.00# 360000"
    "23:59:59.99# 8639999"
    "23:59:59.99# 8639999"
    "24:00:00.00# 8640000"
    "99:59:59.99# 35999999"
) do for /f "tokens=1* delims=#" %%b in (%%a) do (
    call :ftime result %%c
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:ftime   return_var  centiseconds
setlocal EnableDelayedExpansion
set "_result="
set /a "_remainder=%~2"
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
call :Input.string start_date
call :Input.string end_date
call :diffdate difference !end_date! !start_date!
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
call :Input.string days_since_epoch
call :fdate result !days_since_epoch!
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
call :Input.string a_date || set "a_date=!date:* =!"
call :what_day day "!a_date!"
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
call :Input.string date_time || set "date_time=!date:* =!_!time!"
call :time2epoch result !date_time!
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
call :Input.string seconds_since_epoch
call :epoch2time result !seconds_since_epoch!
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


rem ================================== timeit() ==================================

rem ======================== documentation ========================

:timeit.__doc__
echo NAME
echo    timeit - measure execution time of code
echo=
echo SYNOPSIS
echo    timeit   code  [-n loops] [-r repetitions]
echo    timeit.setup_macro
echo    %%timeit[: $args= [-n loops] [-r repetitions]]%%   code
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    code
echo        Code to execute. Single quotes in code is converted
echo        to double quotes when not used as macro.
echo=
echo OPTIONS
echo    -n N, --number N
echo        How many times to execute function.
echo=
echo    -r N, --repeat N
echo        How many times to repeat the timer (default 5).
echo=
echo NOTES
echo    - Code is executed inside a SETLOCAL so no variables are affected.
echo    - Macro can be used inside a FOR loop.
echo    - The FOR loop parameter '%%%%_' is used internally.
exit /b 0


:timeit.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args ^
    ^ difftime
exit /b 0


rem ======================== demo ========================

:demo.timeit
call :timeit.setup_macro

echo Measure time taken to run "REM"
call :timeit "rem"
echo=
echo Measure time taken to run "CALL"
call :timeit "call"
echo=
echo Measure time taken to read this file line by line
call :timeit "for /f 'usebackq tokens=*' %%%%o in ('%~f0') do rem"
echo=
echo Measure time taken to read this file line by line (using macro)
%timeit% for /f "usebackq tokens=*" %%o in ("%~f0") do rem
exit /b 0


rem ======================== function ========================

:timeit   code  [-n loops] [-r repetitions]
setlocal EnableDelayedExpansion
call :timeit._parse_args %*
if defined _as_macro (
    endlocal
    call :timeit._parse_args %*
)
if defined _loops (
    set "_start_repeat=1"
) else (
    set "_loops=1"
    set "_start_repeat=-5"
)
set "_min_time=20"
set "_best_time=2147483647"
set "_result=0"
if defined _as_macro exit /b 0

set "_code= %~1"
set _code=!_code:'="!
if "!_code: =!" == "" ( 1>&2 echo error: No command to execute & exit /b 1 )
set "_code=!_code:~1!"
call :timeit._measure
call :timeit._result
exit /b 0
#+++

:timeit._parse_args
(
    goto 2> nul
    for %%v in (_as_macro _loops) do set "%%v="
    set "_repeat=5"
    set parse_args.args= ^
        ^ "--as-macro       :store_const:_as_macro=true" ^
        ^ "-n, --number     :store:_loops" ^
        ^ "-r, --repeat     :store:_repeat"
    call :parse_args %*
)
exit /b 0
#+++

:timeit._measure
for /l %%r in (!_start_repeat!,1,!_repeat!) do (
    set "_measure=true"
    if %%r LEQ 0 if !_result! GEQ !_min_time! set "_measure="
    if defined _measure (
        set "_start_time=!time!"
        for /l %%l in (1,1,!_loops!) do %_code%
        call :difftime _result "!time!" "!_start_time!"
        if %%r LEQ 0 (
            if !_result! LSS !_min_time! (
                set /a "_loops=!_loops! * !_min_time!1 / !_result!1"
                set /a "_loops=1!_loops! - 9!_loops:~1!"
            )
        ) else if !_result! LSS !_best_time! set "_best_time=!_result!"
    )
)
exit /b 0
#+++

:timeit._result
set "_sf=1"
set "_nodot=-2"
set "_temp=!_best_time!"
for /l %%n in (1,1,10) do (
    set /a "_temp/=10"
    if not "!_temp!" == "0" set /a "_sf+=1"
)
for %%t in (3) do if !_sf! LEQ %%t (
    for /l %%n in (1,1,%%t) do set /a "_best_time*=10"
    set /a "_nodot-=%%t"
)
set /a "_best_time/=!_loops:~0,1!"
set "_temp=!_loops!"
for /l %%n in (1,1,5) do (
    set /a "_temp/=10"
    if not "!_temp!" == "0" set /a "_nodot-=1"
)
set "_unit="
for %%a in (
    "nsec:-9"
    "usec:-6"
    "msec:-3"
    "sec:0"
    "min:60"
    "hour:3600  :last"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do ( rem
) & if not defined _unit (
    if %%c LEQ 0 (
        set "_div=1"
        for /l %%n in (!_nodot!,1,%%c) do set "_div=10*!_div!"
    ) else (
        set "_div=%%c"
        for /l %%n in (!_nodot!,1,0) do set "_div=10*!_div!"
    )
    set /a "_div=!_div!/10"
    if "!_div!" == "0" set "_div=1"
    set /a "_whole=!_best_time!/!_div!"
    if !_whole! LSS 1000 set "_unit=%%b"
    if "%%c" == "last" set "_unit=%%b"
)
set /a "_remainder=!_best_time! %% !_div! * 100 / !_div!"
set "_remainder=00!_remainder!"
set "_remainder=!_remainder:~-2,2!"
set "_result=!_whole!.!_remainder!"
set "_result=!_result:~0,4!"
if "!_result:~3,1!" == "." set "_result=!_result:~0,3!"
echo !_loops! loops, best of !_repeat!: !_result! !_unit! per loop
exit /b 0
#+++

:timeit.setup_macro
rem Mostly derived from timeit._measure()
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set timeit= ^( call !LF!^
    ^ ^) ^& for /l %%_ in (1,1,4) do if "%%_" == "0" ^( call !LF!^
    ^ ^) else if "%%_" == "1" ^( !LF!^
    ^     setlocal EnableDelayedExpansion EnableExtensions !LF!^
    ^     set "_args_valid=" !LF!^
    ^     call :timeit --as-macro  $args  %=END=% ^&^& set "_args_valid=true" !LF!^
    ^ ^) else if "%%_" == "3" ^( !LF!^
    ^     if defined _args_valid call :timeit._result !LF!^
    ^ ^) else if "%%_" == "4" ^( !LF!^
    ^     endlocal !LF!^
    ^ ^) else if "%%_" == "2" if defined _args_valid ^( call !LF!^
    ^ ^) ^& for /l %%r in ^(^^!_start_repeat^^!,1,^^!_repeat^^!^) do ^( !LF!^
    ^     set "_measure=true" !LF!^
    ^     if %%r LEQ 0 if ^^!_result^^! GEQ ^^!_min_time^^! set "_measure=" !LF!^
    ^ ^) ^& if defined _measure ^( call !LF!^
    ^ ^) ^& for /l %%_ in ^(1,1,2^) do if "%%_" == "0" ^( call !LF!^
    ^ ^) else if "%%_" == "2" ^( !LF!^
    ^     call :difftime _result ^"^^!time^^!^" ^"^^!_start_time^^!^" !LF!^
    ^     if %%r LEQ 0 ^( !LF!^
    ^         if ^^!_result^^! LSS ^^!_min_time^^! ^( !LF!^
    ^             set /a ^"_loops=^^!_loops^^! * ^^!_min_time^^!1 / ^^!_result^^!1^" !LF!^
    ^             set /a ^"_loops=1^^!_loops^^! - 9^^!_loops:~1^^!^" !LF!^
    ^         ^) !LF!^
    ^     ^) else if ^^!_result^^! LSS ^^!_best_time^^! set ^"_best_time=^^!_result^^!^" !LF!^
    ^ ^) else if "%%_" == "1" ^( !LF!^
    ^     set ^"_start_time=^^!time^^!^" !LF!^
    ^ ^) ^& for /l %%l in ^(1,1,^^!_loops^^!^) do
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
echo        Variable to store the time remaining. The time format is 'HH:MM:SS.SS'.
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
    call :difftime start_time_cs "!start_time!"

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
                for /f "tokens=1-4 delims=:., " %%a in ("!time!") do (
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

    call :difftime time_taken "!time!" "!start_time!"
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
exit /b 0


rem ======================== function ========================

:timeleft    return_var  start_time_cs  current_progress  total_progress
setlocal EnableDelayedExpansion
for /f "tokens=1-4 delims=:., " %%a in ("!time!") do (
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
echo    wait.setup_macro
echo    wait.calibrate   [delay_target]
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
exit /b 0


:wait.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.wait
call :wait.setup_macro
call :wait.calibrate
echo=
call :Input.number time_in_milliseconds --range "0~10000"
echo=
echo Wait for !time_in_milliseconds! milliseconds...
set "start_time=!time!"

rem Using macro
for %%t in (!time_in_milliseconds!) do %wait%

rem Called
rem call :wait !time_in_milliseconds!

call :difftime time_taken "!time!" "!start_time!"
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
exit /b 0


rem ======================== tests ========================

:tests.lib.wait.main
set "threshold=200"  milliseconds
set "test_delay=1250"  milliseconds

call :wait.setup_macro
call :wait.calibrate > nul || (
    call %unittest%.fail "Calibration failed"
    exit /b 0
)
for %%m in (macro call) do (
    set "start_time=!time!"
    call :tests.lib.wait.using_%%m
    call :difftime time_taken "!time!" "!start_time!"
    set /a "time_taken*=10"
    set /a "inaccuracy=!time_taken! - !test_delay!"
    set /a "fail=!inaccuracy!/!threshold!"
    if not "!fail!" == "0" (
        call %unittest%.fail "Abnormal amount of inaccuracy in delay using %%m: expected !test_delay!s, got !time_taken!s"
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
call :wait.setup_macro
set "wait._increment=100000"
if not "%~1" == "" set /a "_delay_target=%~1" || exit /b 1
set "_time_taken=-1"
for /l %%i in (1,1,12) do if not "!wait._increment!" == "-1" if not "!_time_taken!" == "!_delay_target!" (
    if "%~1" == "" set "_delay_target=!wait._increment:~0,3!"
    set "_start_time=!time!"
    for %%t in (!_delay_target!) do %wait%
    set "_time_taken=0"
    for %%t in ("!time!" "!_start_time!") do for /f "tokens=1-4 delims=:., " %%a in ("%%~t") do (
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

:wait.setup_macro
set wait=for /l %%w in (0,^^!wait._increment^^!,%%t00000) do call
exit /b 0


rem ================================ sleep() ================================

rem ======================== documentation ========================

:sleep.__doc__
echo NAME
echo    sleep - delay for n milliseconds
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
echo    - This function have high CPU usage for maximum of 1 seconds on each call
echo      because it is uses wait()
exit /b 0


:sleep.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ wait
exit /b 0


rem ======================== demo ========================

:demo.sleep
call :wait.setup_macro
call :wait.calibrate
echo=
call :Input.number time_in_milliseconds --range "0~2147483647"
echo=
echo Wait for !time_in_milliseconds! milliseconds...
set "start_time=!time!"

call :sleep !time_in_milliseconds!

call :difftime time_taken "!time!" "!start_time!"
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
exit /b 0


rem ======================== tests ========================

:tests.lib.sleep.main
set "threshold=300"  milliseconds
set "test_delay=2000"  milliseconds

call :wait.setup_macro
call :wait.calibrate > nul || (
    call %unittest%.fail "Calibration failed"
    exit /b 0
)

set "start_time=!time!"
call :sleep !test_delay!
call :difftime time_taken "!time!" "!start_time!"
set /a "time_taken*=10"
set /a "inaccuracy=!time_taken! - !test_delay!"
set /a "fail=!inaccuracy!/!threshold!"
if not "!fail!" == "0" (
    call %unittest%.fail "Abnormal amount of inaccuracy in delay: expected !test_delay!s, got !time_taken!s"
)
exit /b 0


rem ======================== function ========================

:sleep   milliseconds
(
    setlocal EnableDelayedExpansion
    set "_start=!time!"
    set /a "_sec=%~1 / 1000"
    if not "!_sec:~0,1!" == "-" timeout /t !_sec! /nobreak > nul
    set "_remaining=0"
    for %%t in ("!time!" "!_start!") do for /f "tokens=1-4 delims=:., " %%a in ("%%~t") do (
        set /a "_remaining+=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"
        set /a "_remaining*=0xffffffff"
    )
    if "!_remaining:~0,1!" == "-" set /a "_remaining+=0x83D600"
    set /a "_remaining=%~1 - !_remaining! * 10"
    for %%t in (!_remaining!) do %wait%
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
echo    2:  - The path does not satisfy the requirements.
echo    3:  - The path is invalid.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of the path in path_var if relative path is given.
echo=
echo NOTES
echo    - Variables in path will not be expanded (e.g.: %%appdata%%).
echo    - Path in variable is converted to absolte path on success.
exit /b 0


:check_path.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ parse_args
exit /b 0


rem ======================== demo ========================

:demo.check_path
call :Input.string config_file  --message "Input an existing file: "
call :check_path --exist --file config_file && (
    echo Your input is valid
) || echo Your input is invalid

call :Input.string folder  --message "Input an existing folder or a new folder name: "
call :check_path --directory folder && (
    echo Your input is valid
) || echo Your input is invalid

call :Input.string new_name  --message "Input an existing folder or a new folder name: "
call :check_path --not-exist new_name && (
    echo Your input is valid
) || echo Your input is invalid
exit /b 0


rem ======================== tests ========================

:tests.lib.check_path.main
set "char.wc=C:\hello*world"
set "char.colon=C:\hello:world"
set "char.pipe=C:\hello|world"
set "char.qm=C:\hello?world"
set "char.lab=C:\hello<world"
set "char.rab=C:\hello>world"
set char.dquote=C:\hello"world
for %%a in (wc colon pipe qm lab rab dquote) do (
    call :check_path char.%%a 2> nul && (
        call %unittest%.fail "unexpected success with invalid character: %%a"
    )
)

if exist "hello" (
    rd /s /q "hello" || del /f /q "hello"
) 2> nul || ( call :unittest.error "cannot setup dummy directory" & exit /b 1 )
md "hello"
if exist "world" (
    del /f /q "world" || rd /s /q "world"
) 2> nul || ( call :unittest.error "cannot setup dummy file" & exit /b 1 )
call 2> "world"
if exist "none" (
    del /f /q "none" || rd /s /q "none"
) 2> nul || ( call :unittest.error "cannot setup non-existing file" & exit /b 1 )
for %%a in (
    "0: -e  :%~d0\"
    "0: -e  :%~d0"
    "0: -e  :hello\"
    "0: -e  :hello"
    "2: -e  :world\"
    "0: -e  :world"
    "2: -e  :none"

    "2: -n  :%~d0\"
    "2: -n  :hello"
    "2: -n  :world"
    "0: -n  :none"

    "2: -f  :%~d0"
    "2: -f  :hello"
    "0: -f  :world"
    "0: -f  :none"

    "0: -d  :%~d0"
    "0: -d  :hello"
    "2: -d  :world"
    "0: -d  :none"

    "2: -e -f   :none"
    "2: -e -d   :none"

    "0: -e  : none\..\hello"
    "0: -e  : none\..\world"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    set "input_path=%%d"
    call :check_path input_path %%c 2> nul
    set "result=!errorlevel!"
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
for %%a in (
    "%~d0|%~d0\"
    "%~d0\|%~d0\"
    "hello|!cd!\hello"
    "hello\|!cd!\hello"
    "world|!cd!\world"
    "none|!cd!\none"
    "none\.|!cd!\none"
    "none\.\none|!cd!\none\none"
    "none\..|!cd!"
    "none\..\empty|!cd!\empty"
) do for /f "tokens=1* delims=|" %%b in (%%a) do (
    set "input_path=%%b"
    call :check_path input_path %%c 2> nul
    if not "!input_path!" == "%%c" (
        call %unittest%.fail %%a
    )
)
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
if not defined _path ( 1>&2 echo error: Path not defined & exit /b 3 )
set "_temp=!_path!"
if "!_path:~1,1!" == ":" set "_temp=!_path:~0,1!!_path:~2!"
for /f tokens^=1-2*^ delims^=:?^"^<^>^| %%a in ("Q?_!_temp!_") do (
    if not "%%c" == "" ( 1>&2 echo error: Invalid path characters & exit /b 3 )
)
for /f "tokens=1-2* delims=*" %%a in ("Q*_!_temp!_") do (
    if not "%%c" == "" ( 1>&2 echo error: Wildcards are not allowed & exit /b 3 )
)
if "!_path:~1!" == ":" set "_path=!_path!\"
set "_file_exist=false"
for %%f in ("!_path!") do (
    set "_path=%%~ff"
    set "_attrib=%%~af"
)
if defined _attrib (
    set "_attrib=!_attrib:~0,1!"
    set "_file_exist=true"
)
if "!_attrib!" == "d" (
    for %%f in ("!_path!\.") do set "_path=%%~ff"
)
if defined _require_exist if not "!_file_exist!" == "!_require_exist!" (
    if "!_require_exist!" == "true" 1>&2 echo error: Input does not exist
    if "!_require_exist!" == "false" 1>&2 echo error: Input already exist
    exit /b 2
)
if "!_file_exist!" == "true" if defined _require_attrib if not "!_attrib!" == "!_require_attrib!" (
    if defined _require_exist (
        if "!_require_attrib!" == "d" 1>&2 echo error: Input is not a folder
        if "!_require_attrib!" == "-" 1>&2 echo error: Input is not a file
    ) else (
        if "!_require_attrib!" == "d" 1>&2 echo error: Input must be a new or existing folder, not a file
        if "!_require_attrib!" == "-" 1>&2 echo error: Input must be a new or existing file, not a folder
    )
    exit /b 2
)
for /f "delims=" %%c in ("!_path!") do (
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
    ^ wcdir
exit /b 0


rem ======================== demo ========================

:demo.combi_wcdir
call :Input.string search_paths || set "search_paths=C:\Windows\System32;C:\Windows\SysWOW64"
call :Input.string wildcard_paths || set "wildcard_paths=*script.exe"
call :combi_wcdir result "!search_paths!" "!wildcard_paths!"
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
set LF=^
%=REQUIRED=%
%=REQUIRED=%
for %%v in (_path1 _path2) do (
    set "%%v=!%%v:/=\!"
    set ^"%%v=!%%v:;=%NL%!^"
    set "_temp="
    for /f "delims=" %%a in ("!%%v!") do (
        set "_is_listed="
        for /f "tokens=*" %%b in ("!_temp!") do if "%%a" == "%%b" set "_is_listed=true"
        if not defined _is_listed set "_temp=!_temp!%%a!LF!"
    )
    set "%%v=!_temp!"
)
set "_found="
for /f "delims=" %%a in ("!_path1!") do for /f "delims=" %%b in ("!_path2!") do (
    set "_result="
    pushd "!temp!"
    call :wcdir._find "%%a\%%b"
    set "_found=!_found!!_result!"
)
set "_result="
for /f "delims=" %%a in ("!_found!") do (
    set "_is_listed="
    for /f "tokens=*" %%b in ("!_result!") do if "%%a" == "%%b" set "_is_listed=true"
    if not defined _is_listed set "_result=!_result!%%a!LF!"
)
if defined _result (
    set "%~1="
    for /f "delims=" %%r in ("!_result!") do (
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
echo        by a Line Feed character (hex code '0A').
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
echo    - Does not list hidden files and folders.
exit /b 0


:wcdir.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.wcdir
call :Input.string wildcard_path || set "wildcard_path=C:\Windows\System32\*script.exe"
call :strip_dquotes wildcard_path
call :wcdir result "!wildcard_path!"
echo=
echo Wildcard path:
echo !wildcard_path!
echo=
echo Found List:
echo=!result!
exit /b 0


rem ======================== tests ========================

:tests.lib.wcdir.main
if exist "tree" rmdir /s /q "tree"
for %%a in (
    "lap"
    "let"
    "pet"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!"
    call 2> "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)
for %%a in (
    "ape"
    "ate"
    "pea"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)
call :capchar LF

set test_cases= ^
    ^ "pe*: pea pet" !LF!^
    ^ "a*e: ape ate" !LF!^
    ^ "*et: let pet" !LF!^
    ^ "l**: lap let" !LF!^
    ^ "*e*: let pea pet" !LF!^
    ^ "**t: let pet" !LF!^
    ^ "***: ape ate lap let pea pet"
for /f "delims=" %%a in ("!test_cases!") do ( rem
) & for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "pattern=%%b"
    set "pattern=!pattern:~0,1!\!pattern:~1,1!\!pattern:~2,1!"
    call :wcdir result_path "tree\!pattern!"
    set "result="
    for %%f in (!result_path!) do (
        set "word=%%~ff"
        set "word=!word:*%cd%\tree\=!"
        set "word=!word:\=!"
        set "result=!result! !word!"
    )
    if not "!result!" == "%%c" (
        call %unittest%.fail "%%b"
    )
)
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
set LF=^
%=REQUIRED=%
%=REQUIRED=%
call :wcdir._find "!_args!"
for /f "delims=" %%r in ("!_result!") do (
    if not defined %~1 endlocal
    set "%~1=!%~1!%%r!LF!"
)
exit /b 0
#+++

:wcdir._find   wildcard_path
for /f "tokens=1* delims=\" %%a in ("%~1") do if "%%a" == "*:" (
    for %%l in (
        A B C D E F G H I J K L M
        N O P Q R S T U V W X Y Z
    ) do pushd "%%l:\" 2> nul && call :wcdir._find "%%b"
) else if "%%b" == "" (
    if defined _list_dir dir /b /a:d "%%a" > nul 2> nul && (
        for /d %%f in ("%%a") do set "_result=!_result!%%~ff!LF!"
    )
    if defined _list_file dir /b /a:-d "%%a" > nul 2> nul && (
        for %%f in ("%%a") do set "_result=!_result!%%~ff!LF!"
    )
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
call :Input.string bytes
call :bytes2size size "!bytes!"
echo=
echo The human readable form is !size!
exit /b 0


rem ======================== tests ========================

:tests.lib.bytes2size.main
for %%a in (
    "1.00 GB:   1076892679"
    "1.00 GB:   1073741824"
    "1.42 GB:   1533916891"
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
for %%a in (
    "30:GB"
    "20:MB"
    "10:KB"
    "0:bytes"
) do for /f "tokens=1* delims=:" %%b in (%%a) do ( rem
) & if not defined _result (
    set /a "_digits=(%~2) / (1<<%%b)"
    if not "!_digits!" == "0" (
        set "_result=!_digits!"
        if not "%%b" == "0" (
            set /a "_remainder=(%~2) / (1<<(%%b - 10)) %% 1024 * 100 / 1024"
            set "_remainder=00!_remainder!"
            set "_remainder=!_remainder:~-2,2!"
            set "_result=!_result!.!_remainder!"
            set "_result=!_result:~0,4!"
        )
        set "_result=!_result! %%c"
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
call :Input.string size
call :size2bytes bytes "!size!"
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
call :Input.path --exist --file source_file
call :Input.path --not-exist destination_file
echo=
echo Converting to hex...
call :hexlify "!source_file!" "!destination_file!" --eol "0d 0a"
echo Done
exit /b 0


rem ======================== tests ========================

:tests.lib.hexlify.main
call :hexlify "%~f0" "hexlify.hex"
if exist "hexlify.rebuild" del /f /q "hexlify.rebuild"
certutil -decodehex "hexlify.hex" "hexlify.rebuild" > nul
call :diffbin offset "%~f0" "hexlify.rebuild"
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
set "_input_file=%~f1"
set "_output_file=%~f2"
set "_eol_len=2"
if /i "!_eol!" == "0d 0a" set "_eol_len=5"

cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
if exist "raw_hex" del /f /q "raw_hex"
certutil -encodehex "!_input_file!" "raw_hex" > nul || exit /b 1
rem Group hex according to EOL
> "!_output_file!" (
    set "_hex="
    for /f "usebackq tokens=1*" %%a in ("raw_hex") do (
        set "_input=%%b"
        set "_hex=!_hex! !_input:~0,48!"
        if not "!_hex:~7680!" == "" call :hexlify._format
    )
    call :hexlify._format
    echo=!_hex!
    set "_hex="
)
exit /b 0
#+++

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
echo        Affects the base path of input_file and output_file
echo        if relative path is given.
echo=
echo    temp_path
echo        Path to store the temporary VBScript file.
echo=
echo    temp
echo        Fallback path for temp_path if temp_path does not exist
echo=
echo EXIT STATUS
echo    0:  - The path satisfy the requirements.
echo    2:  - Create folder failed.
echo=
echo NOTES
echo    - VBScript is used to extract the zip file.
echo    - Variables in path will not be expanded (e.g.: %%appdata%%).
exit /b 0


:unzip.__metadata__   [return_prefix]
set %~1install_requires=^
    ^ feature:VBScript
exit /b 0


rem ======================== demo ========================

:demo.unzip
call :Input.path --exist --file zip_file
call :Input.path --directory destination_folder
echo=
call :unzip "!zip_file!" "!destination_folder!" && (
    echo Unzip successful
) || (
    echo Unzip failed
)
exit /b 0


rem ======================== function ========================

:unzip   zip_file  destination_folder
setlocal EnableDelayedExpansion
set "_zip_file=%~f1"
set "_dest_path=%~f2"
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
if not exist "!_dest_path!" md "!_dest_path!" || ( 1>&2 echo error: create folder failed & exit /b 2 )
> "unzip.vbs" (
    echo zip_file = WScript.Arguments(0^)
    echo dest_path = WScript.Arguments(1^)
    echo=
    echo set ShellApp = CreateObject("Shell.Application"^)
    echo set content = ShellApp.NameSpace(zip_file^).items
    echo ShellApp.NameSpace(dest_path^).CopyHere(content^)
)
cscript //nologo "unzip.vbs" "!_zip_file!" "!_dest_path!"
del /f /q "unzip.vbs"
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
echo    hash
echo        The algorithm of the hash. Possible values for HASH are:
echo            MD2, MD4, MD5, SHA1, SHA256, SHA384, SHA512
echo        This option is case-insensitive. By default, it is 'SHA1'.
echo=
echo ENVIRONMENT
echo    cd
echo        Affects the base path of input_file if relative path is given.
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    2:  - No known methods to perform the specified hash.
exit /b 0


:checksum.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.checksum
call :Input.path --exist --file file_path
call :Input.string checksum_type
call :checksum checksum "!file_path!" !checksum_type!
echo=
echo Checksum: !checksum!
exit /b 0


rem ======================== function ========================

:checksum   return_var  input_file  [hash]
set "%~1="
setlocal EnableDelayedExpansion EnableExtensions
set "_method="
set "_algorithm=%~3"
if not defined _algorithm set "_algorithm=sha1"
for %%a in (MD2 MD4 MD5 SHA1 SHA256 SHA384 SHA512) do (
    if /i "!_algorithm!" == "%%a" set "_method=certutil"
)
if not defined _method ( 1>&2 echo error: no known methods to perform hash '%~3' & exit /b 2 )
set "_result="
if "!_method!" == "certutil" (
    if "%~z2" == "0" (
        set "_result="
        if /i "!_algorithm!" == "MD2" set "_result=8350e5a3e24c153df2275c9f80692773"
        if /i "!_algorithm!" == "MD4" set "_result=31d6cfe0d16ae931b73c59d7e0c089c0"
        if /i "!_algorithm!" == "MD5" set "_result=d41d8cd98f00b204e9800998ecf8427e"
        if /i "!_algorithm!" == "SHA1" set "_result=da39a3ee5e6b4b0d3255bfef95601890afd80709"
        if /i "!_algorithm!" == "SHA256" (
            set "_result=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        )
        if /i "!_algorithm!" == "SHA384" for %%s in (
            38b060a751ac96384cd9327eb1b1e36a21fdb71114be0743
            4c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b
        ) do set "_result=!_result!%%s"
        if /i "!_algorithm!" == "SHA512" for %%s in (
            cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce
            47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
        ) do set "_result=!_result!%%s"
    ) else for /f "usebackq skip=1 tokens=*" %%a in (`certutil -hashfile "%~f2" !_algorithm!`) do (
        if not defined _result set "_result=%%a"
    )
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


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


rem ================================ check_ipv4() ================================

rem ======================== documentation ========================

:check_ipv4.__doc__
echo NAME
echo    check_ipv4 - check if a string is an IPv4
echo=
echo SYNOPSIS
echo    check_ipv4   input_string  [--wildcard]
echo=
echo POSITIONAL ARGUMENTS
echo    input_string
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
call :Input.string ip_address
echo=
call :check_ipv4 "!ip_address!" && (
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

:check_ipv4   input_string  [--wildcard]
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


rem ================================ expand_url() ================================

rem ======================== documentation ========================

:expand_url.__doc__
echo NAME
echo    expand_url - expands a given URL to several smaller pieces
echo=
echo SYNOPSIS
echo    expand_url   return_prefix  url
echo=
echo POSITIONAL ARGUMENTS
echo    return_prefix
echo        The prefix of the variable to store the results.
echo=
echo    link
echo        The string of the link to expand.
echo=
echo EXAMPLE
echo    url        https://blog.example.com:80/1970/01/news.html?page=1#top
echo    scheme     https
echo                    ://
echo    hostname           blog.example.com
echo                                       :
echo    port                                80
echo    path                                  /1970/01/
echo    filename                                       news
echo    extension                                          .html
echo                                                            ?
echo    query                                                    page=1
echo                                                                   #
echo    fragment                                                        top
echo=
echo NOTES
echo    - IPv6 URLs are not supported (yet).
echo    - The 'url' variable is the rebuild of the original url.
exit /b 0


:expand_url.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.expand_url
call :Input.string web_url || set "web_url=https://blog.example.com:80/1970/01/news.html?page=1#top"
call :expand_url web_url. "!web_url!"
set web_url
exit /b 0


rem ======================== demo ========================

:tests.lib.expand_url.main
for %%a in (
    "https://blog.example.com:80/1970/01/news.html?page=1#top"
) do (
    set "result="
    call :expand_url result. %%a
    if not "!result.url!" == "%%~a" call %unittest%.fail %%a
)
exit /b 0


rem ======================== function ========================

:expand_url   return_prefix  url
pushd "%~d0\"
for %%v in (url scheme host port path name ext query fragment) do set "%~1%%v="
for /f "tokens=1* delims=#" %%a in ("%~2") do (
    set "%~1fragment=%%b"
    for /f "tokens=1* delims=?" %%c in ("%%a") do (
        set "%~1query=%%d"
        set "%~1host=%%c"
        for /f "tokens=1* delims=:\/" %%e in ("%%c") do (
            if "%%e://%%f" == "%%c" (
                set "%~1scheme=%%e"
                set "%~1host=%%f"
            )
        )
        for /f "tokens=1* delims=\/" %%e in ("!%~1host!") do (
            set "%~1path= %%~pf"
            set "%~1path=!%~1path:\=/!"
            set "%~1path=!%~1path:~1!"
            set "%~1name=%%~nf"
            set "%~1ext=%%~xf"
            for /f "tokens=1* delims=:" %%g in ("%%e") do (
                set "%~1host=%%g"
                set "%~1port=%%h"
            )
        )
    )
)
popd
if defined %~1scheme set "%~1url=!%~1url!!%~1scheme!://"
set "%~1url=!%~1url!!%~1host!"
if defined %~1port set "%~1url=!%~1url!:!%~1port!"
set "%~1url=!%~1url!!%~1path!!%~1name!!%~1ext!"
if defined %~1query set "%~1url=!%~1url!?!%~1query!"
if defined %~1fragment set "%~1url=!%~1url!#!%~1fragment!"
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
set %~1install_requires=^
    ^ feature:PowerShell
exit /b 0


rem ======================== demo ========================

:demo.get_ext_ip
call :get_ext_ip ext_ip
echo=
echo External IP    : !ext_ip!
exit /b 0


rem ======================== function ========================

:get_ext_ip   return_var
for %%u in (
    "http://ipecho.net/plain"
    "http://ifconfig.me/ip"
) do for /f "usebackq delims=" %%o in (
    `powershell -Command "(New-Object Net.WebClient).DownloadString('%%~u')" 2^> nul`
) do (
    set "%~1=%%o"
    exit /b 0
)
exit /b 1


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
echo    2:  - Ping test failed.
exit /b 0


:ping_test.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.ping_test
call :Input.string host || set "host=google.com"
echo=
echo Ping: !host!
call :ping_test ping. !host! && (
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
if "!~1loss!" == "100" exit /b 2
exit /b 0


rem ================================ download_file() ================================

rem ======================== documentation ========================

:download_file.__doc__
echo NAME
echo    download_file - download file from the internet
echo=
echo SYNOPSIS
echo    download_file   download_url  save_path
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
echo    - Supports HTTP, HTTPS, FTP.
exit /b 0


:download_file.__metadata__   [return_prefix]
set %~1install_requires=^
    ^ feature:PowerShell
exit /b 0


rem ======================== demo ========================

:demo.download_file
echo For this demo, file will be saved to "!cd!"
echo Enter nothing to download the logo of Git (1.87 KB)
echo=
call :Input.string download_url || set "download_url=https://git-scm.com/images/logo.png"
call :Input.path --file --optional save_path || set "save_path=logo.png"
echo=
echo Download url:
echo=!download_url!
echo=
echo Save path:
echo=!save_path!
echo=
echo Downloading file...
call :download_file "!download_url!" "!save_path!" && (
    echo Download success
)|| echo Download failed
exit /b 0


rem ======================== function ========================

:download_file   download_url  save_path
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
call :get_con_size console_width console_height
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
rem Calling it from pipe will prevent this.

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
call :get_sid result
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
call :get_os result --name
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
call :get_pid result
call :difftime time_taken "!time!" "!start_time!"
echo Using random number
echo PID        : !result!
echo Time taken : !time_taken!
echo=

set "start_time=!time!"
for /f %%g in ('powershell -command "$([guid]::NewGuid().ToString())"') do call :get_pid result %%g
call :difftime time_taken "!time!" "!start_time!"
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
    call :watchvar --name
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
call :watchvar --initialize > "initialize"
for /l %%n in (1,1,%~1) do set "simulate.added.%%n=new"
for /l %%n in (1,1,%~2) do set "simulate.changed.%%n=changed"
for /l %%n in (1,1,%~3) do set "simulate.deleted.%%n="
call :watchvar > "changes"
for /f "usebackq tokens=1* delims=:" %%a in ("initialize") do (
    for /f "tokens=* delims= " %%c in ("%%b") do set "var_count=%%c"
)
for /f "usebackq tokens=1* delims=:" %%a in ("changes") do (
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
echo    2:  - No administrator privilege is detected.
exit /b 0


:is_admin.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.is_admin
call :is_admin && (
    echo Administrator privilege detected
) || echo No administrator privilege detected
exit /b 0


rem ======================== function ========================

:is_admin
( net session || openfiles || exit /b 2 ) > nul 2> nul
exit /b 0


rem ================================ capchar() ================================

rem ======================== documentation ========================

:capchar.__doc__
echo NAME
echo    capchar - capture control characters
echo=
echo SYNOPSIS
echo    capchar   "char1  [char2 [...]]"
echo=
echo POSITIONAL ARGUMENTS
echo    char
echo        The character to capture. See 'LIST OF CHARACTERS'
echo        and 'LIST OF MACROS' for list of valid options.
echo        Use '*' to capture all available characters and macros.
echo=
echo LIST OF CHARACTERS
echo    Var     Hex     Name
echo    ------------------------------
echo    BEL     07      Bell/Beep sound
echo    BS      08      Backspace
echo    TAB     09      Tab
echo    LF      0A      Line Feed
echo    CR      0D      Carriage Return
echo    ESC     1B      Escape
echo=
echo LIST OF MACROS
echo    Var     Description
echo    ------------------------------
echo    BASE    'Base' for SET /P so it can start with whitespace characters
echo    BACK    Delete previous character (in console)
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
call :capchar *
echo Hello^^!LF^^!World^^!CR^^!.
echo Clean^^!BS^^!r
echo %%DQ%%^|No^&Escape^|^^^<Characters^>^^
echo ^^!ESC^^![104;97m Windows 10 ^^!ESC^^![0m
< nul set /p "=^!BASE^! A Whitespace at front"
echo=
echo T^^!TAB^^!A^^!TAB^^!B
echo ======================== RESULT ========================
echo Hello!LF!World!CR!.
echo Clean!BS!r
echo %DQ%|No&Escape|^<Characters>^
echo !ESC![104;97m Windows 10 !ESC![0m
< nul set /p "=!BASE! A Whitespace at front"
echo=
echo T!TAB!A!TAB!B
exit /b 0


rem ======================== tests ========================

:tests.lib.capchar.main
for %%a in (
    "BEL: 07"
    "BS: 08"
    "TAB: 09"
    "LF: 0A"
    "CR: 0D"
    "ESC: 1B"
    "BASE: 5F 08 20 08"
    "BACK: 08 20 08"
    "DQ: 22 08 20 08"
    "NL: 5E 0A 0A 5E"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "%%b="
    call :capchar %%b
    echo [!%%b!] > "char"
    certutil -encodehex "char" "raw_hex" > nul
    set "size=2"
    for %%h in (%%c) do set /a "size+=1"
    set /a "size=!size! * 3 - 1
    set "hex="
    for /f "usebackq tokens=1*" %%d in ("raw_hex") do ( rem
    ) & for %%s in (!size!) do (
        set "hex=%%e"
        set "hex=!hex:~0,%%s!"
    )
    del /f /q "raw_hex"
    if /i not "!hex!" == "5b %%c 5d" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:capchar   "char1  [char2 [...]]"
setlocal EnableDelayedExpansion
rem NOTE: ORDER SENSITIVE, LEAST DEPENDENCY FIRST
for %%d in (
    "BEL"
    "CR"
    "LF"
    "BS"
    "TAB"
    "ESC"
    "BASE: BS"
    "BACK: BS"
    "DQ: BS"
    "NL: LF"
) do for /f "tokens=1* delims=:" %%e in (%%d) do (
    if "%~1" == "*" (
        set "%%e=true"
    ) else (
        set "%%e="
        for %%a in (%~1) do if /i "%%a" == "%%e" (
            for %%c in (%%e %%f) do set "%%c=true"
        )
    )
)
endlocal & (
if /i "%BEL%" == "true" for /f "usebackq delims=" %%a in (
    `forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo 0x07"`
) do set "BEL=%%a"
if /i "%CR%" == "true" for /f %%a in ('copy /z "%ComSpec%" nul') do set "CR=%%a"
if /i "%LF%" == "true" set LF=^
%=REQUIRED=%
%=REQUIRED=%
if /i "%BS%" == "true" for /f %%a in ('"prompt $H & for %%b in (1) do rem"') do set "BS=%%a"
if /i "%TAB%" == "true" for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
if /i "%ESC%" == "true" for /f %%a in ('"prompt $E & for %%b in (1) do rem"') do set "ESC=%%a"
if /i "%BASE%" == "true" set "BASE=_!BS! !BS!"
if /i "%BACK%" == "true" set "BACK=!BS! !BS!"
if /i "%DQ%" == "true" set DQ="!BS! !BS!
if /i "%NL%" == "true" set "NL=^^!LF!!LF!^^"
)
exit /b 0


rem ======================== notes ========================

rem New Line (DisableDelayedExpansion)
set ^"NL=^^^%LF%%LF%^%LF%%LF%^"

rem Other characters
set DQ="
set "EM=^!"
set EM=^^!

rem ================================ clear_line_macro() ================================

rem ======================== documentation ========================

:clear_line_macro.__doc__
echo NAME
echo    clear_line_macro - create a macro to clear current line
echo=
echo SYNOPSIS
echo    clear_line_macro   return_var
echo    echo ^^!CL^^![text]
echo    ^< nul set /p "=^!CL^![text]"
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the macro. By default, it is 'CL'.
echo=
echo NOTES
echo    - Based on: get_con_size(), get_os()
echo    - Text should not reach the end of the line.
exit /b 0


:clear_line_macro.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ capchar
exit /b 0


rem ======================== demo ========================

:demo.clear_line_macro
rem Satisfy dependencies
call :capchar CR BACK

call :clear_line_macro
echo=
echo First test: end of the line not reached
< nul set /p "=Press any key to clear this line"
for /l %%n in (34,1,!console_width!) do < nul set /p "=."
pause > nul
< nul set /p "=!CL!Line cleared"
echo=
echo=
echo Second test: end of the line reached, failure expected
< nul set /p "=Press any key to clear this line"
for /l %%n in (33,1,!console_width!) do < nul set /p "=."
pause > nul
< nul set /p "=!CL!Did it fail?"
exit /b 0


rem ======================== function ========================

:clear_line_macro   return_var
setlocal EnableDelayedExpansion
set "_index=0"
for /f "usebackq tokens=2 delims=:" %%a in (`call ^| mode con`) do (
    set /a "_index+=1"
    if "!_index!" == "2" set /a "_width=%%a"
)
for /f "tokens=4 delims=. " %%w in ('ver') do (
    endlocal
    for /f "tokens=1 delims==" %%v in ("%~1=CL") do (
        set "%%v="
        if %%w GEQ 10 (
            for /l %%n in (1,1,%_width%) do set "%%v=!%%v! "
            set "%%v=_!CR!!%%v!!CR!"
        ) else for /l %%n in (1,1,%_width%) do set "%%v=!%%v!!BACK!"
    )
)
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
call :is_echo_on && (
    echo Echo is on
) || echo Echo is off
exit /b 0


rem ======================== function ========================

:is_echo_on
@(
    ( for %%n in (1) do call ) > "%temp%\result"
    for %%f in ("%temp%\result") do @if "%%~zf" == "0" @exit /b 1
) > nul 2>&1
@exit /b 0


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
call :Input.string hexadecimal_color
call :color2seq color_code "!hexadecimal_color!"
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

call :Input.string text
call :Input.string hexadecimal_color
echo=
call :color_print "!hexadecimal_color!" "!text!" && (
    echo !LF!Print Success
) || echo !LF!Print Failed. Characters not supported, or external error occured
exit /b 0


rem ======================== function ========================

:color_print   color  text
2> nul (
    pushd "!temp_path!" || exit /b 1
     < nul set /p "=!BACK!!BACK!" > "%~2_"
    findstr /l /v /a:%~1 "." "%~2_" nul
    del /f /q "%~2_" > nul
    popd
)
exit /b 0


rem ================================ module ================================

rem ======================== documentation ========================

:module.__doc__
echo Module Framework
echo=
echo DESCRIPTION
echo    module framework allows commands to be executed inside the target script.
echo    In other words, the script can run codes or call function of another script
echo    as if they exist in the caller's file (with some limitation). This also
echo    enable scripts to have multiple entry points. A common example is to use
echo    module framework to start multiple batch script windows.
echo=
echo LIMITATIONS
echo    There are some limitations due to the behavior of batch script.
echo    For completeness, known strange behaviors are listed below:
echo        1. GOTO context hack behaves strangely, specific details for this
echo           behavior is still unknown (but it breaks parse_args() when it is
echo           when used as an external function)
echo        2. Parameters 'decay'. Each time it is passed around, the amount of
echo           special characters decreases (usually by half). The usage of
echo           exclamation mark in parameters is also troublesome; it might be
echo           fully gone on the second pass.
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
echo Demo is unavailable. Please try demo of each sub function instead.
exit /b 0


:module
rem Module Framework
exit /b 0


rem ============================ .entry_point() ============================

rem ======================== documentation ========================

:module.entry_point.__doc__
echo NAME
echo    module.entry_point - interpret command and exits
echo=
echo DESCRIPTION
echo    Reads the argument to determine whether script needs to execute code
echo    on start. Used for run codes or call function of another script.
echo=
echo SYNOPSIS
echo    module.entry_point   [-c command]
echo=
echo OPTIONS
echo    -c COMMAND
echo        Specify the command to execute. Exit code will be preserved upon exit.
echo        If this option is not set, the function will 'GOTO __main__'.
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
echo    - CALL must be used to execute this function, GOTO will quit immediately.
exit /b 0


:module.entry_point.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.module.entry_point
echo Press any key to start another window...
pause > nul
@echo on
start "" /i cmd /c ""%~f0" -c call :scripts.2nd_window_demo   test "arg" Here"
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
> "template" (
    call :extract_func "%~f0" "tests.lib.module.entry_point.test_template" 1,-3
)
> "test_entry_point.bat" (
    call :textrender "template"
)

call :capchar LF
set test_cases= ^
    ^ "no args"         :main:      !LF!^
    ^ "quoted -c"       :main:      "-c" call :scripts.second !LF!^
    ^ "second module"   :second:    -c call :scripts.second
for /f "tokens=*" %%a in ("!test_cases!") do ( rem
) & for /f "tokens=1-2* delims=:" %%b in ("%%a") do (
    set "entry_point="
    call "test_entry_point.bat" %%d
    set "exit_code=!errorlevel!"
    if not "!entry_point!/!exit_code!" == ":scripts.%%c/!expected_exit_code!" (
        echo "!entry_point!/!exit_code!" == ":scripts.%%c/!expected_exit_code!"
        call %unittest%.fail "call %%~b"
    )
)
for %%a in (
    "hello"
) do (
    set "text="
    call "test_entry_point.bat" -c set "text=%%a"
    if not "!text!" == "%%a" (
        call %unittest%.fail "set %%a"
    )
)
exit /b 0
#+++

:tests.lib.module.entry_point.test_template
- extract "__init__ module.entry_point"

``` batchfile ~4
``  :__main__
``  @call :scripts.main %*
``  @exit /b
``
``
``  :scripts.main
``  :scripts.second
``  goto capture_args
``
``
``  :capture_args
``  set "entry_point=%~0"
``  set args=%*
``  set "expected_exit_code=%random%"
``  exit /b %expected_exit_code%
``
``
```
exit /b 0


rem (!) Create unittest for Linux EOL


rem ======================== function ========================

:module.entry_point   [-c command]
:module.entry_point.alt1
:module.entry_point.alt2
@if /i not "%~1" == "-c" @( goto 2> nul & goto __main__ )
@if /i #%1 == #"%~1" @( goto 2> nul & goto __main__ )
@(
    goto 2> nul
    setlocal DisableDelayedExpansion
    call set command=%%*
    setlocal EnableDelayedExpansion
    for /f "tokens=1* delims== " %%a in ("!command!") do @(
        endlocal
        endlocal
        %%b
        exit /b
    )
    exit /b 1
)
@exit /b 1


rem ======================== legacy support ========================
rem If you need legacy support for transitioning, here is the codes:
rem A working example of this is implemented at batchlib 2.1-a.30

rem Insert this line at first line of the function (exactly below module.entry_point.alt2)
@if /i "%~1" == "--module" @( goto 2> nul & goto module.entry_point._legacy )

rem Don't forget to put all of these below the function
:module.entry_point._legacy   [--module=<name>]  [args]
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
#+++

:scripts.lib
@rem The legacy entry point to call functions
@call :%*
@exit /b
goto module.entry_point
#+++

:metadata
@rem The legacy name of __metadata__()
call :__metadata__ %1
exit /b 0


rem ============================ .make_context() ============================

rem ======================== documentation ========================

:module.make_context.__doc__
echo NAME
echo    module.make_context - create context to execute code in another script
echo=
echo SYNOPSIS
echo    module.make_context   return_var  script_path  [command]
echo=
echo DESCRIPTION
echo    Creates a variable that contains code to call function from another script
echo    and setup other necessary information such as absolute path of the script.
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the result.
echo=
echo    script_path
echo        Path of the script file. If this is not specified, it will make the
echo        current script as the context.
echo=
echo    command
echo        The command to execute.
exit /b 0


:module.make_context.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.module.make_context
call :Input.string context_name
call :Input.path --exist --file --optional script_path
call :Input.string command
echo=
call :module.make_context !context_name! "!script_path!" "!command!"
echo=
set "!context_name!"
exit /b 0


rem ======================== tests ========================

:tests.lib.module.make_context.main
call :module.make_context script
if not "!script!@!script.abspath!" == " @%~f0" (
    call %unittest%.fail "self context"
)
for %%a in (
    "C:\asd"
    "C:\asd#call "
) do for /f "tokens=1* delims=#" %%b in (%%a) do (
    call :module.make_context script %%b "%%c"
    set expected="%%b" -c %%c
    if not "!script!@!script.abspath!" == "!expected!@%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:module.make_context   return_var  script_path  [command]
if "%~2" == "" (
    set "%~1.abspath=%~f0"
    set "%~1= "
) else (
    set "%~1.abspath=%~f2"
    set %~1="%~f2" -c %~3
)
exit /b 0


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
call :Input.path --file --exist --optional script_to_check || (
    set "script_to_check=%~f0"
)
call :module.is_module "!script_to_check!" || (
    echo Script does not support call as module
    echo Please choose another script that supports call as module
    exit /b 0
)
echo=
echo Script:
echo !script_to_check!
echo=
echo Metadata:
call :module.read_metadata script. "!script_to_check!"
set "script."
exit /b 0


rem ======================== tests ========================

:tests.lib.module.read_metadata.main
(
    call :extract_func "%~f0" " __init__ module.entry_point"
    echo :__metadata__   [return_prefix]
    echo set "%%~1name=hello"
    echo exit /b 0
    echo=
    echo=
) > "test.bat"
call :module.read_metadata result. "test.bat"
if not "!result.name!" == "hello" (
    call %unittest%.fail "simple"
)
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
call "%~2" -c call :__metadata__ "%~1" || exit /b 1
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
echo    - __init__()
echo    - module.entry_point()
echo    - __metadata__()
echo=
echo    This could prevent script from calling another batch file that does not
echo    contain the module() framework and cause undesired results. Please note
echo    that this function does not prevent execution of arbitrary code.
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
call :Input.path --optional script_to_check || (
    set "script_to_check=%~f0"
)
echo=
echo Script:
echo !script_to_check!
echo=
call :module.is_module "!script_to_check!" && (
    echo Script supports call as module
) || echo Script does not support call as module
exit /b 0


rem ======================== tests ========================

:tests.lib.module.is_module.main
(
    call :extract_func "%~f0" " __init__ module.entry_point"
    echo :__metadata__   [return_prefix]
    echo set "%%~1name=hello"
    echo exit /b 0
    echo=
    echo=
) > "missing_0.bat"
call :module.is_module "missing_0.bat" || (
    call %unittest%.fail "missing_0.bat"
)
exit /b 0


rem ======================== function ========================

:module.is_module   input_file
setlocal EnableDelayedExpansion
set /a "_missing=0x7"
for /f "usebackq tokens=1" %%a in ("%~f1") do (
    if /i "%%a" == ":__init__" set /a "_missing&=~0x1"
    if /i "%%a" == ":module.entry_point" set /a "_missing&=~0x2"
    if /i "%%a" == ":__metadata__" set /a "_missing&=~0x4"
)
if not "!_missing!" == "0" exit /b 1
set "_callable="
for %%x in (.bat .cmd) do if "%~x1" == "%%x" set "_callable=true"
if not defined _callable exit /b 2
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
> "labels" (
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
call :capchar LF
set test_cases= ^
    ^ 13:   -f "labels" !LF!^
    ^ 13:   -f "labels" -p "*" !LF!^
    ^ 9:    -f "labels" -p "tests.*" !LF!^
    ^ 9:    -f "labels" -p "*.main" !LF!^
    ^ 7:    -f "labels" -p "tests.*.main" !LF!^
    ^ 7:    -f "labels" -p "*o*" !LF!^
    ^ 2:    -f "labels" -p "*$*" !LF!^
    ^ 0:    -f "labels" -p ""
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
echo    extract_func   script_path  labels  [skip_lines]  [read_lines]
echo=
echo POSITIONAL ARGUMENTS
echo    input_file
echo        Path of the input (batch) file.
echo=
echo    labels
echo        The function labels to extract. The syntax is "label1 [...]".
echo=
echo    skip_lines
echo        Skip N number of lines for each function. For example, if the value
echo        is set to 1, it will skip the function label. By default, it is 0.
echo=
echo    read_lines
echo        Number of lines to read. If this argument is not specified, it
echo        will read all lines of the function. If the value is set to a
echo        negative number, it will skip the last N lines of the function.
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
echo    2:  - Some labels are not found.
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
call :Input.string function_labels || set "function_labels=extract_func"
echo=
call :extract_func "%~f0" "!function_labels!" && (
    echo Extract successful
) || echo Extract failed
exit /b 0


rem ======================== tests ========================

:tests.lib.extract_func.main
for %%a in (
    "9f54cd14729a19602a5c1c277f92d1d736b2cb1c: special_characters"
    "c75df2b1ef6fe5c363c7b1d2756cef16beb35e29: join_mark"
    "3a6e3b917948a418251d2286c6a4ab8e77e9c007: comments: 2"
    "890e953fc6fa33a61d3f3d2f2dd41511787a58c7: comments: 0, 4"
    "890e953fc6fa33a61d3f3d2f2dd41511787a58c7: comments: 0, -2"
    "da39a3ee5e6b4b0d3255bfef95601890afd80709: comments: 10, 0"
    "da39a3ee5e6b4b0d3255bfef95601890afd80709: comments: 0, -10"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    set "params="
    for %%e in (%%c) do set "params=!params! tests.assets.dummy_func.%%e"
    call :extract_func "%~f0" "!params!" %%d > "extracted" 2> nul
    call :checksum result "extracted"
    if not "!result!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


rem ======================== function ========================

:extract_func   script_path  labels  [skip_lines]  [read_lines]
setlocal EnableDelayedExpansion EnableExtensions
set "_source_file=%~f1"
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "_to_extract= %~2 "
set /a "_skip_top=%~3 + 0"
set "_read_lines="
set "_exclude_lines=0"
if not "%~4" == "" (
    set /a "_read_lines=%~4"
    if !_read_lines! LSS 0 (
        set "_read_lines="
        set /a "_exclude_lines=%~4"
    )
)
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
                    set /a "_start=%%n-1 + !_skip_top!"
                    if defined _read_lines set /a "_max_end=!_start! + !_read_lines!"
                )
                set "_not_found=!_not_found: %%c = !"
            )
        )
    )
    if defined _label if not defined _end (
        if not "%%n" == "!_expected_index!" set "_signal="
        set "_mark="
        if not defined _line set "_mark=EOL"
        if "!_line!" == "#+++" set "_mark=JOIN"
        if defined _mark (
            set "_signal=!_signal! !_mark!"
            for %%p in (
                " EOL EOL"
            ) do if "!_signal!" == %%p set "_mark=END"
            if "!_mark!" == "END" (
                set /a "_end=%%n + !_exclude_lines!"
                if defined _max_end (
                    if !_end! GTR !_max_end! set "_end=!_max_end!"
                )
            )
        ) else set "_signal="
        set /a "_expected_index=%%n+1"
    )
    if defined _label if defined _end (
        for %%l in (!_label!) do (
            if !_start! LSS !_end! (
                for %%n in (!_start!:!_end!) do set "_label_ranges=!_label_ranges: %%l = %%n !"
            ) else set "_label_ranges=!_label_ranges: %%l = !"
            for %%v in (_label _start _end _max_end) do set "%%v="
        )
    )
)
if defined _label for %%l in (!_label!) do (
    for %%n in (!_start!) do set "_label_ranges=!_label_ranges: %%l = %%n: !"
)
set "_leftover=!_not_found: =!"
if defined _leftover ( 1>&2 echo warning: label not found: !_not_found! )
for %%l in (!_not_found! !_joins!) do set "_label_ranges=!_label_ranges: %%l = !"
for %%a in (!_label_ranges!) do for /f "tokens=1-2 delims=:" %%b in ("%%a") do (
    call :extract_func._extract %%b %%c
)
del /f /q "numbered"
if defined _leftover exit /b 2
exit /b 0
#+++

:extract_func._extract   start  end
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


rem ================================ desolve() ================================

rem ======================== documentation ========================

:desolve.__doc__
echo NAME
echo    desolve - function dependency resolver
echo=
echo SYNOPSIS
echo    desolve   return_var  base_context  "[context:]label [...]"
echo=
echo DESCRIPTION
echo    This function generates dependency list of a function recursively.
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
echo EXIT STATUS
echo    0:  - Success.
echo    2:  - Cyclic dependencies detected.
echo        - Namespace error / not defined.
echo        - Failed to resolve dependency of a (sub)module.
exit /b 0


:desolve.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.desolve
call :Input.string function_name || set "function_name=unittest"
echo=
echo Function: !function_name!
echo=
call :desolve result  batchlib !function_name!
echo Dependencies: !result!
exit /b 0


rem ======================== tests ========================

:tests.lib.desolve.main
call :extract_func "%~f0" ^
    ^ ^"__init__ ^
    ^   module.entry_point ^" ^
    ^ > "base"

set "modules=alpha bravo charlie"
set "alpha.functions=one two three four five"
set "alpha.one.install_requires=four"
set "alpha.two.install_requires=three"
set "alpha.three.install_requires=four"
set "alpha.four.install_requires="
set "alpha.five.install_requires=bravo:one"
set "bravo.functions=one"
set "bravo.one.install_requires=alpha:four"
set "charlie.functions=one two three"
set "charlie.one.install_requires=two"
set "charlie.two.install_requires=charlie:one"
set "charlie.three.install_requires=charlie:three"
for %%m in (!modules!) do (
    call :module.make_context %%m "%%m.bat" "call "
    > "!%%m.abspath!" (
        type "base"
        for %%f in (!%%m.functions!) do (
            echo :%%f.__metadata__
            echo set "%%~1install_requires=!%%m.%%f.install_requires!"
            echo exit /b 0
            echo=
            echo=
        )
    )
)

set "test_cases=mutual multi cyclic_sub cyclic_self non_existing"
set "mutual.resolve=alpha:one alpha:two"
set "mutual.expected=alpha:one alpha:two alpha:three alpha:four"
set "multi.resolve=alpha:five"
set "multi.expected=alpha:five bravo:one alpha:four"
set "cyclic_sub.resolve=charlie:one"
set "cyclic_sub.expected="
set "cyclic_self.resolve=charlie:three"
set "cyclic_self.expected="
set "non_existing.resolve=charlie:four"
set "non_existing.expected="

for %%c in (!test_cases!) do (
    set "expected=!%%c.expected!"
    if defined expected (
        set "_temp=!expected!"
        set "expected= "
        for %%b in (!_temp!) do set "expected=!expected!%%b "
    )
    call :desolve result batchlib "!%%c.resolve!" 2> nul
    if not "!result!" == "!expected!" (
        call %unittest%.fail "%%c dependency check failed"
    )
)
exit /b 0


rem ======================== function ========================

:desolve   return_var  base_context  "[context:]label [...]"
setlocal EnableDelayedExpansion
set "_base_module=%~2"
set "_visited= "
set "_stack= "
set "install_requires=%~3"
call :desolve._resolve !_params! || set "_visited="
for /f "tokens=1*" %%a in ("Q !_visited!") do (
    endlocal
    set "%~1=%%b"
    if defined %~1 (
        set "%~1= !%~1!"
    ) else exit /b 2
)
exit /b 0
#+++

:desolve._resolve
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
        ( 1>&2 echo error: cyclic dependencies detected '%%b:%%c' in stack: !_stack! & exit /b 1 )
    )
    set "_stack= %%b:%%c!_stack!"
    set "_module=%%b"
    set "_context=!%%b!"
    set "_label=%%c"
    if not defined _context ( 1>&2 echo error: context for module '%%b' is not defined & exit /b 1 )
    call :desolve._read_metadata || (
        ( 1>&2 echo error: cannot resolve dependency '%%b:%%c' in stack: !_stack! & exit /b 1 )
    )
    if defined install_requires call :desolve._resolve || exit /b 1
    if "!_visited: %%a =!" == "!_visited!" set "_visited= %%a!_visited!"
    for /f "tokens=1* delims= " %%a in ("!_stack!") do set "_stack= %%b"
)
exit /b 0
#+++

:desolve._read_metadata
set "install_requires="
call %_context%:%_label%.__metadata__ || exit /b 1
exit /b 0


rem ================================ collect_func() ================================

rem ======================== documentation ========================

:collect_func.__doc__
echo NAME
echo    collect_func - extract functions in a given namespace/context
echo=
echo SYNOPSIS
echo    collect_func  "context:label [...]"
echo=
echo DESCRIPTION
echo    This function extracts functions from multiple module files. Function
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
echo    2:  - Label conflict detected
echo        - Namespace abspath not defined.
echo    3:  - Some labels are not found.
exit /b 0


:collect_func.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.collect_func
call :Input.string function_name || set "function_name=batchlib:collect_func"
echo=
echo Function: !function_name!
echo=
call :collect_func "!function_name!"
exit /b 0


rem ======================== tests ========================

:tests.lib.collect_func.main
call :module.make_context batchlib "%~f0" "call "
call :module.make_context dummy "dummy.bat" "call "
set test_args= ^
    ^ ^"0172e420b1fb0a0dd1de5d5a9d8f03f49dad8b30: ^
    ^       batchlib:join_mark ^
    ^       dummy:special_characters ^"
for %%a in (!test_args!) do ( rem
) & for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "params="
    set "_dummy_extract="
    for %%d in (%%c) do ( rem
    ) & for /f "tokens=1* delims=:" %%e in ("%%d") do (
        set "params=!params! %%e:tests.assets.dummy_func.%%f"
        if "%%e" == "dummy" set "_dummy_extract=!_dummy_extract! tests.assets.dummy_func.%%f"
    )
    call :extract_func "%~f0" "!_dummy_extract!" > "!dummy.abspath!"
    call :collect_func "!params!" > "extracted"
    call :checksum result "extracted"
    if not "!result!" == "%%b" (
        call %unittest%.fail "extraction failed: %%b"
    )
)
exit /b 0


rem ======================== function ========================

:collect_func  "context:label [...]"
setlocal EnableDelayedExpansion
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "_raw_extract_order=%~1"
set "_to_extract= "
set "_extract_order= "
for %%a in (!_raw_extract_order!) do for /f "tokens=1-2 delims=:" %%b in ("%%a") do (
    if "!_to_extract: %%b:'=!" == "!_to_extract!" (
        if not defined %%b.abspath (
            ( 1>&2 echo error: module '%%b' abspath not defined & exit /b 2 )
        )
        set "_to_extract=!_to_extract!%%b:' ' "
    )
    if not "!_to_extract: %%c =!" == "!_to_extract!" (
        ( 1>&2 echo error: label conflict detected: '%%c' & exit /b 2 )
    )
    set "_to_extract=!_to_extract: %%b:' = %%b:' %%c !"
    set "_extract_order=!_extract_order!%%c "
)
set _to_extract=!_to_extract:'="!
> "unsorted" (
    for %%a in (!_to_extract!) do ( rem
    ) & for /f "tokens=1* delims=:" %%b in ("%%a") do (
        call :extract_func "!%%b.abspath!"  %%c 2> nul
    )
)
call :extract_func "unsorted" "!_extract_order!" || exit /b 3
exit /b 0


rem ================================ textrender() ================================

rem ======================== documentation ========================

:textrender.__doc__
echo NAME
echo    textrender - text renderer for batch script
echo=
echo SYNOPSIS
echo    textrender   template_file  [renderer]
echo=
echo DESCRIPTION
echo    This function render template files.
echo=
echo POSITIONAL ARGUMENTS
echo    template_file
echo        Path of the template file.
echo=
echo    renderer
echo        The function name of the renderer.
echo        By default, it is 'textrender.renderer'
echo=
echo TEMPLATE SYNTAX
echo    Each line represents a command to execute. Syntax for template is designed
echo    to be somewhat similar to and compatible with markdown, with some modifications to
echo    simplify parsing and improve interoperability within script (e.g.: with no
echo    modifications in syntax, labels in
echo    template might be interpreted as an actual label in the script).
echo    These are the list of syntax (or supported markdown):
echo=
echo        COMMAND [args]
echo            Command to be executed by the renderer.
echo=
echo        - COMMAND  [args]
echo            Multi-line command and for listing commands in markdown.
echo            This is the preferred syntax for renderer commands.
echo=
echo        [comment] your comment here
echo        [comment]: # (your comment here)
echo            Write comments in template. The 2nd one is preferred because
echo            it is also compatible in markdown.
echo=
echo        ``` [NAME] [FILTER]
echo        your code here...
echo        ```
echo            Mark text as blocks of code. Texts in these section are ouput
echo            exactly as seen in the text editor. When substring filter is
echo            applied, the result of each line will be the substring of the line.
echo            (e.g.: if filter is "~3,-1", the first 3 and last 1 characters are
echo            removed from each line in the block). Currently the name have no
echo            effect and only exist there to specify language of code in markdown.
echo=
echo    Empty lines does not do anything, except when it is surrounded by
echo    triple back-ticks.
echo=
echo RENDERER COMMANDS
echo    Each line represents a command to execute. The first word represents the
echo    name of the function to call. The built-in renderer for templates is
echo    textrender.renderer() and this is the list of the renderer commands:
echo=
echo        ## heading 2 text
echo        ### heading 3 text
echo            The text of the heading. Note: it does not remove closing hashtags.
echo=
echo        extract "label [label [...]]"
echo            Label names to extract for rendering template.
echo=
echo    Variables can be used in commands.
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    2:  - Template rendering error.
exit /b 0


:textrender.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ extract_func
exit /b 0


rem ======================== demo ========================

:demo.textrender
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "label_name=tests.lib.textrender.example"
set "variable_label=tests.assets.dummy_func.comments"
echo=
echo Label: !label_name!
echo=
echo Variables:
set "variable_label"
echo=
echo Template:
call :extract_func "%~f0" "!label_name!" 1 -3 > "template"
type "template"
echo=
echo Result:
call :textrender "template"
exit /b 0


rem ======================== tests ========================

:tests.lib.textrender.main
set "variable_label=tests.assets.dummy_func.comments"

for %%a in (
    "6b7e4619bff1ce714b7180a97d05be79c3b017ac: tests.lib.textrender.example"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    call :extract_func "%~f0" "%%c" 1 -3 > "template"
    call :textrender "template" > "result"
    call :checksum result "result"
    if not "!result!" == "%%b" (
        call %unittest%.fail "render failed: %%b"
    )
)
exit /b 0


:tests.lib.textrender.example
## Welcome to batch script

### Block of codes
```
- extract "nothing"
because it is in a code block!
```
### Block of codes with filter
``` text ~4
::  This line will be literally written as-is,
::  without the first 4 characters.     ^^^^^
```
[comment]: # (Make three empty lines)
``` text ~4
::
::
::
```
### Call Renderer Functions
- extract
    "tests.assets.dummy_func.comments
     tests.assets.dummy_func.special_characters"
- extract "!variable_label!"
exit /b 0


rem ======================== function ========================

:textrender   template_file  [renderer]
setlocal EnableDelayedExpansion EnableExtensions
set "_source_file=%~f1"
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
if "%~2" == "" (
    set "_renderer=textrender.renderer"
) else set "_renderer=%~2"
findstr /n "^^" "!_source_file!" > "numbered"
setlocal DisableDelayedExpansion
set "_literal_mode="
set "_cmd="
for /f "usebackq tokens=*" %%o in ("numbered") do (
    set "_line=%%o"
    set "_continue="
    setlocal EnableDelayedExpansion
    set "_line=!_line:*:=!"
    set "_op="
    if not defined _op if "!_line:~0,3!" == "```" set "_op=backquote"
    if not defined _op if defined _literal_mode set "_op=literal"
    if not defined _op if not defined _line if not defined _cmd set "_op=pass"
    if not defined _op if not defined _line if defined _cmd set "_op=cmd_exec_on_blank"
    if not defined _op if "!_line:~0,2!" == "- " set "_op=cmd_new_multiline"
    if not defined _op if defined _line if defined _cmd set "_op=cmd_append"
    if not defined _op if "!_line:~0,9!" == "[comment]" set "_op=pass"
    if not defined _op set "_op=exec_line"

    if "!_op!" == "backquote" (
        if defined _cmd call :textrender._renderer_exec || exit /b 2
        if defined _literal_mode (
            set "_literal_mode="
        ) else (
            set "_literal_mode=~0"
            for /f "tokens=2 delims=` " %%a in ("!_line!") do set "_literal_mode=%%a"
        )
        for %%s in ("!_literal_mode!") do (
            endlocal
            set "_cmd="
            set "_literal_mode=%%~s"
        )
    )
    if "!_op!" == "literal" (
        set "_line=!_line! "
        for %%a in ("!_literal_mode!") do set "_line= !_line:%%~a!"
        echo(!_line:~1,-1!
        endlocal
    )
    if "!_op!" == "cmd_new_multiline" (
        if defined _cmd (
            call :textrender._renderer_exec || exit /b 2
        )
        set "_cmd=!_line:~2!"
        for /f "tokens=*" %%a in ("!_cmd!") do (
            endlocal
            set "_cmd=%%a"
        )
    )
    if "!_op!" == "cmd_append" (
        for /f "tokens=*" %%a in ("!_cmd! !_line!") do (
            endlocal
            set "_cmd=%%a"
        )
        set "_continue=true"
    )
    if "!_op!" == "cmd_exec_on_blank" (
        call :textrender._renderer_exec || exit /b 2
        endlocal
        set "_cmd="
    )
    if "!_op!" == "exec_line" (
        set "_cmd=!_line!"
        call :textrender._renderer_exec || exit /b 2
        endlocal
    )
    if "!_op!" == "pass" (
        endlocal
    )
)
if defined _cmd call :textrender._renderer_exec || exit /b 2
exit /b 0
#+++

:textrender._renderer_exec
call :%_renderer%.%_cmd% || exit /b 1
exit /b 0
#+++

:textrender.renderer.extract   labels
call :extract_func "%~f0" %* || exit /b 1
exit /b 0
#+++

:textrender.renderer.##   heading
echo rem ======================================== %* ========================================
echo=
exit /b 0
#+++

:textrender.renderer.###   heading
echo rem ================================ %* ================================
echo=
exit /b 0


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
echo        except for the no Epoch support. For more information see version scheme
echo        section. If the version is undefined, it is assumed to be '0'.
echo=
echo VERSION SCHEME
echo                                [N^^!]N(.N)*[{a^|b^|rc}N][.postN][.devN]
echo    Repr  ^| Segment
echo    F       Epoch               [N^^!]
echo    E       Release                 N(.N)*
echo    B       Pre-release                   [{a^|b^|rc}N]
echo    D       Post-release                             [.postN]
echo    A       Development release                              [.devN]
echo    C       End of string
echo=
echo    Although the Epoch segment in version is not supported, but it still have
echo    its own internal representation in the result string.
echo    The 'Repr' column is the internal representation of the version.
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
echo    2:  - Invalid version.
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
call :Input.string version1
call :Input.string version2
call :Input.string comparison || set "comparison=LSS"
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
    "F000C: "
    "F000C: 0"
    "F000C: 0.0"
    "F000E001C: 1"
    "F000E001C: 1.0"
    "F000E001C: 1.0.0"

    "F000A000C: .dev"
    "F000A000C: _dev"
    "F000A000C: -dev"
    "F000A001C: dev1"
    "F000A001C: dev.1"

    "F000Ba000C: .a"
    "F000Ba000C: _a"
    "F000Ba000C: -a"
    "F000Ba001C: a1"
    "F000Ba001C: a.1"

    "F000D000C: .r"
    "F000D000C: _r"
    "F000D000C: -r"
    "F000D001C: r1"
    "F000D001C: r.1"

    "F000A000C: dev"
    "F000Ba000C: a"
    "F000Ba000C: alpha"
    "F000Bb000C: b"
    "F000Bb000C: beta"
    "F000Bc000C: c"
    "F000Bc000C: rc"
    "F000Bc000C: pre"
    "F000Bc000C: preview"
    "F000D000C: r"
    "F000D000C: rev"
    "F000D000C: post"

    "F000A001C: dev1"
    "F000Ba002C: a2"
    "F000Bb003C: b3"
    "F000Bc004C: c4"
    "F000D005C: r5"

    "F000C+A: +"
    "F000C+Aa: +a"
    "F000C+A2a: +2a"
    "F000C+B0000000000: +0"

    "F000E001E002C: 1.2"
    "F000E001E002E003C: 1.2.3"
    "F000E001E002E003E004C: 1.2.3.4"

    "F000E001E000E003C: 1.0.3"
    "F000E001E000E000E004C: 1.0.0.4"

    "F000E001E000E002Ba000C+A123abc: 1.0.2a+123abc"
    "F000E001Ba000D000A000C+A: 1.0.0a.post.dev+"
    "F000E001E000E002Ba003D004A005C+B0000000001: 1.0.2-a3.post4.dev5+1"
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
    set /a "_evaluated=!_number!" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
    set /a "_number=!_evaluated!" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
    set "_number=000!_number!"
    set "_number=!_number:~-3,3!"
    if not "!_type!" == "E" set "_buffer="
    set "_buffer=!_buffer!!_type!!_number!"
    if not "!_type!,!_number!" == "E,000" (
        set "_result=!_result!!_buffer!"
        set "_buffer="
    )
)
set "_result=F000!_result!C"
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
        if not "!_temp!" == "_" ( 1>&2 echo error: invalid local version identifier & exit /b 2 )

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


rem ============================ updater() ============================

rem ======================== documentation ========================

:updater.__doc__
echo NAME
echo    updater - update a batch script from the internet
echo=
echo SYNOPSIS
echo    updater   return_prefix  script_path  [-V]  [-u]  [-d url]
echo=
echo DESCRIPTION
echo    This function can detect updates, download them, and update the script.
echo    The 'download_url' in __metadata__() needs to be added.
echo=
echo POSITIONAL ARGUMENTS
echo    return_prefix
echo        Prefix of the variable to store the metadata (if exit code is 0)
echo=
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
echo=
echo NOTES
echo    - Do not set your script version to '0.dev0' equivalent values.
echo      Your script will unconditionally fail the unittest.
echo    - Undefined script version is allowed.
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    2:  - No update is available.
echo    3:  - Failed to retrive module information.
echo    4:  - Failed to download update.
echo    5:  - Failed to retrive update information.
echo    6:  - Module name does not match.
echo    7:  - Upgrade failed.
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
call :updater update. "%~f0" || exit /b 0
call :diffdate update_age !date:~4! !update.release_date!
echo !update.description! !update.version! is now available (!update_age! days ago^)
echo=
echo Note:
echo - Updating will REPLACE current script with the newer version
echo=
call :Input.yesno user_input --message "Update now? Y/N? " || exit /b 0
echo=
call :updater update. --upgrade "%~f0" && (
    echo Upgraded to !update.name! !update.version!
    echo Script will exit
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

call :desolve _dependencies batchlib "updater"
set "updater_func="
for %%a in (!_dependencies!) do (
    for /f "tokens=1-2* delims=:" %%b in ("%%a") do (
        set "updater_func=!updater_func! %%c"
    )
)
call :extract_func "%~f0" "tests.lib.updater.template" 1, -3 > "template"
call :textrender "template" > "base.bat"
for %%a in (
    "0: --upgrade --skip-verification"
    "0: --upgrade : version_lower"
    "2: --upgrade : "
    "2: --upgrade : version_higer"
    "3: --upgrade : download_url_undefined"
    "4: --upgrade : download_url_invalid"
    "6: --upgrade : name_different"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    copy /y "base.bat" "test_updater.bat" > nul
    start "" /wait /b cmd /c ""test_updater.bat" "%%c" "%%d"" > nul 2> nul || (
        call %unittest%.error "Cannot start test update" & exit /b 0
    )
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "%%b" (
        call %unittest%.fail %%a
    )
)
exit /b 0


:tests.lib.updater.template
- extract "__init__"
- extract "__metadata__" 0 -3
``` batchfile ~4
``
``  if defined name_different set "%~1name=.test!random!!random!!random!"
``  if defined version_lower set "%~1version=.dev"
``  if defined version_higer set "%~1version=999"
``  if defined date_older set "%~1release_date=1/1/1970"
``  if defined date_newer set "%~1release_date=12/31/9999"
``  if defined download_url_undefined set "%~1download_url="
``  if defined download_url_invalid set "%~1download_url=256.256.256.256"
``  exit /b 0
``
``
``  :__main__
``  @setlocal EnableDelayedExpansion EnableExtensions
``  @echo off
``  for %%a in (
``      "name: different"
``      "version: lower higher"
``      "download_url: undefined invalid"
``  ) do for /f "tokens=1* delims=:" %%b in (%%a) do (
``      for %%f in (%%c) do set "%%b_%%f="
``  )
``  for %%f in (%~2) do set "%%f=true"
``  (
``      call :updater update. "%~f0" %~1
``      exit
``  )
``  exit 1
``
``
```
- extract
    " module.entry_point
      !updater_func! "
exit /b 0


rem ======================== function ========================

:updater   return_prefix  script_path  [-V]  [-u]  [-d url]
setlocal EnableDelayedExpansion
for %%v in (_upgrade _download_url) do set "%%v="
set "_verify=true"
set parse_args.args= ^
    ^ "-V, --skip-verification  :store_const:_verify=" ^
    ^ "-u, --upgrade            :store_const:_upgrade=true" ^
    ^ "-d, --download-url       :store:_download_url"
call :parse_args %*
set "_part=%~f2"
cd /d "!temp!" & ( cd /d "!temp_path!" 2> nul )
set "_other=!cd!\latest.bat"
call :updater._run & for %%e in (!errorlevel!) do (
    endlocal
    if "%%e" == "0" call :updater.read_metadata %1 "%_other%"
    if not defined _upgrade if exist "%_other%" del /f /q "%_other%"
    if "%%e" == "2" ( 1>&2 echo You are using the latest version & exit /b 2 )
    if "%%e" == "3" ( 1>&2 echo error: failed to retrive metadata & exit /b 3 )
    if "%%e" == "4" ( 1>&2 echo error: failed to download update & exit /b 4 )
    if "%%e" == "5" ( 1>&2 echo error: failed to retrive update information & exit /b 5 )
    if "%%e" == "6" ( 1>&2 echo error: module name does not match & exit /b 6 )
    if "%%e" == "7" ( 1>&2 echo error: upgrade failed & exit /b 7 )
    exit /b 0
)
exit /b 0
#+++

:updater._run
set "_read_metadata=true"
if not defined _verify if defined _download_url set "_read_metadata="
if defined _read_metadata call :updater.read_metadata _part. "!_part!" && (
    set "_download_url=!_part.download_url!"
) || exit /b 3
if not defined _download_url exit /b 3
call :download_file "!_download_url!" "!_other!" || exit /b 4
if defined _verify (
    call :updater.read_metadata _other. "!_other!" || exit /b 5
    if not defined _other.version exit /b 5
    if /i not "!_other.name!" == "!_part.name!" exit /b 6
    call :parse_version _part.parsed_version "!_part.version!"
    call :parse_version _other.parsed_version "!_other.version!"
    if "!_other.parsed_version!" LEQ "!_part.parsed_version!" exit /b 2
)
if defined _upgrade (
    copy /b /y /v "!_other!" "!_part!" > nul
) && ( exit /b 0 ) || exit /b 7
exit /b 0
#+++

:updater.read_metadata   return_prefix  script_path
call :module.is_module %2 || exit /b 1
call :module.read_metadata %1 %2 || exit /b 1
exit /b 0



rem ================================ to_crlf() ================================

rem ======================== documentation ========================

:to_crlf.__doc__
echo NAME
echo    to_crlf, to_crlf.alt1, to_crlf.alt2 - convert EOL of the script to CRLF
echo=
echo SYNOPSIS
echo    to_crlf
echo=
echo EXIT STATUS
echo    0:  - EOL conversion is successful.
echo    2:  - EOL conversion is not necessary.
echo    3:  - EOL conversion failed.
echo=
echo BEHAVIOR
echo    - Script SHOULD exit (not 'exit /b') if EOL conversion is successful
echo      to prevent unexpected errors, unless you know what you are doing.
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
echo    - Tabs are converted to 4 spaces
echo    - Can be used to detect and fix script EOL if it was downloaded
echo      from GitHub, since uses Unix EOL (LF).
exit /b 0


:to_crlf.__metadata__   [return_prefix]
set %~1install_requires= ^
    ^ is_crlf
exit /b 0


rem ======================== demo ========================

:demo.to_crlf
echo Fixing EOL...
for %%n in (1 2) do call :to_crlf.alt%%n & (
    set "result=!errorlevel!"
    echo=
    echo Called [to_crlf.alt%%n]
    if "!result!" == "0" (
        echo Fix successful
        echo Script will exit.
        pause
        exit 0
    )
    if "!result!" == "2" echo Fix not necessary
    if "!result!" == "3" echo Fix failed
)
exit /b 0


rem ======================== function ========================

:to_crlf
:to_crlf.alt1
:to_crlf.alt2
for %%n in (1 2) do call :is_crlf.alt%%n --check-exist 2> nul && (
    call :is_crlf.alt%%n && exit /b 2
    echo Converting EOL...
    type "%~f0" | more /t4 > "%~f0.tmp" && (
        move "%~f0.tmp" "%~f0" > nul && exit /b 0
    )
    ( 1>&2 echo warning: Convert EOL failed )
    exit /b 3
)
( 1>&2 echo error: failed to call is_crlf^(^) )
exit /b 3


rem ================================ is_crlf() ================================

rem ======================== documentation ========================

:is_crlf.__doc__
echo NAME
echo    is_crlf, is_crlf.alt1, is_crlf.alt1
echo    - check EOL type of current script
echo=
echo SYNOPSIS
echo    is_crlf   [--check-exist]
echo=
echo OPTIONS
echo    -c, --check-exist
echo        Check if function exist / is callable.
echo=
echo EXIT STATUS
echo    0:  - EOL is Windows (CRLF)
echo        - '-c' is specified, and the function is callable.
echo    1:  - The function is uncallable.
echo    2:  - EOL is Unix (LF)
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
echo    - If EOL is Mac (CR), this script would probably have crashed
echo      in the first place.
exit /b 0


:is_crlf.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.is_crlf
for %%n in (1 2) do call :is_crlf.alt%%n --check-exist 2> nul && (
    call :is_crlf.alt%%n && (
        echo [is_crlf.alt%%n] EOL is Windows 'CRLF'
    ) || echo [is_crlf.alt%%n] EOL is Unix 'LF'
)
exit /b 0


rem ======================== function ========================

:is_crlf   [--check-exist]
:is_crlf.alt1
:is_crlf.alt2
for %%f in (-c, --check-exist) do if /i "%1" == "%%f" exit /b 0
@call :is_crlf._test 2> nul && exit /b 0 || exit /b 2
rem  1  DO NOT REMOVE / MODIFY THIS COMMENT SECTION           #
rem  2  IT IS IMPORTANT FOR THIS FUNCTION TO WORK CORRECTLY   #
rem  3  This comment section should be exactly 511 characters #
rem  4  long when the EOL is LF (Unix EOL).                   #
rem  5                                                        #
rem  6                                                        #
rem  7  Last line should be 1 character                       #
rem  8  shorter than the rest               DO NOT MODIFY -> #
:is_crlf._test
@exit /b 0


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
echo EXIT STATUS
echo    0:  - Unittest passed.
echo    1:  - An unexpected error occured.
echo    2:  - Unittest failed.
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
    ^ difftime ftime ^
    ^ module.make_context
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
    ".unittest"
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
call :module.make_context unittest "%~f0" "call :unittest"
if "!unittest.test_module!" == "%~f0" (
    call :module.make_context unittest.test_context
) else call :module.make_context unittest.test_context "!unittest.test_module!" "call "

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
        call :difftime _elapsed_time "!time!" "!start_time!"
        call :ftime _elapsed_time !_elapsed_time!
        set "unittest.tests_run=%_num_padding%!unittest.tests_run!"
        set "unittest.tests_run=!unittest.tests_run:~-%_num_digits%,%_num_digits%!"
        echo !_elapsed_time! [!unittest.tests_run!/!unittest.tests_count!] %%t
    )
    call :unittest._run  %%t
)
set "stop_time=!time!"
call :difftime time_taken "!stop_time!" "!start_time!"
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
if not defined unittest.was_successful exit /b 2
exit /b 0
#+++

:unittest._run   label
call 2> ".unittest\outcome.bat"
set "unittest.current_test_name=%~1"
setlocal EnableDelayedExpansion EnableExtensions
call %unittest.test_context%:%~1
endlocal & set "_exit_code=%errorlevel%"
if not "!_exit_code!" == "0" (
    >> ".unittest\outcome.bat" (
        echo call %%unittest%%._add_outcome error "Test function did not exit correctly [exit code !_exit_code!]."
    )
)
set "unittest.current_outcome=success"
call ".unittest\outcome.bat"
call :unittest._add_result !unittest.current_outcome! %1
call :%~1.cleanup 2> nul
exit /b 0
#+++

:unittest.skip   reason
>> ".unittest\outcome.bat" (
    echo call %%unittest%%._add_outcome skip %1
)
exit /b 0
#+++

:unittest.fail   msg
>> ".unittest\outcome.bat" (
    echo call %%unittest%%._add_outcome failure %1
)
exit /b 0
#+++

:unittest.error   msg
>> ".unittest\outcome.bat" (
    echo call %%unittest%%._add_outcome error %1
)
exit /b 0
#+++

:unittest.stop
>> ".unittest\outcome.bat" (
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
set "_text=%~2"
if "!unittest.verbosity!" == "2" (
    echo [%~1] !_text!
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
    set "_msg=test '%~2' failed"
)
if /i "%~1" == "error" (
    set "_list_name=errors"
    set "_mark=E"
    rem set "_msg=ERROR"
    set "_msg=test '%~2' failed -- an error occurred"
)
if /i "%~1" == "skip" (
    set "_list_name=skipped"
    set "_mark=s"
    rem set "_msg=skipped '!unittest.test.%unittest.current_test_name%.skip_msg!'"
    set "_msg=test '%~2' skipped '!unittest.test.%unittest.current_test_name%.skip_msg!'"
)
if defined _list_name (
    for %%c in (!_list_name!) do set "unittest.%%c=!unittest.%%c! %~2"
)
if "!unittest.verbosity!" == "1" < nul set /p "=!_mark!"
if "!unittest.verbosity!" == "2" if defined _msg echo !_msg!
exit /b 0


rem ======================== tests ========================

:tests.lib.unittest.main
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
set "expected_error.exit_code=333"
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
echo    parse_args.validate
echo=
echo DESCRIPTION
echo    parse_args() is a argument parser for batch script. All arguments is passed
echo    to parse_args() by calling it using '%%*' and it will read the parsing
echo    options defined in the variable 'parse_args.args' to extract the data.
echo    Arguments that does not match any of the options remains as positional
echo    arguments.
echo=
echo    Syntax of argument in 'parse_args.args' can be validated by calling
echo    parse_args.validate()
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
echo EXIT STATUS
echo    0:  - Success.
echo    2:  - Invalid parameter of 'parse_args.args'.
echo=
echo NOTES
echo    - Function MUST be embedded into the script to work correctly.
echo    - Supports upto 8 positional arguments. Using more than the limit might
echo      cause incorrect parsing results. This is due to limitation in batch script
echo      that only allows reading of first 9 parameters at a time.
exit /b 0

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
echo    -h, --hex
echo        Show result in the form of hexadecimal.
echo=
echo    -p, --plus
echo        Add one to the result. Can be used multiple times.
echo=
call :Input.string parameters
echo=
call :talking_calculator !parameters!
exit /b 0
#+++

:talking_calculator
for %%v in (_say _say_is_set _binary _hex) do set "%%v="
set parse_args.args= ^
    ^ "-s, --say        :store:_args._say" ^
    ^ "-s, --say        :store_const:_args._say_is_set=true" ^
    ^ "-h, --hex        :store_const:_args._hex=true" ^
    ^ "-p, --plus       :append_const:_args._plus= +1"
call :parse_args.validate || exit /b 1
echo parse_args.args= ^^
for %%a in (!parse_args.args!) do (
    echo    ^^ %%a ^^
)
echo=
call :parse_args %* || exit /b 1
echo=
echo Arguments:
set "_args."
echo=
if "%~1" == "" (
    echo Sorry, we need an expression to calculate the result...
    exit /b 1
)
if not "%~2" == "" (
    echo Sorry, we dont accept additional parameters. Aborting...
    exit /b 1
)
set /a "_result=%~1 + 0" 2> nul || (
    echo Sorry, the syntax of the expression is incorrect. Please check again.
    exit /b 1
)
set /a "_result+=0 !_args._plus!"
if defined _args._hex (
    call :int2hex _result !_result!
    set "_result=0x!_result!"
)
if not defined _args._say_is_set (
    set "_args._say=The answer is "
)
echo !_args._say!!_result!
exit /b 0


rem ======================== tests ========================

:tests.lib.parse_args.main
for %%a in (alpha bravo charlie hotel tango x-ray zulu) do (
    set "_char=%%a"
    set "_char=!_char:~0,1!"
    for %%c in (!_char!) do set "p_arg_%%c=-%%c, --%%a"
)
call :tests.lib.parse_args.test_no_args || exit /b 0
call :tests.lib.parse_args.test_validate --hello || exit /b 0
for %%t in (store_const store append_const) do (
    call :tests.lib.parse_args.test_%%t --bravo "--alpha" -t -c -h --x-ray zulu  || exit /b 0
)
call :tests.lib.parse_args.test_special_chars "" --colon ":" --semicolon ";" ^
    ^ --qmark "?" --asterisk "*" --caret "^" --ampersand "&" --equal "=" --empty "" ^
    ^ || exit /b 0
call :tests.lib.parse_args.test_case_sensitivity  -c || exit /b 0
call :tests.lib.parse_args.test_multi_action  pos -s stored || exit /b 0
exit /b 0


:tests.lib.parse_args.test_no_args
setlocal EnableDelayedExpansion EnableExtensions
set "parse_args.args="
call :parse_args %* || (
    call %unittest%.fail "test_no_args: exit state must be successful"
    exit /b 1
)
exit /b 0


:tests.lib.parse_args.test_validate
setlocal EnableDelayedExpansion EnableExtensions
set parse_args.args= ^
    ^ "--hello  :this_is_invalid:hello=true"
call :parse_args.validate 2> nul && (
    call %unittest%.fail "test_validate: type error not detected"
    exit /b 1
)
set parse_args.args= ^
    ^ "--hello  :store_const:"
call :parse_args.validate 2> nul && (
    call %unittest%.fail "test_validate: syntax error not detected"
    exit /b 1
)
exit /b 0


:tests.lib.parse_args.test_store_const
for %%v in (b a t c h x z) do set "arg_%%v="
set "parse_args.args="
for %%c in (b a c x z) do (
    set parse_args.args=!parse_args.args! "!p_arg_%%c!:store_const:arg_%%c=true"
)
call :parse_args.validate 2> nul || (
    call %unittest%.error "test_store_const: invalid test arguments" & exit /b 1
)
call :parse_args %* || ( call %unittest%.fail "test_store_const: parsing error" & exit /b 1 )
set arg_received=[%1, %2, %3, %4, %5]
set arg_expected=["--alpha", -t, -h, zulu, ]
for %%t in (test_store_const) do (
    if not "!arg_received!" == "!arg_expected!" (
        call %unittest%.fail "%%t: positional arguments" & exit /b 1
    )
    for %%v in (b c x) do ( rem
    ) & if not defined arg_%%v (
        call %unittest%.fail "%%t: false negative: %%v" & exit /b 1
    )
    for %%v in (a z) do ( rem
    ) & if defined arg_%%v (
        call %unittest%.fail "%%t: false positive: %%v" & exit /b 1
    )
)
exit /b 0


:tests.lib.parse_args.test_store
for %%v in (b a t c h x z) do set "arg_%%v="
set "parse_args.args="
for %%c in (a t c x z) do (
    set parse_args.args=!parse_args.args! "!p_arg_%%c!:store:arg_%%c"
)
call :parse_args.validate 2> nul || (
    call %unittest%.error "test_store: invalid test arguments" & exit /b 1
)
call :parse_args %* || ( call %unittest%.fail "test_store: parsing error" & exit /b 1 )
set arg_received=[%1, %2, %3, %4]
set arg_expected=[--bravo, "--alpha", -h, ]
for %%t in (test_store) do (
    if not "!arg_received!" == "!arg_expected!" (
        call %unittest%.fail "%%t: positional arguments" & exit /b 1
    )
    for %%v in (a c h z) do (
        if defined arg_%%v ( call %unittest%.fail "%%t: false positive: %%v" & exit /b 1 )
    )
    if not "!arg_t!" == "-c"    ( call %unittest%.fail "%%t: keyword '-t'" & exit /b 1 )
    if not "!arg_x!" == "zulu"  ( call %unittest%.fail "%%t: keyword '-x'" & exit /b 1 )
)
exit /b 0


:tests.lib.parse_args.test_append_const
for %%v in (b a t c h x z) do set "arg_%%v="
set "parse_args.args="
for %%c in (b a t c h x) do (
    set parse_args.args=!parse_args.args! "!p_arg_%%c!:append_const:arg_word=%%c"
)
call :parse_args.validate 2> nul || (
    call %unittest%.error "test_append_const: invalid test arguments" & exit /b 1
)
call :parse_args %* || ( call %unittest%.fail "test_append_const: parsing error" & exit /b 1 )
set arg_received=[%1, %2, %3]
set arg_expected=["--alpha", zulu, ]
for %%t in (test_append_const) do (
    if not "!arg_received!" == "!arg_expected!" (
        call %unittest%.fail "%%t: positional arguments" & exit /b 1
    )
    if not "!arg_word!" == "btchx" ( call %unittest%.fail "%%t: incorrect result" & exit /b 1 )
)
exit /b 0


:tests.lib.parse_args.test_special_chars
set "char_list=dquotes2 qmark asterisk colon semicolon caret ampersand equal empty"
for %%v in (!char_list!) do set "%%v="
set parse_args.args= ^
    ^ "--qmark      :store:var.qmark" ^
    ^ "--asterisk   :store:var.asterisk" ^
    ^ "--colon      :store:var.colon" ^
    ^ "--semicolon  :store:var.semicolon" ^
    ^ "--caret      :store:var.caret" ^
    ^ "--ampersand  :store:var.ampersand" ^
    ^ "--equal      :store:var.equal" ^
    ^ "--empty      :store:var.empty"
call :parse_args.validate 2> nul || (
    call %unittest%.error "test_special_chars: invalid test arguments" & exit /b 1
)
call :parse_args %* || ( call %unittest%.error "test_special_chars: parsing error" & exit /b 1 )
call :tests.assets.set_special_chars expected.
set var.dquotes2=%1
for %%v in (!char_list!) do (
    if not "[!var.%%v!]" == "[!expected.%%v!]" (
        call %unittest%.fail "test_special_chars: %%v"
    )
)
exit /b 0


:tests.lib.parse_args.test_case_sensitivity
for %%v in (_lowercase _uppercase) do set "%%v="
set parse_args.args= ^
    ^ "-c   :store_const:_lowercase=true" ^
    ^ "-C   :store_const:_uppercase=true"
call :parse_args.validate 2> nul || (
    call %unittest%.error "test_case_sensitivity: invalid test arguments" & exit /b 1
)
call :parse_args %* || ( call %unittest%.error "test_case_sensitivity: parsing error" & exit /b 1 )
for %%t in (test_case_sensitivity) do (
    if defined _uppercase ( call %unittest%.fail "%%t: case sensitive" & exit /b 1 )
)
exit /b 0


:tests.lib.parse_args.test_multi_action
for %%v in (
    store1 store2
    store_const1 store_const2
    append_const
) do set "arg_%%v="
set "parse_args.args="
set parse_args.args= ^
    ^ "-s   :store:args_store1" ^
    ^ "-s   :store:args_store2" ^
    ^ "-s   :append_const:args_append_const=+1" ^
    ^ "-s   :append_const:args_append_const=+2" ^
    ^ "-s   :store_const:args_store_const1=1" ^
    ^ "-s   :store_const:args_store_const2=2"
call :parse_args.validate 2> nul || (
    call %unittest%.error "test_multi_action: invalid test arguments" & exit /b 1
)
call :parse_args %* || ( call %unittest%.error "test_multi_action: parsing error" & exit /b 1 )
for %%t in (test_multi_action) do (
    if not "!args_store1!" == "stored" ( call %unittest%.fail "%%t: store1" & exit /b 1 )
    if not "!args_store2!" == "stored" ( call %unittest%.fail "%%t: store1" & exit /b 1 )
    if not "!args_store_const1!" == "1" ( call %unittest%.fail "%%t: store1" & exit /b 1 )
    if not "!args_store_const2!" == "2" ( call %unittest%.fail "%%t: store1" & exit /b 1 )
    if not "!args_append_const!" == "+1+2" ( call %unittest%.fail "%%t: store1" & exit /b 1 )
)
exit /b 0


rem ======================== function ========================

:parse_args   %*
setlocal EnableDelayedExpansion
set "_ast="
call :parse_args._loop %* || exit /b 1
(
    goto 2> nul
    set "parse_args.argc=1"
    for %%a in (%_ast%) do ( rem
    ) & for /f "tokens=1* delims=:" %%c in (%%a) do (
        if /i "%%c" == "store" (
            call set "%%d==%%~!parse_args.argc!"
            set "%%d!%%d:^^=^!"
        )
        if /i "%%c" == "store_const" set "%%d"
        if /i "%%c" == "append_const" (
            for /f "tokens=1* delims==" %%e in ("%%d") do set "%%e=!%%e!%%f"
        )
        if /i "%%c" == "positional" set /a "parse_args.argc+=1"
        if /i "%%c" == "shift" shift /!parse_args.argc!
    )
    set /a "parse_args.argc-=1"
    set "parse_args.args="
    ( call )
)
exit /b 1
#+++

:parse_args._loop
for /l %%_ in (1,1,21) do for /l %%_ in (1,1,21) do (
    call set _value=%%1
    if not defined _value exit /b 0
    set "_actions="
    set "_shift_first="
    for %%b in (!parse_args.args!) do ( rem
    ) & for /f "tokens=1-2* delims=:" %%c in (%%b) do (
        for %%f in (%%c) do if "!_value!" == "%%f" (
            set _actions=!_actions! "%%d:%%e"
            if /i "%%d" == "store" set "_shift_first=true"
        )
    )
    if defined _actions (
        set _actions=!_actions! "shift"
    ) else set _actions=!_actions! "positional"
    if defined _shift_first (
        set _actions= "shift"!_actions!
        shift /1
    )
    set "_ast=!_ast! !_actions!"
    shift /1
)
exit /b 0
#+++

:parse_args.validate
for %%a in (!parse_args.args!) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    set "_valid="
    for %%t in (store store_const append_const) do if /i "%%c" == "%%t" set "_valid=true"
    if not defined _valid ( 1>&2 echo error: invalid argument type '%%c' for '%%b' & exit /b 2 )
    if "%%d" == "" ( 1>&2 echo error: variable name not defined for '%%b' & exit /b 2 )
)
exit /b 0


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


rem ================================ while_range_macro() ================================

rem ======================== documentation ========================

:while_range_macro.__doc__
echo NAME
echo    while_range_macro - setup macro for psuedo infinite loop
echo=
echo SYNOPSIS
echo    while_range_macro   [return_var]  [base]  [power]
echo    %%while_range%%   code
echo=
echo DESCRIPTION
echo    The aim of this macro is to emulate while true loops in batch script
echo    as an alternative to the GOTO loop (which is much slower). This macro
echo    is actually a FOR loop that will terminate after it reaches a certain
echo    number of loops. Unlike a normal single large loop, it is designed to
echo    exit the FOR loop quickly when the 'EXIT /b' command is executed.
echo=
echo POSITIONAL ARGUMENTS
echo    return_var
echo        Variable to store the macro. By default, it is 'while_range'.
echo=
echo    base
echo        The number of the loops in a single FOR loop. The larger the base,
echo        the slower it takes to exit the loop. By default, it is '256'.
echo=
echo    power
echo        The number of nested FOR loops to use. The higher the power, the longer
echo        it takes to exhaust the loop. The loops needed to exhaust the loop is
echo        calculated as: 'base ^^ power'. By default, it is '4'.
echo=
echo NOTES
echo    - By default, it takes 256^^4 (4294967296) loops to exhaust
exit /b 0


:while_range_macro.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.while_range_macro
call :Input.number base --range "0~2147483647"
call :Input.number power --range "0~300"
call :Input.number loops_to_quit --range "0~2147483647"

call :timeit.setup_macro
call :while_range_macro while_range !base! !power!

echo=
echo Measuring time needed to exit the loop...
%timeit% call :tests.lib.while_range_macro.stop_at !loops_to_quit!
exit /b 0


rem ======================== tests ========================

:tests.lib.while_range_macro.stop_at   loops
set "loops=0"
%while_range% (
    if "!loops!" == "%~1" exit /b 0
    set /a "loops+=1"
)
exit /b 0


:tests.lib.while_range_macro.demo
%while_range% (
    set /a "number=!random! %% 10"
    < nul set /p "=!number! "
    if "!number!" == "0" (
        echo=
        exit /b 0
    )
)
echo=
echo END OF LOOP
exit /b 0


rem ======================== function ========================

:while_range_macro   [return_var]  [base]  [power]
for /f "tokens=1 delims==" %%v in ("%~1=while_range") do ( rem
) & for /f "tokens=1 delims==" %%b in ("%~2=256") do (
    set "%%v="
    for /l %%n in (1,1,%~3,2) do (
        set "%%v=!%%v!for /l %%^_ in (1,1,%%b) do "
    )
)
exit /b 0


rem ================================ endlocal() ================================

rem ======================== documentation ========================

:endlocal.__doc__
echo NAME
echo    endlocal - make variables survive ENDLOCAL
echo=
echo SYNOPSIS
echo    endlocal   "old[:new]  [old[:new] [...]]"
echo=
echo POSITIONAL ARGUMENTS
echo    old
echo        Variable name to keep (before endlocal).
echo=
echo    new
echo        Variable name to use (after endlocal). By default, the
echo        new variable name is the same as the old variable name.
echo=
echo NOTES
echo    - Variables that contains Line Feed character are not supported and it
echo      could cause unexpected errors.
echo    - In the code, adding exclamation mark at beginning of string is required
echo      to trigger caret escaping behavior on quoted strings.
echo=
echo EXIT STATUS
echo    0:  - Success.
echo    2:  - Interal variable 'endlocal.*' is used.
exit /b 0


:endlocal.__metadata__   [return_prefix]
set "%~1install_requires="
exit /b 0


rem ======================== demo ========================

:demo.endlocal
set "var_del=This variable will be deleted"
set "var_keep=This variable will keep its content"
set "var_"
echo=
echo [setlocal]
setlocal EnableDelayedExpansion
echo=
set "var_del="
set "var_keep=Attempting to change it"
set "var_hello=I am a new variable^! ^^^^"
set "var_"
echo=
echo [endlocal]
call :endlocal var_del var_hello:var_new_name
echo=
set "var_"
exit /b 0


rem ======================== tests ========================

:tests.lib.endlocal.main
for %%s in (
    Enable
    Disable
) do (
    call :tests.lib.endlocal.test_basic "%%s"
    call :tests.lib.endlocal.test_special_chars "%%s"
)
exit /b 0


:tests.lib.endlocal.test_basic
setlocal EnableDelayedExpansion
set "initial.null=a b c"
set "initial.old=d e f g h"
set "local.changed=b c e g"
set "local.deleted=f h"
set "local.persist=c g h"
set "expected.null=a b h"
set "expected.old=d e f"
set "expected.changed=c g"

for %%v in (!initial.null!) do set "var.%%v="
for %%v in (!initial.old!) do set "var.%%v=old"

set "local.persist_vars="
for %%v in (!local.persist!) do (
    set "local.persist_vars=!local.persist_vars! var.%%v"
)

setlocal %~1DelayedExpansion
setlocal EnableDelayedExpansion
for %%v in (%local.changed%) do set "var.%%v=changed"
for %%v in (%local.deleted%) do set "var.%%v="
call :endlocal %local.persist_vars%

setlocal EnableDelayedExpansion
for %%t in ("basic: %~1DE") do (
    for %%v in (!expected.null!) do (
        if defined var.%%v (
            call %unittest%.fail "%%~t case %%v"
        )
    )
    for %%v in (!expected.old!) do (
        if not "!var.%%v!" == "old" (
            call %unittest%.fail "%%~t case %%v"
        )
    )
    for %%v in (!expected.changed!) do (
        if not "!var.%%v!" == "changed" (
            call %unittest%.fail "%%~t case %%v"
        )
    )
)
exit /b 0


:tests.lib.endlocal.test_special_chars
setlocal EnableDelayedExpansion
set persist= ^
    ^ dquotes dquotes2 ^
    ^ qmark ^
    ^ asterisk ^
    ^ colon ^
    ^ semicolon ^
    ^ caret caret2 ^
    ^ ampersand ^
    ^ equal ^
    ^ bang ^
    ^ pipe ^
    ^ percent ^
    ^ lab rab
set "persist_vars="
for %%v in (!persist!) do (
    set "var.%%v="
    set "persist_vars=!persist_vars! var.%%v"
)

setlocal %~1DelayedExpansion
setlocal EnableDelayedExpansion
call :tests.assets.set_special_chars var.
call :endlocal %persist_vars%

setlocal EnableDelayedExpansion
call :tests.assets.set_special_chars expected.
for %%v in (!persist!) do (
    if not "[!var.%%v!]" == "[!expected.%%v!]" (
        call %unittest%.fail "special_characters: %~1DE %%v"
    )
)
exit /b 0


rem ======================== function ========================

:endlocal   "old[:new]  [old[:new] [...]]"
setlocal EnableDelayedExpansion
set LF=^
%=REQUIRED=%
%=REQUIRED=%
for %%v in (_content _value) do (
    if defined endlocal.%%v (
        ( 1>&2 echo error: interal variable 'endlocal.%%v' is used & exit /b 2 )
    )
)
for %%v in (%*) do for /f "tokens=1-2 delims=:" %%a in ("%%~v:%%~v") do (
    set "endlocal._value=^!!%%a!"
    call :endlocal._to_ede
    set "endlocal._content=!endlocal._content!%%b=!endlocal._value!!LF!"
)
for /f "delims= eol=" %%a in ("!endlocal._content!") do ( rem
) & for /f "tokens=1 delims==" %%b in ("%%a") do (
    if defined endlocal._content (
        goto 2> nul
        endlocal
    )
    set "%%a"
    if not "!!" == "" (
        setlocal EnableDelayedExpansion
        set "endlocal._value=!%%b!"
        call :endlocal._to_dde
        for /f "delims=" %%c in ("=!endlocal._value!") do (
            endlocal
            set "%%b%%c"
        )
    )
    call set "%%b=%%%%b:~1%%"
)
exit /b 0
#+++

:endlocal._to_ede
set "endlocal._value=!endlocal._value:^=^^^^!"
set "endlocal._value=%endlocal._value:!=^^^!%"
exit /b
#+++

:endlocal._to_dde
set "endlocal._value=%endlocal._value%"
exit /b


rem ================================ Add-ons ================================

rem ======================== PowerShell ========================

:PowerShell
rem A mock function to mark presence of PowerShell in the system
exit /b 0


:PowerShell.__metadata__
set "%~1install_requires="
exit /b 0


rem ======================== VBScript ========================

:VBScript
rem A mock function to mark presence of VBScript in the system
exit /b 0


:VBScript.__metadata__
set "%~1install_requires="
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


rem ======================================== Tests ========================================

:tests
:tests.__init__
rem Things to do before any running any tests
exit /b 0


rem ================================ auto_input ================================

:tests.auto_input.main
> "ignore_n_quit" (
    echo ignore1
    echo ignore2
    echo ignore3
    echo 0
)
> nul 2>&1 (
    start "" /i /wait /b cmd /c ""%~f0" --no-cleanup" < "ignore_n_quit"
) && (
    exit /b 0
) || (
    call %unittest%.fail
    exit /b 0
)
exit /b 1


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


rem ================================ Shared test assets ================================

:tests.assets.dummy_func.comments
rem This is a function that does nothing
rem Second line
exit /b 0


:tests.assets.dummy_func.special_characters   arg_1a|arg_1b  arg2 [arg3]
    @call & echo %% !a! %* > nul 2> nul

< nul ( call ) || exit /b 1
exit /b 0


:tests.assets.dummy_func.join_mark
exit /b 0
#+++

:tests.assets.dummy_func.join_mark.joined
exit /b 0


:tests.assets.set_special_chars   prefix
set %~1dquotes="
set %~1dquotes2=""
set "%~1qmark=?"
set "%~1asterisk=*"
set "%~1colon=:"
set "%~1semicolon=;"
set "%~1caret=^"
set "%~1caret2=^^"
set "%~1ampersand=&"
set "%~1pipe=|"
set "%~1lab=<"
set "%~1rab=>"
set "%~1percent=%%"
set "%~1equal=="
if "!!" == "" (
    set "%~1bang=^!"
) else set "%~1bang=!"
set "%~1empty="
exit /b 0


rem ======================================== Assets ========================================

:assets
:assets.__init__
rem Additional data to bundle
exit /b 0


:assets.templates.minified
- extract "__init__"

## Metadata
- extract "__metadata__ about"

## License
- extract "license"

## Configurations
- extract
    " config
      config.default
      config.cli
      config.preferences "

## Changelog
- extract "changelog"

## Main
``` batchfile ~4
``  :__main__
``  @call :scripts.cli %*
``  @exit /b
``
``
```

## Entry points
- extract scripts

### CLI script
- extract scripts.cli

## User Interfaces
- extract
    " ui
      script_cli
      help "

## Core
- extract
    " core
      Category.init
      Function.read
      make_template "

## Library
- extract
    " lib
      !lib_functions! "

## Test
- extract
    " tests
      !test_functions! "

## Assets
- extract assets

## End of Script
- extract "EOF"
exit /b 0


:assets.templates.base
[comment]: # (Template for new script - minimal edition)
[comment]: # ()
[comment]: # (Features:)
[comment]: # (- Module framework support)
[comment]: # (- Library dependency listing)

- extract "__init__"

## Metadata
``` batchfile ~4
``  :__metadata__   [return_prefix]
``  set "%~1name=<package_name>"
``  set "%~1version=0.0"
``  set "%~1author=<author>"
``  set "%~1license=<license>"
``  set "%~1description=<package_title>"
``  set "%~1release_date=03/08/2020"   :: mm/dd/YYYY
``  set "%~1url=https://example.com/path/to/page.html"
``  set "%~1download_url=https://gist.github.com/username/repo/file/raw"
``  exit /b 0
``
``
```

## Main
``` batchfile ~4
``  :__main__
``  @call :scripts.main %*
``  @exit /b
``
``
```

## Entry points
- extract "scripts"

### Main script
``` batchfile ~4
``  :scripts.main
``  @setlocal EnableDelayedExpansion EnableExtensions
``  @echo off
``  set "__name__=main"
``  prompt $$$s
``  call :__metadata__ SOFTWARE.
``
``  rem Write your code here...
``
``  exit /b 0
``
``
```

## Library
- extract "lib"
``` batchfile ~4
``  :lib.__metadata__
``  set %~1install_requires= ^
``      ^ batchlib:^" ^
``      ^   module.entry_point ^"
``  exit /b 0
``
``
```
- extract "module.entry_point"

## End of Script
- extract "EOF"
exit /b 0

rem ======================================== End of Script ========================================

:EOF
rem May be needed if command extenstions are disabled
rem Anything beyond this are not part of the code
exit /b
