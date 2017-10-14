import RealmSwift
class RealmData: Object {
    dynamic var id: Int = 1
    dynamic var plans = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
}
