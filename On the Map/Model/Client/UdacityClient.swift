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
        static var userId = "897101849139"
        static var sessionId = "8271437819S0e644800f2e9a89ba2c1451343839f97"
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
    
    @discardableResult
    class func taskForGetRequest<ResponseType : Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void ) -> URLSessionTask {
        return WebAPIClient<UdacityErrorResponse>.taskForGetRequest(url: url, responseType: responseType, requestPostProcess: nil, responsePreprocess: responsePreprocess(data:), completion: completion)
    }
    
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        WebAPIClient<UdacityErrorResponse>.taskForPostRequest(url: url, responseType: responseType, body: body, requestPostProcess: nil, responsePreprocess: responsePreprocess(data:), completion: completion)
    }
    
    class func responsePreprocess(data: Data?) -> Data? {
        if let data = data {
            return data[5..<data.count]
        }
        return nil
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
            completion()
        }
        task.resume()
    }
    
    class func getPublicUserData(completion: @escaping (UdacityUser?, Error?) -> Void) {
        taskForGetRequest(
            url: EndPoints.userDataGet.url,
            responseType: UdacityUser.self) { user, error in
                if let user = user {
                    completion(user, nil)
                } else {
                    completion(nil, error)
                }
        }
    }
    
}
