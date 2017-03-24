//
//  NSObject+TaskChain.m
//  TaskChain
//
//  Created by dyf on 17/3/24.
//  Copyright © 2017年 wisorg. All rights reserved.
//

#import "NSObject+TaskChain.h"

@implementation NSObject (TaskChain)
- (void)runInThread:(void(^)(TaskChain *))start
{
    TaskChain *mgr = [[TaskChain alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        start(mgr);
    });
}

@end
