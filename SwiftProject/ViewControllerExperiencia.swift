//
//  ViewControllerExperiencia.swift
//  SwiftProject
//
//  Created by Francisco on 07/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import CoreLocation

class ViewControllerExperiencia: UIViewController, CLLocationManagerDelegate{
    
    let dataJsonUrlClass = JsonClass()

    
    var ubicacion: String = ""
    var latitud: Double = 0.0
    var longitud: Double = 0.0
    let dateFormatter = DateFormatter()
    var fechaBDD: String = ""
    var correoU: String = ""
    
    
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblLati: UILabel!
    @IBOutlet weak var lblLong: UILabel!
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var txtPuntuacion: UITextField!
    @IBOutlet weak var lblcorreo: UILabel!
    @IBOutlet weak var txtNumreport: UITextField!
    
    
    
    let locationManager:CLLocationManager = CLLocationManager()
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyy hh:mm:ss")
        
        
        lblcorreo.text = correoU //Modificar y arreglar con el correo que se ingrese en el login
        
        alerta(title: "Precaucion", message: "Llene el campo de eliminar solo si conoce su numero de reporte y si desea borrarlo")

    }
    
    @IBAction func btnIngresar(_ sender: Any) {
        
        
        if  txtTitulo.text!.isEmpty || txtDescripcion.text!.isEmpty || txtPuntuacion.text!.isEmpty || lblcorreo.text!.isEmpty{
            
            alerta(title: "Validacion de Entrada", message:"Error faltan de ingresar datos")
            txtTitulo.becomeFirstResponder()
            return
        }
        else{
                
                let ubi = ubicacion
                let lati = lblLati.text
                let longi = lblLong.text
                let fecha = lblFecha.text
                let descripcion = txtDescripcion.text
                let titulo = txtTitulo.text
                let puntuacion = txtPuntuacion.text
                let correo = lblcorreo.text
                
            //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de va!lores
            let datos_a_enviar = ["ubicacion":ubi,"latitud":lati,"longitud":longi,"fecha":fecha,"descripcion":descripcion,"Titulo":titulo,"puntuacion":puntuacion,"correoUsr":correo] as NSMutableDictionary
                
                //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                
                dataJsonUrlClass.arrayFromJson(url:"WebServices&SQL/insertarReporte.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                    
                    DispatchQueue.main.async {//proceso principal
                        
                        /*
                         recibimos un array de tipo:
                         (
                             [0] => Array
                             (
                                 [success] => 200
                                 [message] => Producto Insertado
                             )
                         )
                         object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                         */
                        let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                        
                        //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                        if let msg = diccionario_datos.object(forKey: "message") as! String?{
                            self.alerta(title: "Guardando", message: msg)
                            
                            
                        }
                        
                        self.txtTitulo.text=""
                        self.txtDescripcion.text = ""
                        self.txtPuntuacion.text = "0"
                        
                    }
                }
        }// Fin del else
        
    }
    
    @IBAction func btnEliminar(_ sender: Any) {
        
        if txtNumreport.text!.isEmpty {
                alerta(title: "Validacion de Entrada", message:"Error faltan de ingresar datos")
                txtNumreport.becomeFirstResponder()
                          return
                      }
                      else{
                              let idrepor = txtNumreport.text!
                          
                              //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
                          let datos_a_enviar = ["idreporte":idrepor] as NSMutableDictionary
                              
                              //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                              
                              dataJsonUrlClass.arrayFromJson(url:"WebServices&SQL/eliminarReporte.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                                  
                                  DispatchQueue.main.async {//proceso principal
                                      
                                      /*
                                       recibimos un array de tipo:
                                       (
                                           [0] => Array
                                           (
                                               [success] => 200
                                               [message] => Producto Actualizado
                                           )
                                       )
                                       object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                                       */
                                      let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                                      
                                      //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                                      if let msg = diccionario_datos.object(forKey: "message") as! String?{
                                          self.alerta(title: "Eliminando", message:msg)
                                      }
                                      
                                      self.txtNumreport.text=""
                                      self.txtTitulo.text=""
                                      self.txtDescripcion.text = ""
                                      self.txtPuntuacion.text = "0"
                                      
                                  }
                              }
                      }// Fin del else

        
    }
    
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for currentLocation in locations {
            ubicacion = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
            latitud = (currentLocation.coordinate.latitude)
            longitud = (currentLocation.coordinate.longitude)
            var fecha: Date = currentLocation.timestamp
            fechaBDD = "\(dateFormatter.string(from: fecha))"
            print("\(currentLocation.timestamp)")
            
            print("\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)")
            
            lblLati.text = String(latitud)
            lblLong.text = String(longitud)
            lblFecha.text = "\(dateFormatter.string(from: fecha))"
                    print("\(dateFormatter.string(from: fecha))")
        }
        
    }

    
    
    func alerta(title: String, message: String){
        //Crea una alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Agrega un boton
        alert.addAction(UIAlertAction(title: "Aceptar",style: UIAlertAction.Style.default, handler: nil))
        //Muestra la alerta
        self.present(alert, animated: true, completion: nil)
    }
   
}


    

