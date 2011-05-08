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
    NSMutableDictionary* singletonInstances;
    NSMutableSet* singletons;
}

typedef id(^OILInitBlock) (OILContainer*);



-(void)setInitializer:(OILInitBlock)block forClass:(Class)theClass;
-(void)removeInitializerForClass:(Class)theClass;
-(void)markClassAsSingleton:(Class)theClass;
-(void)markClassAsNormal:(Class)theClass;
-(id)getInstance:(Class)theClass;
+(OILContainer*)globalContainer;

@end




