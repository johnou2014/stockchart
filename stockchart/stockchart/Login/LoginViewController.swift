//
//  LoginViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/4/13.
//

import Foundation
//MARK: -LoginViewHander
protocol LoginViewHandler {
    func validateUsername(_ username: String?)
    func validatePassword(_ password: String?)
    func login(username: String?, password: String?)
}

class LoginViewController: UIViewController {
    var clickCount = 0
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var errorMsg: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Login In"
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
        let username = usernameTextField.text
        let password = passwordTextField.text
        print("username =",username,"password =",password)
        //handler?.login(username: username, password: password)
       
       // let vc = ViewController()
        
        //self.navigationController?.pushViewController(vc, animated: true)
    }
}
