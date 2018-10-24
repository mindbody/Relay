//
//  LifecycleType.swift
//  Relay
//
//  Created by John Hammerlund on 10/19/18.
//

import Foundation

/// Determines a dependency lifetime
///
/// - transient: Dependencies are short-lived and spawn per-resolution
/// - singleton: Dependencies are created once and only once
public enum LifecycleType: CaseIterable {
    case transient
    case singleton
}
