//
//  NavigationBarAnimator.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 03.07.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

open class NavigationBarAnimator: NSObject, HMNavigationBarAnimator {
    
    public weak var scrollView: UIScrollView?
    public weak var navBar : UIView?
    public var animationDuration: TimeInterval = 0.2
    
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
            guard let `self` = self else { return }
            self.moveNavBar(scrollViewHeight: self.statusBarHeight)
        })
        
    }
    
    open func moveNavBar(animationEnabled: Bool = false, scrollViewHeight: CGFloat, navBarAlpha: CGFloat? = nil) {
        let animationBlock = {
            self.navBar!.frame = CGRect(x: 0, y: 0, width: self.superView!.frame.width, height: scrollViewHeight)
            self.navBar!.subviews.flatMap { subViews in
                return subViews.subviews
                }.forEach {
                    $0.alpha = navBarAlpha != nil ? navBarAlpha! : scrollViewHeight / self.navBarHeight
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
        self.moveNavBar(animationEnabled: true, scrollViewHeight: self.navBarHeight, navBarAlpha: 1)
    }
    
    internal func hideNavBar() {
        self.moveNavBar(animationEnabled: true, scrollViewHeight: self.statusBarHeight, navBarAlpha: 0)
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
            if(self.startDraggingOffsetY == 0 || scrollView.contentOffset.y < self.startDraggingOffsetY - 150 || scrollView.contentOffset.y < 0) {
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
            if self.navBar!.frame.height < self.navBarHeight && self.navBar!.frame.height != self.statusBarHeight {
                self.hideNavBar()
            } else if self.navBar!.frame.height > (self.navBarHeight*0.99) {
                self.showNavBar()
            }
        }
        self.startDraggingOffsetY = 0
    }
    
}
