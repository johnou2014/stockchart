//
//  WatchViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//
import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class WatchViewController: UITableViewController {
    var watchs = [Watch]()//Watch.getWatchList()
    let identifier: String = "tableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromAPI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "watchDetail",
           let indexPath = tableView?.indexPathForSelectedRow,
           let destinationViewController: CanvasViewController = segue.destination as? CanvasViewController {
            destinationViewController.watch = watchs[indexPath.row]
        }
           /*let destinationViewController: WatchDetailViewController = segue.destination as? WatchDetailViewController {
            destinationViewController.watch = watchs[indexPath.row]
        }
 */
    }
}
extension WatchViewController {
    func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Watch List"
        tableView.reloadData()
    }
    private func presentAlertController(withTitle title: String) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
}
extension WatchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TableCell {
            cell.configurateTheCell(watchs[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableView Delegate

extension WatchViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            watchs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/getUserStock", method: .get, parameters: ["username":"john.ou"]).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)
            var candles: [Watch] = [Watch]()
            for json in json.arrayValue {
                let info = Watch(pk: json["pk"].intValue, user: json["user"].stringValue, stock: json["stock"].stringValue, stock_name: json["stock_name"].stringValue, user_id: json["user_id"].intValue, stock_id: json["stock_id"].intValue)
                candles.append(info)
            }
            self.watchs = candles
            self.setupUI()
            print("刷新成功！")
        }
        //MARK: -本地静态数据
    }
}



