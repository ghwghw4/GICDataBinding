//
//  UserAddress.m
//  GICDataBinding_Example
//
//  Created by gonghaiwei on 2019/9/13.
//  Copyright © 2019 gonghaiwei. All rights reserved.
//

#import "UserAddress.h"

@implementation UserAddress
+(instancetype)adress{
    UserAddress *adress = [UserAddress new];
    adress.name = @"上海浦东新区";
    adress.lat= 121.111;
    adress.lng= 32.111;
    
    return adress;
}
@end
