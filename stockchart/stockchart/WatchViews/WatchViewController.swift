//
//  WatchViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//
import UIKit
import Alamofire
import SwiftyJSON

class WatchViewController: UITableViewController {
    var watchs = Watch.getWatchList()
    let identifier: String = "tableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupUI()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("watch Detail = ",segue.identifier as Any)
        if segue.identifier == "watchDetail",
            let indexPath = tableView?.indexPathForSelectedRow,
            let destinationViewController: WatchDetailViewController = segue.destination as? WatchDetailViewController {
            destinationViewController.watch = watchs[indexPath.row]
        }
    }
}
extension WatchViewController {
    func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Watch List"
        tableView.reloadData()
    }
    func updateUI() {
        /*
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.refreshControl!.isRefreshing {
                self.tableView.refreshControl!.endRefreshing()
                self.presentAlertController(withTitle: "List Reloaded Successfully")
            }
        } */
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
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/getUserStock", method: .get, parameters: ["username":"john.ou"]).validate().responseJSON { response in
            var list: [Watch] = [Watch]()
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                for (_, item) in json {
                    let watchData = Watch(pk: item["pk"].intValue, user: item["user"].stringValue, stock: item["stock"].stringValue, stock_name: item["stock_name"].stringValue, user_id: item["user_id"].intValue, stock_id: item["stock_id"].intValue)
                    list.append(watchData)
                }
                TableDataSource.itemsList = list
                self.updateUI()
                print("list =\(list)")
            case .failure(let error):
                print(error)
            }
        }
    }

}


