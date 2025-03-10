//
//  FeedsUseCaseProtocol.swift
//  Domain
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

public protocol FeedsUseCaseProtocol: Sendable {
    func execute(page: Int, pageSize: Int) async throws -> PresentablePosts
}
