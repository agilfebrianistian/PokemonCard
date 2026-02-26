//
//  TypesSectionView.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 26/02/26.
//

import UIKit

final class TypesSectionView: UIView {
    
    private let stackView = UIStackView()
    
    init(types: [String]) {
        super.init(frame: .zero)
        setupUI()
        configure(types: types)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(types: [String]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        types.forEach {
            stackView.addArrangedSubview(makeBadge($0))
        }
    }
    
    private func makeBadge(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        
        let container = UIView()
        container.backgroundColor = colorForType(text)
        container.layer.cornerRadius = 12
        
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
        
        return container
    }
    
    private func colorForType(_ type: String) -> UIColor {
        switch type.lowercased() {
        case "fire": return .systemRed
        case "water": return .systemBlue
        case "grass": return .systemGreen
        case "lightning": return .systemYellow
        case "psychic": return .systemPurple
        default: return .systemGray
        }
    }
}
