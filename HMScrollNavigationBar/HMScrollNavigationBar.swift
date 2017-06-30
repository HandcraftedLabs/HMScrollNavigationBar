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
    
    public var animationDuration: TimeInterval = 0.2
    
    private var observer: Any?
    
    fileprivate var navBarFullyVisible: Bool { return self.navBar!.frame.height == self.navBarHeight }
    fileprivate var navBarHidden: Bool { return self.navBar!.frame.height <= 0 }
    
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
        print("ANIMATION \(navBarHeight) , \(scrollViewHeight) , \(navBarAlpha)")
        DispatchQueue.main.async { [weak self] in
//            UIView.animate(withDuration: self.animationDuration, animations: { [weak self] in
                self?.navBar?.frame = CGRect(x: 0, y: 0, width: (self?.view?.frame.width)!, height: navBarHeight)
                self?.navBar?.alpha = navBarAlpha != nil ? navBarAlpha! : navBarHeight / (self?.navBarHeight)!
                self?.scrollView?.frame = CGRect(x: 0, y: scrollViewHeight, width: (self?.view?.frame.width)!, height: (self?.view?.frame.height)! - scrollViewHeight)
                print("NAVBAR AFTER ANIMATION \(self?.navBar?.frame.height)")
//            })
        }

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
    
   
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(" ")
//        print("LASTSCROLL \(self.lastScrollingOffsetY)")
//        var offsetDelta = self.lastScrollingOffsetY - scrollView.contentOffset.y
//        let offsetStart = -scrollView.contentInset.top
//        let offsetEnd = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom - 0.5)
//        let isBouncingTop = scrollView.contentOffset.y < 0 && self.navBar?.frame.height != self.navBarHeight ? true : false
//        
//        print("bounceMy \(isBouncingTop) / bouncingScroll \(scrollView.bouncesZoom)")
//        
//        if self.lastScrollingOffsetY < offsetStart {
//            offsetDelta = min(0, offsetDelta - (self.lastScrollingOffsetY - offsetStart))
//        }
//        
//        if self.lastScrollingOffsetY > offsetEnd && offsetDelta < 0 {
//            offsetDelta = max(0, offsetDelta - self.lastScrollingOffsetY + offsetEnd)
//        }
//        
//        if offsetDelta == 0 && self.lastScrollingOffsetY < offsetEnd && self.navBar!.frame.height <= self.navBarHeight {
//            offsetDelta = min(0.5, -self.lastScrollingOffsetY)
//        }
//        
//        if(offsetEnd < self.navBarHeight) {
//            return
//        }
//        var scrollingHeight = (self.navBar?.frame.height)! + offsetDelta
//        
//        print("lastScrollOffY \(self.lastScrollingOffsetY) / offEnd \(offsetEnd)  / offStart \(offsetStart) / offDelt \(offsetDelta)  / navBar \(self.navBar!.frame.height) / bounce \(isBouncingTop)")
//        
//        if self.lastScrollingOffsetY <= offsetEnd && offsetDelta < 0 && self.navBar!.frame.height > 0 as CGFloat {
//            scrollingHeight = max(scrollingHeight, 0)
//            let scrollViewHeight = scrollingHeight > self.statusBarHeight ? scrollingHeight : self.statusBarHeight
//            self.animate(navBarHeight: scrollingHeight, scrollViewHeight: scrollViewHeight)
//            
//        } else if self.lastScrollingOffsetY <= offsetEnd && offsetDelta >= 0 && (self.navBar?.frame.height)! < self.navBarHeight {
//            print("Try to animate down \(self.startDraggingOffsetY) / \(scrollView.contentOffset.y)")
//            if(self.startDraggingOffsetY == 0 || scrollView.contentOffset.y < self.startDraggingOffsetY - 250 || scrollView.contentOffset.y < 0) {
//                print("ANIMATE DOWN")
//                scrollingHeight = min(scrollingHeight, self.navBarHeight)
//                let scrollViewHeight = max(scrollingHeight, self.statusBarHeight)
//                self.animate(navBarHeight: scrollingHeight, scrollViewHeight: scrollViewHeight)
//            }
//        }
////        else if isBouncingTop && self.navBar!.frame.height <= CGFloat(0.0) {
////            self.showNavBar()
////        }
//        self.lastScrollingOffsetY = scrollView.contentOffset.y
//        print("LASTSCROLL \(self.lastScrollingOffsetY) /\\ ScrollOff \(scrollView.contentOffset.y)")
//    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bouncesTop = scrollView.contentOffset.y < 0
        let contentOffsetEnd = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom - 0.5)
        let bouncesBottom = scrollView.contentOffset.y > contentOffsetEnd
        
//        if self.lastScrollingOffsetY == -20.5 && scrollView.contentOffset.y == 0.0 {
//            print("BANG")
//            scrollView.contentOffset.y = -21
//        }
        
        var offsetDelta = self.lastScrollingOffsetY - scrollView.contentOffset.y
        
        if offsetDelta == 0 && self.lastScrollingOffsetY < contentOffsetEnd && self.navBar!.frame.height <= self.navBarHeight {
            offsetDelta = min(0.5, -self.lastScrollingOffsetY)
        }
        
        print("**************************")
        print("lastScrollingOffset \(self.lastScrollingOffsetY)")
        print("scrollViewOffsetY \(scrollView.contentOffset.y) // scrollHeight \(scrollView.frame.height)")
        print("offsetDelta \(offsetDelta)")
        print("bouncesTop \(bouncesTop) /\\ bouncesBottom \(bouncesBottom)")
        print(" ")
        
        var scrollingHeight = self.navBar!.frame.height + offsetDelta
        if (!self.navBarHidden && offsetDelta < 0) {
            print("Here will be hiding")
            let scrollViewHeight = scrollingHeight > self.statusBarHeight ? scrollingHeight : self.statusBarHeight
            self.animate(navBarHeight: scrollingHeight, scrollViewHeight: scrollViewHeight)
        } else if !self.navBarFullyVisible && offsetDelta > 0 {
            print("Here will be showing /\\ navFullVisible \(self.navBarFullyVisible)")
            scrollingHeight = min(scrollingHeight, self.navBarHeight)
            let scrollViewHeight = max(scrollingHeight, self.statusBarHeight)
            self.animate(navBarHeight: scrollingHeight, scrollViewHeight: scrollViewHeight)
        }
        
        print(" ")
        
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
