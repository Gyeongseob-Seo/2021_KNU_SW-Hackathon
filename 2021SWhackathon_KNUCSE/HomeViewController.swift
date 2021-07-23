//
//  HomeViewController.swift
//  2021SWhackathon_KNUCSE
//
//  Created by 서경섭 on 2021/07/23.
//

//import UIKit
//import SwiftSoup
//
//class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
//
//
//    @IBOutlet weak var TotalCorona: UILabel!
//    @IBOutlet weak var DaeguCorona: UILabel!
//
//
//    @IBOutlet weak var GongjiTableView: UITableView!{
//        didSet {
//            GongjiTableView.delegate = self
//            GongjiTableView.dataSource = self
//            GongjiTableView.separatorStyle = .none
//            GongjiTableView.rowHeight = 70
//        }
//    }
//
//    var count: Int = 0
//    var GongjiData: [String]!
//    var GongjiIndex: Int = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        fetchHTMLParsingResultWill()
//        fetchHTMLParsingResultGongji()
//
//        GongjiTableView.register(GongjiCellTableViewCell.self, forCellReuseIdentifier: "GongjiCell")
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    func fetchHTMLParsingResultWill(/*completion: @escaping() -> ()*/) {
//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
//        var Data = [String] ()
//        let urlAddress = "http://covid19.daegu.go.kr/index.html"
//        print("함수진입")
//        guard let url = URL(string: urlAddress) else {return}
//        do {
//            let html = try String(contentsOf: url, encoding: .utf8)
//            let doc: Document = try SwiftSoup.parse(html)
//            print(doc)
//            let firstLinkTitless: Elements = try doc.select("div.sa_today").select("p.info_variation")
//
//            for element in firstLinkTitless.array() {
//                print("Title : ", try element.text())
//                Data.append(try element.text())
//            }
//        //completion()
//        }catch let error {
//            print("Error: ", error)
//        }
//
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return GongjiData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let Gongjicell = GongjiTableView.dequeueReusableCell(withIdentifier: "GongjiCell", for: indexPath) as! GongjiCellTableViewCell
//
//        Gongjicell.ContentView.text = GongjiData[indexPath.row]
//        Gongjicell.MoveButton.addTarget(self, action: #selector(moveToView), for: .touchUpInside)
//        return Gongjicell
//    }
//
//
//    func fetchHTMLParsingResultGongji(/*completion: @escaping() -> ()*/) {
//      GongjiData = [String]()
//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
//
//        let urlAddress = "http://knu.ac.kr/wbbs/wbbs/bbs/btin/list.action?bbs_cde=34&menu_idx=224"
//        print("함수진입공지")
//        guard let url = URL(string: urlAddress) else {return}
//        do {
//            let html = try String(contentsOf: url, encoding: .utf8)
//            let doc: Document = try SwiftSoup.parse(html)
//            //print(doc)
//            let firstLinkTitless: Elements = try doc.select("div.board_list").select("td.subject").select("a")
//
//            for element in firstLinkTitless.array() {
//                print("Title : ", try element/*.text()*/)
//              GongjiData.append(try element.text())
//              count += 1
//            }
//        //completion()
//        }catch let error {
//            print("Error: ", error)
//        }
//      print("\(count) 회 필요 ")
//    }
//
//    @objc func moveToView(){
//        guard let svc = self.storyboard?.instantiateViewController(identifier: "NoticeView") as? NoticeView else {
//            return
//        }
//
//        svc.URL = URL(string: "https://www.naver.com")
//        self.present(svc, animated: true)
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

import UIKit
import SwiftSoup

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    var count: Int = 0
    var currentlyWorkingIndex: Int!
    var GongjiData: [String]!
    var GongjiLink: [String]!
    var GongjiIndex: Int = 0
    var studnum: String!
    var password: String!
    
    
    @IBOutlet weak var Time: UILabel!
    
    let timeSelector : Selector = #selector(HomeViewController.updateTime)
    let interval = 1.0
    
    
    
    
    @IBOutlet weak var CoronaInKorea: UILabel!
    
    @IBOutlet weak var CoronaInKoreaForeign: UILabel!
    
    @IBOutlet weak var CoronaDaegu: UILabel!
    
    @IBOutlet weak var Infected_today: UITextView!
    @IBOutlet weak var Infected_local: UITextView!
    @IBOutlet weak var Infected_abroad: UITextView!
    @IBOutlet weak var Cured: UITextView!
    @IBOutlet weak var Curing: UITextView!
    
    @IBOutlet weak var newbtn: UIButton!
    @IBOutlet weak var schoolbtn: UIButton!
    @IBOutlet weak var chatbtn: UIButton!
    
    @IBOutlet weak var GongjiTableView: UITableView!{
        didSet {
            GongjiTableView.delegate = self
            GongjiTableView.dataSource = self
            GongjiTableView.separatorStyle = .none
            GongjiTableView.rowHeight = 70
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        
        fetchHTMLParsingResultWill()
        fetchHTMLParsingResultGongji()
        
        
        GongjiTableView.register(GongjiCellTableViewCell.self, forCellReuseIdentifier: "GongjiCell")
    
        
    }
    
    @objc func updateTime(){
            // count 값을 문자열로 변환하여 lblCurrentTime.text에 출력
    //        lblCurrentTime.text = String(count)
    //        count = count + 1 // count 값을 1 증가
            let date = NSDate() // 현재 시간을 가져옴
            
            
            let formatter = DateFormatter() // DateFormatter라는 클래스의 상수 formatter를 선언
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
            // 상수 formatter의 dateFormat 속성을 설정
            // 현재날짜(date)를 formatter의 dateFormat에서 설정한 포맷대로 string 메서드를 사용하여 문자열(String)로 변환
            Time.text = "현재시간 : "+formatter.string(from: date as Date)
            // 문자열로 변한한 date 값을 "현재시간:"이라는 문자열에 추가하고 그 문자열을 lblCurrentTime의 text에 입력
        }
    
    
    @IBAction func LogOut(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
        
    
    func fetchHTMLParsingResultWill(/*completion: @escaping() -> ()*/) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        var Data = [String] ()
        var Data2 = [String] ()
        let urlAdd_whole = "http://ncov.mohw.go.kr/"
        let urlAddress = "http://covid19.daegu.go.kr/index.html"
        print("함수진입")
        guard let url = URL(string: urlAddress) else {return}
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            //print(doc)
            let firstLinkTitless: Elements = try doc.select("div.sa_today").select("p.info_variation")
            
            for element in firstLinkTitless.array() {
                print("Title : ", try element.text())
                Data.append(try element.text())
            }
        //completion()
        }catch let error {
            print("Error: ", error)
        }
        print("___진입___")
        guard let url_national = URL(string: urlAdd_whole) else {return}
        do {
            let html = try String(contentsOf: url_national, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            //print(doc)
            let firstLinkTitless: Elements = try doc/*.select("div.wrap nj").select("div.manlive_container").select("div.container")*/.select("div.datalist").select("span.data")
            for elements in firstLinkTitless.array() {
                print("Data : ", try elements.text())
                Data2.append(try elements.text())
            }
        } catch let error {
            print("Error: ",error)
        }
        print("---------")
        
        CoronaInKorea.text = Data2[0] + "명"
        CoronaInKoreaForeign.text = Data2[1] + "명"
        CoronaDaegu.text = Data[0]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GongjiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Gongjicell = GongjiTableView.dequeueReusableCell(withIdentifier: "GongjiCell", for: indexPath) as! GongjiCellTableViewCell
        
        Gongjicell.ContentView.text = GongjiData[indexPath.row]
        currentlyWorkingIndex = indexPath.row
        Gongjicell.MoveButton.addTarget(self, action: #selector(moveToView), for: .touchUpInside)
        return Gongjicell
    }
    
    
      func fetchHTMLParsingResultGongji(/*completion: @escaping() -> ()*/) {
        GongjiData = [String]()
        GongjiLink = [String]()
          DispatchQueue.main.async {
              UIApplication.shared.isNetworkActivityIndicatorVisible = true
          }
        
          let urlAddress = "http://knu.ac.kr/wbbs/wbbs/bbs/btin/list.action?bbs_cde=34&menu_idx=224"
          print("함수진입공지")
          guard let url = URL(string: urlAddress) else {return}
          do {
              let html = try String(contentsOf: url, encoding: .utf8)
              let doc: Document = try SwiftSoup.parse(html)
              //print(doc)
              let firstLinkTitless: Elements = try doc.select("div.board_list").select("td.subject").select("a")
                    
              for element in firstLinkTitless.array() {
                  print("Title : ", try element.text())
                GongjiData.append(try element.text())
                let temp : String = try element.attr("href")
                GongjiLink.append( "http://knu.ac.kr" + temp)
                print("href : ",try element.attr("href"))
                count += 1
              }
          //completion()
          }catch let error {
              print("Error: ", error)
          }
        print("\(count) 회 필요 ")
      }
    
    @objc func moveToView(){
        guard let svc = self.storyboard?.instantiateViewController(identifier: "NoticeView") as? NoticeView else {
            return
        }
        
        svc.URL = URL(string: GongjiLink[currentlyWorkingIndex])
        print(GongjiLink[currentlyWorkingIndex])
        GongjiIndex += 1
        self.present(svc, animated: true)
    }
}
