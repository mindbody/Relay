# Relay
[![Release](https://img.shields.io/github/release/mindbody/relay.svg)](https://github.com/mindbody/Relay/releases)
[![Build Status](https://travis-ci.org/mindbody/Relay.svg?branch=master)](https://travis-ci.com/mindbody/Relay)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Relay.svg)](https://cocoapods.org/pods/Relay)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg)](http://cocoapods.org/pods/Relay)

Relay is a dynamic dependency injection framework that uses IoC (Inversion of Control) Containers and builds upon them to make integration testing dependable, focused, and efficient.

By passing a list of command line arguments, a driver program can instruct the system to inject specific dependencies (usually stubs) to keep integration predetermined and to maximize the number of valid assertions. For example, when running an iOS UI test via XCTest, we can instruct the application to inject stubbed backend services so that our UI tests only validate frontend behavior and layout.

This framework aims to champion the [Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html). For most applications, this allows the separation of [UI tests](https://martinfowler.com/articles/practical-test-pyramid.html#UiTests) from [End-to-End tests](https://martinfowler.com/articles/practical-test-pyramid.html#End-to-endTests).

- [Requirements](#requirements)
- [Installation](#installation)
  - [Carthage](#carthage)
  - [Swift Package Manager](#swift-package-manager)
- [Getting Started](#getting-started)
  - [Create a Dependency Registry](#create-a-dependency-registry)
  - [Register Dependencies](#register-dependencies)
  - [Consume Registered Dependencies](#consume-registered-dependencies)
- [Dynamic Dependencies](#dynamic-dependencies)
  - [Index Types and Factories](#index-types-and-factories)
  - [Command Line Injection](#command-line-injection)
  - [Driver Tests](#driver-tests)
- [Advanced Topics](#advanced-topics)
  - [Dependency Lifecyclex](#dependency-lifecycles)
  - [Container Scope](#container-scope)

## Requirements
- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+ / Linux
- Xcode 10+ / Swift 4.2+

## Installation

### Carthage

Add `Relay` to your `Cartfile`:
```
github 'mindbody/Relay'
```

### CocoaPods

Add `Relay` to your `Podfile`:
```
pod 'Relay'
```

### Swift Package Manager

Add `Relay` to your `Package.swift`
```swift
// swift-tools-version:4.2
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/mindbody/Relay.git", from: "0.2.1")
    ]
)
```
---

## Getting Started

While Relay provides powerful tools, it is up to developers to structure code in order to use them. See [Best Practices](./docs/best-practices.md) for ways to achieve this.

Relay uses IoC Containers at its foundation. For detailed information, see [Relay Architecture](./docs/architecture.md).

### Create a Dependency Registry

A **DependencyRegistry** is responsible for registering concrete factories to resolvable types within the application. Each registry does so by interacting with **DependencyContainers** (IoC Containers). Before a driver can inject its own dependencies, you must set up your project for dependency injection. Usually, a single registry is sufficient.

```swift
/// DefaultDependencyRegistry.swift

final class DefaultDependencyRegistry: DependencyRegistryType {

  func registerDependencies() throws {
    DependencyContainer.global.register(MyBackendServiceType.self) { _ in
      MyBackendService()
    }
    /// Recursive dependencies are lazily resolved
    DependencyContainer.global.register(MyViewControllerDataStoreType.self) { container in
        MyViewControllerDataStore(backendService: container.resolve(MyBackendServiceType.self))
    }
    /// etc.
  }

}
```

### Register Dependencies

Your default `DependencyRegistryType` should execute at the very start of the program. In an application, this typically belongs in your **AppDelegate**:

```swift
/// AppDelegate.swift

final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    registerDependencies();
    /// Configure app...
  }

  private func registerDependencies() {
    do {
      let defaultRegistry = DefaultDependencyRegistry()
      try defaultRegistry.registerDependencies()
    }
    catch {
      fatalError(error.localizedDescription)
    }
  }
}
```

### Consume Registered Dependencies

If you've followed our [Best Practices](./docs/best-practices.md), then this should be fairly simple. Where dependencies are manually resolved or injected, they should be replaced with resolutions from an IoC Container:

```swift
/// SampleViewController.swift

final class SampleViewController {

  private func showNextViewController() {
    let container = DependencyContainer.global
    let dataStore = container.resolve(MyViewControllerDataStoreType.self)
    let viewController = MyViewController(dataStore: dataStore)
    navigationController?.pushViewController(viewController, animated: true)
  }

}
```
---

## Dynamic Dependencies

Relay has its own custom type of `DependencyRegistry` for dynamic dependencies, known as **DynamicDependencyRegistry**. It does so by resolving a list of identifiable types and factories from a provided **DynamicDependencyIndex**, which defaults to `DynamicDependencyIndex.shared`. In most cases, you won't need to interact directly with `DynamicDependencyRegistry`.

### Index Types and Factories

In Relay, abstract types are uniquely identifiable by a **DependencyTypeKey**, and concrete factories are uniquely identifiable by a **DependencyFactoryKey**. In order to index types and factories for dynamic registration, you must provide the target `DynamicDependencyIndex` a list of **DependencyTypeIndexable** and **DependencyFactoryIndexable**. Similar to a `DependencyRegistryType`, these types define a list of types and factories, _except they do not register them_.

Since types are universal, you'll likely only need a single **DependencyTypeIndexable**:

```swift
/// DefaultDependencyTypeIndex.swift

final class DefaultDependencyTypeIndex: DependencyTypeIndexable {
    let index: [DependencyTypeKey: Any.Type] = [
        .myViewControllerDataStore: MyViewControllerDataStoreType.self,
        .myBackendService: MyBackendServiceType.self,
        /// etc.
    ]
}
```

Types to factories are one-to-many, so you may end up creating multiple types that implement **DependencyFactoryIndexable**. One method of organization is to separate factory indices based on the same purpose as defined in each `DependencyFactoryKey`, if following our [Best Practices](./docs/best-practices.md). This purpose may describe a unit of functionality, describe a specific behavior, or identify a specific test or test suite:

```swift
/// TestSuite12345DependencyFactoryIndex.swift

final class TestSuite12345DependencyFactoryIndex: DependencyFactoryIndexable {
  let index: [DependencyFactoryKey: (DependencyContainer) -> Any] = TestSuite12345DependencyFactoryIndex.makeIndex()

  private static func makeIndex() -> [DependencyFactoryKey: (DependencyContainer) -> Any] {
    let backendServiceFactory: (DependencyContainer) -> Any = { _ in
      let backendServiceStub = MyBackendServiceStub()
      backendServiceStub.responseUnderTest = [SampleData(), SampleData()]
      return backendServiceStub
    }

    return [
      .testCase56789BackendService: backendServiceFactory
    ]
  }
}
```

### Command Line Injection

Pulling it all together, Relay provides tools to register these dynamic dependencies via command line arguments. This means that a driver, such as a UI Test runner, has the ability to instruct the target application to inject specific dependencies.

These arguments are formatted as such:

```
[program-run] [-d, --dependency] type=<type>,factory=<factory>[,scope=<scope>][,lifecycle=<lifecyle>]
```

The value passed to `--dependency` is called a **DependencyInjectionInstruction**. The input parameters describe:
- `type`: The type identifier, which should match the target `DependencyTypeKey`
- `factory`: The factory identifier, which should match the target `DependencyFactoryKey`
- `scope`: The scope identifier, or "global" if not specified
- `lifecycle`: The dependency lifecycle type (singleton|transient), or "singleton" if not specified

These arguments are provided to an **InjectDependenciesArgumentParser**, which communicates with a `DynamicDependencyRegistry`. For Xcode projects, you'll need to update your `AppDelegate`:

```swift
/// AppDelegate.swift

final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    registerDependencies();
    /// Configure app...
  }

  private func registerDependencies() {
    do {
      let defaultRegistry = DefaultDependencyRegistry()
      try defaultRegistry.registerDependencies()

      #if DEBUG
      /// Release builds likely should avoid promoting this behavior
      DynamicDependencyIndex.shared.add(DefaultDependencyTypeIndex())
      DynamicDependencyIndex.shared.add(TestSuite12345DependencyFactoryIndex())
      DynamicDependencyIndex.shared.add(AnotherTestFactoryIndex())
      /// etc.

      try CommandLine.parse(with: [InjectDependenciesArgumentParser()])
      #endif
    }
    catch {
      fatalError(error.localizedDescription)
    }
  }
}
```

### Driver Tests

For efficiency and clean formatting, Relay provides a **LaunchArgumentBuilder**, which is useful for building a list of dependency instructions to send to the command line. `LaunchArgumentBuilder` takes in a list of types that conform to **LaunchArgument**. For most common scenarios, Relay provides **DependencyInstructionLaunchArgument**.

For example, if our Xcode-built application has a suite of UI tests that need stubbed services, we can structure it as such:

```swift
final class Suite12345Tests: XCTestCase {

  func testCase56789ShowsCorrectNumberOfCells() throws {
    let injectionInstructionArgument = DependencyInstructionLaunchArgument(type: .myBackendService, factory: .testCase56789BackendService)
    let builder = LaunchArgumentBuilder(arguments: [injectionInstructionArgument])

    let app = XCUIApplication()
    app.launchArguments = builder.build()
    app.launch()

    /// Add assertions, etc.
  }

}

```

This is just a rough example, but a starting point for converting end-to-end tests into focused UI tests.

---

## Advanced Topics

### Dependency Lifecycles

By default, Relay dependencies are lazily created using their type-mapped concrete factories. Since they are created once and only once per `DependencyContainer`, they have a `LifecycleType` of `singleton`.

While this tends to be sufficient for services, more-granular DI, especially in the weeds of your application, will prefer short-lived dependencies. These are known as `transient` dependencies, which is configurable only upon dependency registration:

```swift
final class DefaultDependencyRegistry: DependencyRegistryType {

  func registerDependencies() throws {
    /// This factory will be called every time MyViewControllerDataStoreType is resolved
    DependencyContainer.global.register(MyViewControllerDataStoreType.self, lifecycle: .transient) { _ in
      MyViewControllerDataStore()
    }
    /// etc.
  }
```

Dependency lifecycles are also configurable via command line. See [Command Line Injection](#command-line-injection) for documentation on the `lifecycle` parameter.

### Container Scope

Since Relay uses type-mapping for strongly-typed dependency resolution, your code might start to become a bit ugly once a concrete factory does not satisfy all callers. For these cases, we can instead use nested containers, keyed by a `DependencyContainerScope`.

Generally, container scope becomes more useful as dependencies become more granular. For example, we might have a view controller whose presented data can consume a number of different services. These details can be handled by injecting multiple data sources for the view controller:

```swift

/// MyDependencyScopes.swift

extension DependencyContainerScope {

  static var useCase1 = DependencyContainerScope("useCase1")
  static var useCase2 = DependencyContainerScope("useCase2")

}

/// MyScopedDependencyRegistry.swift

MyScopedDependencyRegistry: DependencyRegistryType {

  func registerDependencies() throws {
    DependencyContainer.useCase1.register(MyViewControllerDataStoreType.self, lifecycle: .transient) { _ in
      MyViewControllerFirstUseCaseDataStore()
    }
    DependencyContainer.useCase2.register(MyViewControllerDataStoreType.self, lifecycle: .transient) { _ in
      MyViewControllerSecondUseCaseDataStore()
    }
    /// etc.
  }

}
```

When a scoped container fails to resolve a type, resolution falls back to the global container. Together, scoped and global containers form a dependency graph. To enforce simple dependency graphs, and for sensibility in Relay architecture, dependency scope only extends one layer beneath the global container. For detailed information, see [Relay Architecture](./docs/architecture.md).

Dependency scope is also configurable via command line. See [Command Line Injection](#command-line-injection) for documentation on the `scope` parameter.

## Credits

[![mindbody-logo](./docs/images/MindbodyLogo.png)](https://mindbodyonline.com/careers)

Relay is owned by MINDBODY, Inc. and continuously maintained by our [contributors](https://github.com/mindbody/Relay/graphs/contributors).
