//
//  Service.swift
//  LBTA-18-twitter
//
//  Created by Alexander Baran on 20/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct Service {
    
    let tron = TRON(baseURL: "https://api.letsbuildthatapp.com")
    
    static let sharedInstance = Service()
    
//    func fetchHomeFeed(onSuccess: @escaping (HomeDatasource) -> (), onError: @escaping () -> ()) {
//        let request: APIRequest<HomeDatasource, JSONError> = tron.request("/twitter/home")
//        request.perform(withSuccess: { (homeDatasource: HomeDatasource) in
//            print("Successfully fetched our json objects")
////            print(homeDatasource.users.count)
//            onSuccess(homeDatasource)
//        }) { (error: APIError<JSONError>) in
//            print("Failed to fetch jons...", error)
//            onError()
//        }
//    }
    
    func fetchHomeFeed(completion: @escaping (HomeDatasource?, Error?) -> ()) {
        let request: APIRequest<HomeDatasource, JSONError> = tron.request("/twitter/home")
//        let request: APIRequest<HomeDatasource, JSONError> = tron.request("/twitter/home1") // 404
//        let request: APIRequest<HomeDatasource, JSONError> = tron.request("/twitter/home_with_error") // json error.
        request.perform(withSuccess: { (homeDatasource: HomeDatasource) in
//            print("Successfully fetched our json objects")
            //            print(homeDatasource.users.count)
            completion(homeDatasource, nil)
        }) { (error: APIError<JSONError>) in
//            print("Failed to fetch jons...", error)
//            let error = error as? APIError<JSONError>
//            error?.response?.statusCode
//            print(error.response?.statusCode)
            completion(nil, error)
        }
    }
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("JSON ERROR")
        }
    }
    
}
