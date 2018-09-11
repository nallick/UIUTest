//
//  CucumberTests.swift
//  UIUTestExampleTests
//
//  Created by Tyler Thompson on 8/26/18.
//  Copyright © 2018 Purgatory Design. All rights reserved.
//

import Foundation
import CucumberSwift

extension Cucumber: StepImplementation {
    public func setupSteps() {
        setupAuthenticationTests()
    }
}
