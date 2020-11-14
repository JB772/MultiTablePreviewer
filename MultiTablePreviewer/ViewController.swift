
import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    var selectImages = [UIImage]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func selectPhoto2NextPage(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        //設定只能選擇照片
        configuration.filter = .images
        //設定可以選擇的數量上限，== 0是無限
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
}

extension ViewController: PHPickerViewControllerDelegate{
    
    //didFinishPicking表示選完照片後的function
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //關閉PHPickerViewController
        picker.dismiss(animated: true, completion: nil)
        //存照片前先將該陣列清空，否則程式沒有重啟，陣列會越存越多
        self.selectImages.removeAll()
        //將選擇的照片從型別為PHPickerResult的results中讀出來，因為可能是多張照片，所以是array
        let itemProviders = results.map(\.itemProvider)
        //for (i, itemProvider)表示在itemProviders中是第i個itemProvider的概念，條件是.canLoadObject(ofClass: UIImage.self)才計算
        for (i, itemProvider) in itemProviders.enumerated() where itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    
                    //需在主執行緒中執行存圖片及開啟前往下一頁的動作
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage else{
                            print("image is nil")
                            return }
                        self.selectImages.append(image)
                        //設定條件讓進入下一頁只執行一次，而不是一張圖就pushViewController一次
                        if self.selectImages.count == itemProviders.count {
                            let multiTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MultiViewController") as? MultiViewController
                            multiTableVC?.images = self.selectImages
                            self.navigationController?.pushViewController(multiTableVC!, animated: true)
                        }
                    }
                }
        }
    }
}

