The NuriaFramework
==================

The NuriaFramework extends upon the Qt framework and is written in C++. It is a
collection of modules with focus on data management and distribution.

Dependencies and requirements
-----------------------------

Build dependencies:
* Qt5 including development tools
* A modern C++ compiler with support for C++11
* A bash compatible script interpret

Runtime dependencies:
* Qt5

Platforms
---------

Thanks to Qt everything should run on all platforms. If you have problems
compiling and using this framework on a platform which is supported by Qt,
then please open a bugreport.

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

License
-------

The framework itself uses the zlib license. Please see the LICENSE file for
further information. LICENSE_TEMPLATE contains a ready-to-use comment for you
to use when creating new files.
**Contributed code must be licensed under the zlib license.**
