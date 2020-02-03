//
//  MenuTableViewController.swift
//  Resto Apps iOS
//
//  Created by Rasyid Respati Wiriaatmaja on 03/02/20.
//  Copyright © 2020 rasyidrw. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuTableViewController: UITableViewController {
    
    var dataMakanan = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    func getData(){
        Alamofire.request(Constant().urlPublic + "getMakanan").responseJSON {(response) in
            
            let allJSON = JSON(response.result.value as Any)
            let success = allJSON["sukses"].boolValue
            print(success)
            
            if success{
                self.dataMakanan = allJSON["data"].arrayObject as! [[String : String]]
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return dataMakanan.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMakanan", for: indexPath) as! MenuTableViewCell
        
        // ambil data dari JSON
        let index = dataMakanan[indexPath.row]
        let nama = index["menu_nama"]
        let harga = index["menu_harga"]
        let gambar = index["menu_gambar"]
        
        cell.lblNama.text = nama
        cell.lblHarga.text = harga
        
        Alamofire.request(gambar!).responseJSON {(dataGambar) in
            
            let data = dataGambar.data
            cell.imgGambar.image = UIImage(data: data!)
            
        }
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {(action, view, handler) in
            
            // ambil data dari JSON
            let index = self.dataMakanan[indexPath.row]
            let nama = index["menu_nama"]
            let harga = index["menu_harga"]
            let gambar = index["menu_gambar"]
            let id = index["menu_id"]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(identifier: "editMenu") as EditViewController
            
            destination.id = id
            destination.nama = nama
            destination.harga = harga
            destination.gambar = gambar
            
            self.show(destination, sender: self)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            // ambil data dari JSON
            let index = self.dataMakanan[indexPath.row]
            let id = index["menu_id"]
            
            let param : [String : String] = ["id" : id!]
            
            Alamofire.request(Constant().urlPublic + "deleteMakanan", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON {(response) in
                
                let allJson = JSON(response.result.value as Any)
                let sukses = allJson["sukses"].boolValue
                let pesan = allJson["pesan"].stringValue
                
                if sukses{
                    self.showAlert(title: "Sukses", message: pesan, isFinish: false)
                    self.viewDidAppear(true)
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
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
