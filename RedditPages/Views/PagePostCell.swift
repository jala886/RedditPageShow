//
//  PagePostView.swift
//  RedditPages
//
//  Created by jianli on 4/1/22.
//

import Foundation
import UIKit

class PagePostCell: UITableViewCell{
    class var identifer:String{"PagePostViewCell"}
    /*
    var topTitleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
     */
    var titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        //label.backgroundColor = .blue
        return label
    }()
    
    var bottomView:CellBottomView = {
        let bottomView = CellBottomView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:PagePostCell.identifer)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomView)
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant:10),
            titleLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant:-10),
            titleLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant:-tableViewCellBottomHeight/2),
            //bottomView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            bottomView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant:-tableViewCellBottomHeight/2+5),
            bottomView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            bottomView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
        ])
    }
    
    func configure(data postModel:PostModel){
        titleLabel.text = postModel.title
        bottomView.favorLabel.text = formatNumber(postModel.ups!)
        bottomView.commentLabel.text = "\(postModel.numComments!)"
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
}

