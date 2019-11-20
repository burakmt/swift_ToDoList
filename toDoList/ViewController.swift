//
//  ViewController.swift
//  toDoList
//
//  Created by Bera on 20.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    override func viewWillAppear(_ animated: Bool) {
        //Gelen veri eğer geldiyse tekrardan getData fonksiyonunu çağırıyoruz.
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addClicked))
        
        // Main.storyboard'da bulunan TableView'a kaynağının bu controller dosyası olduğunu belirtiyoruz. !delegate ve datasource yazmadan çalışmıyor.
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    @objc func addClicked(){
        performSegue(withIdentifier: "addToDoVC", sender: nil)
    }
    @objc func getData(){
        //Verileri çekerken ekleme işleminden sonra tekrardan bu sayfaya geldiğinde verilerin klonlanmaması için önce boşaltma işlemi yapılıyor.
        titleArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        //AppDelegate.swift içerisinde bulunan Context'e ulaşabilmek için uyguladığımız fonksiyonlar
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Core Data'da hangi Entity'e ulaşıp ondan veri çekmek istediğimizi bu fonksiyon ile belirtiyoruz.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoList")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(fetchRequest)
            
            //Core Data'dan gelen veriler birer NSManagedObject tipine Cast edilip ondan sonra Key değerlerine göre Value değerlerini çekebiliriz.
            for item in result as! [NSManagedObject] {
                if let newTitle = item.value(forKey: "title") as? String {
                    self.titleArray.append(newTitle)
                }
                if let newID = item.value(forKey: "id") as? UUID {
                    self.idArray.append(newID)
                }
                //Yeni bir veri geldiğinde yenileme işlemi yapılıyor.
                self.tableView.reloadData()
            }
        }
        catch {
            print("Error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TableView'in içerisinde bulunan rowların içeriğini bir UITableViewCell objesi oluştururak içerisine dahil edebiliyoruz.
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TableView'in kaç tane row'dan oluşacağını söylüyoruz.
        return titleArray.count
    }
    
    
    
    
    
}
