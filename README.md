Overview
========

Objective C Dependency Injection Library (OIL) is a tiny dependency injection library for Objective C consisting only of one class. It supports both setter and initializer injection, singletons and protocol bindings. All Configuration is done in the source code itself, so there is no need for config files.


Setting Up OIL
==============

[Download](https://github.com/downloads/brodo/OIL/OILContainer.zip) and extract OILContainer.zip in your project directory. It contains only *OILContainer.h* and *OILContainer.m*. Add these files to your XCode project.

Using OIL
=========

Getting Started
---------------

The code below creates a new container and uses this container to create an instance of the class 'MyClass'.

    //First, set up an OILContainer
    OILContainer* myContainer = [[OILContainer alloc] init];
    //To get a new object of class MyClass, do this:
    MyClass *myObject = [myContainer getInstance:[MyClass class]];

OIL will instantiate myObject by simply calling `[[MyClass alloc] init]`. 

Initializer And Setter Injection
--------------------------------

If you want OIL to use a different init method, or if you want to set certain instance variables directly after creation of the object, you need to provide an *OILInitBlock*. Each class can have one init block. Init blocks are executed, when `getInstance` is called. They do all initialisation and return the object.

```objective-c
    //Set up an OILContainer
    OILContainer* myContainer = [[OILContainer alloc] init];
    //This tells OILContainer what to do if the user wants a new instance of 'MyClass':
    [myContainer setInitializer:^(OILContainer container){
        id myObject = [[MyClass alloc] initWithNumber:5]; //calling custom init method
        myObject.attribute = @"test"; //setting an inistance variable

    } forClass:[MyClass class]];
    
    //Get a new instance of MyClass. It will be initialized with the init block which we just provided.
    MyClass *myObjec = [myContainer getInstance:[MyClass class]];
```

Init blocks take an OILContainer and return the Object which they initialized.

Creating Object Hierarchies
---------------------------

In many cases, an object created by OIL is based on other objects which themselves need to be instantiated by OIL. As an example, consider the following Classes:

**Author.h**

    @interface Author : NSO:wbject {
       NSString* firstName;
       NSString* lastName;
    }

    -(Author*)initWithFirstName:(NSString*)theFistName andLastName:(NSString*)theLastName;
    @end

**Book.h**

    @interface Book : NSObject {
        NSString* title;
        Author* author;
    }
    -(Book*)initWithTitle:(NSString*)theTitle andAuthor:(Author*)theAuthor;
    @end
    
The class 'Book' depends on 'Author'. In order to let OIL create both the book and the author with their designated initializers, you need to call OIL in the initialization code like this:

    //Set up an OILConteainer
    OILContainer* myContainer = [[OILContainer alloc] init];
    //Set initializer for 'Author'
    [myContainer setInitializer:^(OILContainer* cont){
         return (id)[[Author alloc] initWithFirstName:@"Herbert George" andLastName:@"Wells"];
    } forClass:[Author class]];
    //Set initializer for 'Book'  
    [myContainer setInitializer:
     ^(OILContainer* cont){
         return (id)[[Book alloc] initWithTitle:@"The Time Machine" andAuthor:[cont getInstance:[Author class]]];
    } forClass:[Book class]];
    //Create book instance
    Book* myBook = [testContainer getInstance:[Book class]];

OIL now creates the book with the author HG Wells.

Binding Protocols To Classes
----------------------------

It is possible to bind a protocol to a certain class which implements the protocol like this:

    //Set up an OILConteainer
    OILContainer* myContainer = [[OILContainer alloc] init];
    Protocol* person = @protocol(Person); //'Person' is a protocoll which is implemented by 'Author'
    [myContainer setInitializer:^(OILContainer* cont){return (id)[[Author alloc] initWithFirstName:@"HG" andLastName:@"Wells"];} forProtocol:person];
    id<Person> myPerson = [myContainer getInstanceForProtcol:person]; //myPerson is an instance of 'Author'
   

Singletons
----------

You can mark a certain class or protocol as singleton, by calling the *markClassAsSingleton* or *markProtocolAsSingleton* methods like so:

    [myContainer markClassAsSingleton:[MyClass class]];
    [myContainer markProtocolAsSingleton:@protocol(MyProtocoll)];

Singletons are created lazily, as soon as they are needed.
