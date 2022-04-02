//
//  CellBottomView.swift
//  RedditPages
//
//  Created by jianli on 4/2/22.
//

import UIKit

class CellBottomView:UIView{
    
    var favorUpIcon:UIImageView = UIImageView(image:UIImage(systemName:"hand.thumbsup"))
    
    var favorLabel:UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    var favorDownIcon:UIImageView = UIImageView(image:UIImage(systemName:"hand.thumbsdown"))
    
    var commentIcon:UIImageView = UIImageView(image:UIImage(systemName:"text.bubble.fill"))
    var commentLabel:UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    var shareIcon:UIImageView = UIImageView(image:UIImage(systemName:"tray.and.arrow.up"))
    var shareLabel:UILabel = {
        let label = UILabel()
        label.text = "Share"
        return label
    }()
    
    init(){
        super.init(frame:CGRect.zero)
        backgroundColor = .lightGray
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        
        addSubview(favorUpIcon)
        addSubview(favorLabel)
        addSubview(favorDownIcon)
        addSubview(commentIcon)
        addSubview(commentLabel)
        addSubview(shareIcon)
        addSubview(shareLabel)
        
        favorUpIcon.translatesAutoresizingMaskIntoConstraints = false
        favorLabel.translatesAutoresizingMaskIntoConstraints = false
        favorDownIcon.translatesAutoresizingMaskIntoConstraints = false
        commentIcon.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        shareIcon.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            favorUpIcon.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 10),
            favorLabel.leadingAnchor.constraint(equalTo: favorUpIcon.trailingAnchor,constant: 5),
            favorDownIcon.leadingAnchor.constraint(equalTo: favorLabel.trailingAnchor,constant: 5),
            
            //commentIcon.leadingAnchor.constraint(equalTo: favorDownIcon.trailingAnchor,constant:50),
            commentIcon.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -10),
            commentLabel.leadingAnchor.constraint(equalTo: commentIcon.trailingAnchor),
            
            shareIcon.trailingAnchor.constraint(equalTo: shareLabel.leadingAnchor),
            shareLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -10),
        ])

    }
}
