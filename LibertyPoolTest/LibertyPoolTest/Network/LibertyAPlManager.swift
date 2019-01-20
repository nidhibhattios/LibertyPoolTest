//
//  LibertyAPlManager.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation
import Alamofire

enum LibertyAPlManager: Routable {
    
    case getTransactionList(data: [String : Any])
    
    var url: URL {
        switch self {
        case .getTransactionList:
            var urlComponents = URLComponents()
            urlComponents.scheme = APIConstant.scheme
            urlComponents.host = APIConstant.host
            urlComponents.path = path
            return urlComponents.url ?? URL(string: "http://api.etherscan.io")!
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getTransactionList(let data):
            return data
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTransactionList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getTransactionList:
            return "/api"
        }
    }
    
    var header: [String: String] {
        switch self {
        case .getTransactionList:
            return [String: String]()
        }
    }
    
    var request: DataRequest {
        return SessionManager.default.request(url,
                                              method: method,
                                              parameters: parameters,
                                              encoding: URLEncoding.default,
                                              headers: header)
    }
}
