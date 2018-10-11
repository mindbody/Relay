//
//  ArgumentParser.swift
//  Relay
//
//  Created by John Hammerlund on 9/18/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// A type that can parse and respond to command line arguments
protocol ArgumentParser {

    /// Determines if the provided arguments can be parsed by the argument parser
    ///
    /// - Parameter arguments: The command line arguments
    /// - Returns: A Bool indicating if the arguments can be processed
    func canParse(arguments: [String]) -> Bool

    /// Parses and handles a set of command line arguments
    ///
    /// - Parameter arguments: The command line arguments
    func parse(arguments: [String]) throws

}
