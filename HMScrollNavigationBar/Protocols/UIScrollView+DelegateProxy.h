//
//  UIScrollView+DelegateProxy.h
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 29.06.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HMScrollViewDelegateProxy.h"
#import <objc/runtime.h>

@interface UIScrollView (SecondaryDelegate)

@property (nonatomic, strong) HMScrollViewDelegateProxy *delegateProxy;
@property (nonatomic, weak) id<UIScrollViewDelegate> secondaryDelegate;

@end
