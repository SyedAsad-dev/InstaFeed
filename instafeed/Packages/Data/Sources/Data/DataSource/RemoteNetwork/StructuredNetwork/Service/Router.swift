//
//  Router.swift
//  Data
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint) async throws -> (Data,URLResponse)
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    func request(_ route: EndPoint) async throws -> (Data,URLResponse) {
        let session = URLSession.shared
        do {
            let request = try await self.buildRequest(from: route, type: .baseUrlAPI)
            #if DEBUG
            NetworkLogger.log(request: request)
            #endif
            return try await session.data(for: request)
        }catch {
            throw error
        }
    }
    
    fileprivate func buildRequest(from route: EndPoint, type: AppKeys) async throws -> URLRequest {
        
        var request = URLRequest(url: await route.requestURL(url: type))
        
        if type == .baseUrlAPI {
            request.httpMethod = route.httpMethod.rawValue
        }
        
        do {
            switch await route.task {
            case let .requestParametersAndHeaders(bodyParameters, bodyEncoding, urlParameters, additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders,
                                          request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            default:break
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
