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
        case userLocatoinGet(String)
        case userLocationNew
        case userLocationUpdate(String)
        
        var urlString : String {
            switch self {
            case .locatoinsGet:
                return "\(EndPoints.base)/StudentLocation?limit=\(Params.limit)"
            case .userLocatoinGet(let key):
                return "\(EndPoints.base)/StudentLocation?where=" + "{\"uniqueKey\":\"\(key)\"}".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            case .userLocationNew:
                return "\(EndPoints.base)/StudentLocation"
            case .userLocationUpdate(let userId):
                return "\(EndPoints.base)/StudentLocation/\(userId)"
                
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
    
    class func taskForPutRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        WebAPIClient<ErrorResponse>.taskForPutRequest(url: url, responseType: responseType, body: body, requestPostProcess: requestPostProcess(request:), responsePreprocess: nil, completion: completion)
    }
    
    class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGetRequest(url: EndPoints.locatoinsGet.url, responseType: StudentInformationResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getMyStudentInformation(completion: @escaping (StudentInformation, Error?) -> Void) {
        taskForGetRequest(url: EndPoints.userLocatoinGet(UdacityClient.Auth.userId).url, responseType: StudentInformationResults.self) { response, error in
            if let response = response, !response.results.isEmpty {
                completion(response.results.first!, nil)
            } else {
                //Get first and last name from udacity
                UdacityClient.getPublicUserData() { (user, error) in
                    if let user = user {
                        let studentLoc = StudentInformation(uniqueKey: user.uniqueKey, firstName: user.firstName, lastName: user.lastName)
                        completion(studentLoc, nil)
                    } else {
                        completion(StudentInformation(uniqueKey: UdacityClient.Auth.userId, firstName: "", lastName: ""), nil)
                    }
                }
            }
        }
    }
    
    class func postStudentLocation(location: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        if location.objectId.isEmpty {
            //Post new student location
            taskForPostRequest(url: EndPoints.userLocationNew.url, responseType: ParseUpdateResponse.self, body: location) { (response, error) in
                completion(error == nil, error)
                }
        } else {
            //Put student location
            taskForPutRequest(url: EndPoints.userLocationUpdate(location.objectId).url, responseType: ParseUpdateResponse.self, body: location) { (response, error) in
                completion(error == nil, error)
            }
        }
    }
}
