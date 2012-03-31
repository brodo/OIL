//
//  Book.m
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Book.h"

@implementation Book

@synthesize title, author, injectedAuthor;

-(Book*)initWithTitle:(NSString*)theTitle {
    self = [super init];
    if (self) {
        title = theTitle;
        author = nil;
    }
    return self;
}

-(Book*)initWithTitle:(NSString *)theTitle andAuthor:(Author*)theAuthor {
    self = [super init];
    if (self) {
        title = theTitle;
        author = theAuthor;
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ by %@", title, author];
}


@end
