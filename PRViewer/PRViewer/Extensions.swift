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
