//
//  Extensions.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

extension UIView {
    func setCorners(withRadius radius : CGFloat) {
        layer.cornerRadius = radius
    }
    
    func addGradientView(withColors colors : [CGColor], andLocations locations : [NSNumber] = []) {
        let subView = GradientView(frame: self.bounds)
        self.addSubview(subView)
        let constraints = [
            subView.topAnchor.constraint(equalTo: self.topAnchor),
            subView.leftAnchor.constraint(equalTo: self.leftAnchor),
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            subView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ]
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        subView.backgroundColor = .clear
        subView.drawGradients(forColors: colors, andLocations: locations)
        self.sendSubviewToBack(subView)
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIColor {
    class func slicePurple() -> UIColor {
        return UIColor(displayP3Red: 54/255, green: 49/255, blue: 94/255, alpha: 1)
    }
}

extension UIViewController {
    
    func showActionSheet(_ message: String, title: String, actionTittle: [String], images: [String:String], withHandler handler: ((UIAlertAction) -> Void)?, andSourceView sourceView: UIView)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let attributedTitle = title
        
        let titleText = NSMutableAttributedString(
            string: attributedTitle,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont(name: "RobotoSlab-Regular", size: 11) ?? UIFont.systemFont(ofSize: 11),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        
        actionSheetController.setValue(titleText, forKey: "attributedTitle")
        
        for i in 0..<(actionTittle.count)
        {
            let listAction = UIAlertAction(title: actionTittle[i], style: .default, handler: handler)
            
            if let imageName = images[actionTittle[i]], let image = UIImage(named: imageName) {
                listAction.setValue(image , forKey: "image")
            }
            
            actionSheetController.addAction(listAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        })
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.view.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            actionSheetController.overrideUserInterfaceStyle = .dark
        }
        
        actionSheetController.popoverPresentationController?.sourceView = sourceView
        actionSheetController.popoverPresentationController?.sourceRect = sourceView.bounds
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

extension UILabel {
    func setAttributedText(withBoldedPart bold : String, andOtherPart normal: String, isBoldStringFirst isFirst : Bool, fontSize size : CGFloat) {
        
        let firstPart = isFirst ? bold : normal
        let secondPart = isFirst ? normal : bold
        
        let text = String(format: "%@ %@", firstPart, secondPart)
        let attributedString = NSMutableAttributedString(string: text)
        
        let firstRange  =  (text as NSString).range(of: firstPart)
        let secondRange =  (text as NSString).range(of: secondPart)
        
        let boldFont =  UIFont(name: "RobotoSlab-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        let normalFont = UIFont(name: "RobotoSlab-Light", size: size) ?? UIFont.systemFont(ofSize: size)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: isFirst ? boldFont : normalFont, range: firstRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: isFirst ? normalFont : boldFont, range:secondRange)
        
        self.attributedText = attributedString
    }
}
