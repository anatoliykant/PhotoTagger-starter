//
//  ImaggaRouter.swift
//  PhotoTagger
//
//  Created by anatoliy.kant on 08.03.16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire

public enum ImaggaRouter: URLRequestConvertible {
  static let baseURLPath = "http://api.imagga.com/v1"
  static let authenticationToken = "Basic YWNjXzgxMjI0ZmVlYjgwODNmYzo3ZWYzZWQ3OGU3NWIwMTkwMmIzM2M5NjZjZTVlYmM2NA=="
  
  case Content
  case Tags(String, String)
  case Colors(String)
  //case Language(String)
  
  public var URLRequest: NSMutableURLRequest {
    let result: (path: String, method: Alamofire.Method, parameters: [String: AnyObject]) = {
      switch self {
      case .Content:
        return ("/content", .POST, [String: AnyObject]())
      
      case .Tags(let contentID, let language):
        let params = [ "content" : contentID, "language" : language ]
        return ("/tagging", .GET, params)
      
//      case .Tags(let contentID):
//        let params = [ "content" : contentID ]
//        return ("/tagging", .GET, params)
      case .Colors(let contentID):
        let params = [ "content" : contentID, "extract_object_colors" : NSNumber(int: 0) ]
        return ("/colors", .GET, params)
//      case .Language("ru"):
//        return ("/language", .GET)
      }
    }()
    
    let URL = NSURL(string: ImaggaRouter.baseURLPath)!
    let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
    URLRequest.HTTPMethod = result.method.rawValue
    URLRequest.setValue(ImaggaRouter.authenticationToken, forHTTPHeaderField: "Authorization")
    URLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
    
    let encoding = Alamofire.ParameterEncoding.URL
    
    return encoding.encode(URLRequest, parameters: result.parameters).0
  }
}