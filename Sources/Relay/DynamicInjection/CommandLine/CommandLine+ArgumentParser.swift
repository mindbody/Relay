//
//  CommandLine+ArgumentParser.swift
//  Relay
//
//  Created by John Hammerlund on 10/3/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

extension CommandLine {

    static func parse(with argumentParsers: [ArgumentParser]) throws {
        for argumentParser in argumentParsers {
            if argumentParser.canParse(arguments: arguments) {
                try argumentParser.parse(arguments: arguments)
            }
        }
    }

}
