//
//  MAAutoreleasePool.m
//  MAAutoreleasePool
//
//  Created by Sherzod Akhmedov on 11/11/21.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "MAAutoreleasePool.h"

@implementation MAAutoreleasePool

+ (CFMutableArrayRef)_threadPoolStack
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSString *key = [[NSString alloc] initWithUTF8String:"MAAutoreleasePool thread-local pool stack"];
    CFMutableArrayRef array = (CFMutableArrayRef)[threadDictionary objectForKey:key];
    
    if (!array) {
        array = CFArrayCreateMutable(NULL, 0, NULL);
        [threadDictionary setObject:(id)array forKey:key];
        CFRelease(array);
    }
    
    return array;
}

- (id)init
{
    self = [super init];
    if (self) {
        _objects = CFArrayCreateMutable(NULL, 0, NULL);
        CFArrayAppendValue([[self class] _threadPoolStack], self);
    }
    return self;
}

+ (void)addObject:(id)object
{
    CFArrayRef array = [self _threadPoolStack];
    CFIndex count = CFArrayGetCount(array);
    
    if (count == 0) {
        fprintf(stderr, "Object of class %s autoreleased with no pool, leaking\n", class_getName(object_getClass(object)));
    } else {
        MAAutoreleasePool *pool = (id)CFArrayGetValueAtIndex(array, count - 1);
        [pool addObject:object];
    }
}

- (void)addObject:(id)object
{
    CFArrayAppendValue(_objects, object);
}

- (void)dealloc
{
    if (_objects) {
        for (id object in (id)_objects) {
            [object release];
        }
        CFRelease(_objects);
    }
    
    CFMutableArrayRef stack = [[self class] _threadPoolStack];
    CFIndex index = CFArrayGetCount(stack);
    
    while (index -- > 0) {
        MAAutoreleasePool *pool = (id)CFArrayGetValueAtIndex(stack, index);
        if (pool == self) {
            CFArrayRemoveValueAtIndex(stack, index);
            break;
        } else {
            [pool release];
        }
    }
    
    [super dealloc];
}

@end
