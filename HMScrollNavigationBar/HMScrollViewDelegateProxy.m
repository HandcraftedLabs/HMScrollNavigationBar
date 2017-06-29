//
//  HMScrollViewDelegateProxy.m
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 29.06.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

#import "HMScrollViewDelegateProxy.h"

@implementation HMScrollViewDelegateProxy

- (id)init
{
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSObject *delegateForResonse = [self.primaryDelegate respondsToSelector:selector] ? self.primaryDelegate : self.secondaryDelegate;
    return [delegateForResonse respondsToSelector:selector] ? [delegateForResonse methodSignatureForSelector:selector] : nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [self invokeInvocation:invocation onDelegate:self.primaryDelegate];
    [self invokeInvocation:invocation onDelegate:self.secondaryDelegate];
}

- (void)invokeInvocation:(NSInvocation *)invocation onDelegate:(id<UIScrollViewDelegate>)delegate
{
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.primaryDelegate respondsToSelector:aSelector] || [self.secondaryDelegate respondsToSelector:aSelector])
    {
        return YES;
    }
    return NO;
}

@end
