//
//  DynamicDependencyTestUtilities.swift
//  RelayTests
//
//  Created by John Hammerlund on 10/5/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation
@testable import Relay

protocol DynamicTypeA { }
protocol DynamicTypeB { }
protocol DynamicTypeC { }

class ImplementsDynamicTypeA: DynamicTypeA { }
class ImplementsDynamicTypeB: DynamicTypeB { }
class ImplementsDynamicTypeC: DynamicTypeC { }

class TestDynamicTypeIndex: DependencyTypeIndexable {
    let index: [DependencyTypeKey: Any.Type]

    init(index: [DependencyTypeKey: Any.Type]) {
        self.index = index
    }
}
class TestDynamicFactoryIndex: DependencyFactoryIndexable {
    let index: [DependencyFactoryKey: (DependencyContainer) -> Any]

    init(index: [DependencyFactoryKey: (DependencyContainer) -> Any]) {
        self.index = index
    }
}

extension DependencyTypeKey {

    static let dynamicTypeA = DependencyTypeKey("DynamicDependencyInjectionTests.dynamicTypeA")
    static let dynamicTypeB = DependencyTypeKey("DynamicDependencyInjectionTests.dynamicTypeB")
    static let dynamicTypeC = DependencyTypeKey("DynamicDependencyInjectionTests.dynamicTypeC")

}

extension DependencyFactoryKey {

    static let dynamicFactoryA = DependencyFactoryKey("DynamicDependencyInjectionTests.dynamicFactoryA")
    static let dynamicFactoryB = DependencyFactoryKey("DynamicDependencyInjectionTests.dynamicFactoryB")
    static let dynamicFactoryC = DependencyFactoryKey("DynamicDependencyInjectionTestss.dynamicFactoryC")

}
