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

//
        let vc = WatchViewController()
         //self.present(vc, animated: false, completion: nil)
        //let vc = self.storyboard?.instantiateViewController(identifier: "viewController") as! UIViewController
        
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc , animated:true)

        //handler?.login(username: username, password: password)
    }
//    func viewDidAppear() {
//        self.performSegue(withIdentifier: "segue的identifile", sender: nil)
//        let vc = WatchViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    @IBSegueAction func makeNewPageController(_ coder: NSCoder) -> UIViewController? {
        print("run +++ IBSegueAction")
        self.reloadInputViews()
    
        return nil
        print("run +++ IBSegueAction2")
        return ViewController(coder: coder)
    }
}
