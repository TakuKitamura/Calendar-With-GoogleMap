
import RealmSwift
import SwiftyJSON

class Insert {
    
    func insertPlan(json: String, title: String, queryParams: Dictionary<String, String>) {
        
        // print(self.returnParseJson(json: json))
        // 保存
        let realm = try! Realm()
        
        // 降順
        let lastItem = realm.objects(Plan.self).sorted(byKeyPath: "id", ascending: false)
        
        var addId: Int = 0
        
        if lastItem.count > 0 {
            addId = lastItem[0].id + 1
        }
        
        let plan = Plan()
        
        plan.id = addId
        plan.title = title
        plan.json = json
        
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
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd,HH:mm"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//
//        let arrival_time = dateFormatter.date(from: queryParams["arrival_time"]!)
        
        plan.arrival_time = UTCToLocal(date: queryParams["arrival_time"]!)
        plan.origin_lat = Double(queryParams["origin_lat"]!)!
        plan.origin_lng = Double(queryParams["origin_lng"]!)!
        
        plan.destination_lat = Double(queryParams["destination_lat"]!)!
        plan.destination_lng = Double(queryParams["destination_lng"]!)!
        
        plan.mode = queryParams["mode"]!
        
        // 登録処理
        try! realm.write {
            realm.add(plan, update: true)
            print(realm.objects(Plan.self))
        }

    }
    
}
