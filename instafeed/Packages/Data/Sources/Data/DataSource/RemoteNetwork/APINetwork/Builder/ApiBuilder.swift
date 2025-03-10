//
//  ApiBuilder.swift
//  Data
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation
import Utils
import Domain

public enum ApiBuilder {
    case getPosts(page: Int, pageSize: Int)
}


extension ApiBuilder: EndPointType {
    
    var parameters: Parameters? {
        switch self {
        case .getPosts:
            return nil
        }
    }
    
    public var headers: HTTPHeaders? {
        get async {
            switch self {
            default:
                nil
            }
        }
    }
    
    public var task: HTTPTask? {
        get async {
            switch self {
            default: return await .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters, additionHeaders: headers)
            }
        }
        
    }
    
    public var path: ServerPaths? {
        switch self {
        case .getPosts:
            return .instaPosts
        }
    }
    
    public var pathArgs: [String]? {
        switch self {
        default: return nil
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        default: return .get
        }
    }
}
