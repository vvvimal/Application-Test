import Kingfisher
import Cartography
import SwiftIcons

final class DeliveryThumbnailView: UIView {
    // View Components
    private lazy var photoView: UIImageView = UIImageView(backgroundColor: UIColor(white: 0.94, alpha: 1.0), contentMode: .scaleAspectFill)
    private lazy var titleLabel: UILabel = UILabel(font: .boldSystemFont(ofSize: 14), textColor: .lalaText)
    private lazy var subtitleLabel: UILabel = UILabel(font: .systemFont(ofSize: 13), textColor: .gray)
    lazy var statusIconView: StatusIconView = StatusIconView()

    // Update content when set delivery
    var delivery: Delivery? {
        didSet {
            if let delivery = delivery {
                photoView.kf.setImage(with: delivery.imageUrl)
                titleLabel.text = delivery.desc
                subtitleLabel.text = delivery.location.address
            } else {
                photoView.kf.cancelDownloadTask()
                photoView.image = nil
                titleLabel.text = nil
                subtitleLabel.text = nil
            }
        }
    }

    //MARK: - Init with delivery object
    convenience init(_ delivery: Delivery?, showBorder: Bool = false) {
        self.init()
        drawUI()
        if showBorder {
            layer.borderWidth = max(1 / UIScreen.main.scale, 0.5)
            layer.borderColor = UIColor.lightGray.cgColor
        }
        setDelivery(delivery)
    }
    
    // Workaround: set Delivery outside init() to trigger "didSet"
    private func setDelivery(_ delivery: Delivery?) {
        self.delivery = delivery
    }
    
    //MARK: - Draw UI Contents
    private func drawUI() {
        backgroundColor = .white

        // StackView containing text
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.distribution = .equalSpacing
        textStackView.alignment = .leading
        textStackView.spacing = 4

        // StackView containing all contents
        let stackView = UIStackView(arrangedSubviews: [photoView, textStackView, statusIconView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)

        // AutoLayout
        constrain(self, photoView, stackView) { (view, photoView, stackView) -> () in
            stackView.edges == inset(view.edges, 8, 8, 8, 8)
            photoView.width == photoView.height
        }

        photoView.accessibilityLabel = "DeliveryCellPhoto"
        photoView.accessibilityIdentifier = "DeliveryCellPhoto"
        photoView.isAccessibilityElement = true
        
        titleLabel.accessibilityLabel = "DeliveryCellTitle"
        titleLabel.accessibilityIdentifier = "DeliveryCellTitle"
        titleLabel.isAccessibilityElement = true

        subtitleLabel.accessibilityLabel = "DeliveryCellSubtitle"
        subtitleLabel.accessibilityIdentifier = "DeliveryCellSubtitle"
        subtitleLabel.isAccessibilityElement = true

        statusIconView.accessibilityLabel = "DeliveryCellStatusIcon"
        statusIconView.accessibilityIdentifier = "DeliveryCellStatusIcon"
        statusIconView.isAccessibilityElement = true
    }
}

//MARK: - Green Status Icon
class StatusIconView: UIView {
    private lazy var icon: UIImageView = self.makeIcon()
    private var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func drawUI() {
        self.backgroundColor = .lalaGreen
        self.layer.cornerRadius = 17
        self.clipsToBounds = true
        self.widthAnchor.constraint(equalToConstant: 34).isActive = true
        self.heightAnchor.constraint(equalToConstant: 34).isActive = true
        addSubview(icon)
        constrain(self, icon) { (view, icon) -> () in
            icon.center == view.center
        }
    }
    
    private func makeIcon() -> UIImageView {
        let image = UIImage.init(icon: .fontAwesomeSolid(.truck), size: CGSize(width: 30, height: 30), textColor: .white)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }

    private func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.startAnimating()
        return activityIndicator
    }
}
