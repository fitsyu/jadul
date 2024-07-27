//
//  HailingViewController.swift
//  Jadul
//
//  Created by Fitsyu  on 27/07/24.
//

import UIKit

class HailingViewController: UIViewController {
    
    @IBOutlet weak var hailingView: UIView!
    
    @IBAction func stopTapped() {
        dismiss(animated: true)
    }
}
