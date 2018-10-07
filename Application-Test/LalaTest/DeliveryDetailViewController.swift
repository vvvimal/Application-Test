import Cartography

final class DeliveryDetailViewController: UIViewController {
    // View Components
    lazy var thumbnailView: DeliveryThumbnailView = DeliveryThumbnailView(self.delivery, showBorder: true)
    lazy private var mapView: DeliveryMapView = DeliveryMapView(self.delivery)
    
    private var didSetupMap = false
    private var setupMapClosure: (() -> ()) = { }

    //MARK: -  Init with delivery object
    private var delivery: Delivery!
    convenience init(_ delivery: Delivery) {
        self.init()
        self.delivery = delivery
        if self.delivery.id % 3 == 0 {
            self.delivery.location.address = "Unknown Address"
        }
    }
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMapClosure = {
            self.setupMap()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200), execute: { () -> Void in
            self.setupMapClosure()
        })
    }
    
    //MARK: - Draw UI
    private func drawUI() {
        title = "Delivery Detail"
        view.backgroundColor = .white

        // Add components to StackView, from to to bottom.
        view.addSubview(mapView)

        // Add ThumbnailView on top of everything
        view.addSubview(thumbnailView)
        
        // AutoLayout
        constrain(view, mapView, thumbnailView) { (view, mapView, thumbnailView) -> () in
            mapView.edges == inset(view.edges, 0, 0, 0, 0)
            thumbnailView.left == view.left + 24
            thumbnailView.right == view.right - 24
            thumbnailView.bottom == view.bottom - 24
            thumbnailView.height == 80
        }
        
        accessibilityLabel = "DeliveryDetailViewController"
        
        // Typhoon view
        if delivery.id == 13 {
            showTyphoonView()
        }
    }
    
    private func showTyphoonView() {
        let typhoonView = TyphoonView()
        view.addSubview(typhoonView)
        constrain(view, typhoonView) { (view, typhoonView) -> () in
            typhoonView.top == view.top
            typhoonView.left == view.left
            typhoonView.right == view.right
        }
    }
    
    //MARK: -  Show markers and route, zoom and pan window to appropriate position.
    private func setupMap() {
        if didSetupMap { return }
        didSetupMap = true
        self.mapView.updateCamera()
        self.mapView.showMarkers()
    }
}
