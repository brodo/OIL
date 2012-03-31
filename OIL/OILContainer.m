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
-(void)setUpSetterInjection;

@end

@implementation OILContainer


- (id)init {
    self = [super init];
    if (self) {
        _classInitializerInfos = [[NSMutableDictionary alloc] init];
        _protocolInitializerInfos = [[NSMutableDictionary alloc] init];
        _singletons = [[NSMutableSet alloc] init];
        _protocolSingletons = [[NSMutableSet alloc] init];
        _singletonInstances = [[NSMutableDictionary alloc] init];
        _protocolSingletonInstances = [[NSMutableDictionary alloc]init];
        globalContainer = nil;
        [self setUpSetterInjection];
    }
    return self;
}

-(void)setInitializer:(OILInitBlock)block forClass:(Class)theClass {
    [_classInitializerInfos setObject:block forKey:theClass];
}

-(void)setInitializer:(OILInitBlock)block forProtocol:(Protocol*)theProtocol{
    [_protocolInitializerInfos setObject:block forKey:NSStringFromProtocol(theProtocol)];
}

-(void)removeInitializerForClass:(Class)theClass {
    [_classInitializerInfos removeObjectForKey:theClass];
}

-(void)markClassAsSingleton:(Class)theClass {
    [_singletons addObject:theClass];
}

-(void)markProtocolAsSingleton:(Protocol*) theProtocol{
    [_protocolSingletons addObject:theProtocol];
}

-(void)markClassAsNormal:(Class)theClass {
    [_singletons removeObject:theClass];
}

-(id)getInstance:(Class)theClass {
    if ([_singletons containsObject:theClass]) {
        return [self getSingletonForClass:theClass];
    }
    return [self getNewForClass:theClass];
}

-(id)getInstanceForProtcol:(Protocol*)protocol{
    if ([_protocolSingletons containsObject:protocol]) {
        return [self getSingletonForProtocol:protocol];
    }
    return [self getNewForProtocol:protocol];
}



+(OILContainer*)container {
    if (!globalContainer) {
        globalContainer = [[OILContainer alloc] init];
    }
    return globalContainer;
}

@end

@implementation OILContainer (private)

-(id)getNewForClass:(Class)theClass {
    id theObject;
    if ([_classInitializerInfos objectForKey:theClass]) {
        OILInitBlock objectCreator = (OILInitBlock)[_classInitializerInfos objectForKey:theClass];
        theObject = objectCreator(self);
    }
    else {
        theObject = [[theClass alloc] init];
    }
    return  theObject;
}

-(id)getNewForProtocol:(Protocol*)theProtocol{
    id theObject;
    if ([_protocolInitializerInfos objectForKey:NSStringFromProtocol(theProtocol)]) {
        OILInitBlock objectCreator = (OILInitBlock)[_protocolInitializerInfos objectForKey:NSStringFromProtocol(theProtocol)];
        theObject = objectCreator(self);
    }
    else {
        theObject = nil;
    }
    return  theObject;
    
}

-(id)getSingletonForClass:(Class)theClass{
    id retunObject = [_singletonInstances objectForKey:theClass];
    if (!retunObject) {
        retunObject = [self getNewForClass:theClass];
        [_singletonInstances setObject:retunObject forKey:theClass];
    }
    return retunObject;
}

-(id)getSingletonForProtocol:(Protocol*) theProtocol{
    id retunObject = [_protocolSingletonInstances objectForKey:NSStringFromProtocol(theProtocol)];
    if (!retunObject) {
        retunObject = [self getNewForProtocol:theProtocol];
        [_protocolSingletonInstances setObject:retunObject forKey:NSStringFromProtocol(theProtocol)];
    }
    return retunObject;
}

id replacementGetter(id self, SEL _cmd, ...){
    NSString* selector = NSStringFromSelector(_cmd);
    NSString* name = [selector substringFromIndex:8];
    Ivar var = class_getInstanceVariable([self class], [selector cStringUsingEncoding:NSASCIIStringEncoding]);
    id returnVal = object_getIvar(self, var);
    
    if (!returnVal) {
        returnVal = [[OILContainer container] getInstance:NSClassFromString(name)];
    }
    return returnVal;
}

-(void)setUpSetterInjection{
    // Get all Classes 
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            if (class_conformsToProtocol(classes[i], NSProtocolFromString(@"OILInjectable"))) { // We only care for classes marked with that protocol
                unsigned int numProperites;
                objc_property_t *  properties = class_copyPropertyList(classes[i], &numProperites);
                for (int j = 0; j < numProperites; j++) {
                    NSString* propertyName =[NSString stringWithCString:property_getName(properties[j]) encoding:NSASCIIStringEncoding];
                    if ([propertyName length] > 8 && [[propertyName substringToIndex:8] isEqualToString:@"injected"]) {
                        class_replaceMethod(classes[i], NSSelectorFromString(propertyName), replacementGetter, "@@:");
                    }
                }
            }
        }
        free(classes);
    }
}

@end
