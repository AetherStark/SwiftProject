//
//  ViewControllerMapa.swift
//  SwiftProject
//
//  Created by Francisco on 07/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit


class ViewControllerMapa: UIViewController, CLLocationManagerDelegate {
    
    var ubicacion : String = ""
    var latitud: String = ""
    var longitud: String = ""
    
    var Reportes = [Reporte]()
    
    let dataJsonUrlClass = JsonClass()
    
    let locationManager:CLLocationManager = CLLocationManager()
             
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
               locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()
               locationManager.startUpdatingLocation()

               
        Reportes.removeAll()
               let datos_a_enviar = ["id": ""] as NSMutableDictionary

               
               dataJsonUrlClass.arrayFromJson(url:"WebServices&SQL/getReportes.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                   
                   DispatchQueue.main.async {
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
                    
                }
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for currentLocation in locations {
            ubicacion = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
            latitud = "\(currentLocation.coordinate.latitude)"
            longitud = "\(currentLocation.coordinate.longitude)"
           
        }
        let camera = GMSCameraPosition.camera(withLatitude: Double(Double(latitud)!), longitude: Double(Double(longitud)!), zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        
        for repor in Reportes {
                 let marker = GMSMarker()
            var lati = repor.latitud!
            var longi = repor.longitud!
            var titulo = repor.titulo
            var fecha = repor.fecha
            
            
            marker.position = CLLocationCoordinate2D(latitude: Double(Double(lati)!), longitude: Double(Double(longi)!))
            marker.title = titulo
            marker.snippet = fecha
            marker.map = mapView
            
            print(marker.position)
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
