//
//  UIScrollView+DelegateProxy.m
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 29.06.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

#import "UIScrollView+DelegateProxy.h"

@implementation UIScrollView (SecondaryDelegate)

- (void)setSecondaryDelegate:(id<UIScrollViewDelegate>)secondaryDelegate
{
    if (!self.delegateProxy) {
        self.delegateProxy = [HMScrollViewDelegateProxy alloc];
        self.delegateProxy.primaryDelegate = self.delegate;
    }
    
    self.delegateProxy.secondaryDelegate = secondaryDelegate;
    self.delegate = self.delegateProxy;
}

- (id<UIScrollViewDelegate>)secondaryDelegate
{
    return self.delegateProxy.secondaryDelegate;
}

- (void)setDelegateProxy:(HMScrollViewDelegateProxy *)delegateProxy
{
    objc_setAssociatedObject(self, @selector(delegateProxy), delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HMScrollViewDelegateProxy *)delegateProxy
{
    return objc_getAssociatedObject(self, @selector(delegateProxy));
}

@end
