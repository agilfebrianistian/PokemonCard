//
//  PokemonCardDetailViewController.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 06/02/26.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class PokemonCardDetailViewController: UIViewController {
    
    private let viewModel = PokemonCardDetailViewModel()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomSheetView: UIView!
    
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var informationScrollView: UIScrollView!
    
    private var sheetTopConstraint: NSLayoutConstraint!
    private var initialTopConstant: CGFloat = 0
    
    var pokemon:PokemonCardListResponse?
    
    private var rarityGradientLayer = CAGradientLayer()
    
    private lazy var activityIndicatorView: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(
            frame: .zero,
            type: .lineScalePulseOutRapid,
            color: .yellow
        )
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        title = pokemon?.name
        viewModel.fetchDetail(cardId: pokemon?.id ?? "")
        
        sheetTopConstraint = bottomSheetView.topAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -120
        )
        sheetTopConstraint.isActive = true
        
        bottomSheetView.layer.cornerRadius = 24
        bottomSheetView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        bottomSheetView.clipsToBounds = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        bottomSheetView.addGestureRecognizer(pan)
        
        setupRarityGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.frame = view.bounds
        rarityGradientLayer.frame = view.bounds
    }
    
    private func setupRarityGradient() {
        rarityGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        rarityGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        rarityGradientLayer.opacity = 0
        
        view.layer.insertSublayer(rarityGradientLayer, at: 0)
    }
    
    private func bindViewModel() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            isLoading ?  self?.activityIndicatorView.startAnimating() :  self?.activityIndicatorView.stopAnimating()
        }
        
        viewModel.onDataUpdated = { [weak self] in
            self?.updateUI()
        }
        
        viewModel.onShowAlert = { [weak self] error in
            self?.showAlert(title: "", message: error.message ?? "")
        }
    }
    
    private func updateUI() {
        
        let pokemon = viewModel.pokemon
        
        imageView.sd_setImage(with: URL(string: "\(pokemon?.image ?? "")/high.webp"),
                              placeholderImage: UIImage(named: "pokemonCardPlaceholder"))
        
        applyRarityBackground(pokemon?.rarity)
        populateStack()
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
            
        case .began:
            initialTopConstant = sheetTopConstraint.constant
            
        case .changed:
            let newConstant = initialTopConstant + translation.y
            
            let maxTop = -120
            let minTop = -view.frame.height + 120
            
            sheetTopConstraint.constant = min(max(newConstant, minTop), CGFloat(maxTop))
            
        case .ended:
            let velocity = gesture.velocity(in: view).y
            
            UIView.animate(withDuration: 0.3) {
                if velocity < -500 {
                    self.sheetTopConstraint.constant = -self.view.frame.height + 120
                } else {
                    self.sheetTopConstraint.constant = -120
                }
                self.view.layoutIfNeeded()
            }
            
        default:
            break
        }
    }
    
}

extension PokemonCardDetailViewController {
    
    private func populateStack() {
        
        let pokemon = viewModel.pokemon
        
        informationStackView.arrangedSubviews.forEach {
            informationStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        if let name = pokemon?.name, !name.isEmpty {
            let nameLabel = UILabel()
            nameLabel.text = name
            nameLabel.font = .boldSystemFont(ofSize: 22)
            nameLabel.numberOfLines = 0
            nameLabel.textAlignment = .center
            informationStackView.addArrangedSubview(nameLabel)
        }
        
        if let types = pokemon?.types, !types.isEmpty {
            informationStackView.addArrangedSubview(TypesSectionView(types: types))
        }
        
        if let illustrator = pokemon?.illustrator, !illustrator.isEmpty {
            informationStackView.addArrangedSubview(
                InfoRowView(title: "Illustrator", value: illustrator)
            )
        }
        
        if let rarity = pokemon?.rarity, !rarity.isEmpty {
            informationStackView.addArrangedSubview(
                InfoRowView(title: "Rarity", value: rarity)
            )
        }
    }
    
    private func applyRarityBackground(_ rarity: String?) {
        guard let rarity else {
            rarityGradientLayer.opacity = 0
            return
        }
        
        rarityGradientLayer.colors = gradientColors(for: rarity).map { $0.cgColor }
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 0.4
        animation.duration = 0.35
        
        rarityGradientLayer.opacity = 0.4
        rarityGradientLayer.add(animation, forKey: "fadeIn")
    }
    
    private func gradientColors(for rarity: String) -> [UIColor] {
        
        switch rarity.lowercased() {
            
        case "common":
            return [.systemGray6, .systemGray4]
            
        case "uncommon":
            return [
                UIColor.systemGreen.withAlphaComponent(0.8),
                UIColor.systemGreen.withAlphaComponent(0.3)
            ]
            
        case "rare":
            return [
                UIColor.systemBlue.withAlphaComponent(0.8),
                UIColor.systemIndigo.withAlphaComponent(0.4)
            ]
            
        case "holo rare":
            return [
                UIColor.systemPurple.withAlphaComponent(0.8),
                UIColor.systemPink.withAlphaComponent(0.4)
            ]
            
        case "ultra rare":
            return [
                UIColor.systemOrange.withAlphaComponent(0.9),
                UIColor.systemYellow.withAlphaComponent(0.5)
            ]
            
        default:
            return [.systemGray6, .systemGray4]
        }
    }
    
}
