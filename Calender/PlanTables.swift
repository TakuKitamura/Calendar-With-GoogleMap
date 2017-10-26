import RealmSwift
class Plan: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var display: Bool = true
    @objc dynamic var json: String = ""
    @objc dynamic var departureDate: Date? = nil
    @objc dynamic var arrivalDate: Date? = nil
    
    
    override static func primaryKey() -> String {
        return "id"
    }
}
