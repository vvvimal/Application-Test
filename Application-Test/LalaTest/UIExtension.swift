import UIKit
import SwiftIcons

extension UILabel {
    convenience init(font: UIFont, textColor: UIColor) {
        self.init()
        self.textColor = textColor
        self.backgroundColor = .clear
        self.font = font
        self.numberOfLines = 0
    }
}

extension UIImageView {
    convenience init(backgroundColor: UIColor, contentMode: UIView.ContentMode) {
        self.init()
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
}
