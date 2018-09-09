//
//  ViewController.swift
//  DatesFilterEnum
//
//  Created by apple on 9/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var obj_operations = [model_operations]()
    
    enum TableSection : Int {
        case Planned = 0 , Scheduled , total
    }
    let SectionHeaderHeight: CGFloat = 50
    
    var data  = [TableSection : [model_operations]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.getDetailsBusiness()
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    
    func getDetailsBusiness(){
        let jsonurl = "http://shamba.exaact.co:8085/Rancher/activity/operationslist"
        guard let url = URL(string: jsonurl) else {return}
        var request = URLRequest(url: url)
        var token="8b8cc4bd-eb23-4371-926b-4cd7f2ef474f"
        if UserDefaults.standard.value(forKey: "authKey") != nil
        {
            token = UserDefaults.standard.value(forKey: "authKey")as! String
        }
        request.httpMethod = "GET"
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data , error == nil ,response != nil else {
                print("something is wrong")
                return
            }
            DispatchQueue.main.async {
                do{
                    let op = try JSONDecoder().decode(Operations.self, from: data)
                    print(op)
                    self.obj_operations = op.result
                    
                    self.data[.Planned] = self.obj_operations.filter({$0.status == "Planned"})
                    print(self.data[.Planned]?.count ?? "")
                    print(self.data[.Planned] ?? "")
                    
                    self.data[.Scheduled] = self.obj_operations.filter({$0.status == "Scheduled"})
                    print(self.data[.Scheduled] ?? "")
                    print(self.data[.Scheduled]?.count ?? "")
                    self.tableView.reloadData()
                    
                }
                catch{
                    print(error.localizedDescription)
                }
                
            }
            //        if let Responsestr = String(data:data,encoding:.utf8)
            //            {
            //                 print("personalcontactsresponse : \(Responsestr)")
            //            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.total.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = TableSection(rawValue: section),
            let opdata = data[tableSection]{
            return opdata.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection = TableSection(rawValue: section) ,
            let opdata = data[tableSection] ,
            opdata.count > 0{
            return SectionHeaderHeight
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        
        if let tableSection = TableSection(rawValue: section){
            switch tableSection{
            case .Planned:
                label.text = "Planned"
            case .Scheduled:
                label.text = "Scheduled"
            default:
                label.text = ""
            }
        }
        
        view.addSubview(label)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let tableSection = TableSection(rawValue: indexPath.section) ,
            let opd = data[tableSection]?[indexPath.row]{
            if let titleLabel = cell.viewWithTag(10) as? UILabel{
                titleLabel.text = opd.farmName
            }
            if let subtitleLabel = cell.viewWithTag(20) as? UILabel{
                subtitleLabel.text = opd.createdDtm
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}

