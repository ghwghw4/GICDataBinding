//
//  UserAddress.h
//  GICDataBinding_Example
//
//  Created by gonghaiwei on 2019/9/13.
//  Copyright © 2019 gonghaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GICObserverProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface UserAddress : NSObject<GICObserverProtocol>
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)CGFloat lat;
@property (nonatomic,assign)CGFloat lng;

+(instancetype)adress;
@end

NS_ASSUME_NONNULL_END
