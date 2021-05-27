Batchlib
########
Collections of reusable functions/snippets for Batch Script.

These functions are easy to use; just simply copy, paste it and put a CALL command to that function to use.
Concept of the script have been refined over the years to allow easier development in Batch Script.

Features
--------
* Easy to use, suitable for beginners
* Powerful, suitable for hardcore batch script users
* Does not pollute global variables (otherwise specified in documentation)
* Extensive documentation and demo
* Functions have unittest and demo so functionality can be tested before use

First Use
---------
For first time use, we need to do some setups:
::

    # Convert linux EOL to windows EOL
    type batchlib.bat > batchlib.bat.tmp
    move /y batchlib.bat.tmp batchlib.bat

    # Add dependencies to batchlib
    cmd /c batchlib.bat build batchlib.bat

This solves the following problem:

1. If you downloaded it as zip file from GitHub, the file is probably using Linux EOL (`LF`)
2. Satisfy dependency of batchlib (yes, batchlib also have dependencies!)

Template For New Scripts
------------------------
To take full advantage of batchlib, there are some structures to follow. Batchlib can
generate a template that have all the recommended structures and functions for you.
To generate it, type:
::

    cmd /c batchlib.bat template new_script > your_script_name.bat

Now you can use this newly generated script as your starting point. You are ready to code!

Dependency Management
-------------------------------
For example, your script use some library functions of batchlib. It would be a
time-consuming process to copy-paste each of them into your script.
If you use the `Template For New Scripts`_, you could do:
::

    # Add dependencies to file
    cmd /c batchlib.bat build your_script_name.bat

    # Or build with backup
    cmd /c batchlib.bat build your_script_name.bat backup_name.bat

And batchlib will magically add the libraries into your script! Backup file can be
specified if needed. You just need to specify the dependencies in this
section of the script:
::

    :lib.build_system
    set "%~1install_requires=<your_dependencies_here>"
    exit /b 0

When you have added/updated/removed a library from the list, you can run the same code
again to reinstall the libraries.

Adding Your Own Functions To Library
------------------------------------
There are some structures to follow for your function to work correctly in Batchlib.
Batchlib can generate a template that have all the structures you need.
To generate it, type:
::

    cmd /c batchlib.bat template new_library > lib\your_library_name.bat

Now you can create your own library function in this script. There are instructions
inside to guide you too!

Minified Batchlib
-----------------
Minified Batchlib is a stripped down version of Batchlib, with all library functions
compiled into a single file. To generate it, type:
::

    cmd /c batchlib.bat template minified_script > batchlib-min.bat
