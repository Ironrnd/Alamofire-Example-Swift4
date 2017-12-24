//
//  ViewController.swift
//  AlamofireExample
//
//  Created by Andrew Belozerov on 24.12.2017.
//  Copyright © 2017 Andrew Belozerov. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    fileprivate var items = [Item]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let afDelegate = Alamofire.SessionManager.default.delegate
        
        afDelegate.taskDidComplete = { urlSession, urlSessionTask, error in
            print("Task did complete")
        }
        
        afDelegate.dataTaskDidReceiveResponse = { urlSession, urlSessionDataTask, urlResponse in
            print("Data task did receive response")
            let urlsrd = URLSession.ResponseDisposition(rawValue: 1)
            return urlsrd!
            
        }
        
        
    }

    @IBAction func sendRequest(_ sender: UIButton) {
        Alamofire.request("https://jsonplaceholder.typicode.com/photos", method: .get).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных\(String(describing: response.result.error))")
                return
            }
            
            guard let arrayOfItems = response.result.value as? [[String:AnyObject]]
                else {
                    print("Не могу перевести в массив")
                    return
            }
            
            for itm in arrayOfItems {
                let item = Item(albimID: itm["albumId"] as! Int, id: itm["id"] as! Int, title: itm["title"] as! String, url: itm["url"] as! String)
                self.items.append(item)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    private func configureCell(cell: ItemCell, for indexPath: IndexPath) {
        let item = items[indexPath.row]
        cell.idLabel.text = "\(item.id)"
        cell.albumIdLabel.text = "\(item.albimID)"
        cell.urlLabel.text = item.url
        cell.titleLabel.text = item.title
    }
}

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var albumIdLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
}


struct Item {
    let albimID: Int
    let id: Int
    let title: String
    let url: String
}

