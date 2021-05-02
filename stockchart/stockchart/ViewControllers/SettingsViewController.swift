//
//  SettingsViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/12.
//

import UIKit
class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func outLogin() {
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcUrl = homeDirectory + "/Documents/local_data_source_file.json"
        let filePath:String = NSHomeDirectory() + "/Documents/local_data_source_file.json"
        let exist = fileManager.fileExists(atPath: filePath)
        if(exist) {
            try! fileManager.removeItem(atPath: srcUrl)
            self.jumpIndexPage()
        }
        
    }
    func jumpIndexPage() {
        print("run === jumpIndexPage" )
        //use StoryboardId
        let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: LoginViewController())))
                    as! LoginViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
