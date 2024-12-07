//
//  CrimeViewController.swift
//  DAMII_T2_OcampoWilmer
//
//  Created by Wilmer Ocampo on 7/12/24.
//

import UIKit

class CrimeViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var crimeTableView: UITableView!
    
    var crimeList: [CrimeEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crimeTableView.dataSource = self
        findAllData()
    }

    @IBAction func add(_ sender: Any) {
        self.showCrimeAlert()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crimeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crimeCell", for: indexPath) as! CrimeTableViewCell
        
        let crime = crimeList[indexPath.row]
        
        cell.cityLabel.text = "CIUDAD: \(crime.city ?? "")"
        cell.departmentLabel.text = "DEPARTAMENTO: \(crime.department ?? "")"
        cell.crimeLabel.text = "DELITO: \(crime.crime ?? "")"
        cell.descriptionLabel.text = "DESCRIPCION: \(crime.descrip ?? "")"
      
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: crime.datetime ?? Date())
        cell.dateLabel.text = "FECHA: \(dateString)"
        
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: crime.datetime ?? Date())
        cell.timeLabel.text = "HORA: \(timeString)"
        
        return cell
    }
    
}

extension CrimeViewController{
    func showCrimeAlert(){
        var crimeText = UITextField()
        var descripText = UITextField()
        var cityText = UITextField()
        var departmentText = UITextField()
        
        let alert = UIAlertController(title: "Registrar Delito", message: "Los datos se guardaran en el telefono", preferredStyle: .alert)
        
        alert.addTextField() { text in
            text.placeholder = "Delito"
            crimeText = text
        }
        alert.addTextField() { text in
            text.placeholder = "Descripcion"
            descripText = text
        }
        alert.addTextField() { text in
            text.placeholder = "Ciudad"
            cityText = text
        }
        alert.addTextField() { text in
            text.placeholder = "Departamento"
            departmentText = text
        }
        
        let action = UIAlertAction(title: "Registrar", style: .default, handler: { _ in
            let crime = crimeText.text!
            let descrip = descripText.text!
            let city = cityText.text!
            let department = departmentText.text!
            self.registerData(crime: crime, descrip: descrip, city: city, department: department)
        })
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}

extension CrimeViewController {
    func registerData(crime: String, descrip: String, city: String, department: String){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistenceContainer.viewContext
        
        let entity = CrimeEntity(context: context)
        entity.crime = crime
        entity.descrip = descrip
        entity.city = city
        entity.department = department
        entity.datetime = Date()
        
        do {
            try context.save()
            self.crimeList.append(entity)
        } catch let error as NSError {
            print(error)
        }
        self.crimeTableView.reloadData()
    }
    
    func findAllData(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistenceContainer.viewContext
        
        do {
            let crimes = try context.fetch(CrimeEntity.fetchRequest())
            self.crimeList = crimes
        } catch let error as NSError {
            print(error)
        }
        self.crimeTableView.reloadData()
    }
}
