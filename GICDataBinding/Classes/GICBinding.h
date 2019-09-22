//
//  GICBinding.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GICBinding : NSObject
/**
 绑定数据源
 */
@property (nonatomic,weak,readonly)id dataSource;

/**
 绑定表达式
 */
@property (nonatomic,readonly)NSString *expression;

-(void)install:(id)target;
-(void)uninstall;

-(instancetype)initWidthDataSource:(id)dataSource expression:(NSString *)exp;
+(instancetype)bindingWidthDataSource:(id)dataSource expression:(NSString *)exp;
@end

@interface NSObject (GICBinding)
@property (nonatomic,readonly)NSMutableArray<GICBinding *> *gicDataBindings;
-(void)gic_addBinding:(GICBinding *)binding;
-(void)gic_removeBinding:(GICBinding *)binding;
@end

NS_ASSUME_NONNULL_END
