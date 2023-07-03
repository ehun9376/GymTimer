//
//  APIService.swift
//  ChatGPT
//
//  Created by 陳逸煌 on 2023/2/8.
//

import Foundation

typealias HTTPHeaderField = [String: String]

typealias parameter = [String: Any]

typealias CompleteAction<T: JsonModel> = ((_ jsonModel: T?,_ error: Error?)->())

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum HeaderField {
    
    case json
    
    var field: HTTPHeaderField {
        switch self {
        case .json:
            return [
                "Content-Type" : "application/json"
            ]
        }
    }
}


class APIService: NSObject {
    
    static let shared = APIService()
    
    private let apiQueue = DispatchQueue(label: "api_queue", qos: .utility)

    enum URLText: String {
        case TinaDJTypeURL = "http://www.yihuang.online/yihuang.online/ehun9376/GymTimer.json"
    }
        
    func requestWithParam<T: JsonModel>(httpMethod: HttpMethod = .post, headerField: HTTPHeaderField? = [:] , urlText: URLText, param: parameter, modelType: T.Type ,  completeAction: @escaping CompleteAction<T>) {
        
        if let url = URL(string: urlText.rawValue) {
            var request = URLRequest(url: url)
            
            for header in headerField ?? [:] {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions())
            } catch {
                completeAction(nil, error)
            }
            
            request.httpMethod = httpMethod.rawValue

            
            self.apiQueue.async {
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in

                    if let error = error {
                        completeAction(nil, error)
                    } else if let data = data {
                        do {
                            let json = try JBJson(data: data)
                            print(json)
                            completeAction(modelType.init(json: json), error)
                        } catch {
                            completeAction(nil, error)
                        }
                    }
                }

                task.resume()
            }
        }
    }
    
}


