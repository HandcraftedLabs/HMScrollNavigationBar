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
        
        describe("UIScrollView with delegate proxy extension") {
            
            let scrollView = UIScrollView()
            let firstDelegate = ScrollViewDelegateMock()
            let secondDelegate = ScrollViewDelegateMock()
            
            scrollView.delegate = firstDelegate
            
            it("scrollview delegate should be of firstDelegate type") {
                expect(scrollView.delegate).to(beAKindOf(ScrollViewDelegateMock.self))
                expect(scrollView.delegate).to(be(firstDelegate))
            }
            
            scrollView.secondaryDelegate = secondDelegate
            
            it("scrollView delegate should be now proxy") {
                expect(scrollView.delegate!).to(beAKindOf(HMScrollViewDelegateProxy.self))
                
                let delegateProxy = scrollView.delegate! as! HMScrollViewDelegateProxy
                
                expect(delegateProxy).toNot(beNil())
                expect(delegateProxy.primaryDelegate).to(be(firstDelegate))
                expect(delegateProxy.secondaryDelegate).to(be(secondDelegate))
            }
        }
    }
}
