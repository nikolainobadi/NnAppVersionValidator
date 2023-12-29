//
//  NnVersionValidator.swift
//  
//
//  Created by Nikolai Nobadi on 12/29/23.
//

/// Method will return bool based on whether App Version on Device is lower than App Version on AppStore
/// getAppVersionNumbers included to allow manual comparison between version numbers
public protocol NnVersionValidator {
    typealias AppVersionNumberComparison = (deviceVersion: VersionNumber, appStoreVersion: VersionNumber)
    
    func checkIfVersionUpateIsRequired() async throws -> Bool
    func getAppVersionNumbers() async throws -> AppVersionNumberComparison
}
