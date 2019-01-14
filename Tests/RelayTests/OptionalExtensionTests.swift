//
//  OptionalExtensionTests.swift
//  Relay
//
//  Created by John Hammerlund on 1/14/19.
//

import XCTest
@testable import Relay

final class OptionalExtensionTests: XCTestCase {

    func testErasedTypeIsWrappedType() {
        let optionalIntType = Int?.self
        let doubleOptionalStringType = String??.self

        XCTAssert(optionalIntType.wrapped is Int.Type)
        XCTAssert(doubleOptionalStringType.wrapped is String?.Type)
    }

    func testUnwrapsUnderlyingTypeFromNestedOptionals() {
        let optionalIntType = Int?.self
        let doubleOptionalStringType = String??.self
        let tripleOptionalDateType = Date???.self
        let quadrupleOptionalDoubleType = Double????.self

        XCTAssert(optionalIntType.underlyingType is Int.Type)
        XCTAssert(doubleOptionalStringType.underlyingType is String.Type)
        XCTAssert(tripleOptionalDateType.underlyingType is Date.Type)
        XCTAssert(quadrupleOptionalDoubleType.underlyingType is Double.Type)
    }

}
