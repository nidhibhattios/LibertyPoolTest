//
//  LibertyHttpRouter.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation
import Alamofire

class LibertyHttpRouter<T: Codable> {
    
    init() { }
    
    func requestData(router: Routable, completion: @escaping (_ model: T?, _ error: Error?) -> Swift.Void) {
        
        router.request.responseData { response in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let data = response.result.value else {
                completion(nil, nil)
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(model, nil)
            } catch let error  {
                completion(nil, error)
            }
        }
    }
}

protocol Routable {
    
    var url : URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters { get }
    var header: [String: String] { get }
    var request: DataRequest { get }
}
