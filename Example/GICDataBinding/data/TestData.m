//
//  UserInfo.m
//  GICDataBinding_Example
//
//  Created by gonghaiwei on 2019/9/13.
//  Copyright © 2019 gonghaiwei. All rights reserved.
//

#import "TestData.h"

@implementation TestData
+(instancetype)testData{
    TestData *user = [TestData new];
    user.name = @"haiwei";
    user.age = 20;
    user.isMale = YES;
    user.address = [UserAddress adress];
    user.dict = @{@"a":@"A",@"b":@"B"};
    
    user.dict2 = [@{@"a":@"A1",@"b":@"B1"} mutableCopy];
    user.array = @[@"1",@"2",@"3"];
    user.mutArray = [@[@(0)] mutableCopy];
    return user;
}
@end
