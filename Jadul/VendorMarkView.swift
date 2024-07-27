//
//  VendorMarkView.swift
//  Jadul
//
//  Created by Fitsyu  on 27/07/24.
//

import MapKit
import UIKit

class VendorMarkView: MKAnnotationView {
    
    let bubbleView = UIView()
    let label =  UILabel()
    let imageView = UIImageView()
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 70),
            view.widthAnchor.constraint(equalToConstant: 80),
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.backgroundColor = .systemYellow
        bubbleView.layer.cornerRadius = 8
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.image
        
        view.addSubview(bubbleView)
        bubbleView.addSubview(label)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            bubbleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bubbleView.topAnchor.constraint(equalTo: view.topAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bubbleView.heightAnchor.constraint(equalToConstant: 20),
            
            label.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 2),
            label.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 2),
            label.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -2),
            label.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -2),
            
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override var image: UIImage? {
        get {
            self.imageView.image
        }
        
        set {
            self.imageView.image = newValue
        }
    }
    
    func setMessage(msg: String?) {
        self.label.text = msg
    }
}
