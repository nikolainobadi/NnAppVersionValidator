//
//  VersionNumberType.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

/// Enumerates the types of version number components for software versioning.
///
/// This enum is used to specify which part of a semantic version number (major, minor, patch) should be considered
/// when comparing version numbers, for instance, to determine if an application update is required.
///
/// - Cases:
///   - major: Represents the major version number in a versioning scheme. Major versions typically include significant changes or feature additions.
///   - minor: Represents the minor version number. Minor versions usually include smaller feature updates or substantial bug fixes.
///   - patch: Represents the patch number. Patches are generally used for small bug fixes or minor improvements.
///
public enum VersionNumberType: Int, Sendable {
    case major, minor, patch
}
