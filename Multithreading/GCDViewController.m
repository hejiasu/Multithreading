//
//  GCDViewController.m
//  Multithreading
//
//  Created by xiaoyi on 17/3/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import "GCDViewController.h"
@interface GCDViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (strong, nonatomic)  UIImage *image1;
@property (strong, nonatomic)  UIImage *image2;



@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

#pragma mark-异步函数+并发队列：会开启线程

- (IBAction)createAsyncConcurrent:(UIButton *)sender {
    //1、创建一个并发队列
    //参数1：队列的名字
    //参数2：队列的类型(并发：DISPATCH_QUEUE_CONCURRENT,串行：DISPATCH_QUEUE_SERIAL)
//    dispatch_queue_t queue = dispatch_queue_create("com.xiaoyi.queue", DISPATCH_QUEUE_CONCURRENT);
    
    //2、获得全局的并发队列
    //参数1：优先级，官方建议用default
    //参数2：第二个参数目前没有意义，官方文档提示传0
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2、将任务加入队列
    dispatch_async(queue, ^{
        

        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"1--%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_async(queue, ^{

        for (NSInteger i = 0; i<5; i++) {
            
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
}
#pragma mark-同步函数+并发队列：不会开启线程

- (IBAction)createSyncConcurrent:(UIButton *)sender {
    
    //1、创建一个并发队列
    //参数1：队列的名字
    //参数2：队列的类型(并发：DISPATCH_QUEUE_CONCURRENT,串行：DISPATCH_QUEUE_SERIAL)
    //    dispatch_queue_t queue = dispatch_queue_create("com.xiaoyi.queue", DISPATCH_QUEUE_CONCURRENT);
    
    //2、获得全局的并发队列,系统自带
    //参数1：优先级，官方建议用default
    //参数2：第二个参数目前没有意义，官方文档提示传0
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    //2、将任务加入队列
    dispatch_sync(queue, ^{
    
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"1--%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_sync(queue, ^{
        
        for (NSInteger i = 0; i<5; i++) {
            
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
}

#pragma mark- 异步函数+串行队列:会开线程（只能开一条），任务是串行的，执行完一个在执行下一个
- (IBAction)createAsyncSerial:(id)sender {
    
    //1、创建一个串行队列（没有全局，只能创建）
    //参数1：队列的名字
    //参数2：队列的类型(并发：DISPATCH_QUEUE_CONCURRENT,串行：DISPATCH_QUEUE_SERIAL)
    dispatch_queue_t queue = dispatch_queue_create("com.xiaoyi.queue", DISPATCH_QUEUE_SERIAL);
    
    //1、创建一个串行队列(第二种方法)
    //参数1：队列的名字
    //参数2：队列的类型（NULL）
//    dispatch_queue_t queue = dispatch_queue_create("com.xiaoyi.queue", NULL);

    
  
    //2、将任务加入队列
    dispatch_async(queue, ^{
        

        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"1--%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });


}
#pragma mark- 同步函数+串行队列:不会开线程，在当前线程执行任务

- (IBAction)createSyncSerial:(id)sender {

    //1、创建一个串行队列（没有全局，只能创建）
    //参数1：队列的名字
    //参数2：队列的类型(并发：DISPATCH_QUEUE_CONCURRENT,串行：DISPATCH_QUEUE_SERIAL)
    //    dispatch_queue_t queue = dispatch_queue_create("com.xiaoyi.queue", DISPATCH_QUEUE_SERIAL);
    
    //1、创建一个串行队列(第二种方法)
    //参数1：队列的名字
    //参数2：队列的类型（NULL）
    dispatch_queue_t queue = dispatch_queue_create("com.xiaoyi.queue", NULL);
    
    
    
    //2、将任务加入队列
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"1--%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
}

#pragma mark -异步函数+主队列：不开线程

- (IBAction)createAsyncMainQueue:(id)sender {

    
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //2、将任务加入队列
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"1--%@",[NSThread currentThread]);
        }
        
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });

}
//同步和异步主要影响能不能开线程
//串行和并行主要影响任务的执行方式
#pragma mark -同步函数+主队列：卡死崩溃

- (IBAction)createSyncMainQueue:(id)sender {

    
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //2、将任务加入队列
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"1--%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
    
}

#pragma mark-线程间通信

- (IBAction)showImage:(id)sender {

    //图片子线程下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image =[UIImage imageWithData:data];
        
        //图片主线程显示
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    });
}



#pragma mark-给线程设置barrier
- (IBAction)queueSetBarrier:(id)sender {

    
    dispatch_queue_t queue = dispatch_queue_create("com.xiaoyi.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<3; i++) {
            NSLog(@"1----%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<3; i++) {
            NSLog(@"2----%@",[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_sync(queue, ^{
        NSLog(@"--barrier--%@",[NSThread currentThread]);
     });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<3; i++) {
            NSLog(@"3----%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<3; i++) {
            NSLog(@"4----%@",[NSThread currentThread]);
        }
    });
}

#pragma mark-延时

- (IBAction)queueSetDelayed:(id)sender {
    //第一种延时
    [self performSelector:@selector(run) withObject:nil afterDelay:2];
    //第二种延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"run");
    });
    //第三种延时
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(run) userInfo:nil repeats:NO];
    NSLog(@"start");
}
-(void)run{
    NSLog(@"run");
}


#pragma mark-一次性代码
- (IBAction)once:(id)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"--程序在整个加载过程只会加载一次");
    });
}


#pragma mark-快速迭代

- (IBAction)rapidIteration:(id)sender {

    //主要用于并发队列
    //参数1： 指定重复次数
    //参数2：对象的DispatchQueue
    //参数3：带有参数的Block, index的作用是为了按执行的顺序区分各个Block
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_apply(10, queue, ^(size_t index) {
//        NSLog(@"%@--%zu",[NSThread currentThread],index);
//    });
//    NSLog(@"done");
    
    
    NSArray *dictArray = nil;//存放从服务器返回的字典数组
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        dispatch_apply(dictArray.count, queue,  ^(size_t index){
            //字典转模型
            
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"主线程更新");
        });
    });
    
};


#pragma mark-队列组

- (IBAction)queueGroup:(id)sender {
    
    //创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"download image1 start");
        //下载图片1
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.image1 =[UIImage imageWithData:data];
        NSLog(@"download image1 end");

    });
    
    
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"download image2 start");

        //下载图片2
        NSURL *url = [NSURL URLWithString:@"http://pic38.nipic.com/20140228/5571398_215900721128_2.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.image2 =[UIImage imageWithData:data];
        
        NSLog(@"download image2 end");

    });
    
    //当这个队列组的所有队列全部完成，就会收到这个消息
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"download all images");
        
        //合成新图片
        UIGraphicsBeginImageContext(CGSizeMake(100, 100));
        [self.image1 drawInRect:CGRectMake(0, 0, 50, 100)];
        [self.image2 drawInRect:CGRectMake(50, 0, 50, 100)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //在主线程显示
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}











@end
