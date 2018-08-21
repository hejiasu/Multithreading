//
//  SSOperation.h
//  Multithreading
//
//  Created by xiaoyi on 17/3/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSOperation : NSOperation
@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished) BOOL finished;
@end
