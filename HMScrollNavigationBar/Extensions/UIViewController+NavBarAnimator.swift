//
//  UIViewController+NavBarAnimator.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 29.06.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

private var HMNavigationBarAnimatorAssociationKey: UInt8 = 0

public extension UIViewController {
    var navigationBarAnimator: HMNavigationBarAnimator! {
        get {
            var navigationBarAnimator = objc_getAssociatedObject(self, &HMNavigationBarAnimatorAssociationKey) as? HMNavigationBarAnimator
            if(navigationBarAnimator == nil) {
                navigationBarAnimator = NavigationBarAnimator(superView: self.view)
                self.navigationBarAnimator = navigationBarAnimator
            }
            return navigationBarAnimator!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &HMNavigationBarAnimatorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
