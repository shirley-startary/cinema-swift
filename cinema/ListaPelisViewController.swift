//
//  ViewController.swift
//  cinema
//
//  Created by Silvana on 10/29/19.
//  Copyright © 2019 laboratoria. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI

class ListaPelisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet var TablaCartelera: UITableView!
    
    var contenidoCeldas = [Pelicula]()
    var ref: DocumentReference!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()

        TablaCartelera.dataSource = self
        TablaCartelera.delegate = self
        getPelis()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contenidoCeldas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell()
            
//        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath);
        celda.textLabel?.text = contenidoCeldas[indexPath.row].nombre
        celda.detailTextLabel?.text = contenidoCeldas[indexPath.row].sinopsis
        let imageUrl = URL(string: contenidoCeldas[indexPath.row].image)!
        let placeholder = UIImage(named: "imagespeli")

        celda.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.gray

        celda.imageView?.sd_setImage(with: imageUrl) { (image, error, cache, urls) in
            if (error != nil) {
                // Failed to load image
                celda.imageView!.image = placeholder
            } else {
                // Successful in loading image
                celda.imageView!.image = image!
//                print(urls)
            }
        }

        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let idPDFSeleccionado = indexPath.row
        print(idPDFSeleccionado)
//        self.performSegue(withIdentifier: "patallaDosSegue", sender: idPDFSeleccionado)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsPeliViewController" {
            //let idPDFSeleccionadoRecibido = sender as! Int

        }
    }
    
    func getPelis(){
        db.collection("peliculas").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.contenidoCeldas.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let id = document.documentID
                    let values  = document.data()
                    let nombre =  values["nombre"] as? String ?? "Sin valor"
                    let sinopsis = values["sinopsis"] as? String ?? "Sin Dato"
                    let image = values["image"] as? String ?? "Sin Dato"

                    
                    let peliculas =  Pelicula(nombre: nombre, sinopsis: sinopsis, image: image, id: id)
                    
                    self.contenidoCeldas.append(peliculas)
                }
                 self.TablaCartelera.reloadData()
            }
        }
        self.TablaCartelera.reloadData()

    }

}

