//
//  MAAutoreleasePool.h
//  MAAutoreleasePool
//
//  Created by Sherzod Akhmedov on 11/11/21.
//

#ifndef MAAutoreleasePool_h
#define MAAutoreleasePool_h

@interface MAAutoreleasePool : NSObject
{
    CFMutableArrayRef _objects;
}

+ (void)addObject:(id)object;

- (void)addObject:(id)object;

@end

#endif /* MAAutoreleasePool_h */
