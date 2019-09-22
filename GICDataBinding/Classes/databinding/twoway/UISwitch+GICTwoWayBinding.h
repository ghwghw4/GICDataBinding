//
//  UISwitch+GICTwoWayBinding.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISwitch (GICTwoWayBinding)
-(void)gic_towwayBinding:(id)dataSource propertyName:(NSString *)propertyName;
@end

NS_ASSUME_NONNULL_END
