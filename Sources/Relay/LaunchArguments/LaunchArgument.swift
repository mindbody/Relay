//
//  LaunchArgument.swift
//  Relay
//
//  Created by John Hammerlund on 9/20/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// An executable launch argument
public protocol LaunchArgument {

    /// The launch argument flag or name
    var flag: String { get }
    /// The value provided for the flag, if one exists
    var value: String? { get }

}
