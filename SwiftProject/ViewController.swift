//
//  ViewController.swift
//  SwiftProject
//
//  Created by Miguel Angel Jimenez Melendez & Francisco Lara López on 4/23/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    var correo : String = ""
        
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    
    var Reportes = [Reporte]()
    let dataJsonUrlClass = JsonClass()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteLogin.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            alerta(title: "Error", message: "No se puede acceder a la base de datos")
            return
        }else {
            let tableusuario = "Create Table If Not Exists Usuario(foto Text, nombre Text, email Text Primary Key, fechaN text, sexo text, telefono Text)"
            if sqlite3_exec(db, tableusuario, nil, nil, nil) != SQLITE_OK {
                alerta(title: "Error", message: "No se creo Tabla usuairo")
                return
            }
        }
                let sentencia = "Select email From Usuario"
                if sqlite3_prepare(db, sentencia, -1, &stmt, nil) != SQLITE_OK {
                    let error = String(cString: sqlite3_errmsg(db))
                    alerta(title: "Error", message: "Error \(error)")
                    return
                }
                
                if sqlite3_step(stmt) == SQLITE_ROW {
                    let nombre = String(cString: sqlite3_column_text(stmt, 0))
                    if nombre != "" {
                        alerta(title: "Hola", message: "Bienvenido \(nombre)")
                        correo = nombre
                        
                        
                }else {
                        self.performSegue(withIdentifier: "segueRegistro", sender: self)
                       }
                }else {
                   
                        self.performSegue(withIdentifier: "segueRegistro", sender: self)
                }
        
    }

    @IBAction func btnMapa(_ sender: Any) {
        self.performSegue(withIdentifier: "segueMapa", sender: self)
    }
    @IBAction func btnExperiencia(_ sender: Any) {
        self.performSegue(withIdentifier: "segueExperiencia", sender: self)
    }
    @IBAction func btnLista(_ sender: Any) {
        
        Reportes.removeAll()
                          
                          let datos_a_enviar = ["corrUsr": correo] as NSMutableDictionary
                          
                          //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                          
                          dataJsonUrlClass.arrayFromJson(url:"WebServices&SQL/getReportesUsr.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                              
                              DispatchQueue.main.async {//proceso principal
                                  
                                  /*
                                   recibimos un array de tipo:
                                   (
                                       [0] => Array
                                       (
                                           [success] => 200
                                           [message] => Producto encontrado
                                           [idProd] => 1
                                           [nomProd] => Desarmador plus
                                           [existencia] => 10
                                           [precio] => 80
                                       )
                                   )
                                   object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                                 
                                             
                                   */
                                  let cuenta = array_respuesta?.count
                                  
                                  for indice in stride(from: 0, to: cuenta!, by: 1){
                                      let report = array_respuesta?.object(at: indice) as! NSDictionary
                                      let idreporte = report.object(forKey: "idreporte") as! String?
                                      let ubicacion = report.object(forKey: "ubicacion") as! String?
                                      let latitud = report.object(forKey: "latitud") as! String?
                                      let longitud = report.object(forKey: "longitud") as! String?
                                      let fecha = report.object(forKey: "fecha") as! String?
                                      let descripcion = report.object(forKey: "descripcion") as! String?
                                      let titulo = report.object(forKey: "Titulo") as! String?
                                      let puntuacion = report.object(forKey: "puntuacion") as! String?
                                      self.Reportes.append(Reporte(idrep: idreporte, ubi: ubicacion, lat: latitud,long: longitud,fecha: fecha,descrip: descripcion,titulo: titulo,puntuacion: puntuacion))
                                  }
                                self.performSegue(withIdentifier: "segueLista", sender: self)
                               
                           }
                   }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMapa"{
            let seguex = segue.destination as! ViewControllerMapa
        }
        else if segue.identifier == "segueExperiencia"{
            let seguex = segue.destination as! ViewControllerExperiencia
            seguex.correoU = correo
        }
        else if segue.identifier == "segueLista"{
            let seguex = segue.destination as! TableViewControllerExp
            seguex.reportes = Reportes
                        
        }
        else if segue.identifier == "segueRegistro" {
            let seguex = segue.destination as! ViewControllerRegistro
        }
    }
    
    func alerta (title: String, message: String){
        //Crea una alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Agrega un boton
        alert.addAction(UIAlertAction(title: "Aceptar",style: UIAlertAction.Style.default, handler: nil))
        //Muestra la alerta
        self.present(alert, animated: true, completion: nil)
    }

}

