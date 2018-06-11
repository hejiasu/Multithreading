//
//  NSThreadViewController.m
//  Multithreading
//
//  Created by xiaoyi on 17/3/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import "NSThreadViewController.h"

@interface NSThreadViewController ()
//线程锁
@property(strong,nonatomic)NSThread *thread01;
@property(strong,nonatomic)NSThread *thread02;
@property(strong,nonatomic)NSThread *thread03;
@property(assign,nonatomic)NSInteger ticketCount;
//线程锁
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark- 创建线程1
- (IBAction)createThread1:(UIButton *)sender {
    
    /*
     通过alloc init进行创建
     好处：设置一些线程属性；例如线程 名字，从控制台信息可以看出来，当设置了不同的NSThread对象的优先级属性，可以控制其执行的顺序，优先级越高，越先执行；而设置名字属性后，可以通过调试监控当前所处线程，便于问题分析
     */
    //创建线程
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"jack"];
    thread.name = @"my-thread";
    thread.threadPriority = 0.1;

    //启动线程
    [thread start];
    
    if ([thread isMainThread]){
        //是否在主线程执行
    }
    
    if ([NSThread isMainThread]){
        //可用于判断某方法在哪个线程执行
    }
}

#pragma mark- 创建线程2
- (IBAction)createThread2:(UIButton *)sender {
    // 创建方式 2 ：通过 detachNewThreadSelector 方式创建并执行线程
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"rose"];
}

#pragma mark- 创建线程3
- (IBAction)createThread3:(UIButton *)sender {
    
    //创建方式 3：隐式创建后自动启动线程
    [self performSelectorInBackground:@selector(run:) withObject:@"wahaha"];
}

-(void)run:(NSString *)str{
    
    for (NSInteger i = 0; i<10; i++) {
        NSLog(@"-buttonClick-%ld-%@--%@",(long)i,str,[NSThread currentThread]);
        if(i == 9){
            [self performSelectorOnMainThread:@selector(runMainThread) withObject:nil waitUntilDone:YES];
        }
    }
}



-(void)runMainThread{
    NSLog(@"回归主线程--%@",[NSThread currentThread]);
}

#pragma mark-关于线程睡
- (IBAction)threadSleep:(UIButton *)sender {
    [NSThread detachNewThreadSelector:@selector(active) toTarget:self withObject:nil];
}
-(void)active{
    NSLog(@"线程睡眠");
    [NSThread sleepForTimeInterval:2];
    NSLog(@"线程唤醒");
    
    for (NSInteger a = 0; a<10; a++) {
        
        NSLog(@"-执行");
        if (a == 5){
            NSLog(@"退出线程");
            [NSThread exit];//退出线程
            NSLog(@"不会打印");
        }
    }
}



#pragma mark-关于线程锁

- (IBAction)threadLock:(UIButton *)sender {

    self.ticketCount = 5;

    self.thread01 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread01.name = @"售票员1";
    
    self.thread02 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread02.name = @"售票员2";
    
    self.thread03 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread03.name = @"售票员3";

    [self.thread01 start];
    [self.thread02 start];
    [self.thread03 start];
}
-(void)saleTicket{
    while (1) {
        
        NSLog(@"进行卖票-%@",[NSThread currentThread].name);
        // @synchronized (锁对象)，锁对象必须是一个，表示记录状态，一般用self就可以
        @synchronized (self) {
            NSInteger count = self.ticketCount;
            if (count > 0 ){
                self.ticketCount = count - 1;
                NSLog(@"%@卖了一张票，还剩%ld张",[NSThread currentThread].name,(long)self.ticketCount);
            }else{
                NSLog(@"票卖完了");
                break;
            }
        }
    }
}


#pragma mark-线程间的通信

- (IBAction)showImageView:(UIButton *)sender {
    NSLog(@"%@",[NSThread currentThread]);
    [self performSelectorInBackground:@selector(download) withObject:nil];
}

-(void)download{
    NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image =[UIImage imageWithData:data];
    NSLog(@"%@",[NSThread currentThread]);
    [self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:YES];
}

-(void)showImage:(UIImage *)image{
    self.imageView.image = image;
    NSLog(@"%@",[NSThread currentThread]);
}


















@end
