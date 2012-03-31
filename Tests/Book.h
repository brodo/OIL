//
//  Book.h
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 Julian Dax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"
#import "OILInjectable.h"

@interface Book : NSObject <OILInjectable>{
    NSString* title;
    Author* author;
}
-(Book*)initWithTitle:(NSString*)theTitle;
-(Book*)initWithTitle:(NSString*)theTitle andAuthor:(Author*)theAuthor;

@property (nonatomic) NSString* title;
@property (nonatomic) Author* author;
@property (nonatomic) Author* injectedAuthor;

@end
