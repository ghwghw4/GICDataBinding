//
//  Theme.m
//  GICDataBinding_Example
//
//  Created by 龚海伟 on 2019/9/19.
//  Copyright © 2019 gonghaiwei. All rights reserved.
//

#import "Theme.h"

@implementation Theme
+(instancetype)theme{
    Theme *t = [Theme new];
    t.backgroundColor = [UIColor blackColor];
    t.titleColor = [UIColor whiteColor];
    t.title = @"测试数据绑定";
    return t;
}
@end
