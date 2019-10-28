//
//  CloudTag.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 28/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class CloudTag: UIView {
    
    var tags: [String]? {
        didSet {
//            drawTags()
        }
    }
    
    init(frame: CGRect, tags: [String]?) {
        self.tags = tags
        super.init(frame: frame)
//        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawTags()
    }
            
    func drawTags() {
        guard let tags = self.tags else { return }
        var remainWidth = self.frame.width
        
        var previousTag: Tag? = nil
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        for (index, tag) in tags.enumerated() {
            let tagView = Tag(frame: .zero, name: tag)
            tagView.translatesAutoresizingMaskIntoConstraints = false
            
            if (remainWidth > tagView.necessaryWidthToRender) {
                addSubview(tagView)
                
                tagView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                tagView.widthAnchor.constraint(equalToConstant: tagView.necessaryWidthToRender).isActive = true
                tagView.heightAnchor.constraint(equalToConstant: Tag.height).isActive = true
                
                if (previousTag != nil) {
                    tagView.leftAnchor.constraint(equalTo: previousTag!.rightAnchor, constant: 4).isActive = true
                } else {
                    tagView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                }
                
                previousTag = tagView
                remainWidth = remainWidth - tagView.necessaryWidthToRender - 4
            }
            
//            self.layoutIfNeeded()
        }
    }
}
