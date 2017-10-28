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
    
    func returnQueryParams() -> Dictionary<String, String> {
        return queryParams
    }
    
    func updateArrivalTime(arrival_time: String) {
        
        func localToUTC(date:String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.calendar = NSCalendar.current
            dateFormatter.timeZone = TimeZone.current
            
            let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            return dateFormatter.string(from: dt!)
        }
//        self.arrival_time = arrival_time.replacingOccurrences(of: " ", with: ",")
//        queryParams["arrival_time"] = arrival_time.replacingOccurrences(of: " ", with: ",")
        // print(self.arrival_time)
//        let dateString = arrival_time
//        let df = DateFormatter()
//        df.dateFormat = "yyyy/MM/dd HH:mm"
//        if let dateFromString = df.date(from: dateString) {
//            print(dateFromString)  // "2015-01-14 10:53:00 +0000\n"
//            df.timeZone = TimeZone(secondsFromGMT: 0)
//            let stringFromDate = df.string(from: dateFromString) //"Jan 14, 2015, 10:53 AM"
//            print(stringFromDate)
//            queryParams["arrival_time"] = stringFromDate.replacingOccurrences(of: " ", with: ",")
//        }
        queryParams["arrival_time"] = localToUTC(date: arrival_time).replacingOccurrences(of: " ", with: ",")
        
    }
    
    func updateMode(mode: String) {
        queryParams["mode"] = mode
    }
    
    func updateOriginLat(origin_lat: String) {
        queryParams["origin_lat"] = origin_lat
    }
    
    func updateOriginLng(origin_lng: String) {
        queryParams["origin_lng"] = origin_lng
    }
    
    func updateDestinationLat(destination_lat: String) {
        queryParams["destination_lat"] = destination_lat
    }
    
    func updateDestinationLng(destination_lng: String) {
        queryParams["destination_lng"] = destination_lng
    }

    func createRequestUrl() -> String{
        
        queryParams["mode"] = "transit"
        
        var url = "http://localhost:3000/api/v1/?"

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
