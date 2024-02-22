//
//  UILabel + Extension.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 21.02.2024.
//

import UIKit

//For MovieInfo Description label maximum lines
extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
