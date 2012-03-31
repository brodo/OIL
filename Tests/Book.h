//
//  Book.h
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 Julian Dax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"
#import "OILContainer.h"

@interface Book : NSObject <OILInjectable>{
    NSString* title;
    Author* author;
}
-(Book*)initWithTitle:(NSString*)theTitle;
-(Book*)initWithTitle:(NSString*)theTitle andAuthor:(Author*)theAuthor;

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) Author* author;
@property (nonatomic, retain) Author* injectedAuthor;

@end
