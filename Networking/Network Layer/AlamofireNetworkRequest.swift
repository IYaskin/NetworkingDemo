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
    
    static var onProgress: ((Double) -> ())?
    static var completed: ((String) -> ())?
    
    static func sendRequest(url: String, completionHandler: @escaping (_ courses: [Course])->()) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseJSON { (response) in
            
            switch response.result {
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
    
    static func responseData(url: String) {
        
        AF.request(url).responseData { (responseData) in
            
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func responseString(url: String) {
        
        AF.request(url).responseString { (responseString) in
            
            switch responseString.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func response(url: String) {
        
        AF.request(url).response { (response) in
            
            guard let data = response.data,
                  let string = String(data: data, encoding: .utf8)
                  else { return }
            
            print(string)
            
        }
        
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()){
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).responseData { (responseData) in
            
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(let error):
                print(error)
            }
        }
    }

    
    static func downloadImageWithProgress(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().response { (response) in
            
            guard let data = response.data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
            
        }.downloadProgress { (progress) in
            
            print("TotalUnitCount: \(progress.totalUnitCount)")
            print("ComplitedUnitCount: \(progress.completedUnitCount)")
            print("FractionCompleted:\(progress.fractionCompleted)")
            print("LocalizedDescription:\(progress.localizedDescription!)")
            print("--------------------------------------")
            print("--------------------------------------")
            
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
        }
        
    }
    
    static func postRequest(url: String, completionHandler: @escaping (_ courses: [Course])->()) {
        
        guard let  url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name": "Network Request",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": "18",
                                       "numberOfTests": "10"]
        AF.request(url, method: .post, parameters: userData).responseJSON { (responseJSON) in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode", statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                guard let json = value as? [String: Any],
                      let course = Course(json: json) else { return }
                
                var courses = [Course]()
                courses.append(course)
                
                completionHandler(courses)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func putRequest(url: String, completionHandler: @escaping (_ courses: [Course])->()) {
        
        guard let  url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name": "Network Request with Alamofire",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": 18,
                                       "numberOfTests": 10]
        AF.request(url, method: .put, parameters: userData).responseJSON { (responseJSON) in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode", statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                guard let json = value as? [String: Any],
                    let course = Course(json: json) else { return }
                
                var courses = [Course]()
                courses.append(course)
                
                completionHandler(courses)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    static func uploadImage(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        guard let image = UIImage(named: "Simpson") else { return }
        let data = image.pngData()!
        
        let httpHeaders = ["Authorization": "TOKEN 9KSa2U9sRVSUu2siOzQb"]
        
//        AF.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(data, withName: "image")
//            multipartFormData.append(Data("HZOnXOGGRkm1IiUaAeFAAookty3q045XyUH".utf8), withName: "secret_key")
//        }, to: url , headers: httpHeaders)

        let md = MultipartFormData()
        md.append(data, withName: "image")
        
        AF.upload(md, to: url, method: .post, headers: httpHeaders, interceptor: nil, fileManager: FileManager.default)
        
    }


}
