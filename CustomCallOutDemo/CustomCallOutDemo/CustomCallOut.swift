//
//  CustomCallOut.swift
//  CustomCallOutDemo
//
//  Created by shen
//  Copyright © 2016年 shen. All rights reserved.
//

import UIKit

private let margin: CGFloat = 10.0

class CustomCallOut: UIView {

    var labelArray = [UILabel]()
    var labelWidth: CGFloat = 0
    var nameLabel: UILabel!
    let modelArray: Array<AnnoModel>
    var buttonY: CGFloat = 3
    var divideView: UIView!
    var buttonArray = [UIButton]()
    
    init(_ modelArray: Array<AnnoModel>) {
        self.modelArray = modelArray
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(models: Array<AnnoModel>) -> CGSize {
        self.backgroundColor = UIColor.white
        nameLabel = UILabel.init()
        nameLabel.textAlignment = .center
        self.addSubview(nameLabel)
        
        divideView = UIView.init()
        divideView.backgroundColor = UIColor.lightGray
        self.addSubview(divideView)
        
        self.labelWidth = getWidth(models: models)
        
        for (index, model) in models.enumerated() {
            let button = UIButton.init()
            button.setTitle(model.projectName, for: .normal)
            let originalString: String = model.projectName!
            let font = UIFont.systemFont(ofSize: 14.0)
            button.titleLabel?.font = font
            let attributeString = NSAttributedString.init(string: originalString, attributes: [NSFontAttributeName: font])
            let size = CGSize.init(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
            let rect = attributeString.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
            let height = rect.size.height
            button.frame = CGRect(x: margin, y: buttonY, width: labelWidth - margin, height: height)
            buttonY = buttonY + height + 2
            
            button.tag = index
            button.setTitleColor(UIColor.black, for: .selected)
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.addTarget(self, action: #selector(updateContent(button:)), for: .touchUpInside)
            self.addSubview(button)
            
            buttonArray.append(button)
        }
        
        let originY = updateContent(button: buttonArray.first!)
        let size = CGSize(width: labelWidth, height: originY)
        
        return size
    }
    
    private func getWidth(models: Array<AnnoModel>) -> CGFloat {
        let text = models.first?.dates?.first
        let label = UILabel.init()
        label.text = text
        label.sizeToFit()
        return label.frame.width + margin * 2
    }
    
    @objc private func updateContent(button: UIButton) -> CGFloat  {
        
        _ = buttonArray.map({$0.isSelected = false})
        
        button.isSelected = true
        
        var originY = self.buttonY
        originY += 3
        divideView.frame = CGRect(x: margin, y: originY, width: labelWidth - 2 * margin, height: 1)
        
        _ = self.labelArray.map({$0.removeFromSuperview()})
        self.labelArray.removeAll()
        originY += 2
        
        let model = self.modelArray[button.tag]
        
        for (_, text) in model.dates!.enumerated() {
            
            let label = UILabel.init(frame: CGRect(x: margin, y: originY  , width: labelWidth + 5, height: 20))
            originY = originY + 20 + 4
            label.text = text
            self.addSubview(label)
            self.labelArray.append(label)
            print(originY)
        }
        print(originY)
        nameLabel.frame = CGRect(x: margin, y: originY + 2, width: labelWidth - margin, height: 20)
        
        nameLabel.text = model.name
        originY += 25
        let originX = self.frame.origin.y + self.frame.height - originY
        
        self.frame = CGRect(x: self.frame.origin.x, y: originX, width: labelWidth, height: originY + 5)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        return originY
    }

    
    
}
