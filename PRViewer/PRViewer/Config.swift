//
//  Config.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 08/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import Foundation
import UIKit

struct PRViewerColors {
    static let open = UIColor(displayP3Red: 33/255, green: 133/255, blue: 58/255, alpha: 0.7)
    static let closed = UIColor(displayP3Red: 205/255, green: 35/255, blue: 48/255, alpha: 0.7)
    static let merged = UIColor(displayP3Red: 108/255, green: 69/255, blue: 193/255, alpha: 0.7)
}

struct HomeScreenValues {
    let cellSpacingHeight : CGFloat = 15
    let topViewCornerRadius : CGFloat = 15
    let topViewMessage : String = "hi there!"
    let cardsCornerRadius : CGFloat = 12
    let discountLabelCornerRadius : CGFloat = 8.73
    let brandImageCornerRadius : CGFloat = 5
    let backgroundColor = UIColor(displayP3Red: 32/255, green: 32/255, blue: 32/255, alpha: 1)
}

struct PromoDetailScreenValues {
    let topViewCornerRadius : CGFloat = 15
    let brandImageCornerRadius : CGFloat = 7
    let gradientColors : [CGColor] = [UIColor(displayP3Red: 17/255, green: 9/255, blue: 47/255, alpha: 1).cgColor, UIColor.clear.cgColor, UIColor(displayP3Red: 32/255, green: 21/255, blue: 69/255, alpha: 1).cgColor]
    let gradientLocations : [NSNumber] = [0, 0.65, 1]
    let defaultShareMessage = "Hey, I am buying food using slice!."
    let copyMessage = "Code copied"
}
