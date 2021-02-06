//
//  LoginViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//

import UIKit
import SnapKit

protocol ValidatesUserName {
    func validatesUserName(_ userName: String) -> Bool
}
protocol ValidatesPassword {
    func validatesPassword(_ password: String) -> Bool
}
extension ValidatesUserName {
    func validatesUserName(_ userName: String) -> Bool {
        print(userName, userName == "Ou")
        if userName != "Ou" {
            return false
        }
        return true
    }
}
extension ValidatesPassword {
    func validatesPassword(_ password: String) -> Bool {
        print(password.count)
        if password.count < 6 || password.count > 12 {
            return false
        }
        return true
    }
}
class LoginViewController: BaseViewController, ValidatesPassword, ValidatesUserName {
    var userNameTextField:UITextField!
    var passworodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoView = UIImageView(image: UIImage(systemName: "dot.circle.and.cursorarrow"))
        view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        let phoneIconView = UIImageView(image: UIImage(systemName: "ipodtouch"))
        userNameTextField = UITextField()
        userNameTextField.leftView = phoneIconView
        userNameTextField.leftViewMode = .always
        userNameTextField.layer.borderColor = UIColor.hexColor(0x333333).cgColor
        userNameTextField.layer.borderWidth = 1
        userNameTextField.textColor = UIColor.hexColor(0x333333)
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.layer.masksToBounds = true
        userNameTextField.placeholder = "username"
        view.addSubview(userNameTextField)
        
        userNameTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(logoView.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        
        let passwordIconView = UIImageView(image:UIImage(systemName: "mail"))
        passworodTextField = UITextField()
        passworodTextField.leftView = passwordIconView
        passworodTextField.leftViewMode = .always
        passworodTextField.layer.borderColor = UIColor.hexColor(0x333333).cgColor
        passworodTextField.layer.borderWidth = 1
        passworodTextField.textColor = UIColor.hexColor(0x333333)
        passworodTextField.layer.cornerRadius = 5
        passworodTextField.layer.masksToBounds = true
        passworodTextField.placeholder = "passworod"
        passworodTextField.isSecureTextEntry = true
        view.addSubview(passworodTextField)
        
        passworodTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(userNameTextField.snp_bottom).offset(15)
            make.height.equalTo(50)
        }
        
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        loginButton.setBackgroundImage(UIColor.hexColor(0xf8892e).toImage(), for: .normal)
        loginButton.layer.cornerRadius = 5
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(passworodTextField.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        loginButton.addTarget(self, action: #selector(didClickLoginButton), for: .touchUpInside)
        
    }
    @objc func didClickLoginButton() {
        if validatesUserName(userNameTextField.text ?? "") && validatesPassword(passworodTextField.text ?? "") {
            print("sucess!")
        } else {
            self.showToast()
        }
    }
    func showToast() {
        let alertVC = UIAlertController(title: "提示", message: "用户或者密码错误", preferredStyle: .alert)
        present(alertVC, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alertVC.dismiss(animated: true, completion: nil)
        }
    }
}
