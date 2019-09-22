//
//  GICExpresionCalculator.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "GICDataBindingBase.h"
NS_ASSUME_NONNULL_BEGIN

@interface GICJSContextManager : NSObject{
    
}
@property (nonatomic,readonly)JSContext *jsContext;

@property (nonatomic,readonly)JSValue *calcuExpressionFunction;

+(instancetype)manager;


//-(id)calcuExpression:(GICDataBindingBase *)binding;
@end

NS_ASSUME_NONNULL_END
