import UIKit

class CreatePlanViewController: UIViewController, UITextFieldDelegate {
    
    private var myTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インスタンス初期化
        let textField = UITextField()
        
        // サイズ設定
        textField.frame.size.width = self.view.frame.width - 10
        textField.frame.size.height = 48
        
        // 位置設定
        textField.center.x = self.view.center.x
        textField.center.y = 150
        
        // Delegate を設定
        textField.delegate = self
        
        // プレースホルダー
        textField.placeholder = "タイトル"
        
        // 背景色
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // 左の余白
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        // テキストを全消去するボタンを表示
        textField.clearButtonMode = .always
        
        // 改行ボタンの種類を変更
        textField.returnKeyType = .done
        
        // 画面に追加
        self.view.addSubview(textField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* 以下は UITextFieldDelegate のメソッド */
    
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        print("Clear")
        return true
    }
    
    // テキストフィールドがフォーカスされた時の処理
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Start")
        return true
    }
    
    // テキストフィールドでの編集が終わろうとするときの処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("End")
        return true
    }
}
