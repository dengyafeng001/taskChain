# taskChain
把有依赖关系的异步请求串行形成任务链，当其中一个任务要求中断则断开整条任务链，后续任务也不会继续执行。
根据实际项目中的业务需求做的封装,可能不适用于大部分同学的项目需求，但至少比使用gcd实现串行看起来代码整洁不少。如果赞同请给颗star～～
# 背景
在我开发项目过程中有这样一个场景，应用启动时要先更新token（已登录情况），然后获取用户资料，更新服务器配置信息等，后两个请求是必须依赖token更新成功的，所以需要把它们从业务上串连起来。
# 实现
参考ReactiveCocoa和Masory两大第三方框架的链式编程特点，实现了“中括号”和“点block”两种调用方式。另外实现了任务间传参的需求，方便两个任务间要根据参数来做不同逻辑处理。

###原理：
通过run方法传递进来的任务会保存到array数组中，然后取第一个任务开始执行，当第一个任务执行完毕（任务需要`主动回调next()`)继续下一个。如果其中一个任务回调了next(NO)，则把array中所有任务remove掉。参数传递的原理也是通过next，前一个任务在执行完毕后回调next（YES，data）来把参数传递到下一个任务中。
```oc
//不携带传递参数，masory风格
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
    //携带传递参数，RAC风格
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
    }];```
