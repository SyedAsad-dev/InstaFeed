//
//  AppConfigManager.swift
//  Data
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation


import Foundation

public enum AppKeys : String, Codable, Sendable {
    case baseUrlAPI
    
    public var key: String {
        switch self {
        case .baseUrlAPI:
            return "https://f1rstmotors.com"
        }
    }
}

public actor AppConfigManager: @unchecked Sendable {
    public static let shared = AppConfigManager()
    
    // Cache to store base URLs
    private var cachedBaseURL: [AppKeys: Codable & Sendable] = [.baseUrlAPI: AppKeys.baseUrlAPI.key] // Default value
    
    // MARK: - Get Cached Value
    
    /// Get a cached value for the given key.
    public func getCachedValue<T>(url: AppKeys) -> T? where T: Codable & Sendable {
        return cachedBaseURL[url] as? T
    }
}
