//
//  OILContainer.h
//  OIL
//
//  Created by Julian Dax on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface OILContainer : NSObject {
    NSMutableDictionary* classInitializerInfos;
    NSMutableDictionary* protocolInitializerInfos;
    NSMutableDictionary* singletonInstances;
    NSMutableSet* singletons;
    NSMutableDictionary* protocolSingletonInstances;
    NSMutableSet* protocolSingletons;
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
+(OILContainer*)globalContainer;

@end




