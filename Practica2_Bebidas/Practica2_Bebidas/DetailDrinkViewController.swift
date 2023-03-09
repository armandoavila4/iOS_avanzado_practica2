//
//  DetailDrinkViewController.swift
//  Practica2_Bebidas
//
//  Created by Jorge Armando Avila Estrada on 03/03/23.
//

import UIKit
import AVFoundation

class DetailDrinkViewController: UIViewController {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var urlLocalImage: URL? = {
        var tmp = URL(string: "")
        if let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            tmp = imageURL
        }
        return tmp
    }()
    var drink: Bebida?
    var videoSession:AVCaptureSession!
    
    @IBOutlet weak var aind: UIActivityIndicatorView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var iVDrink: UIImageView!
    @IBOutlet weak var lbIngredients: UILabel!
    @IBOutlet weak var lbDirections: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lbName.text = drink?.name
        lbDirections.text = drink?.directions
        lbIngredients.text = drink?.ingredients
        
        //Se revisa si ya existe la imagen
        checkImage(name: drink!.img)
        
        
    }
    
    func checkImage(name:String){
        //Validamos si existe el archivo localmente
        if FileManager.default.fileExists(atPath: urlLocalImage?.appendingPathComponent(name).path ?? ""){
            //Se lee el archivo de imagen
            do {
                let data = try Data(contentsOf: urlLocalImage!.appendingPathComponent(drink!.img))
                iVDrink.image = UIImage(data: data)
                iVDrink.layer.cornerRadius = 25
                iVDrink.clipsToBounds = true
            } catch {
                iVDrink.image = UIImage(systemName: "wineglass")
                iVDrink.layer.cornerRadius = 25
                iVDrink.clipsToBounds = true
                print(error)
            }
            aind.stopAnimating()
        }else{
            downloadImage(name: name)
        }
    }
    
    func downloadImage(name:String){
        //Verifica conexión a internet
        if ad.checkInternet(){
            if let laURL = URL(string:"http://janzelaznog.com/DDAM/iOS/drinksimages/"+name) {
                //Se implementa descarga en background con URLSession
                //1.- Se establece la configuración o usamos la básica
                let config = URLSessionConfiguration.ephemeral
                //2.- Creamos la sesión de descarga, con la configuración elegida
                let session = URLSession(configuration: config)
                //3.- Creamos el request para especificar que obtener
                let request = URLRequest(url: laURL)
                //4.- Creamos la tarea especifica de descarga
                let task = session.dataTask(with: request){ bytes, response, error in
                    //Que hacemos cuando termine el response
                    if error == nil {
                        guard let data = bytes else {return}
                        DispatchQueue.main.async {
                            self.iVDrink.image = UIImage(data: data)
                            self.iVDrink.layer.cornerRadius = 25
                            self.iVDrink.clipsToBounds = true
                            self.aind.stopAnimating()
                        }
                        
                        do{ try data.write(to:self.urlLocalImage!.appendingPathComponent(name),options: .atomic)
                            }catch{
                                print("Error en la descarga de la imagen")
                            }
                        
                    }
                }
                task.resume()
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
        }
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
