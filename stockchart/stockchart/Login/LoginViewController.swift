//
//  LoginViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/4/13.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: -LoginViewHander
protocol LoginViewHandler {
    func validateUsername(_ username: String?)
    func validatePassword(_ password: String?)
    func login(username: String?, password: String?)
}
func getUserInfo(type: String) -> String {
    if(type != "username" && type != "Authorization") {
        return ""
    }
    let fileManager = FileManager.default
    let filePath:String = NSHomeDirectory() + "/Documents/local_data_source_file.json"
    let exist = fileManager.fileExists(atPath: filePath)
    if(exist) {
        //存在文件
        print("读取文件=",exist)
        //读文件
        let _manager = FileManager.default
        let urlsForDocDirectory = _manager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlsForDocDirectory[0]
        let file = docPath.appendingPathComponent("local_data_source_file.json")
        print(file)
        
        //读取本地的文件
        
        let readHandler = try! FileHandle(forReadingFrom:file)
        let data = readHandler.readDataToEndOfFile()
        let readString = String(data: data, encoding: String.Encoding.utf8)!
        print(JSON(readString))
        if let dataFromString = readString.data(using: .utf8, allowLossyConversion: false) {
            let json = try! JSON(data: dataFromString)
            print("json =", json[type].stringValue)
            return json[type].stringValue
        }
    }
    return ""
}
let headers: HTTPHeaders = [.authorization(getUserInfo(type: "Authorization"))]
class LoginViewController: UIViewController {
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var errorMsg: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Login In"
        getUserData()
    }
    @IBAction func textFiledEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {return }
        switch sender {
        case usernameTextField:
            handler?.validateUsername(text)
        case passwordTextField:
            handler?.validatePassword(text)
        default: break
        }
    }
    var handler: LoginViewHandler?
    @IBAction func loginButtonTouchInside(_ sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        if(username == "" || password == "") {
            self.dialogMessage(str: "请填写完整")
            return
        }
        print("username =",username,"password =",password)
        
        AF.request("http://easytrade007.com:8080/api/v1/checkUser/", method: .post,parameters: ["username":username,"password":password], encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            print("response =",response)
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let success = JSON(response.data)["success"].boolValue
            print("success =", success)
            if success {
                print("登录成功")
                //保存token
                // 写入文件
                let filePath:String = NSHomeDirectory() + "/Documents/local_data_source_file.json"
                let info = JSON(["username":username, "password": password, "Authorization": "Token \(JSON(response.data as Any)["data"]["token"].stringValue)" ]).rawString()
                print("写入文件 info ===",info)
                try! info?.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                self.jumpIndexPage()
            } else {
             self.dialogMessage(str: "登录失败")
            }
        }
    }
    func dialogMessage(str: String) {
        var dialogMessage = UIAlertController(title: "登录提示", message: str, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
        // Present alert to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func jumpIndexPage() {
        //use StoryboardId
        let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: ViewController())))
                    as! ViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func getUserData() {
        if !getUserInfo(type: "username").isEmpty {
            self.jumpIndexPage()
        }
    }
}

