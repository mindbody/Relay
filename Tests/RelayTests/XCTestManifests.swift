import XCTest

extension CommandLineExtensionTests {
    static let __allTests = [
        ("testOnlyParsesWithEligibleArgumentParsers", testOnlyParsesWithEligibleArgumentParsers),
        ("testParsesLaunchArguments", testParsesLaunchArguments),
        ("testThrowsParseErrors", testThrowsParseErrors),
    ]
}

extension DependencyContainerTests {
    static let __allTests = [
        ("testComponentContainersFallBackToGlobalScope", testComponentContainersFallBackToGlobalScope),
        ("testLazyLoadsDependencies", testLazyLoadsDependencies),
        ("testRegistersTypes", testRegistersTypes),
        ("testRegistersTypesAtComponentScope", testRegistersTypesAtComponentScope),
        ("testResolvesLazyCircularDependencies", testResolvesLazyCircularDependencies),
    ]
}

extension DependencyInjectionInstructionTests {
    static let __allTests = [
        ("testParsesCommandLineIdentifiers", testParsesCommandLineIdentifiers),
        ("testThrowsForMissingFactory", testThrowsForMissingFactory),
        ("testThrowsForMissingType", testThrowsForMissingType),
        ("testThrowsOnMalformattedParameters", testThrowsOnMalformattedParameters),
        ("testThrowsOnUnrecognizedParameters", testThrowsOnUnrecognizedParameters),
    ]
}

extension DependencyInstructionLaunchArgumentTests {
    static let __allTests = [
        ("testFormatsInjectionInstructions", testFormatsInjectionInstructions),
    ]
}

extension DynamicDependencyIndexTests {
    static let __allTests = [
        ("testIndexesFactories", testIndexesFactories),
        ("testIndexesTypes", testIndexesTypes),
        ("testThrowsOnLookupsWhenFactoryIndexDoesNotExist", testThrowsOnLookupsWhenFactoryIndexDoesNotExist),
        ("testThrowsOnLookupsWhenTypeIndexDoesNotExist", testThrowsOnLookupsWhenTypeIndexDoesNotExist),
    ]
}

extension DynamicDependencyRegistryTests {
    static let __allTests = [
        ("testRegistersDynamicDependencies", testRegistersDynamicDependencies),
        ("testThrowsForUnknownFactories", testThrowsForUnknownFactories),
        ("testThrowsForUnknownTypes", testThrowsForUnknownTypes),
    ]
}

extension InjectDependenciesArgumentParserTests {
    static let __allTests = [
        ("testBridgesDependencyInstructionsToDynamicRegistry", testBridgesDependencyInstructionsToDynamicRegistry),
        ("testCanOnlyParseDependencyFlags", testCanOnlyParseDependencyFlags),
        ("testThrowsForMissingDependencyInstructions", testThrowsForMissingDependencyInstructions),
    ]
}

extension LaunchArgumentBuilderTests {
    static let __allTests = [
        ("testBuildsCommandLineArguments", testBuildsCommandLineArguments),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CommandLineExtensionTests.__allTests),
        testCase(DependencyContainerTests.__allTests),
        testCase(DependencyInjectionInstructionTests.__allTests),
        testCase(DependencyInstructionLaunchArgumentTests.__allTests),
        testCase(DynamicDependencyIndexTests.__allTests),
        testCase(DynamicDependencyRegistryTests.__allTests),
        testCase(InjectDependenciesArgumentParserTests.__allTests),
        testCase(LaunchArgumentBuilderTests.__allTests),
    ]
}
#endif
