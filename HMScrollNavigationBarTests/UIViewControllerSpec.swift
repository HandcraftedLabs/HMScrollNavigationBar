//
//  UIViewControllerSpec.swift
//  HMScrollNavigationBar
//
//  Created by Piotr Sękara on 07.07.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import HMScrollNavigationBar

class UIViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe("UIViewController with navigationBarAnimator extension") {
            let viewController = UIViewController()
            
            it("there should exist navigationBarAnimator instance") {
                expect(viewController.navigationBarAnimator).toNot(beNil())
            }
        }
    }
}
