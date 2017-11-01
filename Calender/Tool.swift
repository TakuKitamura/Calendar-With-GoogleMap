import UIKit
import SwiftyJSON
class Tool {
    
    private let session: URLSession = URLSession.shared
    
    func returnParseJson(json: String) -> JSON {
        
        if let dataFromString = json.data(using: .utf8, allowLossyConversion: false) {
            let parseJson = JSON(data: dataFromString)
            return parseJson
        }
            
        else {
            return "PARSE JSON ERROR"
        }
        
    }

    func createRequestUrl(queryParams: Dictionary<String, String>) -> String{
        
        var url = "http://192.168.2.200:3000/api/v1/?"
//        var url = "http://localhost:3000/api/v1/?"

        var queryParamsCount = queryParams.count

        for (key, value) in queryParams {
            if(queryParamsCount > 1) {
                url += key + "=" + value + "&"
            }

            else if(queryParamsCount == 1) {
                url += key + "=" + value
            }
            
            else {
                url = ""
                print("CREATE URL ERROR!")
            }

            queryParamsCount -= 1
        }

        return url
    }
    
    func getRequest(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
