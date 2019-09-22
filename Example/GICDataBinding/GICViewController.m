//
//  GICViewController.m
//  GICDataBinding
//
//  Created by gonghaiwei on 09/13/2019.
//  Copyright (c) 2019 gonghaiwei. All rights reserved.
//

#import "GICViewController.h"
#import "TestData.h"
#import "NSObject+GICObserver.h"
#import "GICDataBinding.h"
#import "GICJSContextManager.h"
#import "Theme.h"
#import "GICObserver_MutableArray.h"
#import "TestViewModel.h"

@interface GICViewController (){
    TestData *user;
    Theme *theme;
    
    TestViewModel *testViewModel;
}

@end

@implementation GICViewController

-(void)changedTheme{
    if(theme.backgroundColor ==[UIColor blackColor]){
        theme.backgroundColor = [UIColor whiteColor];
        theme.titleColor = [UIColor blackColor];
    }else{
        theme.backgroundColor = [UIColor blackColor];
        theme.titleColor = [UIColor whiteColor];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /**
     绑定表达式中的 $ 表示的是 数据源本身
     表达式中你可以执行任何JS执行的方法，但是仅支持单一表达式，无法支持多个表达式
     **/
    {
        // NOTE:绑定主题
        // 对Theme 执行 observe
        theme = [[Theme theme] gic_observer];
        // 绑定背景色
        [self.view gic_addBinding:createPropertyDataBindingWithBlock(theme, @"$.backgroundColor", @"backgroundColor", ^(id  _Nonnull target, id  _Nonnull newValue) {
            NSLog(@"背景色改变了");
        })];
        // 绑定标题
        [self gic_addBinding:createDataBinding(theme, @"$.title", ^(GICViewController *target, id  _Nonnull newValue) {
            target.title  = newValue;
        })];
        // 延迟1秒后更新主题
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changedTheme];
            self->theme.title = @"数据变了";
        });
    }
    
    // 绑定用户数据
    user = [[TestData testData] gic_observer];
    UIButton *btn = [self createButtonFromPreView:nil];
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn gic_addBinding:createDataBinding(user, @"'点我：'+$.age", ^(id  _Nonnull target, id  _Nonnull newValue) {
        [target setTitle:newValue forState:UIControlStateNormal];
    })];
    [self.view addSubview:btn];

    // switch 双向绑定
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame)+10, 100, 44)];
    [sw gic_towwayBinding:user propertyName:@"isMale"];
    [self.view addSubview:sw];

    // UITextField 双向绑定
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sw.frame)+10, 100, 44)];
    [text gic_addBinding:createPropertyDataBinding(theme, @"$.titleColor", @"textColor")];
    text.placeholder = @"输入名字";
    [text gic_towwayBinding:user propertyName:@"name"];
    text.layer.borderColor = [UIColor grayColor].CGColor;
    text.layer.borderWidth = 1;
    [self.view addSubview:text];

    UILabel *lblName= [self createLableFromPreView:text];
    [lblName gic_addBinding:createPropertyDataBinding(user, @"'姓名：'+$.name.split('').reverse().join('') + ',性别：'+($.isMale?'男':'女')", @"text")];
    [self.view addSubview:lblName];

    [user.dict2 setObject:user forKey:@"user"];
    UILabel *lbl= [self createLableFromPreView:lblName];
    [lbl gic_addBinding:createPropertyDataBinding(user, @"'绑定字典：'+$.dict.a+',可变字典：'+$.dict2.a ", @"text")];
    [self.view addSubview:lbl];
    
    // 计数器
    {
        lbl= [self createLableFromPreView:lbl];
        [lbl gic_addBinding:createPropertyDataBinding(user, @"'计数：'+$.timeTick", @"text")];
        [self.view addSubview:lbl];
        
        // 开始计数
        [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            user.timeTick++;
        }];
    }
    
    // 模拟被重设的属性是一个其他对象
    user.dict2 = [@{@"a":@"bb"} mutableCopy];
    // 模拟数据转换
    {
        
        lbl= [self createLableFromPreView:lbl];
        // 添加一个JS 转换器
        // NOTE：转换器是一种执行特定任务发方法，理论上你可以添加任何你自定义的方法。
        /** NOTE:注入JS方法有两种方式
         1. 直接如下面的方法，采用block方式注入
         2. 调用 [[GICExpresionCalculator calculator].jsContext evaluateScript:jsString] 注入JS脚本
        **/
        [GICJSContextManager manager].jsContext[@"customFunc"] = ^(JSValue*value){
            //这里以将Color 转换成字符串为例
            UIColor *color = [value toObject];
            CGFloat r,g,b,a;
            [color getRed:&r green:&g blue:&b alpha:&a];
            return [NSString stringWithFormat:@"r:%f,g:%f,b:%f",r,g,b];
        };
        // 数据绑定表达式直接调用js方法
        [lbl gic_addBinding:createPropertyDataBinding(theme, @"'颜色转换：'+customFunc($.titleColor)", @"text")];
        [self.view addSubview:lbl];
    }
    
    
    {
        //绑定数组
        lbl= [self createLableFromPreView:lbl];
        // 数据绑定表达式直接调用js方法
        [lbl gic_addBinding:createPropertyDataBinding(user, @"'绑定数组：'+$.array.join('&')", @"text")];
        [self.view addSubview:lbl];
        
        
        //绑定动态数组
        lbl= [self createLableFromPreView:lbl];
        // 数据绑定表达式直接调用js方法
        [lbl gic_addBinding:createPropertyDataBinding(user, @"'绑定可变数组：'+$.mutArray.join('&')", @"text")];
        [self.view addSubview:lbl];
        
        // 数组更改回调
        // NOTE:前面已经对 user 做了 gic_observer处理，这里可以直接获取被observer 的array
        GICObserver_MutableArray *arrayObserve = (GICObserver_MutableArray *)user.mutArray;
        arrayObserve.changedBlock = ^(NSMutableArray * _Nonnull mutArray, GICMutableArrayChangedType changedType, NSArray * _Nullable params) {
            switch (changedType) {
                case GICMutableArrayChangedAddObject:
                    NSLog(@"GICMutableArrayChangedAddObject:%@",params[0]);
                    break;
                case GICMutableArrayChangedRemoveObject:
                    NSLog(@"GICMutableArrayChangedRemoveObject:%@",params[0]);
                    break;
                case GICMutableArrayChangedRemoveAllObjects:
                    NSLog(@"GICMutableArrayChangedRemoveAllObjects");
                    break;
                case GICMutableArrayChangedRemoveLastObject:
                    NSLog(@"GICMutableArrayChangedRemoveLastObject:%@",params[0]);
                    break;
                case GICMutableArrayChangedSortArray:
                    NSLog(@"GICMutableArrayChangedSortArray:%@",mutArray);
                    break;
                case GICMutableArrayChangedInsertObject:
                    NSLog(@"GICMutableArrayChangedInsertObject:%@,index:%@",params[0],params[1]);
                    break;
                case GICMutableArrayChangedReplaceObject:
                    NSLog(@"GICMutableArrayChangedReplaceObject:%@,index:%@",params[0],params[1]);
                    break;
                default:
                    break;
            }
        };
    }
    
    // 事件绑定
    {
        // 扩展JSCore 方法。用来输出日志
        GICJSContextManager.manager.jsContext[@"log"] = ^(NSString *msg){
            NSLog(@"JSLog:%@",msg);
        };
        
        // 创建viewmodel
        testViewModel = [[[TestViewModel alloc] init] gic_observer];
        testViewModel.v1 = @"海伟";
        testViewModel.v2 = 30;
        
        btn = [self createButtonFromPreView:lbl];
        [btn gic_addBinding:createDataBinding(testViewModel, @"`绑定事件:v2=${$.v2}`", ^(id  _Nonnull target, id  _Nonnull newValue) {
            [btn setTitle:newValue forState:UIControlStateNormal];
        })];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        // 绑定到viewmode 中的方法
        [btn gic_addEventBinding:[GICEventBinding bindingWidthDataSource:testViewModel expression:@"$.onButtonClicked(`${$.v1}----${$.v2}`)"] forControlEvents:UIControlEventTouchUpInside];
        // 直接调用本地方法
        [btn gic_addEventWatch:^(NSArray * _Nullable params) {
            NSLog(@"点击了");
        } forControlEvents:UIControlEventTouchUpInside];
        // 绑定到JS中的方法
        [btn gic_addEventBinding:[GICEventBinding bindingWidthDataSource:testViewModel expression:@"log('TouchDown')"] forControlEvents:UIControlEventTouchDown];
        // 通过事件绑定，直接修改数据源
        [btn gic_addEventBinding:[GICEventBinding bindingWidthDataSource:testViewModel expression:@"$.v2++"] forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
    }
}

-(void)onClicked:(UIButton *)btn{
    self->user.age = 25;
    [self changedTheme];
    [user.dict2 setObject:@"AA" forKey:@"a"];
    if(user.mutArray.count>5){
        [user.mutArray removeAllObjects];
    }else{
        [user.mutArray addObject:@(user.mutArray.count)];
    }
}

-(UIButton *)createButtonFromPreView:(UIView *)preView{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, preView==nil?100:( CGRectGetMaxY(preView.frame)+10), 100, 44)];
    [btn gic_addBinding:createPropertyDataBinding(theme, @"$.titleColor", @"backgroundColor")];
    [btn gic_addBinding:createDataBinding(theme, @"$.backgroundColor", ^(UIButton *target, id  _Nonnull newValue) {
        [target setTitleColor:newValue forState:UIControlStateNormal];
    })];
    return btn;
}

-(UILabel *)createLableFromPreView:(UIView *)preView{
    UILabel *lbl= [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(preView.frame)+10, self.view.frame.size.width - 20, 40)];
    [lbl gic_addBinding:createPropertyDataBinding(theme, @"$.titleColor", @"textColor")];
    return lbl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
