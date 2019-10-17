//
//  NetworkManager.swift
//  Networking
//
//  Created by Igor Yaskin on 15/10/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func getRequest(url: String) {
        
        guard let url = URL(string: url ) else { return }
        //"https://jsonplaceholder.typicode.com/posts"
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    
    
    
    static func postRequest(url: String) {
        
        guard let url = URL(string: url ) else { return }
        //"https://jsonplaceholder.typicode.com/posts"
        let userData = ["Course": "Networking", "Lesson": "GET and POST"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            } .resume()
    }
    
    static func downloadImage(url: String, completionHandler: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            }
        } .resume()

    }
    
    static func fetchData(url: String, completionHandler: @escaping (_ courses: [Course])->()) {
        
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                completionHandler(courses)
            } catch let error {
                print("Error serialization json", error)
            }
            
            }.resume()

    }
    
    static func uploadImage(url: String) {
        let image = UIImage(named: "Saturn")!
        //let image2 = UIImage(named: "Simpson")!
        guard let url = URL(string: url) else { return }
        
        let httpHeaders = ["Authorization": "TOKEN 9KSa2U9sRVSUu2siOzQb"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        
        let boundary = UUID().uuidString
        let fieldSecretKey = "secret_key"
        let secretKey = "HZOnXOGGRkm1IiUaAeFAAookty3q045XyUH"
        let fieldName = "name"
        let imageName = "Saturn.png"
        let fieldImage = "image"
        let imageData = (image.jpegData(compressionQuality: 1)?.base64EncodedData())!
        //let fieldURL = "url"
        //let imageURL = "https://dutchwannabe.com/wp-content/uploads/2019/04/double-tree-sunset-amsterdam.jpg"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Convert secretKey value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldSecretKey)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(secretKey)".data(using: .utf8)!)
        
        // Add the userName value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(imageName)".data(using: .utf8)!)
        
        // Add the imageURL to the raw http request data
        //data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        //data.append("Content-Disposition: form-data; name=\"\(fieldName3)\"\r\n\r\n".data(using: .utf8)!)
        //data.append("\(fieldValue3)".data(using: .utf8)!)

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldImage)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        
        URLSession.shared.uploadTask(with: request, from: data) { (data, responce, error) in
            if let responce = responce {
                print(responce)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
        
        
    }
    
}
