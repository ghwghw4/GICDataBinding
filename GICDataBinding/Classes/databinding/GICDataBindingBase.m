//
//  GICDataBindinng.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import "GICDataBindingBase.h"
#import "NSObject+GICObserver.h"
#import "GICJSContextManager.h"
#import <GICDataBinding/GICDataBinding.h>
#import "GICDataBindingBase+Private.h"
#import "GICDataBindingLock.h"
#import "GICObserver+Private.h"

@interface GICDataBindingBase (){
    NSMutableArray<GICObserverWatch *> *watchs;
    __weak id _target;
}
@end


@implementation GICDataBindingBase{
    BOOL installed;//是否已经安装
}
// NOTE:这里使用信号量来处理加锁操作
static GICDataBindingLock *lock;
+(void)initialize{
    lock = [GICDataBindingLock new];
}

-(instancetype)initWidthDataSource:(id)dataSource expression:(NSString *)exp{
    self =[super initWidthDataSource:dataSource expression:exp];
    _isMainThread = YES;
    watchs = [NSMutableArray array];
    return self;
}

-(instancetype)updateValueChangedBlock:(GICDataBindinngValueChangedBlock)block{
    _valueChangedBlock = [block copy];
    return self;
}

-(void)install:(id)target{
    if(_target) return;
    _target = target;
    [self updateBinding];
    installed = YES;
}

-(id)getTarget{
    return _target;
}

-(void)uninstall{
    _target = nil;
    [watchs enumerateObjectsUsingBlock:^(GICObserverWatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj endwatch];
    }];
    [watchs removeAllObjects];
}

-(void)onGetPropertCall:(GICObserver*)observer propertyName:(NSString *)propertyName{
    if(self->installed && ([GICObserver currentSetValueObserver] && ![[GICObserver currentSetValueObserver] isEqual:observer])){
        return;
    }
    
    //  NOTE:剔除重复的情况，比如表达式：$.name + $.name,对同一个数据源多次访问同一个属性，那么会出现重复创建watch的情况。
    __block BOOL isFind = NO;
    [self->watchs enumerateObjectsUsingBlock:^(GICObserverWatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.observer == observer && [obj.propertyName isEqualToString:propertyName]){
            isFind = YES;
            *stop = YES;
        }
    }];
    if(isFind){
        return;
    }
    __weak GICDataBindingBase *wself = self;
    GICObserverWatch *watch = [GICObserverWatch watchForPropertName:propertyName valueChanged:^(id  _Nullable newValue, id  _Nullable oldValue) {
        [wself updateBinding];
    }];
    [watch beginWatch:observer];
    [self->watchs addObject:watch];
}

-(void)updateBinding{
    [lock lock];
    _currentCalcuBinding = self;
    // 计算表达式的时候，会访问数据源中的属性。当Observer属性被访问的时候会判断当前访问该属性的DataBinding，这样就可以建立一个watch用来监听该属性的改变，下次属性改变的后就立即立即调用watch中的回调
    JSValue *result= [[GICJSContextManager manager].calcuExpressionFunction callWithArguments:@[self.dataSource,self.expression]];
    id value =  result.toObject;
    
    _currentCalcuBinding = nil;
    [lock unlock];
    [self updateValue:value];
}

-(void)updateValue:(id)value{
    if(self.isMainThread){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.valueChangedBlock(self->_target, value);
        });
    }else{
        self.valueChangedBlock(_target, value);
    }
}

-(void)dealloc{
    [self uninstall];
}

static GICDataBindingBase *_currentCalcuBinding;
+(instancetype)currentCalcuBinding{
    return _currentCalcuBinding;
}
@end




GICDataBindingBase* createDataBinding(id dataSource,NSString *expression,GICDataBindinngValueChangedBlock block){
    GICDataBindingBase *b = [[GICDataBindingBase alloc] initWidthDataSource:dataSource expression:expression];
    [b updateValueChangedBlock:block];
    return b;
}
