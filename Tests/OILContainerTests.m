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
    
    [testContainer markProtocolAsSingleton:@protocol(Person)];
    
}

-(void)testSetterInjection{
    [[OILContainer container] setInitializer:^id(OILContainer * cont) {
        return [[Author alloc]initWithFirstName:@"HG" andLastName:@"Wells"];} 
                         forClass:[Author class]];
    Book* testBook = [testContainer getInstance:[Book class]];
    Author* injectedAuthor = testBook.injectedAuthor;
    GHAssertTrue([injectedAuthor.firstName isEqualToString:@"HG"],@"Setter injection did not work");
}


-(void)testSetterInjectionOverride{
    Book* testBook = [[OILContainer container] getInstance:[Book class]];
    testBook.injectedAuthor = [[Author alloc] initWithFirstName:@"William" andLastName:@"Gibson"];
    GHAssertTrue([testBook.injectedAuthor.firstName isEqualToString:@"William"], @"Overrriding a injected ivar did not work");
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

-(void)testProtocolBinding{
    Protocol* person = @protocol(Person); 
    [testContainer setInitializer:^(OILContainer* cont){return (id)[[Author alloc] initWithFirstName:@"HG" andLastName:@"Wells"];} forProtocol:person];
    id<Person> myPerson = [testContainer getInstanceForProtcol:person];
    GHAssertNotNil(myPerson, @"Should have been created by AOPContainer");
    GHAssertTrue([myPerson isKindOfClass:[Author class]], @"Person should be bound to author");
    
}

@end
