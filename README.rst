Batchlib
########
Collections of reusable functions/snippets for Batch Script.

These functions can be used by simply copy, paste it and CALL the function.
Concept of the script have been refined over the years to allow easier
development in Batch Script.

Features
--------
* Easy to use, suitable for beginners
* Powerful, suitable for hardcore batch script users
* Does not use global variables (otherwise specified in documentation)
* Extensive documentation and demo
* Functions have unittest and demo so functionality can be tested before use
* Library dependency management for scripts

Getting Started
---------------
For first time use, run batchlib once to add dependencies automatically
(batchlib also have dependencies!) and test the libraries to make sure it works.
Another way to test it is by running these commands:
::

    rem Test the Batchlib core
    cmd /c batchlib.bat -c :tests

    rem Test all library functions
    cmd /c batchlib.bat test

A good way to get stated with batchlib is to explore the features and libraries
first. After you are somehow familiar with them, use a `Template For New
Scripts`_, read the documentations inside, and try to make something out of it.

Template For New Scripts
------------------------
To take full advantage of batchlib, there are some structures to follow.
Use the template script ``template.bat`` as your starting point. It has all
the recommended structures to work flawlessly with batchlib.
There are guides inside to help you get started.

Minified Batchlib
-----------------
Minified Batchlib is a stripped down and packed version of Batchlib.

The differences are:

* All library functions (only the function) are compiled into the file.
* No library docs, demo, or tests included.
* Command line interface instead of menu interface.

To generate it, type:
::

    cmd /c batchlib.bat template minified > batchlib-min.bat

Dependency Management
-------------------------------
Batchlib have an automated way of adding libraries into a script. Use the
`Template For New Scripts`_ and specify the dependencies in this section of
the script:
::

    :lib.dependencies
    set "%~1install_requires=<your_dependencies_here>"
    exit /b 0

And run:
::

    # Add dependencies to file
    cmd /c batchlib.bat build your_script_name.bat

    # Or build with backup
    cmd /c batchlib.bat build your_script_name.bat backup_name.bat

And batchlib will magically add the libraries into your script! Backup file can
be specified if necessary. When you have changed the dependency list, you can
run the same code again to update the libraries.

Call As External Library
------------------------
It is possible to call batchlib as an external program. However, some functions
will only work when it is copy-pasted (embedded) into the script.

These functions usually have note that says any of these:
::

    - Function MUST be embedded into the script to work correctly
    - Function SHOULD be embedded into the script

These are the recommended ways to do this (depending on use case):
::

    rem 1. Use macro
    set batchlib="C:\absolute\path\to\batchlib-min.bat" -c %=END=%
    call %batchlib%:input_yesno -m "Sleep? [y/n] "

    rem 2. Add to PATH
    set "path=C:\absolute\path\to;%PATH%"
    call batchlib-min -c :input_yesno -m "Midnight snacks? [y/n] "

At method #1, the ``%=END=%`` is used to prevent accidental truncation of trailing space.

Adding Your Own Functions To Library
------------------------------------
You can use the template for new library as the starting point.
Copying the library template and rename it:
::

    copy lib\new_lib_template.bat lib\your_library_name.bat

This template contains all the structures you need for your function to work
correctly with Batchlib. There are documentations inside to help you.

To debug your library, you can use:
::
    rem Run a test case
    cmd /c batchlib.bat debug your_library_name :quicktest your_test_case_label

    rem Run all test cases
    cmd /c batchlib.bat debug your_library_name :quicktest

    rem Do a full test
    cmd /c batchlib.bat test your_library_name

The 'debug' command will temporarily add unittest() and quicktest() into your
library to make testing more convenient

Unit Testing Your Script
------------------------
There are 2 unit testing frameworks: unittest() and quicktest().

- Use unittest() when more features are needed (supports test suite,
  experimental `TAP <http://testanything.org/>`_ output).
- Use quicktest() when testing a small script.

Both frameworks have the same syntax so compatibility is not a problem.
