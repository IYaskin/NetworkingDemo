//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Igor Yaskin on 17/10/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String, completionHandler: @escaping (_ courses: [Course])->()) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseJSON { (responce) in
            
            switch responce.result {
            case .success(let value):
                if let courses = Course.getArray(from: value){
                completionHandler(courses)
                } else {
                    return
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
