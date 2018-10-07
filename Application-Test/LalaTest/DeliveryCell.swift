import Cartography

final class DeliveryCell: UITableViewCell {
    // View Components
    lazy var thumbnailView: DeliveryThumbnailView = self.makeThumbnailView()
    
    // Update content when set delivery
    var delivery: Delivery? {
        didSet {
            thumbnailView.delivery = delivery
            thumbnailView.isHidden = false
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawUI()
        makeLongPressGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func drawUI() {
        backgroundColor = .clear
        contentView.addSubview(thumbnailView)
        constrain(contentView, thumbnailView) { (contentView, thumbnailView) -> () in
            thumbnailView.edges == inset(contentView.edges, 12, 12, 0, 12)
        }
    }
    
    func makeLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler))
        addGestureRecognizer(gesture)
    }
    
    @objc private func longPressGestureHandler() {
        Global.crash()
    }
    
    // MARK: - Override functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Override this function to prevent background color change when selected
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Change color when highlight
        thumbnailView.backgroundColor = highlighted ? UIColor(white: 0.94, alpha: 1.0) : .white
    }
}

//MARK: - Make View Components
extension DeliveryCell {
    fileprivate func makeThumbnailView() -> DeliveryThumbnailView {
        let thumbnailView = DeliveryThumbnailView(nil)
        thumbnailView.layer.shadowRadius = 1
        thumbnailView.layer.shadowColor = UIColor.gray.cgColor
        thumbnailView.layer.shadowOpacity = 0.5
        thumbnailView.layer.shadowOffset = CGSize(width: 1, height: 1)
        return thumbnailView
    }
}
