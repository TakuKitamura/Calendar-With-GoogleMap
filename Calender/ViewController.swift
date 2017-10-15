
import UIKit
import RealmSwift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var myCollectionView : UICollectionView!
    private let dateManager = DateManager()

    private let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    private let cellMargin: CGFloat = 2.0

    private var beforeMonthButton: UIButton!
    private var nextMonthButton: UIButton!

    private var dateButton1: UIButton!
    private var dateButton2: UIButton!
    private var dateButton3: UIButton!
    private var dateButton4: UIButton!
    private var dateButton5: UIButton!
    private var dateButton6: UIButton!
    private var dateButton7: UIButton!
    private var dateButton8: UIButton!
    private var dateButton9: UIButton!
    private var dateButton10: UIButton!
    private var dateButton11: UIButton!
    private var dateButton12: UIButton!
    private var dateButton13: UIButton!
    private var dateButton14: UIButton!
    private var dateButton15: UIButton!
    private var dateButton16: UIButton!
    private var dateButton17: UIButton!
    private var dateButton18: UIButton!
    private var dateButton19: UIButton!
    private var dateButton20: UIButton!
    private var dateButton21: UIButton!
    private var dateButton22: UIButton!
    private var dateButton23: UIButton!
    private var dateButton24: UIButton!
    private var dateButton25: UIButton!
    private var dateButton26: UIButton!
    private var dateButton27: UIButton!
    private var dateButton28: UIButton!
    private var dateButton29: UIButton!
    private var dateButton30: UIButton!
    private var dateButton31: UIButton!

    private var showedYear = Calendar.current.dateComponents([.year], from:selectedDate as Date).year!
    private var showedMonth = Calendar.current.dateComponents([.month], from:selectedDate as Date).month!
//    private var showedDay = Calendar.current.dateComponents([.day], from:selectedDate as Date).day!



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         self.title = "カレンダー"

        self.automaticallyAdjustsScrollViewInsets = false

        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()

        // Cell一つ一つの大きさ.
        layout.itemSize = CGSize(width:self.view.frame.width / 9, height:self.view.frame.height / 10)

        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width:0,height:10)

        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height:self.view.frame.height - 110), collectionViewLayout: layout)

        // Cellに使われるクラスを登録.
        myCollectionView.register(CustomUICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Section")

        myCollectionView.backgroundColor = UIColor.clear

        myCollectionView.delegate = self
        myCollectionView.dataSource = self

        beforeMonthButton = UIButton()

        beforeMonthButton.frame = CGRect(x: self.view.frame.width / 2 - 100, y: 113, width: 20, height: 20)

        beforeMonthButton.backgroundColor = UIColor.gray

        beforeMonthButton.setTitle("<", for: .normal)
        
        beforeMonthButton.alpha = 0.6;

        beforeMonthButton.addTarget(self, action: #selector(ViewController.changeBeforeMonth(sender: )), for: .touchUpInside)

        myCollectionView.backgroundColor = UIColor.clear

        myCollectionView.delegate = self
        myCollectionView.dataSource = self

        nextMonthButton = UIButton()

        nextMonthButton.frame = CGRect(x: self.view.frame.width / 2 + 90, y: 113, width: 20, height: 20)

        nextMonthButton.backgroundColor = UIColor.gray

        nextMonthButton.setTitle(">", for: .normal)
        
        nextMonthButton.alpha = 0.6;

        nextMonthButton.addTarget(self, action: #selector(ViewController.changeNextMonth(sender: )), for: .touchUpInside)


        self.view.addSubview(myCollectionView)
        self.view.addSubview(beforeMonthButton)
        self.view.addSubview(nextMonthButton)

    }

    @objc func changeBeforeMonth(sender: Any) {
        beforeMonthButton.backgroundColor = UIColor.darkGray

        self.showedYear = self.showedMonth == 1 ? self.showedYear - 1 : self.showedYear

        self.showedMonth = self.showedMonth > 1 ? self.showedMonth - 1 : 12

        dateManager.setShowDate(setYear: self.showedYear, setMonth: self.showedMonth)


        loadView()
        viewDidLoad()
    }

    @objc func changeNextMonth(sender: Any) {
        nextMonthButton.backgroundColor = UIColor.darkGray

        self.showedYear = self.showedMonth == 12 ? self.showedYear + 1 : self.showedYear

        self.showedMonth = self.showedMonth < 12 ? self.showedMonth + 1 : 1

        dateManager.setShowDate(setYear: self.showedYear, setMonth: self.showedMonth)
        
        // データベース初期化
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            try! FileManager.default.removeItem(at: fileURL)
        }

        loadView()
        viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Sectionの数
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        switch(section){
        case 0:
            return CGSize(width: self.view.frame.width, height: 30)
        default:
            return CGSize(width: 0, height: 0)
        }
    }

    //Cellの総数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // Section毎にCellの総数を変える.
        switch(section){
        case 0:
            return 7

        case 1:
            return self.dateManager.daysAcquisition()//数を変える

        default:
            print("error")
            return 0
        }

    }


    //セクションを返すメソッド
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Section", for: indexPath) as! CollectionReusableView

//        let nowDate = NSDate()
//        let comp = Calendar.current.dateComponents([.year, .month, .day], from:nowDate as Date)
        
        headerView.textLabel?.text =  "\(showedYear)年\(showedMonth)月"
        headerView.textLabel?.textColor = UIColor.gray

        return headerView


    }

    //Cellに値を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomUICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! CustomUICollectionViewCell


        // Section毎にCellのプロパティを変える.
        switch(indexPath.section){
        case 0:
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = weekArray[indexPath.row]
            if indexPath.row == 0{
                cell.textLabel?.textColor = UIColor(red: 220.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
            }else if indexPath.row == 6{
                cell.textLabel?.textColor = UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
            }else{
                cell.textLabel?.textColor = UIColor.gray
            }

        case 1:

            if indexPath.row % 7 == 0{
                cell.textLabel?.textColor = UIColor(red: 220.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
            }else if indexPath.row % 7 == 6{
                cell.textLabel?.textColor = UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
            }else{
                cell.textLabel?.textColor = UIColor.gray
            }

            let ordinalityOfFirstDay2 = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: dateManager.firstDateOfMonth())

            let dateRange = NSCalendar.current.range(of: .day, in: .month, for: dateManager.firstDateOfMonth())
            //numberOfItems = numberOfItems + dateRange!.count

            cell.textLabel?.text = self.dateManager.conversionDateFormat(indexPath: indexPath)


            if (ordinalityOfFirstDay2! - 1) > indexPath.row{
                cell.textLabel?.text = ""
            }
            if ((ordinalityOfFirstDay2! - 1) + dateRange!.count) - 1 < indexPath.row{
                cell.textLabel?.text = ""
            }

            if(cell.textLabel?.text != ""){
                
                switch cell.textLabel!.text! {
                case "1" :
                    dateButton1 = UIButton()
                    dateButton1.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton1.backgroundColor = UIColor.red
                    dateButton1.tag = 1
                    dateButton1.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton1)

                case "2" :
                    dateButton2 = UIButton()
                    dateButton2.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton2.backgroundColor = UIColor.red
                    dateButton2.tag = 2
                    dateButton2.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton2)

                case "3" :
                    dateButton3 = UIButton()
                    dateButton3.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton3.backgroundColor = UIColor.red
                    dateButton3.tag = 3
                    dateButton3.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton3)

                case "4" :
                    dateButton4 = UIButton()
                    dateButton4.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton4.backgroundColor = UIColor.red
                    dateButton4.tag = 4
                    dateButton4.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton4)

                case "5" :
                    dateButton5 = UIButton()
                    dateButton5.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton5.backgroundColor = UIColor.red
                    dateButton5.tag = 5
                    dateButton5.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton5)

                case "6" :
                    dateButton6 = UIButton()
                    dateButton6.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton6.backgroundColor = UIColor.red
                    dateButton6.tag = 6
                    dateButton6.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton6)

                case "7" :
                    dateButton7 = UIButton()
                    dateButton7.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton7.backgroundColor = UIColor.red
                    dateButton7.tag = 7
                    dateButton7.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton7)

                case "8" :
                    dateButton8 = UIButton()
                    dateButton8.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    dateButton8.tag = 8
                    // dateButton8.backgroundColor = UIColor.red
                    dateButton8.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton8)

                case "9" :
                    dateButton9 = UIButton()
                    dateButton9.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton9.backgroundColor = UIColor.red
                    dateButton9.tag = 9
                    dateButton9.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton9)

                case "10" :
                    dateButton10 = UIButton()
                    dateButton10.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton10.backgroundColor = UIColor.red
                    dateButton10.tag = 10
                    dateButton10.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton10)

                case "11" :
                    dateButton11 = UIButton()
                    dateButton11.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton11.backgroundColor = UIColor.red
                    dateButton11.tag = 11
                    dateButton11.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton11)

                case "12" :
                    dateButton12 = UIButton()
                    dateButton12.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton12.backgroundColor = UIColor.red
                    dateButton12.tag = 12
                    dateButton12.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton12)

                case "13" :
                    dateButton13 = UIButton()
                    dateButton13.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton13.backgroundColor = UIColor.red
                    dateButton13.tag = 13
                    dateButton13.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton13)

                case "14" :
                    dateButton14 = UIButton()
                    dateButton14.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton14.backgroundColor = UIColor.red
                    dateButton14.tag = 14
                    dateButton14.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton14)

                case "15" :
                    dateButton15 = UIButton()
                    dateButton15.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton15.backgroundColor = UIColor.red
                    dateButton15.tag = 15
                    dateButton15.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton15)

                case "16" :
                    dateButton16 = UIButton()
                    dateButton16.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton16.backgroundColor = UIColor.red
                    dateButton16.tag = 16
                    dateButton16.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton16)

                case "17" :
                    dateButton17 = UIButton()
                    dateButton17.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton17.backgroundColor = UIColor.red
                    dateButton17.tag = 17
                    dateButton17.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton17)

                case "18" :
                    dateButton18 = UIButton()
                    dateButton18.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton18.backgroundColor = UIColor.red
                    dateButton18.tag = 18
                    dateButton18.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton18)

                case "19" :
                    dateButton19 = UIButton()
                    dateButton19.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton19.backgroundColor = UIColor.red
                    dateButton19.tag = 19
                    dateButton19.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton19)

                case "20" :
                    dateButton20 = UIButton()
                    dateButton20.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton20.backgroundColor = UIColor.red
                    dateButton20.tag = 20
                    dateButton20.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton20)

                case "21" :
                    dateButton21 = UIButton()
                    dateButton21.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton21.backgroundColor = UIColor.red
                    dateButton21.tag = 21
                    dateButton21.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton21)

                case "22" :
                    dateButton22 = UIButton()
                    dateButton22.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton22.backgroundColor = UIColor.red
                    dateButton22.tag = 22
                    dateButton22.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton22)

                case "23" :
                    dateButton23 = UIButton()
                    dateButton23.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton23.backgroundColor = UIColor.red
                    dateButton23.tag = 23
                    dateButton23.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton23)

                case "24" :
                    dateButton24 = UIButton()
                    dateButton24.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton24.backgroundColor = UIColor.red
                    dateButton24.tag = 24
                    dateButton24.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton24)

                case "25" :
                    dateButton25 = UIButton()
                    dateButton25.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    dateButton25.tag = 25
                    // dateButton25.backgroundColor = UIColor.red
                    dateButton25.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton25)

                case "26" :
                    dateButton26 = UIButton()
                    dateButton26.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton26.backgroundColor = UIColor.red
                    dateButton26.tag = 26
                    dateButton26.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton26)

                case "27" :
                    dateButton27 = UIButton()
                    dateButton27.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton27.backgroundColor = UIColor.red
                    dateButton27.tag = 27
                    dateButton27.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton27)

                case "28" :
                    dateButton28 = UIButton()
                    dateButton28.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton28.backgroundColor = UIColor.red
                    dateButton28.tag = 28
                    dateButton28.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton28)

                case "29" :
                    dateButton29 = UIButton()
                    dateButton29.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton29.backgroundColor = UIColor.red
                    dateButton29.tag = 29
                    dateButton29.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton29)

                case "30" :
                    dateButton30 = UIButton()
                    dateButton30.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton30.backgroundColor = UIColor.red
                    dateButton30.tag = 30
                    dateButton30.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton30)

                case "31" :
                    dateButton31 = UIButton()
                    dateButton31.frame = CGRect(x: cell.frame.midX - 14, y: cell.frame.midY + 86, width: 30, height: 30)
                    // dateButton31.backgroundColor = UIColor.red
                    dateButton31.tag = 31
                    dateButton31.addTarget(self, action: #selector(changePlaningPage(sender: )), for: .touchUpInside)
                    view.addSubview(dateButton31)

                default:
                    print("dateButton ERROR !")

                }



            }



        default:
            print("section error")
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
    
    func createDayButton(Day: Int) {
        
    }

    @objc func changePlaningPage(sender: Any) {
        // 遷移するViewを定義する.
        let planViewController = PlanViewController()
        
        let selectedDay = (sender as AnyObject).tag
        planViewController.initSelectedDay(showedYear: self.showedYear, showedMonth: self.showedMonth,  selectedDay: selectedDay!)
        self.navigationController?.pushViewController(planViewController, animated: false)

    }


    //セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = width * 1.2
        return CGSize(width:width, height:height)

    }

    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }

    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }

}
