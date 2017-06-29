//
//  HMScrollNavigationBar.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 15.03.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocols

public protocol HMNavigationBarAnimator: NSObjectProtocol {
    var view: UIView? { get set }
    var animationDuration: TimeInterval { get set }
    
    func setup(scrollView: UIScrollView, navBar: UIView)
    func animate(navBarHeight: CGFloat, scrollViewHeight: CGFloat, navBarAlpha: CGFloat?)
}


//MARK: Implementation

open class NavigationBarAnimator: NSObject, HMNavigationBarAnimator {
    
    var application: UIApplication = UIApplication.shared
    lazy private(set) var statusBarHeight: CGFloat = self.application.statusBarFrame.size.height
    
    var navBarHeight: CGFloat = 0
    var lastScrollingOffsetY: CGFloat = 0
    var startDraggingOffsetY: CGFloat = 0
    
    weak var scrollView: UIScrollView?
    weak var navBar : UIView?
    public weak var view: UIView?
    
    public var animationDuration: TimeInterval = 0.1
    
    private var observer: Any?
    
    public func setup(scrollView: UIScrollView, navBar: UIView) {
        self.scrollView = scrollView
        self.navBar = navBar
        self.navBarHeight = (self.navBar?.frame.height)!
        self.scrollView?.secondaryDelegate = self
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] _ in
            UIView.animate(withDuration: 0.0, animations: {
                self?.navBar?.frame = CGRect(x: 0, y: 0, width: (self?.view?.frame.width)!, height: (self?.navBar?.frame.height)!)
                self?.navBar?.alpha = (self?.navBar?.frame.height)! / (self?.navBarHeight)!
            })
        })
    }
    
    open func animate(navBarHeight: CGFloat, scrollViewHeight: CGFloat, navBarAlpha: CGFloat? = nil) {
        UIView.animate(withDuration: self.animationDuration, animations: { [weak self] in
            self?.navBar?.frame = CGRect(x: 0, y: 0, width: (self?.view?.frame.width)!, height: navBarHeight)
            self?.navBar?.alpha = navBarAlpha != nil ? navBarAlpha! : navBarHeight / (self?.navBarHeight)!
            self?.scrollView?.frame = CGRect(x: 0, y: scrollViewHeight, width: (self?.view?.frame.width)!, height: (self?.view?.frame.height)! - scrollViewHeight)
        })
    }
    
    internal func showNavBar() {
        self.animate(navBarHeight: self.navBarHeight, scrollViewHeight: self.navBarHeight)
    }
    
    internal func hideNavBar() {
        self.animate(navBarHeight: 0, scrollViewHeight: self.statusBarHeight, navBarAlpha: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.observer!)
    }
}

extension NavigationBarAnimator: UIScrollViewDelegate {
    
   
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetDelta = self.lastScrollingOffsetY - scrollView.contentOffset.y
        let offsetStart = -scrollView.contentInset.top
        let offsetEnd = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom - 0.5)
        let isBouncingTop = scrollView.contentOffset.y < 0 && self.navBar?.frame.height != self.navBarHeight ? true : false
        
        if self.lastScrollingOffsetY < offsetStart {
            offsetDelta = min(0, offsetDelta - (self.lastScrollingOffsetY - offsetStart))
        }
        
        if self.lastScrollingOffsetY > offsetEnd && offsetDelta < 0 {
            offsetDelta = max(0, offsetDelta - self.lastScrollingOffsetY + offsetEnd)
        }
        
        if(offsetEnd < self.navBarHeight) {
            return
        }
        var scrollingHeight = (self.navBar?.frame.height)! + offsetDelta
        
        if self.lastScrollingOffsetY <= offsetEnd && offsetDelta < 0 && (self.navBar?.frame.height)! > 0 as CGFloat {
            scrollingHeight = max(scrollingHeight, 0)
            let scrollViewHeight = scrollingHeight > self.statusBarHeight ? scrollingHeight : self.statusBarHeight
            self.animate(navBarHeight: scrollingHeight, scrollViewHeight: scrollViewHeight)
            
        } else if !isBouncingTop && self.lastScrollingOffsetY  >= offsetStart && self.lastScrollingOffsetY <= offsetEnd && offsetDelta > 0 && (self.navBar?.frame.height)! < self.navBarHeight {
            if(self.startDraggingOffsetY == 0 || scrollView.contentOffset.y < self.startDraggingOffsetY - 250) {
                scrollingHeight = min(scrollingHeight, self.navBarHeight)
                let scrollViewHeight = max(scrollingHeight, self.statusBarHeight)
                self.animate(navBarHeight: scrollingHeight, scrollViewHeight: scrollViewHeight)
            }
        } else if isBouncingTop && self.navBar?.frame.height != self.navBarHeight {
            self.showNavBar()
        }
        self.lastScrollingOffsetY = scrollView.contentOffset.y
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startDraggingOffsetY = scrollView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetEnd = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom - 0.5)
        
        if(!decelerate || scrollView.contentOffset.y > offsetEnd) {
            let heightPercentage = (self.navBar?.frame.height)! / self.navBarHeight
            if heightPercentage > 0.6 {
                self.showNavBar()
            } else {
                self.hideNavBar()
            }
        }
        self.startDraggingOffsetY = 0
    }

}
