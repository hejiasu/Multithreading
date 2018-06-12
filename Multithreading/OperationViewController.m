//
//  OperationViewController.m
//  Multithreading
//
//  Created by xiaoyi on 17/3/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import "OperationViewController.h"
#import "SSOperation.h"
@interface OperationViewController ()
@property(strong,nonatomic)NSOperationQueue *queue;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //队列挂起初始化
    //    [self createOperationQueueSuspended];
}


#pragma mark-invocationOperation
- (IBAction)invocationOperation:(id)sender {
    
    //初始化Operation子类
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
    //开启
    [operation start];
}
-(void)run{
    NSLog(@"--%@",[NSThread currentThread]);
}

#pragma mark-blockOperation
- (IBAction)blockOperation:(id)sender {
    
    //初始化Operation子类
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //在主线程
        NSLog(@"--%@",[NSThread currentThread]);
    }];
    
    //添加额外的任务（在子线程执行）
    [operation addExecutionBlock:^{
        NSLog(@"--%@",[NSThread currentThread]);
    }];
    
    [operation start];
}

#pragma mark-OperationQueue基本用法
- (IBAction)creatOperationQueue1:(id)sender {
    
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //创建操作（任务）
    //创建--NSInvocationOperation
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run2) object:nil];
    //创建--NSBlockOperation
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-3--%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-4--%@",[NSThread currentThread]);
    }];
    
    //自定义（需要继承NSOperation，执行的操作需要放在这个自定义类的main中）
    SSOperation *op5 = [[SSOperation alloc]init];
    
    //添加任务队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    //也可以直接创建任务到队列中去
    [queue addOperationWithBlock:^{
        NSLog(@"-6--%@",[NSThread currentThread]);
    }];
}

-(void)run1{
    NSLog(@"-1--%@",[NSThread currentThread]);
}

-(void)run2{
    NSLog(@"-2--%@",[NSThread currentThread]);
}




#pragma mark-OperationQueue相关设置--设置最大并发操作数
- (IBAction)creatOperationQueue2:(id)sender {
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //设置最大并发操作数(不管加入队列有多少操作，实际队列并发数为2)
//    queue.maxConcurrentOperationCount = 2;
    
    //设置为1就成了串行队列
    queue.maxConcurrentOperationCount = 1;
    
    [queue addOperationWithBlock:^{
        NSLog(@"-1--%@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"-2--%@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"-3--%@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"-4--%@",[NSThread currentThread]);
    }];
}



#pragma mark-OperationQueue相关设置--设置队列挂起（暂停）
- (IBAction)createOperationQueueSuspended:(id)sender {

    //创建队列
    self.queue = [[NSOperationQueue alloc]init];
    self.queue.maxConcurrentOperationCount = 1;
    [self.queue addOperationWithBlock:^{
        NSLog(@"-1--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    [self.queue addOperationWithBlock:^{
        NSLog(@"-2--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    [self.queue addOperationWithBlock:^{
        NSLog(@"-3--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    [self.queue addOperationWithBlock:^{
        NSLog(@"-4--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    //设置队列挂起或者取消的话都必须是在block方法执行完之后才有效
    [self.queue addOperationWithBlock:^{
        for(NSInteger i = 0;i<5;i++){
            NSLog(@"-5--%zd---%@",(long)i,[NSThread currentThread]);
        }
    }];
}
#pragma mark-设置队列挂起
- (IBAction)operationSetSuspended:(id)sender {
    if(self.queue.suspended){
        //恢复队列，继续执行
        self.queue.suspended  = NO;
    }else{
        //挂起（暂停队列）
        self.queue.suspended  = YES;
    }
}
#pragma mark-设置队列取消（取消就意味着后续队列不再执行，再次启动需要重新加入队列）
- (IBAction)operationSetCancel:(id)sender {
    [self.queue cancelAllOperations];
}




#pragma mark-OperationQueue相关设置--设置队列依赖
- (IBAction)createOperationQueueSetDependency:(id)sender {

    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down1---%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down2---%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down3---%@",[NSThread currentThread]);
    }];
    
    //设置依赖（op1和op2执行完之后才执行3）
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    
    //监听一个操作的执行完成
    [op3 setCompletionBlock:^{
        NSLog(@"执行完成");
    }];
}

#pragma mark-线程间的通信
- (IBAction)createOperationQueueShowImage:(id)sender {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    __block UIImage *image1;
    NSBlockOperation *downloadw1 = [NSBlockOperation blockOperationWithBlock:^{
        
        //下载图片1
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image1 =[UIImage imageWithData:data];
    }];
    
    __block UIImage *image2;
    NSBlockOperation *downloadw2 = [NSBlockOperation blockOperationWithBlock:^{
        
        //下载图片2
        NSURL *url = [NSURL URLWithString:@"http://pic38.nipic.com/20140228/5571398_215900721128_2.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image2 =[UIImage imageWithData:data];
        
    }];
    
    
    NSBlockOperation *combine = [NSBlockOperation blockOperationWithBlock:^{
        
        //合成新图片
        UIGraphicsBeginImageContext(CGSizeMake(100, 100));
        [image1 drawInRect:CGRectMake(0, 0, 50, 100)];
        [image2 drawInRect:CGRectMake(50, 0, 50, 100)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.imageView.image = image;
        }];
    }];
    
    [combine addDependency:downloadw1];
    [combine addDependency:downloadw2];
    
    [queue addOperation:downloadw1];
    [queue addOperation:downloadw2];
    [queue addOperation:combine];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
