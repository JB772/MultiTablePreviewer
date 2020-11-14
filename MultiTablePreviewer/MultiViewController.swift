

import UIKit

class MultiViewController: UIViewController {
    
    @IBOutlet weak var scrollControl: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    var backgroundImage : UIImage?
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollControl.delegate = self
        
        guard self.images.count > 0 else {
            print("images count is \(images.count)")
            return
        }
        
        for i in 1...(images.count) {
            print("i :\(i)")
            if let array = Bundle.main.loadNibNamed("ZoomViewController", owner: nil, options: nil),
               let backgroundView = array.first as? ZoomView{
                
                stackView.addArrangedSubview(backgroundView)
                if i == 1 {
                    backgroundView.widthAnchor.constraint(equalTo: scrollControl.frameLayoutGuide.widthAnchor).isActive = true 
                }
                backgroundView.zoomImageView.image = images[i-1]
                backgroundView.zoomScrollControl.delegate = self
                backgroundView.zoomScrollControl.maximumZoomScale = 5
                backgroundView.zoomScrollControl.minimumZoomScale = 1
                backgroundView.zoomScrollControl.zoomScale = 1
            }
        }

    }
    
}

extension MultiViewController: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for pageView in scrollView.subviews{
            if pageView.isKind(of: UIView.self) {
                return pageView
            }
        }
        return nil
    }

}


