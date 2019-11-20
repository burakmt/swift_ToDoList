//
//  AddToDoController.swift
//  toDoList
//
//  Created by Bera on 20.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit
import CoreData

class AddToDoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Herhangi bir objeye tıklanabilirlik özelliği vermek istiyorsak GestureRecognizer oluşturmamız gerekiyor
        let gestureHandler = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //Oluşturduğumuz recognizer'ı herhangi bir objeye eklemek için addGestureRecognizer dememiz gerekiyor
        view.addGestureRecognizer(gestureHandler)
        
        //Oluşturduğumuz ImageView'a tıklanabilir özelliğini aktif ediyoruz ve recognizer ekliyoruz.
        image.isUserInteractionEnabled = true
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickerFunc))
        image.addGestureRecognizer(imageRecognizer)
    }
    
    @objc func pickerFunc(){
        //Yeni bir image picker oluşturuyoruz
        let picker = UIImagePickerController()
        picker.delegate = self
        //Picker'ın sourceType özelliği resimi nereden çekeceğini belirtmemize yarıyor. Kamera'dan direkt fotoğraf çekimide yaptırabiliyoruz.
        picker.sourceType = .photoLibrary
        //Seçilen veya çekilen resmin düzenlenebilirliğini aktif hale getiriyoruz.
        picker.allowsEditing = true
        //Resim seçme penceresini ekranda göstermemiz için present fonksiyonunu kullanamamız gerekiyor.
        present(picker, animated: true, completion: nil)
    }
    
    //Picker'dan seçilen resmin seçildikten sonra ne olacağını belirtmemize yarıyan fonksiyon
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Resmin hangi türde seçmek istediğimizi belirtiyoruz. Orjinal halimi yoksa editlenmiş hali mi vs..
        image.image = info[.originalImage] as? UIImage
        //Tüm işlemler bittikten sonra picker penceresini kapatıyoruz.
        self.dismiss(animated: true, completion: nil)
    }
    @objc func hideKeyboard(){
        //Klavye açık ise düzenlemeyi kapat diyoruz.
        view.endEditing(true)
    }
    @IBAction func saveClicked(_ sender: Any) {
        //AppDelegate.swift dosyasına erişim sağlıyoruz.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Verileri ekleyeceğimiz CoreData'daki entity'i belirtiyoruz.
        let newToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDoList", into: context)
        
        //Seçtiğimiz entity içerisinde ki coloum'lara eklemeler yapıyoruz.
        newToDo.setValue(UUID(), forKey: "id")
        newToDo.setValue(titleText.text!, forKey: "title")
        newToDo.setValue(contentText.text!, forKey: "content")
        newToDo.setValue(Date(), forKey: "date")
        
        //ImageView'da ki resmi binary tipine dönüştürüp sıkıştırma kalitesini belirtiyoruz.
        let imageData = image.image?.jpegData(compressionQuality: 0.5)
        newToDo.setValue(imageData, forKey: "image")
        
        //Veri tabanına kayıt işlemi esnasında kesinlikle try - catch içerisine almamız gerekiyor
        do{
            try context.save()
            //Notification fonksiyonu başka bir viewController'a bir bildirim göndermek için kullanılıyor.
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        catch{
            print("Error")
        }
    }
}
