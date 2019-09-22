//
//  TestViewModel.h
//  GICDataBinding_Example
//
//  Created by 龚海伟 on 2019/9/20.
//  Copyright © 2019 gonghaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GICObserverProtocol.h>
NS_ASSUME_NONNULL_BEGIN


@interface TestViewModel : NSObject<GICObserverProtocol>
@property (nonatomic,copy)NSString *v1;
@property (nonatomic,assign)NSInteger v2;
/// 所有可以被JS调用的方法，都必须带有一个参数，否则无法调用
-(void)onButtonClicked:(id)param;
@end

NS_ASSUME_NONNULL_END
