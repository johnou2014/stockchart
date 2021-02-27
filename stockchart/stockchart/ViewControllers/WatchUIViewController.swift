//
//  WatchUIViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/21.
//


import UIKit
import Alamofire
import SwiftyJSON

protocol messageDelegate {
    func messageTitle(title: String)
}

class WatchUIViewController: UIViewController {
    
    // MARK:- Outlets and Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var activityIndicator:UIActivityIndicatorView!
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the activity indicator
        activityIndicator = UIActivityIndicatorView()
        
        addRefreshControl(to: tableView)
        setup(activityIndicator: activityIndicator)
        
        // Make the API request
        loadDataFromAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK:- Actions
    
    @IBAction func addItems(_ sender: Any) {
       // let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        detailVC.delegate = self
//        detailVC.navigationItem.title = "Add Item"
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK:- Network Functions
    
    @objc func loadDataFromAPI() {
        // Use Alamofire to make the request
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

// MARK: - TableView DataSource

extension WatchUIViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableDataSource.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(in: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - TableView Delegate

extension WatchUIViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateItem(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) { deleteItem(at: indexPath) }
    }
    
}

// MARK: - Message Delegate

extension WatchUIViewController: messageDelegate {
    func messageTitle(title: String) {
        presentAlertController(withTitle: title)
    }
}

// MARK: - Helper Functions

extension WatchUIViewController {
    
    private func setup(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.style = .large
        activityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(self.view)
        activityIndicator.startAnimating()
    }
    
    private func addRefreshControl(to tableView: UITableView) {
        // Initialize the Refresh Control
        let refreshControl = UIRefreshControl()
        // Add Refresh Control to Table View
        tableView.refreshControl = refreshControl
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(loadDataFromAPI), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching List Data ...")
    }
    
    private func setupCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        // Set title and body of the cell
        //var title = TableDataSource.itemsList[indexPath.item]["stock"] as? String
//        title = String(indexPath.item + 1) + "-" + title!
//        cell.textLabel?.text = title
//        cell.detailTextLabel?.text =  TableDataSource.itemsList[indexPath.item]["stock_name"] as? String
        
        return cell
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            if self.tableView.refreshControl!.isRefreshing {
                self.tableView.refreshControl!.endRefreshing()
                self.presentAlertController(withTitle: "List Reloaded Successfully")
            }
        }
    }
    
    private func updateItem(at indexPath: IndexPath) {
//        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        detailVC.delegate = self
//        detailVC.navigationItem.title = "Update Item"
//        detailVC.selectedCell = indexPath.item
//        detailVC.selectedCellTitle = ItemsModel.itemsList[indexPath.item]["title"] as? String
//        detailVC.selectedCellBody = ItemsModel.itemsList[indexPath.item]["body"] as? String
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        TableDataSource.itemsList.remove(at: indexPath.item)
        tableView.reloadData()
    
        presentAlertController(withTitle: "Item Deleted Successfully")
    }
    
    private func presentAlertController(withTitle title: String) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
}
