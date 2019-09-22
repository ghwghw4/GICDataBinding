# GICDataBinding

[![CI Status](https://img.shields.io/travis/gonghaiwei/GICDataBinding.svg?style=flat)](https://travis-ci.org/gonghaiwei/GICDataBinding)
[![Version](https://img.shields.io/cocoapods/v/GICDataBinding.svg?style=flat)](https://cocoapods.org/pods/GICDataBinding)
[![License](https://img.shields.io/cocoapods/l/GICDataBinding.svg?style=flat)](https://cocoapods.org/pods/GICDataBinding)
[![Platform](https://img.shields.io/cocoapods/p/GICDataBinding.svg?style=flat)](https://cocoapods.org/pods/GICDataBinding)

## 简介

`GICDataBinding`是一款基于`NSProxy`开发的数据绑定库，支持`数据绑定`和`事件绑定`(**觉得好的各位，不要吝啬您的`star`**)有如下特色功能：

1. 支持`JS表达式`

   ```objective-c
   @"'姓名：'+$.name.split('').reverse().join('') + ',性别：'+($.isMale?'男':'女')"
   ```

   > 1. 表达式仅支持单一表达式，如果表达式字符串中出现多个表达式，可能会出现意外。
   >2. 你可以在单一表达式中调用任意JS中的方法，甚至调用你`预先注入`的方法。这样一来就为基于数据绑定开发的功能增加了无限可能。你可以直接将一些以前在`ViewModel`中定义的方法直接注入到JSCore中，使得可以直接在JS表达中调用这些方法
   > 3. 你可以直接在JS表达式中对数据源中的属性做计算，然后将结果返回。

   灵活基于`JSCore`开发、注入各种`方法`、`Class`将会使得开发某些功能变得异常的简单。甚至如果你的部分UI是基于`Texture`这样的支持自动布局的库开发的话，那么对于构建UI这样的任务变得异常的简单。

2. 单向绑定

3. 双向绑定

   > 双向绑定在本质上还是基于单向绑定的，但是`GICDataBinding`对某些UI组件进行了封装，使得可以直接一行代码就能完成双向绑定。类似于前端`vue`中的`model`

4. 支持对`NSMutableArray`进行观察。

   > 当数组内容变更后，你可以得到相应的回调。这样一来你可以开发出类前端`VUE`那样的自动根据数组内容变更，从而update UI的功能。

5. 支持`事件绑定`。**重点**

   > 当前对于`UIControl`已经实现了相关的事件绑定。其他的事件开发者可以自己去实现。实现的方法也是很简单的
   >
   > 这里面的**技术基础**就是，基于NSProxy实现对方法调用的拦截，从而可以实现类似方法交换的目的。也就是说这里可以不通过方法交换技术就能实现类似的功能需求。PS:有兴趣可以看下这部分源码，我相信一定会让你有所收获。

5. 当然也支持`Swift`开发。但是要求`Swift`中的数据类必须是`NSObject`子类。

## 安装

```ruby
pod 'GICDataBinding'
```



## 使用方法

### 数据模型

所有的数据绑定功能的前提是一个可以`被观察`的对象，就像`KVO`那样的。但是`GICDataBinding`不是基于`KVO`开发的，而是基于`NSProxy`开发的，因此在进行数据绑定以前，需要对你的数据源做一个转换，将数据源变成可观察对象，这一切的原理基础是基于`NSProxy`实现的。

1. 首先你要有一个数据类，比如`UserInfo`这样的数据模型

2. 数据类必须实现`GICObserverProtocol`协议，这个协议其实是一个空协议，仅仅是用来标记该类是可观察的。由于`GICDataBinding`是**支持嵌套**的，因此所有数据模型中的对象想要可以被观察，那么都需要实现`GICObserverProtocol`协议。

   ```objective-c
   @interface TestData : NSObject<GICObserverProtocol>
   @property(nonatomic,copy)NSString *name;
   @property(nonatomic,assign)NSInteger age;
   @property(nonatomic,assign)BOOL isMale;
   @property(nonatomic,strong)UserAddress *address;
   @property (nonatomic,strong)NSDictionary *dict;
   @property (nonatomic,strong)NSMutableDictionary *dict2;
   @property (nonatomic,strong)NSArray *array;
   @property (nonatomic,strong)NSMutableArray *mutArray;
   @property(nonatomic,assign)NSInteger timeTick;
   +(instancetype)testData;
   @end
   ```

3. 对数据模型调用`gic_observer`方法，你会获得一个可以被观察的数据模型。

   ```objective-c
    TestData *data = [[TestData testData] gic_observer];
   ```



### 数据绑定

> JS表达式中的`$`表示数据源本身，因此如果你想要访问数据源的某个属性或方法，那么必须使用`$`来访问

1. 普通的单向绑定。

   ```objective-c
   [btn gic_addBinding:createDataBinding(theme, @"$.backgroundColor", ^(UIButton *target, id newValue) {
      [target setTitleColor:newValue forState:UIControlStateNormal];
   })];
   ```

   这样当数据源中的`backgroundColor`属性改变的时候就会触发回调

2. 直接将表达式绑定到目标对象的属性上。

   ```objective-c
   [lbl gic_addBinding:createPropertyDataBinding(user, @"'计数：'+$.timeTick", @"text")];
   ```

   通过`createPropertyDataBinding`可以创建一个属性绑定，将表达式`'计数：'+$.timeTick`的结果自动绑定到`UILable`的 `text`属性。

   > 注意：createPropertyDataBinding 在内部实现的时候基于`setValue:forKey`来实现的，因此确保这个属性是支持KVC的。
   >
   > 如果这个属性不支持，那么使用第一种方法也能达到数据绑定目的。

3. 双向绑定。

   ```objective-c
   UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame)+10, 100, 44)];
   [sw gic_towwayBinding:user propertyName:@"isMale"];
   [self.view addSubview:sw];
   ```

   >  你可以通过`gic_towwayBinding`来创建一个双向绑定。`propertyName`表示的是数据源中的属性名称。也就说，当数据源中的`isMale`改变的时候，`UISwitch`的`isOn`也会跟着改变。而当`UISwitch`的`isOn`被改变的时候，数据源中的`isMale`属性也会跟着改变。但这里你不用担心会陷入死循环，类库已经做了比较处理，如果两次变更的value是一样的，那么不会重复触发。

4. 对`NSMutableArray`进行观察。

   第一步当然是需要将array转换成可观察对象了。通过调用`gic_observer`来实现。。

   ```objective-c
    arrayObserve.changedBlock = ^(NSMutableArray *mutArray, GICMutableArrayChangedType changedType, NSArray *params) {
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
   ```
   
   目前`GICDataBinding`支持的课观察方法的枚举都已经在上面列出。
   
5. 在表达式中调用注入的JS方法。

   ```objective-c
   [GICJSContextManager manager].jsContext[@"customFunc"] = ^(JSValue*value){
      //这里以将Color 转换成字符串为例
      UIColor *color = [value toObject];
      CGFloat r,g,b,a;
      [color getRed:&r green:&g blue:&b alpha:&a];
      return [NSString stringWithFormat:@"r:%f,g:%f,b:%f",r,g,b];
   };
   // 数据绑定表达式直接调用js方法
   [lbl gic_addBinding:createPropertyDataBinding(theme, @"'颜色转换：'+customFunc($.titleColor)", @"text")];
   ```

   >  注入JS方法有两种方式
   >
   > 1. 直接如下上面的方法，采用block方式注入
   >
   > 2. 调用 [[GICExpresionCalculator calculator].jsContext evaluateScript:jsString] 注入JS脚本

###  事件绑定

`GICDataBinding`中的事件绑定只能调用JS代码，但是得益于JSCore能够直接调用本地代码，也就意味着你也可以直接在事件绑定中调用本地代码。

在做事件绑定前，首先你要有一个`ViewModel`。同样，这个`ViewModel`需要实现`GICObserverProtocol`协议。比如下面：

```objective-c
@interface TestViewModel : NSObject<GICObserverProtocol>
@property (nonatomic,copy)NSString *v1;
@property (nonatomic,assign)NSInteger v2;
/// 所有可以被JS调用的方法，都必须带有一个参数，否则无法调用
-(void)onButtonClicked:(id)param;
@end
```

1. 初始化ViewModel

   ```objective-c
    testViewModel = [[[TestViewModel alloc] init] gic_observer];
   ```

1. 绑定按钮的点击事件。

   ```objective-c
    [btn gic_addEventBinding:[GICEventBinding bindingWidthDataSource:testViewModel expression:@"$.onButtonClicked(`${$.v1}----${$.v2}`)"] forControlEvents:UIControlEventTouchUpInside];
   ```

   > 从这里你可以看到，当按钮点击事件触发后，就会执行JS脚本

   ```javascript
   $.onButtonClicked(`${$.v1}----${$.v2}`)
   ```

   > 从这里看到，是调用的`testViewModel`中的`onButtonClicked`方法，并且传入字符串参数。

2. 绑定事件中**直接设置数据源的value**

   ```objective-c
    [btn gic_addEventBinding:[GICEventBinding bindingWidthDataSource:testViewModel expression:@"$.v2++"] forControlEvents:UIControlEventTouchDown];
   ```

   > 这里每当点击事件触发后，就会对数据源的`v2`属性`+1`。如果有其他地方绑定了`v2`属性，那么也会同时更新数据绑定

3. 事件绑定直接调用本地代码。

   ```objective-c
   [btn gic_addEventWatch:^(NSArray * _Nullable params) {
      NSLog(@"点击了");
   } forControlEvents:UIControlEventTouchUpInside];
   ```

   > 这里其实已经不算事件绑定了，可以说是事件代理。`GICDataBinding`基于`NSProxy`实现了一套可以直接`block`回调按钮事件的库。现在你无需`RAC`就能实现同样的通能。事实上，你可以对任意对象的任意方法进行`watch`,在某些情况下，你压根就无需`方法交换`就能实现类似方法交换的功能，而且这种基于`NSProxy`实现调用拦截的过程是安全、不冲突的，不会出现`方法交换`可能引起的crash问题(多次交换)。

**注意：**

> 所有可以在事件绑定中被调用的`ViewModel`中定义的方法，必须带有一个参数，哪怕这个参数你不会用到，而且目前只支持带有一个参数的方法。如果你需要传入多个参数，目前唯一的方法是以数组的方式传入



**说明**

不管是`数据绑定`还是`事件绑定`,因为都是基于JS表达式来实现的，因此想要熟练的将数据绑定应用到项目中，还需要您对`JavaScript`有一定的了解，另外`GICDataBinding`的JS引擎是基于`JavaScriptCore`来实现的，因此如果你想在项目中扩展JSCore甚至想要以前端开发一样，直接在JS中创建ViewModel，那么需要你对`JavaScriptCore`有一定的了解

### 应用

基于`GICDataBinding`数据绑定系统，你可以做一些很多以前实现起来比较复杂的功能。比如：

1. app 主题(Example 有例子)

   > 可以直接基于绑定系统，将一些主题元素绑定到提供主题数据的模型。这样当用户修改主题的时候，app可以做出实时的改变。

2. 重新思考`ViewModel`的定义。将`ViewModel` **JS化**

   > 你现在可以把部分或者整个原来已有的ViewModel移入JSCore，然后通过数据绑定系统直接调用

3. 配合`Texture`实现整个UI 基于绑定系统的可响应式设计。

4. `HotFix`

   > 由于数据绑定和事件绑定都是采用JS表达式的方式调用，因此理论是上可以直接通过下发JS脚本来动态修复、增加功能的。当然，这仅仅是理论上，真要实现起来还是有很大开发量的

5. 更多功能可自行发掘



## 作者

龚海伟, 693963124@qq.com

## License

GICDataBinding is available under the MIT license. See the LICENSE file for more info.
