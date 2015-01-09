The NuriaFramework
==================

The NuriaFramework extends upon the Qt framework and is written in C++. It is a
collection of modules with focus on data management and distribution.

Dependencies and requirements
-----------------------------

Build dependencies:
* Qt5 including development tools
* A modern C++ compiler with support for C++11
* CMake buildsystem (See http://www.cmake.org/) - Minimum version is 2.8.8
* LLVM/Clang for [Tria](https://github.com/NuriaProject/Tria/) (Optional)
* Doxygen for documentation generation (Optional)

Runtime dependencies:
* Qt5

Platforms
---------

Thanks to Qt everything should run on all platforms. If you have problems
compiling and using this framework on a platform which is supported by Qt,
then please open a bugreport.

Documentation
-------------

Documentation is written in source through doxygen-style comments.
You can find an online version of it here: [Online documentation](http://nuriaproject.github.io/Framework/annotated.html)

Examples are available in the [examples repository](https://github.com/NuriaProject/FrameworkExamples)
with explanations in the [examples github wiki](https://github.com/NuriaProject/FrameworkExamples/wiki).
Unit-tests can be run by invoking ```make test``` in the build directory.

API and ABI
-----------

Currently the framework does not follow a version scheme. This means that
currently ABI or even API breakages may occur. This should not happen and is
quite rare, but it *may* happen. If we end up following a version scheme,
backwards compatibility in major versions, like Qt, will be a mandatory
requirement for all modules.

Contact and contributions
-------------------------

Contributions are welcome. If you want to make a contribution, please see the
HACKING file for coding guidelines (TL;DR: Keep the style which is used
everywhere else in the project).

Contact is possible using Github or via IRC: #Nuria at freenode.
[IRC Webchat](http://webchat.freenode.net?channels=%23Nuria&uio=d4)

Build configuration
-------------------

All of these options must be passed to the cmake call

* -DCMAKE_INSTALL_PREFIX=<Path> - Sets the install prefix
* -DNURIA_NO_DOCS=1 - Disables documentation generation

To generate documentation, you need to have doxygen installed. If a QtCreator
installation is found, the QtCreator helpfile (QCH) will be installed automatically.
By default, all documentation files are installed in /usr/share/doc/nuriaframework
on linux, and are not further touched on other OSes.

License
-------

The framework itself is available under the terms of the GPLv3 or LGPLv3.
Please make sure to understand the terms of the (L)GPL license. If you're not
sure if you can use the NuriaProject Framework in your project under these
licenses, please consult a lawyer. For other requests on this matter you can
also message Papierkorb on GitHub.

**All code must be licensed under the terms of the (L)GPL.**
