import UIKit

class ParseJson {
    
    private let session: URLSession = URLSession.shared
    
    private var departure_time = "2017/01/01%2000:00:00"
    private var mode = "transit"
    private var origin_lat = "0.0"
    private var origin_lng = "0.0"
    private var destination_lat = "0.0"
    private var destination_lng = "0.0"
    
    private var url = "http://localhost:3000/api/v1/?"
    
    private var json = ""
    
    private var needInfo: Dictionary<String, String> = [:]
    
    func parseJson() {
        
    }
    
    func updateDepartureTime(departure_time: String) {
        self.departure_time = departure_time.replacingOccurrences(of: " ", with: "%20")
        print(self.departure_time)
    }
    
    func updateMode(mode: String) {
        self.mode = mode
        print(self.mode)
    }
    
    func updateOriginLat(origin_lat: String) {
        self.origin_lat = origin_lat
        print(self.origin_lat)
    }
    
    func updateOriginLng(origin_lng: String) {
        self.origin_lng = origin_lng
        print(self.origin_lng)
    }
    
    func updateDestinationLat(destination_lat: String) {
        self.destination_lat = destination_lat
        print(self.destination_lat)
    }
    
    func updateDestinationLng(destination_lng: String) {
        self.destination_lng = destination_lng
        print(self.destination_lng)
    }
    
    func updateJson(json: String) {
        self.json = json
        print(self.json)
    }
    
    func createRequestUrl() -> String{
        
        self.url += "departure_time=" + self.departure_time + "&" + "mode=" + self.mode + "&" + "origin_lat=" + self.origin_lat + "&" + "origin_lng=" + self.origin_lng + "&" + "destination_lat=" + self.destination_lat + "&" + "destination_lng=" + self.destination_lng

        print(self.url)
        return self.url

        //return URL(string: self.url)!
    }
    
    func getRequest(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
