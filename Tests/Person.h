//
//  Person.h
//  OIL
//
//  Created by Julian Dax on 31.05.11.
//  Copyright 2011 Julian Dax. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol Person <NSObject>

@property(nonatomic,readonly)NSString* firstName;
@property(nonatomic,readonly)NSString* lastName;

@end
