//
//  OILContainer.h
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 Julian Dax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// Use this to mark classes where properties should be injected
@protocol OILInjectable <NSObject>

@end




@interface OILContainer : NSObject {
    NSMutableDictionary* _classInitializerInfos;
    NSMutableDictionary* _protocolInitializerInfos;
    NSMutableDictionary* _singletonInstances;
    NSMutableSet* _singletons;
    NSMutableDictionary* _protocolSingletonInstances;
    NSMutableSet* _protocolSingletons;
}

typedef id(^OILInitBlock) (OILContainer*);



-(void)setInitializer:(OILInitBlock)block forClass:(Class)theClass;
-(void)setInitializer:(OILInitBlock)block forProtocol:(Protocol*)theProtocol;
-(void)removeInitializerForClass:(Class)theClass;
-(void)markClassAsSingleton:(Class)theClass;
-(void)markClassAsNormal:(Class)theClass;
-(void)markProtocolAsSingleton:(Protocol*) theProtocol;
-(id)getInstance:(Class)theClass;
-(id)getInstanceForProtcol:(Protocol*)protocol;
+(OILContainer*)container;

@end




