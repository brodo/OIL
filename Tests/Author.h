//
//  Author.h
//  OIL
//
//  Created by Julian Dax on 03.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Author : NSObject <Person> {
    NSString* firstName;
    NSString* lastName;
}

-(Author*)initWithFirstName:(NSString*)theFistName andLastName:(NSString*)theLastName;

@property(nonatomic,readonly)NSString* firstName;
@property(nonatomic,readonly)NSString* lastName;

@end
