//
//  UISwitch+GICTwoWayBinding.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import "UISwitch+GICTwoWayBinding.h"
#import "GICDataBinding_TwoWay.h"
#import "UIControl+GICEventBinding.h"

@implementation UISwitch (GICTwoWayBinding)
-(void)gic_towwayBinding:(id)dataSource propertyName:(NSString *)propertyName{
    GICDataBinding_TwoWay *binding = [createTwowayDataBinding(dataSource, propertyName) updateValueChangedBlock:^(UISwitch *target, id  _Nonnull newValue) {
                [target setOn:[newValue boolValue] animated:YES];
    }];
    [self gic_addBinding:binding];
    [self gic_addEventWatch:^(NSArray * _Nullable params) {
        [binding.dataSource setValue:@(self.isOn) forKey:binding.propertyName];
    } forControlEvents:UIControlEventValueChanged];
}
@end
