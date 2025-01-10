//
//  VersionComparisonHandler.swift
//  
//
//  Created by Nikolai Nobadi on 1/9/25.
//

import Foundation

enum VersionComparisonHandler {
    static func updateRequired(deviceVersion: VersionNumber, onlineVersion: VersionNumber, selectedVersionNumber: VersionNumberType) -> Bool {
        let majorUpdate = deviceVersion.majorNum < onlineVersion.majorNum
        let minorUpdate = deviceVersion.minorNum < onlineVersion.minorNum
        let patchUpdate = deviceVersion.patchNum < onlineVersion.patchNum
        
        switch selectedVersionNumber {
        case .major:
            return majorUpdate
        case .minor:
            return majorUpdate || minorUpdate
        case .patch:
            return majorUpdate || minorUpdate || patchUpdate
        }
    }
}
