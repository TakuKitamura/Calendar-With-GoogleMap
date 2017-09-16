import UIKit

class CreatePlanViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var datePicker: UIDatePicker!
    private var startSelectedDate = "2017/09/16 22:00"
    private var endSelectedDate = "2017/09/17 10:00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* 以下は UITextFieldDelegate のメソッド */
    
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ planTitleField: UITextField) -> Bool {
        
        // キーボードを隠す
        planTitleField.resignFirstResponder()
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
        
        
        if indexPath.row == 0 {
            let separatorView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
            separatorView.backgroundColor = UIColor.lightGray
            cell.addSubview(separatorView)
            
            cell.textLabel?.text = "開始"
            cell.detailTextLabel?.text = self.startSelectedDate
        }
        
        else {
            cell.textLabel?.text = "終了"
            cell.detailTextLabel?.text = self.endSelectedDate
        }

        /*
        if(indexPath.row < 12) {
            cell.textLabel?.text = "午前\(indexPath.row)時"
        }
            
        else if(indexPath.row == 12) {
            cell.textLabel?.text = "正午"
        }
            
        else if(indexPath.row < 24) {
            cell.textLabel?.text = "午後\(indexPath.row % 12)時"
        }
            
        else {
            cell.textLabel?.text = "午前0時"
        }
        //cell.detailTextLabel?.text = "\(indexPath.row + 1)番目のセルの説明"
        */
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return 2
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時の処理
        print("タップされたセルのindex番号: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 50
    }
    /*
    func onDidChangeDate(sender: UIDatePicker){
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        self.startSelectedDate = mySelectedDate as String
        
        print(self.startSelectedDate)
        loadView()
        viewDidLoad()
        
    }
    */
    internal func onDidChangeDate(sender: UIDatePicker){
        
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        self.startSelectedDate = mySelectedDate as String
        
        print(self.startSelectedDate)
        self.tableView.reloadData()

    }
}
