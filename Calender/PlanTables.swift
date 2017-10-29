import RealmSwift
class Plan: Object {
    @objc dynamic var id: Int = 0
    
    @objc dynamic var title: String = ""
    
    @objc dynamic var display: Bool = true
    
    @objc dynamic var json: String = ""
    
    @objc dynamic var departure_time: Date = Date()
    
//    目的地に到着したい時刻
    @objc dynamic var arrival_time: Date = Date()
    
//    目的地に到着する時刻
    @objc dynamic var actual_arrival_time: Date = Date()
    
    @objc dynamic var origin_lat: Double = 0.0
    @objc dynamic var origin_lng: Double = 0.0
    
    @objc dynamic var destination_lat: Double = 0.0
    @objc dynamic var destination_lng: Double = 0.0
    
    @objc dynamic var mode: String = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
}
