//
//  GICExpresionCalculator.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import "GICJSContextManager.h"
#import "GICObserverProtocol.h"

@implementation GICJSContextManager
+(instancetype)manager{
    static GICJSContextManager *_calculator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _calculator = [GICJSContextManager new];
    });
    return _calculator;
}

-(id)init{
    self = [super init];
    _jsContext = [JSContext new];
    NSString *path = [[[NSBundle bundleForClass:[self class]] bundlePath] stringByAppendingPathComponent:@"GICDataBinding.bundle/JSExpression.js"];
    NSString *jsString = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil];
    [_jsContext evaluateScript:jsString];
    
    self.jsContext[@"getValue"] = ^(JSValue *target,NSString *key){
        id obj = [target toObject];
        // 属性查找
        id value = [obj valueForKey:key];
        if(value == nil){
            // 查找方法
            // NOTE：这里面决定了，所有可以别访问的方法，都必须要是带一个参数的方法
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:",key]);
            if(sel && [obj respondsToSelector:sel]){
                value = [JSValue valueWithObject:^(JSValue *param){
                    [obj performSelector:sel withObject:[param toObject]];
                } inContext:[JSContext currentContext]];
            }
        }
        return value;
    };
    
    self.jsContext[@"setValue"] = ^(JSValue *target,NSString *key,JSValue *value){
        id obj = [target toObject];
        [obj setValue:[value toObject] forKey:key];
    };
    
    self.jsContext[@"canObserve"] = ^(JSValue *target){
        id obj = [target toObject];
        return [obj isProxy];
    };
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JSException: %@ \n stacktrace:\n%@",exception,exception[@"stack"]);
    };
    return self;
}

-(JSValue *)calcuExpressionFunction{
    return self.jsContext[@"calcuExpression"];
}

//-(id)calcuExpression:(GICDataBindingBase *)binding{
//   JSValue *result= [self.calcuExpressionFunction callWithArguments:@[binding.dataSource,binding.expression]];
//    return result.toObject;
//}
@end
