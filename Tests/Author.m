//
//  Author.m
//  OIL
//
//  Created by Julian Dax on 03.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Author.h"


@implementation Author

@synthesize firstName, lastName;

-(Author*)initWithFirstName:(NSString*)theFistName andLastName:(NSString*)theLastName {
    self = [super init];
    if (self) {
        firstName = theFistName;
        lastName = theLastName;

    }
    return self;
      
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}
@end
