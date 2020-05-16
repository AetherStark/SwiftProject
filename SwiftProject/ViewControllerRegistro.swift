//
//  ViewControllerRegistro.swift
//  SwiftProject
//
//  Created by Francisco on 07/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3

class ViewControllerRegistro: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBOutlet weak var imagenUsr: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtFechaN: UITextField!
    @IBOutlet weak var txtSexo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    
    let imagePicker = UIImagePickerController()
    var infoIMG: String = ""
    
    let dataJsonUrlClass = JsonClass()
    
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

         let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteLogin.sqlite")
               if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
                   alerta(title: "Error", message: "No se puede acceder a la base de datos")
                   return
               }else {
                   let tableusuario = "Create Table If Not Exists Usuario(foto Text, nombre Text, email Text Primary Key, fechaN text, sexo text, telefono Text)"
                   if sqlite3_exec(db, tableusuario, nil, nil, nil) != SQLITE_OK {
                       alerta(title: "Error", message: "No se creo Tabla Usuairo")
                       return
                }
            }
    }
    
    @IBAction func btnCargarCamara(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func btnCargarGaleria(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagenUsr?.image = img
        self.dismiss(animated: true, completion: nil)
        print(img)
        infoIMG = "\(img)"
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnGuardar(_ sender: Any) {
        if txtNombre.text!.isEmpty || txtFechaN.text!.isEmpty || txtCorreo.text!.isEmpty || txtSexo.text!.isEmpty || txtTelefono.text!.isEmpty
        || infoIMG.isEmpty{
            alerta(title: "Falta Informaciòn", message: "Complete el formulario")
            txtNombre.becomeFirstResponder()
        } else {
            
            let foto = infoIMG.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let nombre = txtNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let fecha = txtFechaN.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let correo = txtCorreo.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let sexo = txtSexo.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let telefono = txtTelefono.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let query = "Insert Into Usuario(foto,nombre,email,fechaN,sexo,telefono) Values(?, ?, ?, ?, ?, ?)"
            if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Error al ligar insert")
                return
            } else {
                if sqlite3_bind_text(stmt, 1, foto.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "foto")
                    return
                }
                if sqlite3_bind_text(stmt, 2, nombre.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "nombre ")
                    return
                }
                if sqlite3_bind_text(stmt, 3, correo.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "correo")
                    return
                }
                if sqlite3_bind_text(stmt, 4, fecha.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "fecha")
                    return
                }
                if sqlite3_bind_text(stmt, 5, sexo.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "sexo")
                    return
                }
                if sqlite3_bind_text(stmt, 6, telefono.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "telefono")
                    return
                }
                if sqlite3_step(stmt) != SQLITE_OK {
                    
                    print(fecha)
                     let datos_a_enviar = ["foto":foto,"nombre":nombre,"correo":correo,"fechaNac":fecha,"sexo":sexo,"telefono":telefono] as NSMutableDictionary
                    
                    dataJsonUrlClass.arrayFromJson(url:"WebServices&SQL/insertarUsuarios.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                        
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
                            
                            //self.imagenUsr.image =
                            self.txtNombre.text=""
                            self.txtCorreo.text=""
                            self.txtFechaN.text=""
                            self.txtSexo.text=""
                            self.txtTelefono.text=""
                        }
                    }
                    
                    
                    self.performSegue(withIdentifier: "segueInicio", sender: self)
                   /* var cont = 0
                    if cont < 1 {
                    alerta(title: "Lista muestra tus registros", message: "Antes de acceder a la lista interta un registro")
                    cont = cont + 1
                    }*/
                    
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "segueInicio" {
            
               _ = segue.destination as! ViewController
                
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
