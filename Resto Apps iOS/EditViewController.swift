//
//  EditViewController.swift
//  Resto Apps iOS
//
//  Created by Rasyid Respati Wiriaatmaja on 03/02/20.
//  Copyright © 2020 rasyidrw. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditViewController: UIViewController {
    
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var tfEditNama: UITextField!
    @IBOutlet weak var tfEditHarga: UITextField!
    @IBOutlet weak var tfEditGambar: UITextField!
    
    var id : String?
    var nama : String?
    var harga : String?
    var gambar : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEditNama.text = nama
        tfEditHarga.text = harga
        tfEditGambar.text = gambar
        
        Alamofire.request(gambar!).response {(data) in
            let dataGambar = data.data
            self.imgEdit.image = UIImage(data: dataGambar!)
            
        }
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        
        if tfEditNama.text == "" || tfEditHarga.text == "" || tfEditGambar.text == "" {
            showAlert(title: "warning", message: "tidak boleh kosong", isFinish: false)
        } else {
            
            let param : [String : String] = ["name" : tfEditNama.text!,
                                             "price" : tfEditHarga.text!,
                                             "gambar" : tfEditGambar.text!,
                                             "id" : id!]
            
            Alamofire.request(Constant().urlPublic + "updateMakanan", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON {(response) in
                
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
