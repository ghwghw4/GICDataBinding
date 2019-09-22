//
//  UITextField+GICTwoWayBinding.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import "UITextField+GICTwoWayBinding.h"
#import "GICDataBinding_TwoWay.h"
#import "UIControl+GICEventBinding.h"

@implementation UITextField (GICTwoWayBinding)
-(void)gic_towwayBinding:(id)dataSource propertyName:(NSString *)propertyName{
    GICDataBinding_TwoWay *binding = [createTwowayDataBinding(dataSource, propertyName) updateValueChangedBlock:^(UITextField *target, id  _Nonnull newValue) {
        target.text = newValue;
    }];
    [self gic_addBinding:binding];
    [self gic_addEventWatch:^(NSArray * _Nullable params) {
        [binding.dataSource setValue:self.text forKey:binding.propertyName];
    } forControlEvents:UIControlEventEditingChanged];
}
@end
