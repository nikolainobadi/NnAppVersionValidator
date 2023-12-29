//
//  VersionValidationInfo.swift
//
//
//  Created by Nikolai Nobadi on 12/29/23.
//

public struct VersionValidationInfo {
    let bundleId: String?
    let infoDictionary: [String: Any]?
    let selectedVersionNumber: VersionNumberType
    
    public init(bundleId: String?, infoDictionary: [String: Any]?, selectedVersionNumber: VersionNumberType = .major) {
        self.bundleId = bundleId
        self.infoDictionary = infoDictionary
        self.selectedVersionNumber = selectedVersionNumber
    }
}
