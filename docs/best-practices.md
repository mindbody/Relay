# Best Practices

This document outlines a list of suggestions to make your code more testable and to make Relay more powerful.

---

## Architecture

The first step to writing testable code is following Object-Oriented design principles. Specifically, we aim to adhere to [SOLID principles](https://en.wikipedia.org/wiki/SOLID). At minimum, you'll need to familiarize yourself with the **D** in **SOLID**, which stands for the **Dependency Inversion Principle**. Similarly, but not a SOLID principle, you'll need to understand **Inversion of Control**, which is the foundation of Relay.

### Dependency Inversion Principle
> 1. High-level modules should not depend on low-level modules. Both should depend on abstractions.
> 2. Abstractions should not depend on details. Details should depend on abstractions.

#### Breakdown

Try to structure your code by interface. When importing a module, or even referencing another class or struct, what is it that the referencing class truly needs from the imported type, and can it be defined in an abstract interface?

#### Example

```swift
/// Bad ❌
final class MyViewController {
  private let dataStore = MyViewControllerDataStore()
}

final class MyViewControllerDataStore {
  private let backendService = MyBackendService()
}
```

```swift
/// Good ✅
protocol MyViewControllerDataStoreType {
  func fetchBackingData(completion: @escaping ([MyViewModel]) -> Void)
}

protocol MyBackendServiceType {
  func fetchServiceData(completion: @escaping ([DomainModel]) -> Void)
}

final class MyViewController {

  private let dataStore: MyViewControllerDataStoreType
  ...

}

final class MyViewControllerDataStore: MyViewControllerDataStoreType {

  private let backendService: MyBackendServiceType
  ...

}
```

#### Takeaways
- Depend on abstract interfaces (protocols) so that implementation is interchangeable
- Abstractions should be independent (also see: [Interface Segregation Principle](https://en.wikipedia.org/wiki/Interface_segregation_principle))

### Inversion of Control Principle
> Inversion of Control (IoC) is a design principle in which custom-written portions of a computer program receive the flow of control from a generic framework.

#### Breakdown

By following this principle, you put the main control of your program into the hands of an external, generic framework; sometimes, even outside of the program itself. This principle is _similar_ to Dependency Inversion in that common design approaches achieve the same goals.

To adhere to these principles, Relay utilizes IoC Containers and Dependency Injection. For detailed information, see [Relay Architecture](./architecture.md).

#### Example

```swift
/// Without Dependency Injection ❌
final class MyViewController {
  private let dataStore: MyViewControllerDataStoreType = MyViewControllerDataStore()
}

final class MyViewControllerDataStore {
  private let backendService: MyBackendServiceType = MyBackendService()
}
```

```swift
/// With Dependency Injection ✅
final class MyViewController {

  private let dataStore: MyViewControllerDataStoreType

  init(dataStore: MyViewControllerDataStoreType) {
    self.dataStore = dataStore
  }

}

final class MyViewControllerDataStore: MyViewControllerDataStoreType {

  private let backendService: MyBackendServiceType

  init(backendService: MyBackendServiceType) {
    self.backendService = backendService
  }

}
```

---

## Relay Usage

Relay is a very hands-on framework. Follow these general patterns to get the most value out of Relay while maintaining clean, readable code.

### Project Setup

Relay is a dynamic dependency injection framework. From a testing scenario, this means that it is necessary only for the system under test (your application or program) and the driver (ex. a UI Test target).

For Xcode projects, Relay must be linked to the main **application target** and any **UI Test targets** that need to inject dependencies. For SwiftPM projects, Relay must be a dependency for the target executable and any integration test targets that need to inject dependencies.

### Dependency Keys

Type and Factory keys should be visible to both the application target and driver targets. The actual types and factories, however, should only be visible to your application target. To enforce this separation, you can define keys in standalone extensions:

```swift
/// DependencyKeyExtensions.swift

import Relay

extension DependencyTypeKey {
  static let myViewControllerDataStore = DependencyTypeKey("MyApp.MyViewControllerDataStoreType")
  static let myBackendService = DependencyTypeKey("MyApp.MyBackendServiceType")
  /// etc.
}

extension DependencyFactoryKey {
  static let myViewControllerDataStore = DependencyFactoryKey("MyApp.MyViewControllerDataStore")
  static let myViewControllerDataStoreStub = DependencyFactoryKey("MyApp.MyViewControllerDataStore.Stub")
  static let myBackendService = DependencyFactoryKey("MyApp.MyBackendService")
  static let myBackendServiceStub = DependencyFactoryKey("MyApp.MyBackendService.Stub")
  /// etc.
}
```

#### Naming

Type keys should be named using the fully-qualified name of the type. Remember that types and factories __must not__ be linked to your driver target, so these strings must be manually defined:

```swift
extension DependencyTypeKey {
  static let format = DependencyTypeKey("[BundleName].[TypeName]")
  static let example = DependencyTypeKey("MyApp.SampleType")
}
```

Similarly, factory keys should be named using the fully-qualified name of the concrete type, optionally appended by the purpose of the factory. A single type may have many potential resolvable factories.

```swift
extension DependencyFactoryKey {
  static let format = DependencyTypeKey("[BundleName].[TypeName].[Purpose]")
  static let example1 = DependencyTypeKey("MyApp.Sample")
  static let example2 = DependencyTypeKey("MyApp.Sample.MyAppUITests.MyViewControllerTests.testBehavesWithStubbedData")
}
```
