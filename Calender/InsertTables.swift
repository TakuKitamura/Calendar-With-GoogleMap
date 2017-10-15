import RealmSwift
import SwiftyJSON

class InsertTables {
    
    /*
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
     */
    
    func insertPlan(json: String) {
        
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
        plan.json = json
        
        // 登録処理
        try! realm.write {
            realm.add(plan, update: true)
            print(realm.objects(Plan.self))
        }

    }
    
}
