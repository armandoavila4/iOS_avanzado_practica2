//
//  ViewController.swift
//  Practica2_Bebidas
//
//  Created by Jorge Armando Avila Estrada on 27/02/23.
//

import UIKit
import Network

class ViewController: UITableViewController {

    let ad = UIApplication.shared.delegate as! AppDelegate
    var drinks:[Bebida]?
    
    @IBOutlet var tableDrinks: UITableView!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Something Else", style: .plain, target: nil, action: nil)
        //Verifica si el archivo JSON existe, sino lo descarga
        checkJSON()
        
        //Se lee el archivo JSON
        readJSON()
    }
    
    

    func checkJSON(){
        //Validamos si existe el archivo localmente
        if FileManager.default.fileExists(atPath: ad.urlLocalDrinks?.path ?? ""){
            print ("Ya existe el archivo local")
        }else{
            if(!downloadJSON()){
                print ("Error al descargar el archivo JSON")
            }
        }
    }
    
    func downloadJSON() -> Bool{
        //Verifica conexión a internet
        if ad.checkInternet(){
            guard let laURL = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks.json") else {return false}
            do{
                let bytes = try Data(contentsOf: laURL)
                // que se hace con el archivo (Documents tiene respaldo en iCloud y Library no)
                if let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first{
                    try bytes.write(to:libraryURL.appendingPathComponent("drinks.json"),options: .atomic)
                }
                return true
            }catch{
                print("ocurrio el error")
                return false
            }
        }else{
            let mensaje = "No hay conexion a internet"
            let ac = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default){
                alertaAction in
                //Se ejecuta la accion deseada
            }
            ac.addAction(action)
            present(ac, animated: true)
            return false
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // Configure the cell...
        let bebida = drinks?[indexPath.row]
        cell.textLabel?.text = bebida?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail"){
            let destination = segue.destination as! DetailDrinkViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            destination.drink = drinks?[indexPath.row]
        }
    }
    
    func readJSON(){
        do {
            let data = try Data(contentsOf: ad.urlLocalDrinks!)
            let result = try JSONDecoder().decode([Bebida].self, from: data)
            drinks = result as [Bebida]
            print(drinks!)
            
        } catch {
            print(error)
        }
    }
    
    @objc func refresh() {
        readJSON()
        self.tableDrinks.reloadData() // a refresh the tableView.
        self.tabBarController?.selectedIndex = 0
    }
    
}

