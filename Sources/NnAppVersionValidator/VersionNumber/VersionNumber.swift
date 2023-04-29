//
//  VersionNumber.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

struct VersionNumber: Equatable {
    let majorNum: Int
    let minorNum: Int
    let patchNum: Int
    
    var fullVersionNumber: String {
        "\(majorNum).\(minorNum).\(patchNum)"
    }
}
