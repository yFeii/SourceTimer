//
//  ViewController.m
//  TimerDemo
//
//  Created by yFeii on 2020/2/23.
//  Copyright © 2020 yFeii. All rights reserved.
//

#import "ViewController.h"
#import "YFTimer.h"
#import "NextViewController.h"

@interface ViewController ()
@property (nonatomic, strong)YFTimer *timer;
@property (nonatomic, strong)YFTimer *timer1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timer = [YFTimer scheduledTimerWithTimeInterval:1 repeats:true block:^{
        NSLog(@"333");
    }];
    [self.timer resume];
    [self.timer addObserver:self forKeyPath:@"isFiring" options:NSKeyValueObservingOptionNew context:NULL];
    [self.timer addObserver:self forKeyPath:@"repeatCount" options:NSKeyValueObservingOptionNew context:NULL];
//    [self raceTest];
    
}
- (void)raceTest {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        while (true) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self.timer resume];
            });
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        while (true) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self.timer suspend];
            });
        }
    });

}

int clickCount = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ((clickCount & 1) == 1) {
        [self.timer suspend];
    }else{
            
        [self.timer resume];
    }
    clickCount ++;
    NextViewController *v = [[NextViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nav animated:true completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"isFiring"]) {

        NSLog(@"isFiring = %@",self.timer.isFiring?@"True":@"False");
    }else if ([keyPath isEqualToString:@"repeatCount"]){
        NSLog(@"repeatCount = %u",self.timer.repeatCount);
    }
}

@end
