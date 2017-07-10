//
//  UIScrollViewExtensionSpec.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 07.07.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import HMScrollNavigationBar

class ScrollViewDelegateMock: NSObject, UIScrollViewDelegate {
    
}

class UIScrollViewExtensionSpec: QuickSpec {
    
    override func spec() {
        
        describe("UIScrollViewExtensionSpec") {
            let scrollView: UIScrollView = UIScrollView()
            
            
            context("UIScrollView with one delegate") {
                var firstDelegate: UIScrollViewDelegate!
                
                beforeEach {
                    firstDelegate = ScrollViewDelegateMock()
                    scrollView.delegate = firstDelegate
                }
                
                it("scrollview delegate should be of firstDelegate type") {
                    expect(scrollView.delegate).to(beAKindOf(ScrollViewDelegateMock.self))
                    expect(scrollView.delegate).to(be(firstDelegate))
                }
            }
            
            context("UIScrollView with two delegates") {
                var firstDelegate: UIScrollViewDelegate!
                var secondDelegate: UIScrollViewDelegate!
                
                beforeEach {
                    firstDelegate = ScrollViewDelegateMock()
                    secondDelegate = ScrollViewDelegateMock()
                    scrollView.delegate = firstDelegate
                    scrollView.secondaryDelegate = secondDelegate
                }
                
                it("should have delegate proxy") {
                    expect(scrollView.delegate!).to(beAnInstanceOf(HMScrollViewDelegateProxy.self))
                }
            }
        }
    }
}
