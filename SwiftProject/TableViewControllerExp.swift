//
//  TableViewControllerExp.swift
//  SwiftProject
//
//  Created by Francisco on 07/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit

class TableViewControllerExp: UITableViewController {
    
    @IBOutlet var tabla: UITableView!
    
    var reportes = [Reporte]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reportes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda") as! TableViewCellExp
        let repo : Reporte
        repo = reportes[indexPath.row]
        cell.fecha.text = repo.fecha
        cell.numReporte.text = "No. Reporte: \(String(repo.idreporte!))"
        cell.titulo.text = repo.titulo


        return cell
    }


}
