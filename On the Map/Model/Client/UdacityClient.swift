//
//  UdacityClient.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 18/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var userId = ""
        static var sessionId = ""
    }
    
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case sessionIdCreate
        case sessionIdDelete
        case userDataGet
        
        var urlString : String {
            switch self {
            case .sessionIdCreate, .sessionIdDelete:
                return "\(EndPoints.base)/session"
            case .userDataGet:
                return "\(EndPoints.base)/users/\(Auth.userId)"
            }
        }
        
        var url : URL {
            return URL(string: urlString)!
        }
    }
    
    class func taskForGetRequest<ResponseType : Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void ) -> URLSessionTask {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(responseType.self, from: data)
                    DispatchQueue.main.async { completion(responseObject, nil) }
                }  catch {
                    do {
                        let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data)
                        DispatchQueue.main.async { completion(nil, errorResponse) }
                    } catch {
                        DispatchQueue.main.async { completion(nil, error) }
                    }
                }
        }
        task.resume()
        return task
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            data = data[5..<data.count]
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async { completion(responseObject, nil) }
            }  catch {
                do {
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data)
                    DispatchQueue.main.async { completion(nil, errorResponse) }
                } catch {
                    DispatchQueue.main.async { completion(nil, error) }
                }
            }
        }
        task.resume()
    }
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPostRequest(
            url: EndPoints.sessionIdCreate.url,
            responseType: UdacityLoginResponse.self,
            body: LoginRequest(udacity: UsernamePasswordRequest(username: username, password: password))) { response, error in
                if let response = response {
                    Auth.sessionId = response.session.id
                    Auth.userId = response.account.key
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: EndPoints.sessionIdDelete.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            Auth.userId = ""
            Auth.sessionId = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
}
