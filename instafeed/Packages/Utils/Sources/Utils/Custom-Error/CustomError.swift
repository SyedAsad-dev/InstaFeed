//
//  CustomError.swift
//  Utils
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation

public protocol APPError: LocalizedError {
    var message: String { get }
}

extension APPError {
    public var errorDescription: String { message }
}

public struct AnyAppError: APPError, Hashable {
    public var message: String
    
    public init(message: String) {
        self.message = message
    }
}
