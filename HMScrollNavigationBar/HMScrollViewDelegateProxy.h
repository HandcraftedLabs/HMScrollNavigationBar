//
//  HMScrollViewDelegateProxy.h
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 29.06.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMScrollViewDelegateProxy : NSProxy

@property (nonatomic, weak) id<UIScrollViewDelegate> primaryDelegate;
@property (nonatomic, weak) id<UIScrollViewDelegate> secondaryDelegate;

- (id)init;

@end
