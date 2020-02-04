//
//  RegisterViewController.swift
//  Resto Apps iOS
//
//  Created by Rasyid Respati Wiriaatmaja on 04/02/20.
//  Copyright © 2020 rasyidrw. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var tfRegisNama: UITextField!
    @IBOutlet weak var tfRegisEmail: UITextField!
    @IBOutlet weak var tfRegisPassword: UITextField!
    @IBOutlet weak var tfRegisHp: UITextField!
    
    var userDefaultLogin = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        
        if tfRegisNama.text == "" || tfRegisEmail.text == "" || tfRegisPassword.text == "" || tfRegisHp.text == "" {
            showAlert(title: "Warning", message: "Tidak boleh kosong!", isFinish: false)
        } else {
            
            let param : [String : String] = ["name" : tfRegisNama.text!,
                                             "email" : tfRegisEmail.text!,
                                             "password" : tfRegisPassword.text!,
                                             "hp" : tfRegisHp.text!]
            
            Alamofire.request(Constant().urlPublic + "register", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON {(response) in
                
                let allJson = JSON(response.result.value as Any)
                let sukses = allJson["sukses"].boolValue
                let pesan = allJson["pesan"].stringValue
                
                if sukses{
                    self.showAlert(title: "Sukses", message: pesan, isFinish: true)
                    
                } else {
                    self.showAlert(title: "Gagal", message: pesan, isFinish: false)
                
                }
            }
        }
    }
    
    func showAlert(title: String, message: String, isFinish : Bool) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var ok = UIAlertAction()
        if isFinish {
            ok = UIAlertAction(title: "ok", style: .default, handler: {(alertAction) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destination = storyboard.instantiateViewController(withIdentifier: "login")
                self.show(destination, sender: self)
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
