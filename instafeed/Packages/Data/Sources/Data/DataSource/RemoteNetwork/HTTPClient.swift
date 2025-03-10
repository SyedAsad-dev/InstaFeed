//
//  HTTPClient.swift
//  Data
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation
import Utils

fileprivate enum Error: Swift.Error {
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
}

public enum NetworkError: APPError {
    case failed(String)
    case internetUnavailable
    case noDataAvailable
    case unknown
     
    public var message: String {
        switch self {
        case .failed(let errorDescription):
            return "\(errorDescription)"
        case .noDataAvailable:
            return "No data available for the current location"
        case .internetUnavailable:
            return "Internet Unavailable"
        case .unknown:
            return "Unknow Error"
        }
    }
}


public struct ResponseHandler {
    public static func handle<T>(_ operation: @Sendable @escaping () async throws -> T) async throws -> T {
        do {
            return try await operation()
        } catch let error as NetworkError {
            throw AnyAppError(message: error.message)
        } catch {
            throw AnyAppError(message: error.localizedDescription)
        }
    }
}

public protocol HTTPClient {
    func sendRequest<T:EndPointType, P:Codable>(_ requestBuilder: T, model: P.Type) async throws -> P
}

extension HTTPClient {
    public func sendRequest<T:EndPointType, P:Codable>(_ requestBuilder: T, model: P.Type) async throws -> P {
        let router = Router<T>()
        do {
            let(data, response) = try await router.request(requestBuilder)
            do {
                return try self.handleNetworkResponse(response, data, model: P.self)
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    
    fileprivate func handleNetworkResponse<T: Codable>(_ response: URLResponse, _ data: Data, model: T.Type) throws -> T {
        guard let response = response as? HTTPURLResponse else {throw Error.badRequest}
        let statusCode = response.statusCode
        switch statusCode {
        case 200...299:
            return try map(data, model: T.self)
        case 401...500:
            throw Error.authenticationError
        case 501...599:
            throw Error.badRequest
        case 600:
            throw Error.outdated
        default:
            throw Error.failed
        }
    }
    
    private func map<T: Codable>(_ data: Data, model: T.Type) throws -> T {
        do {
            let _ = try? JSONSerialization.jsonObject(with: data)
//            print(ppp)
            let obj:T = try JSONDecoder().decode(T.self, from: data)
            return obj
        }catch let error {
            throw error
        }
    }
}

