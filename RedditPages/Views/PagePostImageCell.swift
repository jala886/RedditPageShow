//
//  PagePostImageCell.swift
//  RedditPages
//
//  Created by jianli on 4/2/22.
//

import UIKit

class PagePostImageCell: PagePostCell{
    override class var identifer:String{"PagePostImageViewCell"}
    
    var imagePostView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override internal func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(imagePostView)
        contentView.addSubview(bottomView)
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
        titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant:10),
        titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant:-10),
        
        imagePostView.heightAnchor.constraint(equalToConstant: tableViewCellImageHeight),
        //imagePostView.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant:labelHeight),
        imagePostView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant:-10),
        imagePostView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant:10),
        imagePostView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant:-tableViewCellBottomHeight/2),
        
        bottomView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant:-tableViewCellBottomHeight/2+5),
        bottomView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
        bottomView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
        ])

    }
    func configure(data postModel:PostModel,imageView uiimage: UIImage){
        super.configure(data: postModel)
        imagePostView.image = uiimage
    }
}
