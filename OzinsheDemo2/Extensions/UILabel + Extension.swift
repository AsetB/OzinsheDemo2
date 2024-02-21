//
//  UILabel + Extension.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 21.02.2024.
//

import UIKit

//For MovieInfo Description label maximum lines
//extension UILabel {
//    var maxNumberOfLines: Int {
//        guard let text = self.text else {
//            return 0
//        }
//        layoutIfNeeded()
//        let rect = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        let labelSize = text.boundingRect(
//            with: rect,
//            options: .usesLineFragmentOrigin,
//            attributes: [NSAttributedString.Key.font: font as Any],
//            context: nil)
//        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
//    }
//}

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
