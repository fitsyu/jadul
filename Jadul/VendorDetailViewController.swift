//
//  VendorDetailViewController.swift
//  Jadul
//
//  Created by Fitsyu  on 27/07/24.
//

import UIKit
import AVFoundation

struct VendorDetailViewModel {
    let name: String
    let audio: URL
    let image: URL?
    let items: [(name: String, price: String)]
}

class VendorDetailViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ctaButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    var model: VendorDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setModel(model: VendorDetailViewModel) {
        self.model = model
        label.text = model.name
        tableView.reloadData()
        contentView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height).isActive = true
    }
    
    @IBAction func ctaDidTap() {
        let hailingVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HVC")
        self.present(hailingVc, animated: true)
    }
    
    private var player: AVPlayer?
    
    @IBAction func audioDidTap() {
        guard let audio = model?.audio else { return }
        
        let item = AVPlayerItem(url: audio)
        self.player = AVPlayer(playerItem: item)
        player?.play()
    }
}

extension VendorDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = model?.items[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = item.name
        cell.priceLabel.text = item.price
        
        return cell
    }
}


class ItemCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            nameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.4),
            
            priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            priceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
        ])
    }
}
