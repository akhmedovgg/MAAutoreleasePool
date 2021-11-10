//
//  NSObject+MAAutoreleasePool.m
//  MAAutoreleasePool
//
//  Created by Sherzod Akhmedov on 11/11/21.
//

#import <Foundation/Foundation.h>
#import "NSObject+MAAutoreleasePool.h"
#import "MAAutoreleasePool.h"

@implementation NSObject (MAAutoreleasePool)

- (id)ma_autorelease
{
    [MAAutoreleasePool addObject:self];
    return self;
}

@end
