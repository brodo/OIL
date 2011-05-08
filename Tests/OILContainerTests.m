//
//  OILContainerTests.m
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OILContainerTests.h"


@implementation OILContainerTests

- (void)setUp {
    testContainer = [[OILContainer alloc] init];
}

- (void)tearDown {
    [testContainer release];
    testContainer = nil;
}  

-(void)testInitOfUnknownClass{
    Book* testBook = [testContainer getInstance:[Book class]];
    GHAssertTrue([testBook isKindOfClass:[Book class]], @"Object schould be kind of class \"book\"");
}

-(void)testinitForKnownClass{
    [testContainer setInitializer:
     ^(OILContainer* cont){return [[Book alloc] initWithTitle:@"Test"];} forClass:[Book class]];
    Book* testBook = [testContainer getInstance:[Book class]];
    GHAssertEqualStrings(@"Test", testBook.title, @"Initialization did not work.");
}

-(void)testSingleton{
    [testContainer markClassAsSingleton:[Book class]];
    Book* book1 = [testContainer getInstance:[Book class]];
    Book* book2 = [testContainer getInstance:[Book class]];
    GHAssertEquals(book1, book2, @"Both variables should point to the same instance.");
    
}

-(void)testComplexObject{
    [testContainer setInitializer:^(OILContainer* cont){
         return (id)[[Author alloc] initWithFirstName:@"HG" andLastName:@"Wells"];
    } forClass:[Author class]];
      
    
    [testContainer setInitializer:
     ^(OILContainer* cont){
         return (id)[[Book alloc] initWithTitle:@"test" andAuthor:[cont getInstance:[Author class]]];
    } forClass:[Book class]];
    Book* testBook = [testContainer getInstance:[Book class]];
    GHAssertEqualStrings(testBook.title,@"test", @"Book initialization went wrong");
    GHAssertEqualStrings(testBook.author.firstName, @"HG", @"Author initialisazion went wrong");

}

@end