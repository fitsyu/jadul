//
//  HailingViewController.swift
//  Jadul
//
//  Created by Fitsyu  on 27/07/24.
//

import Lottie
import UIKit

class HailingViewController: UIViewController {
    
    @IBOutlet weak var hailerView: UIView!
    
    var lottieView: LottieAnimationView?

    
    @IBAction func stopTapped() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottieView = .init(name: "hail")
        lottieView?.contentMode = .scaleAspectFit
        lottieView?.loopMode = .loop
        lottieView?.frame = hailerView.bounds
        lottieView?.play()
        
        self.hailerView.addSubview(lottieView!)
    }
}
