//
//  YFTimer.h
//  TimerDemo
//
//  Created by yFeii on 2020/2/23.
//  Copyright © 2020 yFeii. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^eventCallBack)(void);
@interface YFTimer : NSObject
/* KVO */
@property (nonatomic, assign, readonly) BOOL isFiring;
@property (nonatomic, assign, readonly) unsigned int repeatCount;

+ (YFTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(eventCallBack)block;

+ (YFTimer *)scheduledTimerInBackgroundThreadWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(eventCallBack)block;

+ (YFTimer *)createTimerWithTimeInterval:(NSTimeInterval)interval delay:(NSTimeInterval)delay repeats:(BOOL)repeats block:(eventCallBack)block scheduledQueue:(dispatch_queue_t)queue;

- (instancetype)initWithInterval:(NSTimeInterval)interval delay:(NSTimeInterval)delay repeats:(BOOL)repeats block:(eventCallBack)block onThread:(dispatch_queue_t)thread;

- (void)suspend;
- (void)resume;
- (void)invalidate;
@end

NS_ASSUME_NONNULL_END
