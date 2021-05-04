//
//  CreateNewAccountViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/5/4.
//

import Foundation
import SwiftyJSON
import Alamofire

struct NewAccount: Decodable {
    let email: String
    let username: String
    let password: String
    let first_name: String
    let last_name: String
}
class CreateNewAccountViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var create_email: UITextField!
    @IBOutlet weak var create_username: UITextField!
    @IBOutlet weak var create_password: UITextField!
    @IBOutlet weak var create_passwordAgin: UITextField!
    @IBOutlet weak var create_first_name: UITextField!
    @IBOutlet weak var create_last_name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        create_email.delegate = self
        create_username.delegate = self
        create_password.delegate = self
        create_passwordAgin.delegate = self
        create_first_name.delegate = self
        create_last_name.delegate = self
        self.navigationController?.title = "Create Account"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    @IBAction func createNewAccount() {
        let emailText = create_email.text!
        let usernameText = create_username.text!
        let passwordText = create_password.text!
        let first_nameText = create_first_name.text!
        let passwordAginText = create_passwordAgin.text!
        let last_nameText = create_last_name.text!
        let data = JSON(["email":emailText, "username": usernameText, "password": passwordText, "first_name": first_nameText, "last_name": last_nameText])
        print(data["email"].stringValue.isEmpty)
        if(data["email"].stringValue.isEmpty || data["username"].stringValue.isEmpty || data["password"].stringValue.isEmpty ) {
            dialogMessage(str: "Input Can not be Empty!")
            return
        }
        if(isValidEmail(emailText)) {
            if(passwordAginText == passwordText) {
                print("right Info")
                print(data)
                self.createAccount(data: data)
            } else {
                dialogMessage(str: "Enter The Password Does Not Match")
                return
            }
        } else {
            dialogMessage(str: "Please Enter Your Vaild Email")
            return
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func dialogMessage(str: String) {
        let dialogMessage = UIAlertController(title: "Prompt Message", message: str, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
        // Present alert to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    func goToLogin() {
        let alertController: UIAlertController = UIAlertController(title: "Create prompt", message: "The email has been sent, please log in to activate the email", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //dont have to do anything
        }
        let nextAction = UIAlertAction(title: "Go to Login", style: .default) { action -> Void in
            self.jumpIndexPage()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(nextAction)
        self.present(alertController, animated: true, completion: nil);
    }
    func jumpIndexPage() {
        //use StoryboardId
        let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: LoginViewController())))
                    as! LoginViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func createAccount(data: JSON) {
        AF.request("http://easytrade007.com:8080/api/v1/signup/", method: .post,parameters: data, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            print("response =",response)
            if let err = response.error {
                print("error \(err.localizedDescription)")
                self.dialogMessage(str: err.localizedDescription)
                return
            }
            print("response.success =", JSON(response)["message"], JSON(response)["message"].stringValue.isEmpty)
            let emptyMessage = JSON(response.data as Any)["message"].stringValue.isEmpty
            if(!emptyMessage) {
                self.dialogMessage(str: JSON(response.data as Any)["message"].stringValue)
                return
            }
           self.goToLogin()
           
        }
    }
}
