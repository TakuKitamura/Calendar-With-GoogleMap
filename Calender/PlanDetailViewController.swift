import UIKit
import RealmSwift
import SwiftyJSON

class PlanDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var planLines:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        // UITableView を作成
        let tableView = UITableView()
        
        // サイズと位置調整
        tableView.frame = CGRect(
            x: 0,
            y: statusBarHeight,
            width: self.view.frame.width,
            height: self.view.frame.height - statusBarHeight
        )
        
        // Delegate設定
        tableView.delegate = self
        
        // DataSource設定
        tableView.dataSource = self
        
        tableView.separatorInset = .zero
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showDetailPlan(plan: Plan) {
        let dataFromString = plan.json.data(using: .utf8, allowLossyConversion: false)
        let json = JSON(data: dataFromString!)
//        print(json["routes"][0]["legs"][0]["start_address"].stringValue)
        
        let startAddress = "出発地：" + json["routes"][0]["legs"][0]["start_address"].stringValue
        let endAddress = "到着地：" + json["routes"][0]["legs"][0]["end_address"].stringValue
        let departureTime = "出発時刻：" + json["routes"][0]["legs"][0]["departure_time"]["text"].stringValue
        let arrivalTime = "到着時刻：" + json["routes"][0]["legs"][0]["arrival_time"]["text"].stringValue
        let distance = "距離：" + json["routes"][0]["legs"][0]["distance"]["text"].stringValue
        let fare = "所要金額：" + json["routes"][0]["fare"]["text"].stringValue
        let duration = "所要時間：" + json["routes"][0]["legs"][0]["duration"]["text"].stringValue
        
        self.planLines.append(startAddress)
        self.planLines.append(endAddress)
        self.planLines.append(departureTime)
        self.planLines.append(arrivalTime)
        self.planLines.append(distance)
        self.planLines.append(fare)
        self.planLines.append(duration)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        if (indexPath.row == 0) {
            let separatorView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
            separatorView.backgroundColor = UIColor.lightGray
            cell.addSubview(separatorView)
        }
        
        cell.textLabel?.text = self.planLines[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 60
    }
    
}
