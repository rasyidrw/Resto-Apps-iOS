//
//  LoginViewController.swift
//  Resto Apps iOS
//
//  Created by Rasyid Respati Wiriaatmaja on 03/02/20.
//  Copyright © 2020 rasyidrw. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfEmailLogin: UITextField!
    @IBOutlet weak var tfPasswordLogin: UITextField!
    
    var userDefaultLogin = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        userDefaultLogin = UserDefaults.standard
        
        let isLogin : Bool = (userDefaultLogin.bool(forKey: "isLogin"))
        
        if isLogin == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "navMenu")
            show(destination, sender: self)
            
            print("sudah login")
        } else {
            print("belum login")
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if tfEmailLogin.text == "" || tfPasswordLogin.text == "" {
            showAlert(title: "warning", message: "tidak boleh kosong", isFinish: false)
        } else {
            let param : [String : String] = ["email" : tfEmailLogin.text!,
                                             "password" : tfPasswordLogin.text!]
            
            Alamofire.request(Constant().urlPublic + "login", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON {(response) in
                
                let allJson = JSON(response.result.value as Any)
                let sukses = allJson["sukses"].boolValue
                let pesan = allJson["pesan"].stringValue
                
                if sukses{
                    
                    self.userDefaultLogin.set(true, forKey: "isLogin")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let destination = storyboard.instantiateViewController(withIdentifier: "navMenu")
                    self.show(destination, sender: self)
                } else {
                    self.showAlert(title: "warning", message: pesan, isFinish: false)
                }
                
            }
        }
        
    }
    
    func showAlert(title: String, message: String, isFinish : Bool) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var ok = UIAlertAction()
        if isFinish {
            ok = UIAlertAction(title: "ok", style: .default, handler: {(alertAction) in
                self.navigationController?.popToRootViewController(animated: true)
            })
        } else {
            ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        }
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
