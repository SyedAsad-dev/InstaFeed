//
//  FeedsModel.swift
//  Domain
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation

// MARK: - PostModel
public struct PostModelResponse: Codable, Sendable {
    let response, success: Int?
    let message: String?
    let data: DataList?
}

// MARK: - DataClass
public struct DataList: Codable, Sendable {
    let data: [Post]?
}

// MARK: - Datum
public struct Post: Codable, Sendable {
    let id: String?
    let mediaType: MediaType?
    let mediaURL: String?
    let caption: String?
    let thumbnailURL: String?
    let permalink: String?
    let timestamp: String?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case mediaURL = "media_url"
        case caption
        case thumbnailURL = "thumbnail_url"
        case permalink, timestamp, username
    }
}

public enum MediaType: String, Codable, Sendable {
    case video = "VIDEO"
    case image = "IMAGE"
}


public struct PresentablePost: Sendable, Identifiable {
    public var id: String
    public var mediaType: MediaType
    public var mediaURL: URL?
    public var caption: String
    public var thumbnailURL: URL?
    public var permalink: String
    public var timestamp: String
    public var username: String
    
    public init(id: String, mediaType: MediaType, mediaURL: URL?, caption: String, thumbnailURL: URL?, permalink: String, timestamp: String, username: String) {
        self.id = id
        self.mediaType = mediaType
        self.mediaURL = mediaURL
        self.caption = caption
        self.thumbnailURL = thumbnailURL
        self.permalink = permalink
        self.timestamp = timestamp
        self.username = username
    }
}

public typealias PresentablePosts = [PresentablePost]
