//
//  LevelsViewController.swift
//  Leovegas
//
//  Created by Valados on 23.07.2022.
//

import UIKit

class ShopViewController: BaseViewController {
    
    @IBOutlet weak var shopCollectionView: UICollectionView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var ballsButton: UIButton!
    @IBOutlet weak var portalsButton: UIButton!
    @IBOutlet weak var coinsLabel: UILabel!
    
    lazy var bgView: UIView = {
        let bgView: UIView = .init(frame: .init(origin: .zero, size: view.frame.size))
        bgView.backgroundColor = .black
        bgView.alpha = 0.5
        return bgView
    }()
    
    lazy var alertView: UIView = {
        let alertView: UIView = .init(frame: .init(origin: .init(x: view.frame.midX - 150 ,
                                                                 y: view.frame.midY - 100),
                                                   size: .init(width: 300,
                                                               height: 200)))
        alertView.backgroundColor = .init(red: 38 / 255.0,
                                          green: 43 / 255.0,
                                          blue: 167 / 255.0,
                                          alpha: 1)
        alertView.layer.cornerRadius = 20
        return alertView
    }()
    
    lazy var buyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white
        label.font = .init(name: GameFont, size: 50)
        label.frame = .init(origin: .init(x: view.frame.midX - 75,
                                          y: view.frame.midY - 75),
                            size: .init(width:100,
                                        height: 55) )
        return label
    }()
    
    lazy var coinImage: UIImageView = {
        let img = UIImageView(image: UIImage.init(named: "coin"))
        img.frame = .init(origin: .init(x: view.frame.midX + 25,
                                        y: view.frame.midY - 75),
                          size: .init(width:55,
                                      height: 55) )
        return img
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton(frame: .init(origin: .init(x:view.frame.midX - 125,
                                                      y:view.frame.midY + 25),
                                        size: .init(width:100,
                                                    height: 50)))
        btn.setBackgroundImage(UIImage.init(named: "cancel_button") , for: .normal)
        btn.setTitle(" ", for: .normal)
        btn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var confirmButton: UIButton = {
        let btn = UIButton(frame: .init(origin: .init(x:view.frame.midX + 25,
                                                      y:view.frame.midY + 25),
                                        size: .init(width:100,
                                                    height: 50)))
        btn.setBackgroundImage(UIImage.init(named: "buy_button") , for: .normal)
        btn.setTitle(" ", for: .normal)
        btn.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    var isBallsSelected: Bool = true
    var buyBall:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopCollectionView.delegate = self
        shopCollectionView.dataSource = self
        shopCollectionView.backgroundColor = .clear
        
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        ballsButton.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
        portalsButton.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
        
        ballsButton.setBackgroundImage(.init(named: "balls_selected"), for: .normal)
        portalsButton.setBackgroundImage(.init(named: "portals"), for: .normal)
        
        coinsLabel.text = String.init(describing: Shop.shared.coins)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shopCollectionView.reloadData()
    }
    
    @objc func segmentSelected(_ sender: UIButton) {
        if sender == ballsButton {
            isBallsSelected = true
            ballsButton.setBackgroundImage(.init(named: "balls_selected"), for: .normal)
            portalsButton.setBackgroundImage(.init(named: "portals"), for: .normal)
        } else if sender == portalsButton {
            isBallsSelected = false
            ballsButton.setBackgroundImage(.init(named: "balls"), for: .normal)
            portalsButton.setBackgroundImage(.init(named: "portals_selected"), for: .normal)
        }
        shopCollectionView.reloadData()
    }
    
    @objc func homeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonTapped() {
       removeViews()
    }
    
    func removeViews() {
        bgView.removeFromSuperview()
        alertView.removeFromSuperview()
        buyLabel.removeFromSuperview()
        cancelButton.removeFromSuperview()
        confirmButton.removeFromSuperview()
        coinImage.removeFromSuperview()
    }
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        if buyBall {
            guard Shop.shared.coins > Shop.shared.ballSkins[sender.tag].price else { return }
            Shop.shared.buyBall(at: sender.tag)
            Shop.shared.coins -=  Shop.shared.ballSkins[sender.tag].price
        } else {
            guard Shop.shared.coins > Shop.shared.portalSkins[sender.tag].price else { return }
            Shop.shared.buyPortal(at: sender.tag)
            Shop.shared.coins -=  Shop.shared.portalSkins[sender.tag].price
        }
        
        coinsLabel.text = String.init(describing: Shop.shared.coins)
        removeViews()
        shopCollectionView.reloadData()
    }
    
}
extension ShopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension ShopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isBallsSelected {
            return 4
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shopCollectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        cell.shopDelegate = self
        cell.configureCell(index: indexPath.row, isBall: isBallsSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: shopCollectionView.frame.height * 0.05,
                     left: shopCollectionView.frame.width * 0.05,
                     bottom: 0,
                     right: shopCollectionView.frame.width * 0.05)
    }
    
}
extension ShopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: shopCollectionView.frame.width * 0.4,
                     height: shopCollectionView.frame.width * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension ShopViewController: ShopDelegate {
    func selectSkin(at position: Int, isBall: Bool) {
        if isBall {
            Shop.shared.ball = position
        } else {
            Shop.shared.portal = position
        }
        shopCollectionView.reloadData()
    }
    
    func buySkin(at position: Int, isBall: Bool) {
        buyBall = isBall
        showAllert(position: position)
    }
    
    
    func showAllert(position: Int) {
        buyLabel.text = "\(Shop.shared.portalSkins[position].price)"
        confirmButton.tag = position
        view.addSubview(bgView)
        view.addSubview(alertView)
        view.addSubview(buyLabel)
        view.addSubview(cancelButton)
        view.addSubview(confirmButton)
        view.addSubview(coinImage)
    }
    
    
    
}
