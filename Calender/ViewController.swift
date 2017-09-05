//
//  ViewController.swift
//  test_uikit
//
//  Created by FujiiYuji on 2017/05/23.
//  Copyright © 2017年 Yuji Fujii. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var myCollectionView : UICollectionView!
    let dateManager = DateManager()
    
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    let cellMargin: CGFloat = 2.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        self.view.addSubview(myCollectionView)
        
        
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
        
        let nowDate = NSDate()
        let comp = Calendar.current.dateComponents([.year, .month, .day], from:nowDate as Date)
        headerView.textLabel?.text = "\(comp.year!)年\(comp.month!)月\(comp.day!)日"
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
            
            
            
        default:
            print("section error")
            cell.backgroundColor = UIColor.white
        }
        
        return cell
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
