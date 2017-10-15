import UIKit
import SwiftyJSON
import RealmSwift

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let createPlanViewController = CreatePlanViewController()
    
    private var showedYear = 2000
    private var showedMonth = 01
    private var showedDay = 01
    
    private var tableView: UITableView!
    
    private var plans: [JSON] = []
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height

    override func viewDidLoad() {
        super.viewDidLoad()
        print("お")

        // Do any additional setup after loading the view, typically from a nib.
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd"
        let date = dateFormater.date(from: String(self.showedYear) + "/" + String(self.showedMonth) + "/" + String(self.showedDay))
        
        
        var calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date!) - 1
        calendar.locale = Locale(identifier: "ja")
        let weekdaySymbols = calendar.weekdaySymbols
        
        self.title = String(self.showedYear) + "年" + String(self.showedMonth) + "月" + String(self.showedDay) + "日" + weekdaySymbols[weekday]
        
        self.view.backgroundColor = UIColor.white
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(PlanViewController.createPlanButton))
        
        self.navigationItem.setRightBarButtonItems([addButton], animated: false)
        
        // self.cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        // UITableView を作成
        self.tableView = UITableView()
        
        // サイズと位置調整
        self.tableView.frame = CGRect(
            x: 0,
            y: statusBarHeight,
            width: self.view.frame.width,
            height: self.view.frame.height - statusBarHeight
        )
        
        // Delegate設定
        self.tableView.delegate = self
        
        // DataSource設定
        self.tableView.dataSource = self
        
        self.tableView.separatorInset = .zero
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(self.tableView)
        
        print(self.plans)

    }
    
  @objc   func createPlanButton(){
        self.navigationController?.pushViewController(createPlanViewController, animated: false)
    }
    
    func initSelectedDay(showedYear: Int, showedMonth: Int ,selectedDay: Int) {
        
        self.showedYear = showedYear
        self.showedMonth = showedMonth
        self.showedDay = selectedDay
        
        loadView()
        viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを作る
        
//        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
//            try! FileManager.default.removeItem(at: fileURL)
//        }
 
        
        let realm = try! Realm()
        
        let lastItem = realm.objects(RealmData.self).sorted(byKeyPath: "id", ascending: false)
        var addId: Int = 1
        if lastItem.count > 0 {
            addId = lastItem[0].id - 1
        }
        
        let realmData = realm.objects(RealmData.self)
 
        print(realmData)
        
        print("です")

        // 登録処理
        
        print(realm.objects(RealmData.self))
        
        print("か")
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        // cell.accessoryType = .detailButton
        
        
        if (indexPath.row == 0) {
            let separatorView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
            separatorView.backgroundColor = UIColor.lightGray
            cell.addSubview(separatorView)
            
            cell.textLabel?.text = "開始"
            cell.detailTextLabel?.text = realmData[addId].plans
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return 1 // self.plans.count
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時の処理
        print("タップされたセルのindex番号: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 60
    }
    
    func addPlanToTable(plan: JSON) {
        self.plans.append(plan)
        // 入力値をセット
        
        // 保存
        let realm = try! Realm()
        print(realm.objects(RealmData.self))
        let lastItem = realm.objects(RealmData.self).sorted(byKeyPath: "id", ascending: false)
        var addId: Int = 1
        if lastItem.count > 0 {
            addId = lastItem[0].id + 1
        }

        let realmData = RealmData()
        realmData.id = addId
        realmData.plans = plans[0]["status"].stringValue
        // 登録処理
        try! realm.write {
            realm.add(realmData, update: true)
        }
        
        print(realm.objects(RealmData.self))
 
        loadView()
        viewDidLoad()
         
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
