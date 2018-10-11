//
//  DependencyTypeIndexable.swift
//  Relay
//
//  Created by John Hammerlund on 10/2/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Provides an index of dependency types
public protocol DependencyTypeIndexable {

    var index: [DependencyTypeKey: Any.Type] { get }

}
