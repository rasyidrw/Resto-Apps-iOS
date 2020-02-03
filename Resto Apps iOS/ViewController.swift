//
//  ViewController.swift
//  Resto Apps iOS
//
//  Created by Rasyid Respati Wiriaatmaja on 03/02/20.
//  Copyright © 2020 rasyidrw. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var tfInsertNama: UITextField!
    @IBOutlet weak var tfInsertHarga: UITextField!
    @IBOutlet weak var tfUrlGambar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnInsertData(_ sender: UIButton) {
        
        if tfInsertNama.text == "" || tfInsertHarga.text == "" || tfUrlGambar.text == "" {
            showAlert(title: "warning", message: "Tidak boleh kosong!", isFinish: false)
        } else {
            
            let param : [String : String] = ["name" : tfInsertNama.text!,
                                             "price" : tfInsertHarga.text!,
                                             "gambar" : tfUrlGambar.text!]
            
            Alamofire.request(Constant().urlPublic + "insertMakanan", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON {(response) in
                
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
                self.navigationController?.popToRootViewController(animated: true)
            })
        } else {
            ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        }
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
}

