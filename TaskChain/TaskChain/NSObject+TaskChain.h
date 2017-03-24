//
//  NSObject+TaskChain.h
//  TaskChain
//
//  Created by dyf on 17/3/24.
//  Copyright © 2017年 wisorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskChain.h"

@interface NSObject (TaskChain)

- (void)runInThread:(void(^)(TaskChain *))start;

@end
