//
//  OILContainer.m
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OILContainer.h"

static OILContainer* globalContainer;

@interface OILContainer (private)

-(id)getSingletonForClass:(Class)theClass;
-(id)getNewForClass:(Class)theClass;

@end

@implementation OILContainer


- (id)init {
    self = [super init];
    if (self) {
        classInitializerInfos = [[NSMutableDictionary alloc] init];
        singletons = [[NSMutableSet alloc] init];
        singletonInstances = [[NSMutableDictionary alloc] init];
        globalContainer = nil;
    }
    return self;
}

-(void)setInitializer:(OILInitBlock)block forClass:(Class)theClass {
    [classInitializerInfos setObject:block forKey:theClass];
}

-(void)removeInitializerForClass:(Class)theClass {
    [classInitializerInfos removeObjectForKey:theClass];
}

-(void)markClassAsSingleton:(Class)theClass {
    [singletons addObject:theClass];
}

-(void)markClassAsNormal:(Class)theClass {
    [singletons removeObject:theClass];
}

-(id)getInstance:(Class)theClass {
    if ([singletons containsObject:theClass]) {
        return [self getSingletonForClass:theClass];
    }
    return [self getNewForClass:theClass];
}

+(OILContainer*)globalContainer {
    if (!globalContainer) {
        globalContainer = [[OILContainer alloc] init];
    }
    return globalContainer;
}
- (void)dealloc {
    [classInitializerInfos release];
    [singletonInstances release];
    [singletons release];
    [globalContainer release];
    [super dealloc];
}

@end

@implementation OILContainer (private)

-(id)getNewForClass:(Class)theClass {
    id theObject;
    if ([classInitializerInfos objectForKey:theClass]) {
        OILInitBlock objectCreator = (OILInitBlock)[classInitializerInfos objectForKey:theClass];
        theObject = objectCreator(self);
    }
    else {
        theObject = [[theClass alloc] init];
    }
    return  theObject;
}

-(id)getSingletonForClass:(Class)theClass{
    id retunObject = [singletonInstances objectForKey:theClass];
    if (!retunObject) {
        retunObject = [self getNewForClass:theClass];
        [singletonInstances setObject:retunObject forKey:theClass];
    }
    return retunObject;
}


@end
