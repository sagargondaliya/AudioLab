//
//  NetworkManager.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import UIKit
import MobileCoreServices

/*
 typealias
 */
public typealias ResponseData = [String: Any]
public typealias FailureMessage = String
public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]
public typealias ResponseArray = [Any]

/**
  NetworkManager
 */
final class NetworkManager {

    // MARK : - Singleton
    static let shared = NetworkManager()
}

// MARK: - Public
extension NetworkManager {
    
    /**
     GET or POST request
     */
    public func request(_ url : String, method : HTTPMethod, parameters : Parameters?, headers: HTTPHeaders?, success:@escaping ((Any)->Void), failure:@escaping ((FailureMessage)->Void)){
        
        // check network reachability
        if !NetworkReachability.isInternetAvailable(){
            failure(Failure.noInternetConnection)
            return
        }
        
        // Showing activity loader
        ActivityLoader.showActivityView()
        
        // create request
        guard let requestURL = URL(string: url) else { return }
        
        var request: URLRequest = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        // set content type and accept headers
        request.setValue(HTTPHeaderValue.applicationJSON.rawValue, forHTTPHeaderField: HTTPHeader.accept.rawValue)
        request.setValue(HTTPHeaderValue.applicationJSON.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        
        // add headers
        if let httpHeaders = headers {
            for (key, value) in httpHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // add parameters if post request
        if let postParameters = parameters, method == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postParameters, options: .prettyPrinted)
            }catch{
                print("Error in parameters")
            }
        }
        
        // start dataTask
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Removing activity loader
            ActivityLoader.hideActivityView()
            
            // check if error
            if error != nil {
                failure(Failure.errorInRequestTryAgain)
                return
            }
            
            // get response data
            guard let responseData = data else {
                failure(Failure.noDataFound)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? ResponseData
            success(json ?? [:])
        }
        dataTask.resume()
    }
}

