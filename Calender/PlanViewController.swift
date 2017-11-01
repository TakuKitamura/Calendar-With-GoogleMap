import UIKit
import SwiftyJSON
import RealmSwift
import CoreLocation

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locationManager: CLLocationManager!
    
    private var queryParams: Dictionary<String, String> = [:]
    
    private var showedYear = 2000
    private var showedMonth = 01
    private var showedDay = 01
    
    private var selectedDate = Date()
    
    private var tableView: UITableView!
    
    private var plans: [JSON] = []
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        
        locationManager.startUpdatingLocation()
        
        print("お")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        self.selectedDate = dateFormatter.date(from: String(self.showedYear) + "-" + String(self.showedMonth) + "-" + String(self.showedDay))!
        
        ///
        
        let realm = try! Realm()
        
        let tool = Tool()
        
        let displayPlan = realm.objects(Plan.self)
            .filter(self.returnDatePredicate())
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd,HH:mm"
        
        if(displayPlan.count > 0) {
            for planTable in displayPlan {
                self.queryParams["arrival_time"] = dateFormatter.string(from: planTable.arrival_time)
                self.queryParams["destination_lat"] = String(planTable.destination_lat)
                self.queryParams["destination_lng"] = String(planTable.destination_lng)
                self.queryParams["mode"] = planTable.mode
                self.queryParams["origin_lat"] = "34.982076"
                self.queryParams["origin_lng"] = "135.963717"
                print("self.queryParamsarrival_time " + self.queryParams["arrival_time"]!)
                
                let createUrl = tool.createRequestUrl(queryParams: queryParams)
                print(createUrl)
                let url = URL(string: createUrl)!
                
                tool.getRequest(url: url, completionHandler: { data, response, error in
                    
                    if let dat = data {
                        if let stringJson = String(data: dat, encoding: .utf8) {
                            
                            let jsonJson = tool.returnParseJson(json: stringJson)
                            
                            let jsonStatus = jsonJson["status"].stringValue
                            
                            if(jsonStatus == "OK"){
                                
                                let db = DB()
                                DispatchQueue.main.async {
                                    db.updatePlan(id: planTable.id, json: stringJson, title: planTable.title, queryParams: self.queryParams)
                                }
                            }
                                
                            else {
                                print("ZERO_RESULTS")
                            }
                            
                        } else {
                            print("not a valid UTF-8 sequence")
                        }
                    }
                    
                    if let err = error {
                        print(err)
                    }
                })
                print(planTable.id)
                print(self.queryParams)
            }
            
            
        }
        
        
        
        ///
        
        var calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self.selectedDate) - 1
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
        
    }
    
    @objc func createPlanButton(){
        self.navigationController?.pushViewController(CreatePlanViewController(), animated: false)
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
        
        let realm = try! Realm()
        
        let displaySortedPlan = realm.objects(Plan.self)
            .filter(self.returnDatePredicate())
            // 降順
            .sorted(byKeyPath: "departure_time", ascending: true)
        
        // 登録処理
        
        
        print("か")
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // cell.accessoryType = .detailButton
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 0
        
        let index = indexPath.row
        
        if (indexPath.row == 0) {
            
            let separatorView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
            separatorView.backgroundColor = UIColor.lightGray
            cell.addSubview(separatorView)
        }
        
        let item = displaySortedPlan[index]
        
        cell.textLabel?.text = String(item.title)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = "MM/dd HH:mm"
        
        let departureTime = dateFormatter.string(from: item.departure_time)
        let actualArrivalTime = dateFormatter.string(from: item.actual_arrival_time)
        cell.detailTextLabel?.text = "出発　" + departureTime + "　" + "時刻　" + actualArrivalTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        let realm = try! Realm()
        
        let displayPlan = realm.objects(Plan.self)
            .filter(self.returnDatePredicate())
        
        return displayPlan.count // self.plans.count
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時の処理
        
        let index = indexPath.row
        
        let realm = try! Realm()
        
        // 後に、日付の条件を加える ex. 2017/10/1 のとき
        let displaySortedPlan = realm.objects(Plan.self)
            .filter(self.returnDatePredicate())
            // 降順
            .sorted(byKeyPath: "departure_time", ascending: true)
        
        let planDetailViewController = PlanDetailViewController()
        
        planDetailViewController.showDetailPlan(plan: displaySortedPlan[index])
        self.navigationController?.pushViewController(planDetailViewController, animated: false)
        print("タップされたセルのindex番号: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 60
    }
    
    func returnDatePredicate() -> NSPredicate {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        let startBaseDate = dateFormatter.string(from: self.selectedDate)
        
        let startDate = dateFormatter.date(from: startBaseDate)
        
        let finishBaseDate = dateFormatter.string(from: self.selectedDate + TimeInterval(60 * 60 * 24))
        
        //        startDateの24時間後
        let finishDate = dateFormatter.date(from: finishBaseDate)
        //        let finishDate = dateFormatter.string(from: self.selectedDate + TimeInterval(60 * 60 * 24))
        
        let predicate = NSPredicate(format: "(%@ <= departure_time  AND departure_time < %@) AND display = true", startDate! as CVarArg, finishDate! as CVarArg)
        
        return predicate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PlanViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
            
            self.queryParams["origin_lat"] = String(location.coordinate.latitude)
            self.queryParams["origin_lng"] = String(location.coordinate.longitude)
            //            tool.updateOriginLat(origin_lat: String(location.coordinate.latitude))
            //            tool.updateOriginLng(origin_lng: String(location.coordinate.longitude))
        }
    }
}


