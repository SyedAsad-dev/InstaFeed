//
//  feedsRepo.swift
//  Data
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation
import CoreLocation
import Domain


public typealias protocols = FeedsRepositoryProtocol & HTTPClient

public final class FeedsRepository: protocols {
    public init() {}
    
    public func fetchPosts(page: Int, pageSize: Int) async throws -> PostModelResponse {
        return try await ResponseHandler.handle {  [weak self] in
            guard let self else { throw NetworkError.unknown }
                let data = try await sendRequest(ApiBuilder.getPosts(page: page, pageSize: pageSize), model: PostModelResponse.self)
                return data
        }
    }
}
