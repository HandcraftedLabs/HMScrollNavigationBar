//
//  HMScrollNavigationBar.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 15.03.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

///HMNavigationBarAnimator class which supports hiding or showing custom navigation bar while scrolling.
public protocol HMNavigationBarAnimator: NSObjectProtocol {
    
    /// UIScrollView on which animator is based
    weak var scrollView: UIScrollView? { get }
    
    /// UIView for custom navigation bar
    weak var navBar : UIView? { get }
    
    /// Animation duration of hiding/showing navBar
    var animationDuration: TimeInterval { get set }
    
    /**
        Setup method of HMNavigationBarAnimator
        
        - Parameters:
            - scrollView: Object which is subclass of the UIScrollView
            - navBar: Custom navigation bar view
     */
    func setup(scrollView: UIScrollView, navBar: UIView)
    
    /**
        Method for changing navBar and scrollView height
        
        - Parameters:
            - animationEnabled: A Boolean value indicating whether animation should be visible
            - scrollViewHeight: Value at which navBar and ScrollView should be now
            - navBarAlpha: Value for navBar alpha
     */
    func moveNavBar(animationEnabled: Bool, scrollViewHeight: CGFloat, navBarAlpha: CGFloat?)
}
