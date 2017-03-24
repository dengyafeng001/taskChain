//
//  AppDelegate.m
//  TaskChain
//
//  Created by dyf on 17/3/23.
//  Copyright © 2017年 wisorg. All rights reserved.
//

#import "AppDelegate.h"
#import "TaskChain.h"
#import "PTaskChain.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)longTimeTask:(void(^)(void))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //不携带传递参数
    TaskChain *mm = [[TaskChain alloc] init];
    mm.run(^(void(^next)(BOOL go)){
        [self longTimeTask:^{
            NSLog(@"12");
            next(YES);
        }];
    }).run(^(void(^next)(BOOL go)){
        [self longTimeTask:^{
            NSLog(@"13后面不会执行");
            next(NO);
        }];
    }).run(^(void(^next)(BOOL go)){
        [self longTimeTask:^{
            NSLog(@"14");
            next(YES);
        }];
    });
    
    //携带传递参数
    PTaskChain *mgr = [[PTaskChain alloc] init];
    [[mgr run:^(id input, void (^next)(BOOL go, id output)) {
        [self longTimeTask:^{
            NSLog(@"1:传递来的参数：%@",input);
            next(YES,@"1");
        }];
    }] run:^(id input, void (^next)(BOOL go, id output)) {
        [self longTimeTask:^{
            NSLog(@"2:传递来的参数：%@",input);
            next(YES,@"2");
        }];
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
