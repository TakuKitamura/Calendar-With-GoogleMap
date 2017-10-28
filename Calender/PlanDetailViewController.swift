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
        
        var startAddressList = json["routes"][0]["legs"][0]["start_address"].stringValue.split(separator: " ")
        
        startAddressList.removeFirst()
        
        let startAddress = startAddressList.joined(separator: "")
        
        var endAddressList = json["routes"][0]["legs"][0]["end_address"].stringValue.split(separator: " ")
        
        endAddressList.removeFirst()
        
        let endAddress = endAddressList.joined(separator: "")
        
        
        let departureTime = json["routes"][0]["legs"][0]["departure_time"]["text"].stringValue
        let arrivalTime = json["routes"][0]["legs"][0]["arrival_time"]["text"].stringValue
        let fare = json["routes"][0]["fare"]["value"].intValue
//        let duration = json["routes"][0]["legs"][0]["duration"]["text"].stringValue
        
//        self.planLines.append("所要時間　" + duration + "\n" + "所要金額　" + String(fare) + "円")
        print(departureTime)
        self.planLines.append(startAddress + "\n" + "出発時刻　" + departureTime + "　所要金額　" + String(fare) + "円")
//        self.planLines.append(startAddress)
        
        for (index, subJson):(String, JSON) in json["routes"][0]["legs"][0]["steps"] {
            
            if(subJson["travel_mode"].stringValue == "WALKING") {
                
                let walkingDuration = subJson["duration"]["text"].stringValue
                self.planLines.append("↓　徒歩　" + walkingDuration)
            }
            
            else if(subJson["travel_mode"].stringValue == "TRANSIT") {
                
                let transitDepartureTime = subJson["transit_details"]["departure_time"]["text"].stringValue
                let transitArrivalTime = subJson["transit_details"]["arrival_time"]["text"].stringValue
                
                let arrivalStopName = subJson["transit_details"]["arrival_stop"]["name"].stringValue
                let transitHeadsign = subJson["transit_details"]["headsign"].stringValue
                let agenciesName = subJson["transit_details"]["line"]["agencies"][0]["name"].stringValue
                let lineName = subJson["transit_details"]["line"]["name"].stringValue
                let lineVehicleName = subJson["transit_details"]["line"]["vehicle"]["name"].stringValue
                
                let transitDuration = subJson["duration"]["text"].stringValue
                
                let departureStopName = subJson["transit_details"]["departure_stop"]["name"].stringValue
                
                self.planLines.append("出発バス停　" + departureStopName + "\n" + agenciesName + "　" + transitHeadsign + "　" + lineName + "\n" + "バス出発時刻　" + transitDepartureTime)
                
                self.planLines.append("↓　" + lineVehicleName + "　" + transitDuration)
                
                self.planLines.append("到着バス停　" + arrivalStopName + "\n" + "バス到着時刻　" + transitArrivalTime)

                
                
            }
        }
        
        self.planLines.append(endAddress + "\n" + "到着時刻　" + arrivalTime)
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
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.planLines[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 60
    }
    
}
