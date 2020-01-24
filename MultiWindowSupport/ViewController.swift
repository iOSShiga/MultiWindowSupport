//A12n3u4p5a6m7C8h9u9n2g1
//  ViewController.swift
//  MultiWindowSupport
//
//  Created by Suresh Shiga on 23/01/20.
//  Copyright © 2020 Suresh Shiga. All rights reserved.
//

import UIKit

enum Filters: String, CaseIterable {
   case process = "CIPhotoEffectProcess"
    case noir = "CIPhotoEffectNoir"
    case chrome = "CIPhotoEffectChrome"
    case transfer =  "CIPhotoEffectTransfer"
    case clear =  "clear"
}

class ViewController: UIViewController {
    
    let VCActivityType = "VCKey"
    var photo: UIImageView?
    var currentImage: UIImage?
    var marginConstant: CGFloat = 40
    var stackView: UIStackView?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNavigationBar()
        setupStackView()
        setupImageView()
        
            }

    
    private func setupImageView() {
        photo = UIImageView(frame: .zero)
        photo?.backgroundColor = .red
        photo?.translatesAutoresizingMaskIntoConstraints = false
        
        photo?.image = UIImage(named: "spiderman")
        currentImage = photo?.image
        photo?.contentMode = .scaleAspectFit
        
        photo?.isUserInteractionEnabled = true
        photo?.addInteraction(UIDragInteraction(delegate: self))
        
        view.addSubview(photo!)
        
        NSLayoutConstraint.activate([
            photo!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: marginConstant),
            photo!.bottomAnchor.constraint(equalTo: self.stackView!.topAnchor, constant: -marginConstant),
            photo!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: marginConstant),
            photo!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -marginConstant),
            
        ])
    }
    
    @objc func addScreen() {
        let activity = NSUserActivity(activityType: VCActivityType)
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
    }
    
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        stackView?.backgroundColor = .blue
        
        
        for filter in Filters.allCases {
            let button = UIButton(type: .roundedRect)
            button.setTitle(filter.rawValue.replacingOccurrences(of: "CIPHotoEffect", with: ""), for: .normal)
            stackView?.addArrangedSubview(button)
            button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        }
        
        view.addSubview(stackView!)
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -marginConstant/2),
            stackView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView!.heightAnchor.constraint(equalToConstant: marginConstant),
        ])
    }
    
    
    @objc func onButtonClick(sender: UIButton) {
        photo?.image = currentImage
        let value = sender.titleLabel?.text ?? ""
        for filter in Filters.allCases {
            if filter.rawValue.contains(value) {
                if value != "clear" {
                    photo?.image = photo?.image?.addFilter(filter: filter)
                }
            }
        }
    }
    
    private func setNavigationBar() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScreen))
        navigationItem.title = "Multi Window Part 1"
        navigationItem.rightBarButtonItems = [add]
        navigationItem.leftBarButtonItem = nil
        
    }

}



extension ViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let imageView = interaction.view as? UIImageView {
            guard let image = imageView.image else { return []}
            let provider = NSItemProvider(object: image)
            let userActivity = NSUserActivity(activityType: VCActivityType)
            provider.registerObject(userActivity, visibility: .all)
            let item = UIDragItem(itemProvider: provider)
            return [item]
        }
        return []
    }
}



extension UIImage {
    func addFilter(filter: Filters) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        return UIImage(cgImage: cgImage!)
    }
}

