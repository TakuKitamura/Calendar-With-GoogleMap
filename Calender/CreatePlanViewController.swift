import UIKit

class CreatePlanViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var dataList = ["開始","終了"]
    
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
        planTitleField.clearButtonMode = .always
        
        // 改行ボタンの種類を変更
        planTitleField.returnKeyType = .done
        
        // 画面に追加
        self.view.addSubview(planTitleField)
        
        // UITableView を作成
        let tableView = UITableView()
        
        // サイズと位置調整
        tableView.frame = CGRect(
            x: 0,
            y: 150,
            width: self.view.frame.width,
            height: self.view.frame.height - 100
        )
        
        // Delegate設定
        tableView.delegate = self
        
        // DataSource設定
        tableView.dataSource = self
        
        tableView.separatorInset = .zero
        
        tableView.isScrollEnabled = false
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(tableView)
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
        
        cell.textLabel?.text = dataList[indexPath.row]
        
        
        if indexPath.row == 0{
            let separatorView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
            separatorView.backgroundColor = UIColor.lightGray
            cell.addSubview(separatorView)
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
        
        cell.detailTextLabel?.text = "\(indexPath.row + 1)番目のセルの説明"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return dataList.capacity
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

}
