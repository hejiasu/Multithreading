//
//  FirstViewController.m
//  Multithreading
//
//  Created by xiaoyi on 17/3/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"当前线程%@",[NSThread currentThread]);
    
    
}
- (IBAction)buttonClick:(id)sender {
    
    for (NSInteger i = 0; i<10000; i++) {
        NSLog(@"---buttonClick----%d",i);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
