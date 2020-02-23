//
//  YFTimer.m
//  TimerDemo
//
//  Created by yFeii on 2020/2/23.
//  Copyright © 2020 yFeii. All rights reserved.
//

#import "YFTimer.h"
#import "pthread.h"
@interface YFTimer ()

@property (nonatomic, copy) eventCallBack timerBlock;

@property (nonatomic, assign, readwrite) BOOL isFiring;
@property (nonatomic, assign, readwrite) unsigned int repeatCount;

@end

@implementation YFTimer{
    dispatch_queue_t _timerQueue;
    dispatch_source_t _timerSource;
    BOOL _repeat;
//    pthread_mutex_t _lock;
}

static dispatch_queue_t yf_timer_scheduled_queue() {
    static dispatch_queue_t yf_timer_scheduled_queue_t;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yf_timer_scheduled_queue_t = dispatch_queue_create("com.yf.timer.scheduled.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return yf_timer_scheduled_queue_t;
}

+ (YFTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(eventCallBack)block{
    
    YFTimer *timer = [YFTimer createTimerWithTimeInterval:interval delay:0 repeats:true block:block scheduledQueue:yf_timer_scheduled_queue()];
    [timer resume];
    return timer;
}

+ (YFTimer *)createTimerWithTimeInterval:(NSTimeInterval)interval delay:(NSTimeInterval)delay repeats:(BOOL)repeats block:(eventCallBack)block scheduledQueue:(dispatch_queue_t)queue{
    
    return [[YFTimer alloc] initWithInterval:interval delay:delay repeats:repeats block:block onThread:queue];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval delay:(NSTimeInterval)delay repeats:(BOOL)repeats block:(eventCallBack)block onThread:(dispatch_queue_t)thread{
    
    self = [super init];
    if (self) {
        _timerBlock = block;
        _isFiring = NO;
        _repeat = repeats;
        _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, thread);
        dispatch_source_set_event_handler(_timerSource, ^{[self fire];});
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
        dispatch_source_set_timer(_timerSource, delayTime, interval*NSEC_PER_SEC, 0);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"timer dealloc");
}

- (void)fire {
    self.repeatCount++;
    if (!_repeat || !self.timerBlock) {
        [self invalidate];
        return;
    }
    self.timerBlock();
}

- (void)suspend{
    if (!self.isFiring) return;
    self.isFiring = NO;
    dispatch_suspend(_timerSource);
}

- (void)resume{
    if (self.isFiring) return;
    self.isFiring = true;
    dispatch_resume(_timerSource);
}

- (void)invalidate{
    dispatch_source_cancel(_timerSource);
    _timerSource = NULL;
    self.repeatCount = 0;
}
@end
