//
//  AppUpdateValidationService.swift
//
//
//  Created by Nikolai Nobadi on 1/9/25.
//

import Foundation

public protocol AppUpdateValidationService {
    func fetchAvailableUpdate() async throws -> AppUpdateInfo?
}
