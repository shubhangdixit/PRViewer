//
//  PRTableViewCell.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 08/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import UIKit

class PRTableViewCell: UITableViewCell {

    @IBOutlet weak var PRImage: UIImageView!
    @IBOutlet weak var prNumber: UILabel!
    @IBOutlet weak var prTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var pullRequest : PullRequest?
    
        override func awakeFromNib() {
        super.awakeFromNib()
            
        containerView.setCorners(withRadius: 10)
        containerView.layer.masksToBounds = true
        self.selectionStyle = .none
    }
    
    func configureCell(forPR pr : PullRequest) {
        self.prTitle.text = pr.title
        let prNumberString = "#" + pr.number
        let prCreationInfoString = pr.getInfoString()
        prNumber.setAttributedText(withBoldedPart: prNumberString, andOtherPart: prCreationInfoString, isBoldStringFirst: true, fontSize: 12)
        self.PRImage.image = pr.getPRSymbolImage()
        self.containerView.backgroundColor = pr.getPRSymbolColor()
    }
}


extension PRTableViewCell {
    func getAttributedText(withBoldedFirstPart firstPart : String,andSecondPart secondPart: String) -> NSMutableAttributedString
    {
        let text = String(format: "%@ %@",firstPart, secondPart)
        let attributedString = NSMutableAttributedString(string: text)
        
        let firstRange  =  (text as NSString).range(of: firstPart)
        let secondRange =  (text as NSString).range(of: secondPart)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "RobotoSlab-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12), range: firstRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "RobotoSlab-Light", size: 12) ?? UIFont.systemFont(ofSize: 12), range:secondRange)
        
        return attributedString
    }
}

