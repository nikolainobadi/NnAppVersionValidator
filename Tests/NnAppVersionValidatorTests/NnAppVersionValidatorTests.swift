import XCTest
@testable import NnAppVersionValidator

final class NnAppVersionValidatorTests: XCTestCase {
    func test_checkIfVersionUpateIsRequired_noUpdateRequired() async throws {
        let updateRequired = try await makeSUT().checkIfVersionUpateIsRequired()
        
        XCTAssertFalse(updateRequired)
    }
}


// MARK: - SUT
extension NnAppVersionValidatorTests {
    func makeSUT(deviceVersion: VersionNumber? = nil, onlineVersion: VersionNumber? = nil, selectedVersionNumber: VersionNumberType = .major, throwLocalError: Bool = false, throwRemoteError: Bool = false) -> VersionValidator {
        
        let localLoader = MockLoader(throwError: throwLocalError, versionNumber: deviceVersion ?? makeVersionNumber())
        let remoteLoader = MockLoader(throwError: throwRemoteError, versionNumber: onlineVersion ?? makeVersionNumber())
        
        return VersionValidator(local: localLoader, remote: remoteLoader, selectedVersionNumber: selectedVersionNumber)
    }
}


// MARK: - Helpers
extension NnAppVersionValidatorTests {
    func makeVersionNumber(_ major: Int = 1, minor: Int = 0, patch: Int = 0) -> VersionNumber {
        return VersionNumber(majorNum: major, minorNum: minor, patchNum: patch)
    }
    
    class MockLoader: VersionNumberLoader {
        let throwError: Bool
        let versionNumber: VersionNumber
        
        init(throwError: Bool, versionNumber: VersionNumber) {
            self.throwError = throwError
            self.versionNumber = versionNumber
        }
        
        func loadVersionNumber() async throws -> VersionNumber {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            return versionNumber
        }
    }
}
