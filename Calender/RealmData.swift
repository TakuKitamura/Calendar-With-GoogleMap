import RealmSwift
class RealmData: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var plans = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
}
