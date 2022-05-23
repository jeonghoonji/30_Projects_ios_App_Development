//
//  ContentCollectionView.swift
//  NetflixStyleSampleApp
//
//  Created by 지정훈 on 2022/05/22.
//



//basic을 구성하는 뷰

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell{
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
