//
//  AddDrinkViewController.swift
//  Practica2_Bebidas
//
//  Created by Jorge Armando Avila Estrada on 06/03/23.
//

import UIKit

class AddDrinkViewController: UIViewController {

    let ad = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtIngredients: UITextField!
    @IBOutlet weak var txtDirections: UITextField!
    @IBOutlet weak var btnPhoto: UIButton!
    var drink:Bebida?
    var drinks:[Bebida]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        
        
    }
    
    @IBAction func validaCampos(_ sender: Any) {
        
        guard let name = txtName.text,
              let ingredients = txtIngredients.text,
              let directions = txtDirections.text
        else{
            return
        }
        
        var mensaje = ""
        if name == "" {
            mensaje = "Indique el nombre de la bebida"
        }
        else if ingredients == ""{
            mensaje = "Indique los ingredientes"
        }
        else if directions == ""{
            mensaje = "Indique la preparación"
        }
        
        if mensaje == ""{
            //TODO Guarda la bebida
            drink = Bebida(name: name, directions: directions, ingredients: ingredients, img: "0.jpg")
            
            do {
                let data = try Data(contentsOf: ad.urlLocalDrinks!)
                let result = try JSONDecoder().decode([Bebida].self, from: data)
                drinks = result as [Bebida]
                drinks?.append(drink!)
                let encoder = JSONEncoder()
                try encoder.encode(drinks).write(to: ad.urlLocalDrinks!)
                
                let mensaje = "Se almacenó la bebida "
                let ac = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default){
                    alertaAction in
                    //Se ejecuta la accion deseada
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                    self.txtIngredients.text  = ""
                    self.txtDirections.text = ""
                    self.txtName.text = ""
                }
                ac.addAction(action)
                present(ac, animated: true)
            } catch {
                print(error)
            }
        
        }
        else{
            let ac = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default){
                alertaAction in
                //Se ejecuta la accion deseada
            }
            ac.addAction(action)
            present(ac, animated: true)
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
    
}
