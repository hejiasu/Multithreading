//
//  PthreadController.m
//  Multithreading
//
//  Created by xiaoyi on 17/3/9
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import "PthreadController.h"
#import <pthread.h>
@interface PthreadController ()

@end

@implementation PthreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonClick:(id)sender {
    //PThread的创建
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL);
    
    //PThread的创建
    pthread_t thread1;
    pthread_create(&thread1, NULL, run, NULL);

}

void * run(void *param){
    
    NSLog(@"当前线程--%@",[NSThread currentThread]);
    
    for (NSInteger i = 0; i<5000; i++) {
        NSLog(@"-buttonClick-%ld-%@",(long)i,[NSThread currentThread]);
    }
    return NULL;
}



@end
