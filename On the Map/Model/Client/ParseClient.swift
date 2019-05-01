//
//  ParseClient.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 21/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

class ParseClient {
    
    struct Params {
        static let limit = 100
    }
    enum EndPoints {
        static let base = "https://parse.udacity.com/parse/classes"
        
        case locatoinsGet
        
        var urlString : String {
            switch self {
            case .locatoinsGet:
                return "\(EndPoints.base)/StudentLocation?limit=\(Params.limit)"
            }
        }
        
        var url : URL {
            return URL(string: urlString)!
        }
    }
    
    class func requestPostProcess(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        newRequest.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return newRequest
    }
    
    @discardableResult
    class func taskForGetRequest<ResponseType : Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void ) -> URLSessionTask {
        return WebAPIClient<ErrorResponse>.taskForGetRequest(url: url, responseType: responseType, requestPostProcess: requestPostProcess(request:),
                                                             responsePreprocess: nil, completion: completion)
    }
    
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        WebAPIClient<ErrorResponse>.taskForPostRequest(url: url, responseType: responseType, body: body, requestPostProcess: requestPostProcess(request:), responsePreprocess: nil, completion: completion)
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGetRequest(url: EndPoints.locatoinsGet.url, responseType: StudentLocationResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getMyLocation(completion: @escaping (StudentLocation, Error?) -> Void) {
        taskForGetRequest(url: EndPoints.locatoinsGet.url, responseType: StudentLocationResults.self) { response, error in
            if let response = response, !response.results.isEmpty {
                completion(response.results.first!, nil)
            } else {
                //Get first and last name from udacity
                UdacityClient.getPublicUserData() { (user, error) in
                    if let user = user {
                        let studentLoc = StudentLocation(uniqueKey: user.uniqueKey, firstName: user.firstName, lastName: user.lastName)
                        completion(studentLoc, nil)
                    } else {
                        completion(StudentLocation(uniqueKey: UdacityClient.Auth.userId, firstName: "", lastName: ""), nil)
                    }
                }
            }
        }
    }
}
