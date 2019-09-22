//
//  Theme.h
//  GICDataBinding_Example
//
//  Created by 龚海伟 on 2019/9/19.
//  Copyright © 2019 gonghaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GICObserverProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface Theme : NSObject<GICObserverProtocol>
@property (nonatomic,strong)UIColor *backgroundColor;
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,copy)NSString *title;

+(instancetype)theme;
@end

NS_ASSUME_NONNULL_END
