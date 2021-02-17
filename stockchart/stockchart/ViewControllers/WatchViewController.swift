//
//  WatchViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//
import UIKit
import Alamofire

class WatchViewController: UITableViewController {
    
    var watchs = Watch.getWatchList()
    let identifier: String = "tableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

}


