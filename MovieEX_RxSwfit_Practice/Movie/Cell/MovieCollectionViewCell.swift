//
//  MovieCollectionViewCell.swift
//  MovieEX_RxSwfit_Practice
//
//  Created by YJ on 8/8/24.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure() {
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
    }
}
