import UIKit
import GooglePlaces
import GooglePlacePicker
import CoreLocation

class CreatePlanViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GMSPlacePickerViewControllerDelegate {
    
    var locationManager: CLLocationManager!
    
    private var parseJson = ParseJson()

    private var tableView: UITableView!
    private var datePicker: UIDatePicker!
    private var startSelectedDate = "2017/10/16 13:00"

    private var destination = "地図で調べる"
    
    private var planTitle = ""
    
    private var isSelectedStart = true
    
    private var isSelectedDestination = false
    
    private var placePicker: GMSPlacePickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        
        locationManager.startUpdatingLocation()
        
        // インスタンス初期化
        let planTitleField = UITextField()
        
        // サイズ設定
        planTitleField.frame.size.width = self.view.frame.width - 10
        planTitleField.frame.size.height = 48
        
        // 位置設定
        planTitleField.center.x = self.view.center.x
        planTitleField.center.y = 100
        
        // Delegate を設定
        planTitleField.delegate = self
        
        // プレースホルダー
        planTitleField.placeholder = "タイトル"
        
        // 背景色
        planTitleField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // 左の余白
        planTitleField.leftViewMode = .whileEditing
        planTitleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        // テキストを全消去するボタンを表示
        planTitleField.clearButtonMode = .whileEditing
        
        // 改行ボタンの種類を変更
        planTitleField.returnKeyType = .done
        
        // 画面に追加
        self.view.addSubview(planTitleField)
        
        // UITableView を作成
        self.tableView = UITableView()
        
        // サイズと位置調整
        tableView.frame = CGRect(
            x: 0,
            y: 150,
            width: self.view.frame.width,
            height: self.view.frame.height - 100
        )
        
        // Delegate設定
        self.tableView.delegate = self
        
        // DataSource設定
        self.tableView.dataSource = self
        
        self.tableView.separatorInset = .zero
        
        self.tableView.isScrollEnabled = false
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(self.tableView)
        
        // DatePickerを生成する.
        self.datePicker = UIDatePicker()
        
        // datePickerを設定（デフォルトでは位置は画面上部）する.
        self.datePicker.frame = CGRect(x:0, y:400, width:self.view.frame.width, height:200)
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.layer.cornerRadius = 5.0
        self.datePicker.layer.shadowOpacity = 0.5
        
        // 値が変わった際のイベントを登録する.
        self.datePicker.addTarget(self, action: #selector(CreatePlanViewController.onDidChangeDate(sender:)), for: .valueChanged)
        
        // DataPickerをViewに追加する.
        self.view.addSubview(self.datePicker)
        
        self.datePicker.isHidden = true
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(CreatePlanViewController.savePlanButton))
        
        self.navigationItem.setRightBarButtonItems([saveButton], animated: false)

        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* 以下は UITextFieldDelegate のメソッド */
    
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ planTitleField: UITextField) -> Bool {
        
        // キーボードを隠す
        self.planTitle = planTitleField.text!
        planTitleField.resignFirstResponder()
        // print(planTitleField.text)
        return true
    }
    
    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ planTitleField: UITextField) -> Bool {
        
        print("Clear")
        return true
    }
    
    // テキストフィールドがフォーカスされた時の処理
    func textFieldShouldBeginEditing(_ planTitleField: UITextField) -> Bool {
        print("Start")
        self.datePicker.isHidden = true
        return true
    }
    
    // テキストフィールドでの編集が終わろうとするときの処理
    func textFieldShouldEndEditing(_ planTitleField: UITextField) -> Bool {
        print("End")
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを作る

        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        // cell.accessoryType = .detailButton
        
        
        if (indexPath.row == 0) {
            let separatorView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
            separatorView.backgroundColor = UIColor.lightGray
            cell.addSubview(separatorView)
            
            cell.textLabel?.text = "開始"
            cell.detailTextLabel?.text = self.startSelectedDate

        }
        
        else {
            cell.textLabel?.text = "目的地"
            cell.detailTextLabel?.text = self.destination
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return 2
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時の処理
        
        if(indexPath.row == 0) {
            self.isSelectedStart = true
            self.datePicker.isHidden = false
        }
        
        else {
            self.isSelectedDestination = true
            self.datePicker.isHidden = true
            pickPlace()
        }
        print("タップされたセルのindex番号: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 50
    }

    @objc func onDidChangeDate(sender: UIDatePicker){
        
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: String = myDateFormatter.string(from: sender.date) as String
        
        if(isSelectedStart) {
            self.startSelectedDate = mySelectedDate as String
            parseJson.updateArrivalTime(arrival_time: self.startSelectedDate)
        }
        
        else {
            print("SelectedStartEnd ERROR!")
        }

        self.tableView.reloadData()

    }
    
    @objc func savePlanButton(){

        self.datePicker.isHidden = true
        
        let createUrl = parseJson.createRequestUrl()
        
        let url = URL(string: createUrl)!
        
        parseJson.getRequest(url: url, completionHandler: { data, response, error in

            if let dat = data {
                if let stringJson = String(data: dat, encoding: .utf8) {
                    
                    let jsonJson = self.parseJson.returnParseJson(json: stringJson)
                    
                    let jsonStatus = jsonJson["status"].stringValue
                    
                    if jsonStatus == "OK" && self.planTitle != "" {
                        print("え")
                        // planViewController.addPlanToTable(plan: self.parseJson.returnParseJson())
                        
                        let insertTables = InsertTables()
                        
                        insertTables.insertPlan(json: stringJson, title: self.planTitle)
                        
                        DispatchQueue.main.async {
                            self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
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
        
//        self.navigationController?.popViewController(animated: false)
//        self.navigationController?.popToViewController(ViewController(), animated: false)
//         self.navigationController?.pushViewController(planViewController, animated: false)
        
//        if(isValidPlan) {
//            navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
//        }
    }
    
    func pickPlace() {
        let config = GMSPlacePickerConfig(viewport: nil)
        self.placePicker = GMSPlacePickerViewController(config: config)
        
        self.placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        
        if(self.isSelectedDestination) {
            parseJson.updateDestinationLat(destination_lat: String(place.coordinate.latitude))
            parseJson.updateDestinationLng(destination_lng: String(place.coordinate.longitude))
            
            if(place.formattedAddress != nil) {
                self.destination = place.name
            }

            self.tableView.reloadData()
        }
        
        else {
            print("place.coordinate ERROR!")
        }
        
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        self.isSelectedDestination = false
        
        print("No place selected")
    }
    
    func hidePickerView(sender: Any) {
        self.datePicker.resignFirstResponder()
        self.datePicker.isHidden = !self.datePicker.isHidden
    }
    
    func donePressed(){

    }
    func cancelPressed(){

    }
}

extension CreatePlanViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
            
            parseJson.updateOriginLat(origin_lat: String(location.coordinate.latitude))
            parseJson.updateOriginLng(origin_lng: String(location.coordinate.longitude))
        }
    }
}

