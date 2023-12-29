//
//  VersionNumber.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

public struct VersionNumber: Equatable {
    public let majorNum: Int
    public let minorNum: Int
    public let patchNum: Int
}

public extension VersionNumber {
    var fullVersionNumber: String {
        "\(majorNum).\(minorNum).\(patchNum)"
    }
}
