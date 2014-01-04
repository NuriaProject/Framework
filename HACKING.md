Codestyle guideline
===================

All code contributions MUST follow this guideline to be accepted!
If you think this text overcomplicates things, just have a look at checked-in
code to get a feel for the code style.

General
-------

* CamelCaseForTypes (structures, typedefs, classes, ...)
* everythingElseStartsWithASmallLetter (methods, variables, ...)
* MACROS_ARE_ALL_UPPERCASE_WITH_UNDERSCORES (Macros. Nothing else!)
* Acronyms are written like a single word (e.g. setUrl - **not** setURL)
* Pointer and reference markers go on the side of the variable name (int *foo, int &bar)
* One expression (outside conditions) per line.
* Write code "the Qt way". Use pointers for QObjects. Everything else should be a shared structure.
* Oh, and don't use any kind of hungarian notation. Never.
* All code is inside the 'Nuria' namespace. Exception are static helper methods which appear only in implementation files.
* Prefer qualifying the namespace yourself in implementations. Don't put everything in a namespace Nuria {}!
* Write code which can be extended in the future without breaking API **nor** ABI!

Indention and lines
-------------------

* This project uses tabs. Not multiple spaces. Tabs.
* A tab is 8 spaces in length. Not more or less.
* A line should be less than 100 chars in length ("soft limit").
* A line **must** be less than 120 chars in length.
* All blocks open a new indention level, except for namespaces, which do not.
* Visibility markers are on the same indention level as is the class definition.

Methods, prototypes and types
-----------------------------

* The type, method name and argument lists are on the same line if possible.
* If the return type is so long that it's not feasable to write the whole prototype on the same line, the type is on its own line.
* When breaking argument lists, the comma goes on the trailing side, that is, the previous line.
* The opening brace after a method name is seperated by a single space.
* After a comma (',') comes a single space too.
* There's no space behind a opening or before a closing brace.
* Choose names which describe what a method or does - But don't be too verbose either. See Qt for good examples.
* Initializers for constructors go on a seperate line, including the ':'. The opening curly-brace goes on its own line in this case.
* The inherit ':' in class definitions go on the same line as the class name.
* Use d-pointers ([Read the documentation](http://qt-project.org/wiki/Dpointer)).
* The d-pointer in a QObject sub-class is called d_ptr. Everywhere else it's called d.
* The private data class is called <Classname>Private.
* The location of that class in the implementation file of the class OR in a private header if it needs to be shared.

Blocks
------

* The opening curly-brace ('{') must be on the same line as the expression before it.
* A opening curly-brace is simply never on its own line.
* The closing curly-braces ('}') are on their own line. A empty line always follows.
* Prefer a multi-expression body over single expression ones. (E.g. if (...) { ... })
* Before a opening curly- or round-brace *always* comes a single space. Before '[' there's none.
* When writing a trivial inline method, and the body is short, you *can* write it like this:
    ````c++
    int foo ()
    { return bar (); }
    ````

Operators
---------

* There is a single space before and behind logical, binary and arithmetic operators.
* There's no space before or behind every other operator. (E.g. ::, ->, ., etc.)
* When overloading operators, there's no space between the keyword operator and the operator itself.

Templates
---------

* Use templates where it makes sense. Don't use them because you think they're cool.
* There's a space after '<' and before '>'. There's no space to the left side of '<'.

Visibility
----------

* The order for visibility is always: public, public slots, private slots, protected, private.
* Omit un-needed  visibility markers.
* When subclassing QObject, use the implicit private space on the top for all Q_* macros.
* And avoid exposing variables directly. Use getters/setters instead.

Tests
-----

* A well-written API is testable.
* A testable API is not necessarily well-written though.
* Unit-tests are necessary for new code.
* We use QtTest.
* Try to test for corner-cases too.
* Test logic, don't test language features. (That is, don't write tests for dumb getters/setters)
* The path to a test is: tests/<Module>/<header filename>/.
* The test class has a name of <Class>Test in tst_<header filename>.cpp.
* The project file with name <header filename>.pro creates a executable of name <header filename>.

Documentation
-------------

* Documentation of public API (Classes, methods, typedefs, enums, unions) is mandatory.
* Doxygen-style, use a backslash ('\') as escape introducer rather than a at ('@')
* The introducing /** line does not contain other text.
* End end of the documentation must be on its own line IF the whole documentation doesn't fit in the char limit.
* Prefer full-text. There's no need for \return, \param, etc.
* Classes must have a \brief description, methods don't have to.
* Write at least a short description for enum fields!
* Documentation have a hard limit of 80 chars per line. In total (including indention).
* Try to lay out corner-cases. Be as precise as possible, but don't explain the same thing over and over again.
* Use \sa for cross-references.
* \a marks arguments only.
* \c marks values and expressions only.
* \b may be used to emphasize important facts. Please use with care.

Example
-------

````c++
namespace Nuria {

/**
 * \brief MyType can do magic.
 * 
 * This type does something to readers of this file to understand the style
 * guidelines used in the NuriaProject Framework. Not obeying to these will
 * summon horrible things.
 */
class MyType : public QObject {
	Q_OBJECT
public:

	/** Constructs a invalid instance. */
	MyType ();
	
	/**
	 * Does some foo and always returns \c 20 for no apparent reason.
	 */
	int foo ();
	
	/**
	 * Has way too many arguments but is fine for educational purposes.
	 * Takes \a a and multiplies it with \a b. Does something with \a c,
	 * \a d and \a e too, but I don't know what.
	 */
	void pretendWeHaveLotsOfArguments (int a, int b, int c,
					   int d, const QString &e);
	
private:
	QList< int > iAmAList;
	int *myVar;
	bool bla;
};

}

// The implementation
Nuria::MyType::MyType ()
	: myVar (nullptr),
	  bla (false)
{
	foo ();
}

int Nuria::MyType::foo ()  {
	return 5 * 4;
}

// ...
````
