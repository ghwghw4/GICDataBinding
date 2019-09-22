//
//  UserInfo.h
//  GICDataBinding_Example
//
//  Created by gonghaiwei on 2019/9/13.
//  Copyright © 2019 gonghaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAddress.h"
#import <GICObserverProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestData : NSObject<GICObserverProtocol>
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,assign)BOOL isMale;
@property(nonatomic,strong)UserAddress *address;

@property (nonatomic,copy)NSDictionary *dict;

@property (nonatomic,strong)NSMutableDictionary *dict2;

@property (nonatomic,copy)NSArray *array;
@property (nonatomic,strong)NSMutableArray *mutArray;

@property(nonatomic,assign)NSInteger timeTick;


+(instancetype)testData;
@end

NS_ASSUME_NONNULL_END
