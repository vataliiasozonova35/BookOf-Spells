//
//  LevelCollectionViewCell.swift
//  Leovegas
//
//  Created by Valados on 23.07.2022.
//

import UIKit

protocol ShopDelegate: AnyObject {
    func selectSkin(at position: Int, isBall: Bool)
    func buySkin(at position: Int, isBall: Bool)
}

class ItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ItemCollectionViewCell"
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var coinImage: UIImageView!
    weak var shopDelegate: ShopDelegate?
    var skin: Skin!
    var isBall: Bool!
    
    private let shop = Shop.shared
    
    func configureCell(index: Int, isBall: Bool) {
      
        self.isBall = isBall
        if isBall {
            print(Shop.shared.isBoughtBall(at: index))
        } else {
            print(Shop.shared.isBoughtPortal(at: index))
        }
        if self.isBall {
            skin = shop.ballSkins[index]
            if shop.ball == skin.position {
                configureBackgroundLayer(borderColor: .yellow)
            } else {
                configureBackgroundLayer(borderColor: .clear)
            }
            if shop.isBoughtBall(at: index) {
                priceLabel.isHidden = true
                coinImage.isHidden = true
            } else {
                priceLabel.isHidden = false
                coinImage.isHidden = false
            }
        } else {
            skin = shop.portalSkins[index]
            if shop.portal == skin.position {
                configureBackgroundLayer(borderColor: .yellow)
            } else {
                configureBackgroundLayer(borderColor: .clear)
            }
            if shop.isBoughtPortal(at: index) {
                priceLabel.isHidden = true
                coinImage.isHidden = true
            } else {
                priceLabel.isHidden = false
                coinImage.isHidden = false
            }
        }
        
        priceLabel.text = String.init(describing: skin.price)
        itemImage.image = .init(named: skin.name)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGesture)
        setConstraints()
    }
    
    func configureBackgroundLayer(borderColor: UIColor) {
        backgroundColor = .init(red: 164 / 255.0,
                                green: 250 / 255.0,
                                blue: 255 / 255.0,
                                alpha: 0.1)
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 5
        
        layer.cornerRadius = frame.width / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
    
    @objc func tapped() {
        if isBall {
            if shop.isBoughtBall(at: skin.position) {
                shopDelegate?.selectSkin(at: skin.position, isBall: isBall)
            } else {
                shopDelegate?.buySkin(at: skin.position, isBall: isBall)
            }
        } else {
            if shop.isBoughtPortal(at: skin.position) {
                shopDelegate?.selectSkin(at: skin.position, isBall: isBall)
            } else {
                shopDelegate?.buySkin(at: skin.position, isBall: isBall)
            }
        }
    }
    
    func setConstraints() {
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        let widthAnchor = itemImage.widthAnchor.constraint(equalToConstant: frame.width * 0.6)
        let heightAnchor = itemImage.heightAnchor.constraint(equalToConstant: frame.width * 0.6)
        
        NSLayoutConstraint.activate([widthAnchor,heightAnchor])
    }
}
