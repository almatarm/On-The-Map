//
//  WebAPIClient.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 21/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

class WebAPIClient<ErrorResponse : Codable & LocalizedError> {
    class func taskForGetRequest<ResponseType : Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        requestPostProcess: ((URLRequest) -> URLRequest)?,
        responsePreprocess: ((Data?) -> Data?)?,
        completion: @escaping (ResponseType?, Error?) -> Void ) -> URLSessionTask {
        
        var request = URLRequest(url: url)
        request = requestPostProcess?(request) ?? request
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            data = responsePreprocess?(data) ?? data
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async { completion(responseObject, nil) }
            }  catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async { completion(nil, errorResponse) }
                } catch {
                    DispatchQueue.main.async { completion(nil, error) }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPutRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        requestPostProcess: ((URLRequest) -> URLRequest)?,
        responsePreprocess: ((Data?) -> Data?)?,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        taskForPostOrPutRequest(url: url, responseType: responseType, body: body, requestPostProcess: requestPostProcess, responsePreprocess: responsePreprocess, isPostMethod: false, completion: completion)
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        requestPostProcess: ((URLRequest) -> URLRequest)?,
        responsePreprocess: ((Data?) -> Data?)?,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        taskForPostOrPutRequest(url: url, responseType: responseType, body: body, requestPostProcess: requestPostProcess, responsePreprocess: responsePreprocess, isPostMethod: true, completion: completion)
    }
    
    class func taskForPostOrPutRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        requestPostProcess: ((URLRequest) -> URLRequest)?,
        responsePreprocess: ((Data?) -> Data?)?,
        isPostMethod: Bool,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = isPostMethod ? "POST" : "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request = requestPostProcess?(request) ?? request
       // {"code":111,"error":"schema mismatch for StudentLocation.updatedAt; expected Date but got String"}
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            data = responsePreprocess?(data) ?? data
            
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
    
}


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
    
}
