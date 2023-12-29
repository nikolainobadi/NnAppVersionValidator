//
//  VersionNumber.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

/// Represents a version number in a structured format.
///
/// This struct encapsulates the components of a semantic version number, typically used for software versioning.
/// It includes major, minor, and patch numbers, following the Semantic Versioning guidelines (major.minor.patch).
///
/// - Properties:
///   - majorNum: An integer representing the major version number.
///   - minorNum: An integer representing the minor version number.
///   - patchNum: An integer representing the patch version number.
///
public struct VersionNumber: Equatable {
    public let majorNum: Int
    public let minorNum: Int
    public let patchNum: Int
}

public extension VersionNumber {
    /// A computed property to get the full version number as a string in the format "major.minor.patch".
    ///
    /// This property concatenates the major, minor, and patch numbers into a single string, separated by periods.
    /// It is useful for displaying the version number in a human-readable format or for comparisons as a string.
    ///
    /// - Returns: A string representation of the full version number.
    var fullVersionNumber: String {
        "\(majorNum).\(minorNum).\(patchNum)"
    }
}

