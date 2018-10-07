//
//  TyphoonView.swift
//  LalaTest
//
//  Created by Kenneth Tsang on 18/9/2018.
//  Copyright © 2018 Kenneth. All rights reserved.
//

import Cartography

class TyphoonView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initView()
    }
    
    private func initView() {
        backgroundColor = .yellow
        let imageView = UIImageView(image: #imageLiteral(resourceName: "typhoon8"))
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel(font: .systemFont(ofSize: 14), textColor: .darkGray)
        label.text = "Gale or storm force wind is expected or blowing generally in Hong Kong near sea level, with a sustained wind speed of 63–117 km/h from the quarter indicated and gusts which may exceed 180 km/h, and the wind condition is expected to persist."
        
        addSubview(imageView)
        addSubview(label)

        constrain(self, imageView, label) { (view, imageView, label) -> () in
            imageView.left == view.left + 8
            imageView.centerY == view.centerY
            imageView.width == 90
            imageView.height == 90
            label.top == view.top + 8
            label.bottom == view.bottom - 8
            label.left == imageView.right + 8
            label.right == view.right - 8
        }
    }
}
