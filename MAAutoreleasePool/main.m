//
//  main.m
//  MAAutoreleasePool
//
//  Created by Sherzod Akhmedov on 11/11/21.
//

#import <Foundation/Foundation.h>
#import "NSObject+MAAutoreleasePool.h"
#import "MAAutoreleasePool.h"

int main(int argc, const char * argv[]) {
    MAAutoreleasePool *arp1 = [[MAAutoreleasePool alloc] init];
    
    NSString *str1 = [NSString stringWithUTF8String:"Hello, World!"];
    printf("Reference count: %lu\n", [str1 retainCount]);
    
    [arp1 addObject:str1];
    [str1 retain];
    printf("Reference count: %lu\n", [str1 retainCount]);
    
    [arp1 release];
    printf("Reference count: %lu\n", [str1 retainCount]);
    
    return 0;
}
