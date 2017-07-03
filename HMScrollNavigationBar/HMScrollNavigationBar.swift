//
//  HMScrollNavigationBar.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 15.03.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocol


///HMNavigationBarAnimator class which supports hiding or showing custom navigation bar while scrolling.
public protocol HMNavigationBarAnimator: NSObjectProtocol {
    
    /// UIScrollView on which animator is based
    weak var scrollView: UIScrollView? { get }
    
    /// UIView for custom navigation bar
    weak var navBar : UIView? { get }
    
    /// Animation duration of hiding/showing navBar
    var animationDuration: TimeInterval { get set }
    
    /// A Boolean value indicating whether the navBar should become transparent while hiding
    var transparencyEnabled: Bool { get set }
    
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


//MARK: Implementation

open class NavigationBarAnimator: NSObject, HMNavigationBarAnimator {
    
    public weak var scrollView: UIScrollView?
    public weak var navBar : UIView?
    public var animationDuration: TimeInterval = 0.2
    public var transparencyEnabled: Bool = false
    
    private var application: UIApplication = UIApplication.shared
    private var observer: Any?
    
    fileprivate lazy var statusBarHeight: CGFloat = self.application.statusBarFrame.size.height
    fileprivate weak var superView: UIView?
    fileprivate var navBarFullyVisible: Bool { return self.navBar!.frame.height == self.navBarHeight }
    fileprivate var navBarHidden: Bool { return self.navBar!.frame.height <= self.statusBarHeight }
    
    fileprivate var navBarHeight: CGFloat = 0
    fileprivate var lastScrollingOffsetY: CGFloat = 0
    fileprivate var startDraggingOffsetY: CGFloat = 0
    fileprivate var lastScrollingOffsetDelta: CGFloat = 0

    
    public init(superView: UIView) {
        super.init()
        self.superView = superView
    }
    
    public func setup(scrollView: UIScrollView, navBar: UIView) {
        self.scrollView = scrollView
        self.navBar = navBar
        self.navBarHeight = self.navBar!.frame.height
        self.scrollView?.secondaryDelegate = self
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] _ in
            UIView.animate(withDuration: 0.0, animations: {
                guard let `self` = self else { return }
                self.navBar!.frame = CGRect(x: 0, y: 0, width: self.superView!.frame.width, height: self.navBar!.frame.height)
                self.navBar!.alpha = self.navBar!.frame.height / self.navBarHeight
            })
        })
    }
    
    open func moveNavBar(animationEnabled: Bool = false, scrollViewHeight: CGFloat, navBarAlpha: CGFloat? = nil) {
        
        let animationBlock = {
            self.navBar!.frame = CGRect(x: 0, y: 0, width: self.superView!.frame.width, height: scrollViewHeight)
            if self.transparencyEnabled {
                self.navBar!.alpha = navBarAlpha != nil ? navBarAlpha! : scrollViewHeight / self.navBarHeight
            }
            
            self.scrollView!.frame = CGRect(x: 0, y: scrollViewHeight, width: self.superView!.frame.width, height: self.superView!.frame.height)
            self.scrollView!.contentInset = UIEdgeInsetsMake(0, 0, scrollViewHeight, 0)
        }
        
        DispatchQueue.main.async {
            if !animationEnabled {
                animationBlock()
            } else {
                UIView.animate(withDuration: self.animationDuration, animations: {
                    animationBlock()
                })
            }

        }
    }
    
    internal func showNavBar() {
        self.moveNavBar(animationEnabled: true, scrollViewHeight: self.navBarHeight)
    }
    
    internal func hideNavBar() {
        self.moveNavBar(animationEnabled: true, scrollViewHeight: self.statusBarHeight, navBarAlpha: 1)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.observer!)
    }
}

extension NavigationBarAnimator: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bouncesTop = scrollView.contentOffset.y < 0
        let contentOffsetEnd = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom - 0.5)
        let bouncesBottom = scrollView.contentOffset.y > contentOffsetEnd
        
        var offsetDelta = self.lastScrollingOffsetY - scrollView.contentOffset.y
        
        if offsetDelta == 0 && self.lastScrollingOffsetY < contentOffsetEnd && self.navBar!.frame.height <= self.navBarHeight {
            offsetDelta = min(0.5, -self.lastScrollingOffsetY)
        }
        
        var scrollingHeight = self.navBar!.frame.height + offsetDelta
        if (!self.navBarHidden && offsetDelta < 0 && self.lastScrollingOffsetDelta < 0 && !bouncesTop) {
            let scrollViewHeight = scrollingHeight > self.statusBarHeight ? scrollingHeight : self.statusBarHeight
            self.moveNavBar(scrollViewHeight: scrollViewHeight)
        } else if (!self.navBarFullyVisible && offsetDelta > 0 && !bouncesBottom) {
            if(self.startDraggingOffsetY == 0 || scrollView.contentOffset.y < self.startDraggingOffsetY - 250 || scrollView.contentOffset.y < 0) {
                scrollingHeight = min(scrollingHeight, self.navBarHeight)
                let scrollViewHeight = max(scrollingHeight, self.statusBarHeight)
                self.moveNavBar(scrollViewHeight: scrollViewHeight)
            }
            
        }
        self.lastScrollingOffsetDelta = offsetDelta
        self.lastScrollingOffsetY = scrollView.contentOffset.y
    }
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startDraggingOffsetY = scrollView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetEnd = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom - 0.5)
        let offsetStart = -scrollView.contentInset.top
        
        if(!decelerate || scrollView.contentOffset.y > offsetEnd || scrollView.contentOffset.y < offsetStart) {
            if self.navBar!.frame.height < self.navBarHeight {
                self.hideNavBar()
            } else {
                self.showNavBar()
            }
        }
        self.startDraggingOffsetY = 0
    }

}
