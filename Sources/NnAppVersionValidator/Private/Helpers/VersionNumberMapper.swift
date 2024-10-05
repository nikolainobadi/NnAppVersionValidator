//
//  VersionNumberMapper.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

internal enum VersionNumberMapper {
    static func map(_ versionString: String) throws -> VersionNumber {
        let noDecimals = versionString.components(separatedBy: ".")
        let array = noDecimals.compactMap { Int($0) }
        
        guard array.count == noDecimals.count else {
            throw VersionValidationError.missingNumber
        }
        
        return makeVersionNumber(from: array)
    }
}


// MARK: - Private
private extension VersionNumberMapper {
    static func makeVersionNumber(from array: [Int]) -> VersionNumber {
        return .init(majorNum: getNumber(.major, in: array), minorNum: getNumber(.minor, in: array), patchNum: getNumber(.patch, in: array))
    }
    
    static func getNumber(_ numtype: VersionNumberType, in array: [Int]) -> Int {
        let index = numtype.rawValue
        
        return array.count > index ? array[index] : 0
    }
}
