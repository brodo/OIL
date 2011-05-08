//
//  Book.h
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"


@interface Book : NSObject {
    NSString* title;
    Author* author;
}
-(Book*)initWithTitle:(NSString*)theTitle;
-(Book*)initWithTitle:(NSString*)theTitle andAuthor:(Author*)theAuthor;

@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) Author* author;
@end
