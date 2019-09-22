//
//  GICDataBindingLock.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/18.
//

#import "GICDataBindingLock.h"

@implementation GICDataBindingLock{
    dispatch_semaphore_t dispatch_semaphore;
}
-(id)init{
    self = [super init];
    dispatch_semaphore = dispatch_semaphore_create(1);
    return self;
}

-(void)lock{
     dispatch_semaphore_wait(dispatch_semaphore, -1);
}

-(void)unlock{
     dispatch_semaphore_signal(dispatch_semaphore);
}
@end
