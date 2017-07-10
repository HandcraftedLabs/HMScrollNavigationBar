//
//  NavigationBarAnimatorSpec.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 07.07.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import HMScrollNavigationBar



class NavigationBarAnimatorSpec: QuickSpec {
    
    override func spec() {
        
        describe("NavigationBarAnimatorSpec") {
            let viewController: UIViewController = UIViewController()
            
            context("scrollView with custom navBar") {
                var scrollView: UIScrollView!
                var navBar: UIView!
                var offsetEnd: CGFloat!
                
                beforeEach {
                    scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 365, height: 667))
                    scrollView.contentSize = CGSize(width: 365, height: 3500)
                    navBar = UIView(frame: CGRect(x: 0, y: 0, width: 365, height: 180))
                    viewController.navigationBarAnimator.setup(scrollView: scrollView, navBar: navBar)
                    viewController.navigationBarAnimator.statusBarHeight = 20
                    
                    offsetEnd = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom - 0.5)
                }
                
                it("scrolls down and hide navBar") {
                    scrollView.contentOffset.y = 1
                    scrollView.contentOffset.y = offsetEnd.divided(by: 2)
                    
                    waitUntil(timeout: 1.0) { done in
                        expect(navBar.bounds.height).to(beLessThanOrEqualTo(viewController.navigationBarAnimator.statusBarHeight))
                        done()
                    }
                }
                
                it("scrolls up and shows navBar") {
                    scrollView.contentOffset.y = 0
                    
                    waitUntil(timeout: 1.0) { done in
                        expect(navBar.bounds.height).to(beGreaterThanOrEqualTo(180))
                        done()
                    }
                }
                
            }
            
        }
    }
}
