//
//  Injected.swift
//  Relay
//
//  Created by John Hammerlund on 12/17/19.
//

#if swift(>=5.1)

import Foundation

/// Auto-injects a property via IoC container. Defaults to the global container.
///
/// Example:
///
///     class MyClass {
///         // Retrieves mapped FooDependency from the global container
///         @Injected var foo: FooDependency
///         // Retrieves mapped BarDependency from the custom container
///         @Injected(scope: .custom) var bar: BarDependency
///     }
///
/// - Important: Dependency factories are invoked lazily.
@propertyWrapper
public struct Injected<Value> {

    private let scope: DependencyContainerScope
    public lazy var wrappedValue: Value = DependencyContainer.container(for: scope).resolve()

    /// Applies auto-injection using the specified `DependencyContainer`
    /// - Parameter scope: The IoC container scope used to resolve the dependency
    public init(scope: DependencyContainerScope) {
        self.scope = scope
    }

    /// Applies auto-injection using the global container
    public init() {
        self.init(scope: .global)
    }

}

#endif
