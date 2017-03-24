//
//  PTaskChain.h
//  TaskChain
//
//  Created by dyf on 17/3/24.
//  Copyright © 2017年 wisorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTaskChain : NSObject

- (PTaskChain *)run:(void(^)(id input, void(^next)(BOOL go, id output)))task;
- (PTaskChain *(^)(void(^)(id input,void(^next)(BOOL go, id output))))run;

@end
