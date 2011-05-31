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
-(id)getSingletonForProtocol:(Protocol*) theProtocol;
-(id)getNewForClass:(Class)theClass;
-(id)getNewForProtocol:(Protocol*)theProtocol;

@end

@implementation OILContainer


- (id)init {
    self = [super init];
    if (self) {
        classInitializerInfos = [[NSMutableDictionary alloc] init];
        protocolInitializerInfos = [[NSMutableDictionary alloc] init];
        singletons = [[NSMutableSet alloc] init];
        protocolSingletons = [[NSMutableSet alloc] init];
        singletonInstances = [[NSMutableDictionary alloc] init];
        protocolSingletonInstances = [[NSMutableDictionary alloc]init];
        globalContainer = nil;
    }
    return self;
}

-(void)setInitializer:(OILInitBlock)block forClass:(Class)theClass {
    [classInitializerInfos setObject:block forKey:theClass];
}

-(void)setInitializer:(OILInitBlock)block forProtocol:(Protocol*)theProtocol{
    [protocolInitializerInfos setObject:block forKey:NSStringFromProtocol(theProtocol)];
}

-(void)removeInitializerForClass:(Class)theClass {
    [classInitializerInfos removeObjectForKey:theClass];
}

-(void)markClassAsSingleton:(Class)theClass {
    [singletons addObject:theClass];
}

-(void)markProtocolAsSingleton:(Protocol*) theProtocol{
    [protocolSingletons addObject:theProtocol];
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

-(id)getInstanceForProtcol:(Protocol*)protocol{
    if ([protocolSingletons containsObject:protocol]) {
        return [self getSingletonForProtocol:protocol];
    }
    return [self getNewForProtocol:protocol];
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
    [protocolSingletons release];
    [protocolInitializerInfos release];
    [protocolSingletonInstances release];
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

-(id)getNewForProtocol:(Protocol*)theProtocol{
    id theObject;
    if ([protocolInitializerInfos objectForKey:NSStringFromProtocol(theProtocol)]) {
        OILInitBlock objectCreator = (OILInitBlock)[protocolInitializerInfos objectForKey:NSStringFromProtocol(theProtocol)];
        theObject = objectCreator(self);
    }
    else {
        theObject = nil;
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

-(id)getSingletonForProtocol:(Protocol*) theProtocol{
    id retunObject = [protocolSingletonInstances objectForKey:NSStringFromProtocol(theProtocol)];
    if (!retunObject) {
        retunObject = [self getNewForProtocol:theProtocol];
        [protocolSingletonInstances setObject:retunObject forKey:NSStringFromProtocol(theProtocol)];
    }
    return retunObject;
}

@end
