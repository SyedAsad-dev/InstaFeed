//
//  FeedsRepositoryProtocol.swift
//  Domain
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation

public protocol FeedsRepositoryProtocol: Sendable {
    func fetchPosts(page: Int, pageSize: Int) async throws -> PostModelResponse
}
