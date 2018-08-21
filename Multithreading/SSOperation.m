//
//  SSOperation.m
//  Multithreading
//
//  Created by xiaoyi on 17/3/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import "SSOperation.h"

@implementation SSOperation

#pragma mark-需要执行的任务
-(void)main{
    if (!self.isCancelled) {
        NSLog(@"-0--%@",[NSThread currentThread]);
    }
}
@end
