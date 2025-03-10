//
//  EndPointType.swift
//  Data
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation

public protocol EndPointType {
    func baseURL(url: AppKeys) async -> URL
    var path: ServerPaths? { get }
    var pathArgs: [String]? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask? { get async }
    var headers: HTTPHeaders? { get async}
}

extension EndPointType {
    
    func environmentBaseURL(url: AppKeys) async -> String {
        if let baseURLString: String = await AppConfigManager.shared.getCachedValue(url: url) {
            return "\(baseURLString)/"
        }
        return AppKeys.baseUrlAPI.key
    }
    
    public func baseURL(url: AppKeys) async -> URL {
        guard let url = URL(string: await environmentBaseURL(url: url)) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var pathArgs: [String]?  {
        return nil
    }
    
    public func requestURL(url: AppKeys) async -> URL {
        return await baseURL(url: url).appendingPathComponent(path?.rawValue.formatted(with: self.pathArgs) ?? "")
    }

}


extension String {
    func formatted(with args: [String]?) -> String {
        guard let args = args, args.count > 0 else {
            return self
        }
        var data = self
        for i in 0...args.count - 1 {
            data =  data.replacingOccurrences(of: "{\(i)}", with: args[i])
        }
        return data
    }
}
