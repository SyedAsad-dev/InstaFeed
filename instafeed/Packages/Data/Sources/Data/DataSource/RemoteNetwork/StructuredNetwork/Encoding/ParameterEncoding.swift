//
//  ParameterEncoding.swift
//  Data
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    public func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?, urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest,
                                                 with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest,
                                                  with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters, let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest,
                                                 with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest,
                                                  with: bodyParameters)
            }
        }catch {
            throw error
        }
    }
}



