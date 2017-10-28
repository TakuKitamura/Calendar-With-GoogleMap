import UIKit
import SwiftyJSON
class ParseJson {
    
    private let session: URLSession = URLSession.shared
    
    private var arrival_time = "2017/01/01,00:00:00"
    private var mode = "transit"
    private var origin_lat = "0.0"
    private var origin_lng = "0.0"
    private var destination_lat = "0.0"
    private var destination_lng = "0.0"
    
    private var json = ""
    
    var queryParams: Dictionary<String, String> = [:]
    
    func returnParseJson(json: String) -> JSON {
        
        if let dataFromString = json.data(using: .utf8, allowLossyConversion: false) {
            let parseJson = JSON(data: dataFromString)
            //            print(parseJson)
            return parseJson
        }
            
        else {
            return "PARSE JSON ERROR"
        }
        
    }
    
    func updateArrivalTime(arrival_time: String) {
//        self.arrival_time = arrival_time.replacingOccurrences(of: " ", with: ",")
        queryParams["arrival_time"] = arrival_time.replacingOccurrences(of: " ", with: ",")
        // print(self.arrival_time)
    }
    
    func updateMode(mode: String) {
//        self.mode = mode
        queryParams["mode"] = mode
        // print(self.mode)
    }
    
    func updateOriginLat(origin_lat: String) {
//        self.origin_lat = origin_lat
        queryParams["origin_lat"] = origin_lat
        // print(self.origin_lat)
    }
    
    func updateOriginLng(origin_lng: String) {
//        self.origin_lng = origin_lng
        queryParams["origin_lng"] = origin_lng
        // print(self.origin_lng)
    }
    
    func updateDestinationLat(destination_lat: String) {
//        self.destination_lat = destination_lat
        queryParams["destination_lat"] = destination_lat
        // print(self.destination_lat)
    }
    
    func updateDestinationLng(destination_lng: String) {
//        self.destination_lng = destination_lng
        queryParams["destination_lng"] = destination_lng
        // print(self.destination_lng)
    }

    func createRequestUrl() -> String{
        
        queryParams["mode"] = "transit"
        
        var url = "http://localhost:3000/api/v1/?"

        var queryParamsCount = queryParams.count

        print()

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
        
//        let url = "http://localhost:3000/api/v1/?" + "arrival_time=" + queryParams["arrival_time"] + "&" + "mode=" + queryParams["mode"] + "&" + "origin_lat=" + queryParams["origin_lat"] + "&" + "origin_lng=" + queryParams["origin_lng"] + "&" + "destination_lat=" + queryParams["destination_lat"] + "&" + "destination_lng=" + queryParams["destination_lng"]
        
//        let url = "http://localhost:3000/api/v1/?" + "arrival_time=" + self.arrival_time + "&" + "mode=" + self.mode + "&" + "origin_lat=" + self.origin_lat + "&" + "origin_lng=" + self.origin_lng + "&" + "destination_lat=" + self.destination_lat + "&" + "destination_lng=" + self.destination_lng
        

//        print(self.url)
        return url

        //return URL(string: self.url)!
    }
    
    func getRequest(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
