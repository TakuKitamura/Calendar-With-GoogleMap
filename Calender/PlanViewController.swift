import UIKit

class PlanViewController: UIViewController {
    
    private let createPlanViewController = CreatePlanViewController()
    
    private var showedYear = -1
    private var showedMonth = -1
    private var showedDay = -1

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        
        
    }
    
    func createPlanButton(){
        self.navigationController?.pushViewController(createPlanViewController, animated: true)
    }
    
    func initSelectedDay(showedYear: Int, showedMonth: Int ,selectedDay: Int) {
        
        self.showedYear = showedYear
        self.showedMonth = showedMonth
        self.showedDay = selectedDay
        
        loadView()
        viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
