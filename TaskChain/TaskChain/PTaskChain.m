//
//  PTaskChain.m
//  TaskChain
//
//  Created by dyf on 17/3/24.
//  Copyright © 2017年 wisorg. All rights reserved.
//

#import "PTaskChain.h"

@interface PTaskChain ()
@property (nonatomic, assign) BOOL stop;

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, copy) void(^runingTask)(id,void(^)(BOOL stop, id output));
@property (nonatomic, strong) id data;
@end

@implementation PTaskChain


- (id)init
{
    self = [super init];
    if (self) {
        self.tasks = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc {
    self.runingTask = NULL;
}

- (PTaskChain *)run:(void(^)(id input, void(^next)(BOOL go, id output)))task
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tasks addObject:task];
        [self flushQueue];
    });
    return self;
}

- (PTaskChain *(^)(void(^)(id input,void(^next)(BOOL go, id output))))run
{
    return ^PTaskChain *(void(^f)(id input,void(^finish)(BOOL,id))){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tasks addObject:f];
            [self flushQueue];
        });
        return self;
    };
}

- (void)flushQueue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.runingTask) {
            return;
        }
        if (self.stop) {
            [_tasks removeAllObjects];
            return;
        }
        if ([_tasks count] > 0) {
            self.runingTask = _tasks[0];
            [_tasks removeObjectAtIndex:0];
            
            void (^fi)(BOOL,id) = ^(BOOL go, id data) {
                self.stop = !go;
                self.data = data;
                self.runingTask = NULL;
                [self flushQueue];
            };
            _runingTask(_data,fi);
        }
    });
}

@end
