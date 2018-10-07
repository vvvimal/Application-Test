import UIKit
import Cartography
import SwiftIcons

protocol EmptyViewDelegate: class {
    func emptyViewButtonTapped()
}

enum EmptyViewStatus {
    case loading
    case disconnected
    case empty
}

final class EmptyView: UIView {
    private var currentView: UIStackView?

    //MARK: - Init with Delegate
    weak var delegate: EmptyViewDelegate?
    convenience init(delegate: EmptyViewDelegate?) {
        self.init()
        self.delegate = delegate
    }
    
    // Redraw content when status changed
    var status: EmptyViewStatus = .loading {
        didSet {
            if status != oldValue {
                redrawContents()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Draw UI
    private func drawUI() {
        backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        redrawContents()
    }
    
    func redrawContents() {
        currentView?.removeFromSuperview()
        currentView = nil
        switch status {
        case .loading:
            showLoadingView()
            currentView?.accessibilityLabel = "EmptyViewLoading"
        case .empty:
            showContentView(icon: .fontAwesomeSolid(.truck), text: "Nothing to deliver", buttonTitle: "Refresh")
            currentView?.accessibilityLabel = "EmptyViewEmpty"
        case .disconnected:
            showContentView(icon: .fontAwesomeSolid(.wifi), text: "Please check your internet connection", buttonTitle: "Retry")
            currentView?.accessibilityLabel = "EmptyViewDisconnected"
        }
    }
    
    //MARK: - Button Action
    @objc func buttonTapped() {
        delegate?.emptyViewButtonTapped()
    }
    
    //MARK: - Make View Components
    private func showContentView(icon: FontType, text: String, buttonTitle: String) {
        let image = UIImage.init(icon: icon, size: CGSize(width: 220, height: 190), textColor: .lightGray)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel(font: .boldSystemFont(ofSize: 18), textColor: .lightGray)
        label.textAlignment = .center
        label.text = text
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.setTitleColor(.lightGray, for: UIControl.State())
        button.layer.cornerRadius = 4.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        button.setTitle("     \(buttonTitle)     ", for: .normal)
        button.isExclusiveTouch = true
        button.accessibilityLabel = "RefreshButton"
        
        currentView = UIStackView(arrangedSubviews: [imageView, label, button])
        if let currentView = currentView {
            currentView.axis = .vertical
            currentView.distribution = .equalSpacing
            currentView.spacing = 16
            currentView.alignment = .center
            addSubview(currentView)
            constrain(self, currentView) { (view, currentView) -> () in
                currentView.centerX == view.centerX
                currentView.centerY == view.centerY - 32
                currentView.width == view.width * 0.9
            }
        }
    }
    
    private func showLoadingView() {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.text = "Loading..."
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        
        currentView = UIStackView(arrangedSubviews: [label, activityIndicator])
        if let currentView = currentView {
            currentView.axis = .horizontal
            currentView.distribution = .equalSpacing
            currentView.spacing = 8
            currentView.alignment = .center
            addSubview(currentView)
            constrain(self, currentView) { (view, currentView) -> () in
                currentView.center == view.center
            }
            layoutIfNeeded()
        }
    }
}
