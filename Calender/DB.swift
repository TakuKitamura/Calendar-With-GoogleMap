
import RealmSwift
import SwiftyJSON

class DB {
    
    func updatePlan(id: Int, json: String, title: String, queryParams: Dictionary<String, String>) {
        
        // print(self.returnParseJson(json: json))
        // 保存
        let realm = try! Realm()
        
        let plan = Plan()
        
        ////////////////
        
        // 新規プラン作成
        if(id == -1) {
            // 降順
            let lastItem = realm.objects(Plan.self).sorted(byKeyPath: "id", ascending: false)
            
            var addId: Int = 0
            
            if lastItem.count > 0 {
                addId = lastItem[0].id + 1
            }
            
            plan.id = addId
            

        }
        
        // 既存プラン更新
        else {
            plan.id = id
        }
        
        func UTCToLocal(date:String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd,HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            return dt!
        }
        
        plan.title = title
        
        plan.mode = queryParams["mode"]!
        
        plan.arrival_time = UTCToLocal(date: queryParams["arrival_time"]!)
        
        plan.destination_lat = Double(queryParams["destination_lat"]!)!
        plan.destination_lng = Double(queryParams["destination_lng"]!)!
        
        
        ////////////////
        plan.json = json

        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let dataFromString = json.data(using: .utf8, allowLossyConversion: false)
        let jsonJson = JSON(data: dataFromString!)
        
        let duration = jsonJson["routes"][0]["legs"][0]["duration"]["value"].intValue
        
        if(jsonJson["routes"][0]["legs"][0]["arrival_time"]["text"].exists()) {
            let arrivalTimeUnix = jsonJson["routes"][0]["legs"][0]["arrival_time"]["value"].intValue
            plan.departure_time = (NSDate(timeIntervalSince1970: TimeInterval(arrivalTimeUnix)) as Date) - TimeInterval(duration)
            plan.actual_arrival_time = NSDate(timeIntervalSince1970: TimeInterval(arrivalTimeUnix)) as Date
        }
        
        else {
            plan.departure_time = plan.arrival_time - TimeInterval(duration)
            plan.actual_arrival_time = plan.arrival_time
        }
        
        plan.origin_lat = Double(queryParams["origin_lat"]!)!
        plan.origin_lng = Double(queryParams["origin_lng"]!)!
        
        // 登録処理
        try! realm.write {
            realm.add(plan, update: true)
            print(realm.objects(Plan.self))
        }

    }
}
