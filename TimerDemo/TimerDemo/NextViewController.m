//
//  NextViewController.m
//  TimerDemo
//
//  Created by yFeii on 2020/2/23.
//  Copyright © 2020 yFeii. All rights reserved.
//

#import "NextViewController.h"

#import "YFTimer.h"

@interface NextViewController ()
@property (nonatomic, strong)YFTimer *timer;
@end

@implementation NextViewController

- (void)dealloc {
    [self.timer removeObserver:self forKeyPath:@"isFiring"];
    [self.timer removeObserver:self forKeyPath:@"repeatCount"];
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"NextViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timer = [YFTimer createTimerWithTimeInterval:3 delay:0 repeats:true block:^{
        NSLog(@"next log");
    } scheduledQueue:dispatch_get_main_queue()];
    [self.timer resume];
    [self.timer addObserver:self forKeyPath:@"isFiring" options:NSKeyValueObservingOptionNew context:NULL];
    [self.timer addObserver:self forKeyPath:@"repeatCount" options:NSKeyValueObservingOptionNew context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"isFiring"]) {

        NSLog(@"next isFiring = %@",self.timer.isFiring?@"True":@"False");
    }else if ([keyPath isEqualToString:@"repeatCount"]){
        NSLog(@"next repeatCount = %u",self.timer.repeatCount);
    }
}
@end
