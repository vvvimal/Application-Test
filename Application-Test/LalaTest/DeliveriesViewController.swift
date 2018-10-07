import Cartography
import Toast_Swift

final class DeliveriesViewController: UIViewController {
    // View Components
    lazy var tableView: UITableView = self.makeTableView()
    fileprivate lazy var emptyView: EmptyView = EmptyView(delegate: self)
    fileprivate var loadingFooter: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()

    //MARK: -  ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        drawUI()
        tableView.reloadData()
        emptyView.redrawContents()

        // Register for 3D touch
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: tableView)
        }

        // Listen to data change
        NotificationCenter.default.addObserver(self, selector: #selector(deliveriesStartRefresh), name: .deliveriesStartRefresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deliveriesDidUpdate), name: .deliveriesDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deliveriesDidFailToRefresh), name: .deliveriesDidFailToRefresh, object: nil)
        
        // Listen to application state
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        // Fetch data
        DeliveriesManager.instance.fetch(.refresh, loadFromCacheWhenFailed: true)
    }
    
    //MARK: - Draw UI
    private func drawUI() {
        title = "Delivery List"
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        view.addSubview(tableView)
        constrain(view, tableView) { (view, tableView) -> () in
            tableView.edges == inset(view.edges, 0, 0, 0, 0)
        }
        // EmptyView shows corresponding UI when network fail or empty content.
        tableView.backgroundView = emptyView

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        loadingFooter = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        loadingFooter.color = .black
        loadingFooter.startAnimating()
        
        tableView.accessibilityLabel = "DeliveriesTableView"
        tableView.accessibilityIdentifier = "DeliveriesTableView"
    }
    
    //MARK: -  Present View Controller
    fileprivate func goDeliveryDetail(_ delivery: Delivery) {
        let vc = DeliveryDetailViewController(delivery)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private var isLandscape = UIDevice.current.orientation.isLandscape
    private var didCheckOrientation = false
    @objc private func rotated() {
        if didCheckOrientation {
            if UIDevice.current.orientation.isLandscape != isLandscape {
                Global.crash()
            }
        } else {
            didCheckOrientation = true
            isLandscape = UIDevice.current.orientation.isLandscape
        }
    }

    @objc private func applicationDidEnterBackground() {
        presentedViewController?.dismiss(animated: false, completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    func loopFunction() {
        DispatchQueue.global().async {
            var text = ""
            for i in 0...2000 {
                for n in 0...2000 {
                    text = ""
                    text.append("\(i)\(n)")
                }
            }
        }
    }
    
    @objc private func pullToRefresh() {
        loopFunction()
        DeliveriesManager.instance.fetch(.refresh)
    }
}

//MARK: -  Make View Components
extension DeliveriesViewController {
    fileprivate func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        tableView.rowHeight = 90
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliveryCell.classForCoder(), forCellReuseIdentifier: "DeliveryCell")
        return tableView
    }
}

//MARK: -  Listen to data change
extension DeliveriesViewController {
    @objc func deliveriesStartRefresh() {
        emptyView.status = .loading
    }
    
    @objc func deliveriesDidUpdate() {
        //Stop the pullToRefrsh
        tableView.refreshControl?.endRefreshing()
        
        //Reset the empty view status
        emptyView.status = .empty
        
        //Reload TableView
        tableView.reloadData()
        tableView.tableFooterView = nil
    }
    
    @objc func deliveriesDidFailToRefresh() {
        //Stop the pullToRefrsh
        tableView.refreshControl?.endRefreshing()

        //Update the empty view status
        emptyView.status = .disconnected
        
        //Reload TableView
        tableView.reloadData()
        tableView.tableFooterView = nil

        // If already have data, show a toast about the network issue.
        if DeliveriesManager.instance.data.count > 0 {
            view.makeToast("Experiencing network issue...", duration: 1.0, position: .bottom)
        }
    }
}

//MARK: -  TableView Data Source and Delegate
extension DeliveriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (DeliveriesManager.instance.data.count != 0)
        return DeliveriesManager.instance.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCell", for: indexPath) as! DeliveryCell
        cell.delivery = DeliveriesManager.instance.data[safe: indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delivery = DeliveriesManager.instance.data[safe: indexPath.row] else { return }
        goDeliveryDetail(delivery)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if !DeliveriesManager.instance.isFetching && DeliveriesManager.instance.hasNextPage {
                tableView.tableFooterView = loadingFooter
                DeliveriesManager.instance.fetch(.nextPage)
            }
        }
    }
}

//MARK: -  EmptyView Delegate
extension DeliveriesViewController: EmptyViewDelegate {
    func emptyViewButtonTapped() {
        DeliveriesManager.instance.fetch(.refresh)
    }
}

//MARK: -  3D Touch Peek and Pop
extension DeliveriesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard
            let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? DeliveryCell,
            let delivery = DeliveriesManager.instance.data[safe: indexPath.row]
            else { return nil }
        let vc = DeliveryDetailViewController(delivery)
        previewingContext.sourceRect = cell.thumbnailView.superview!.convert(cell.thumbnailView.frame, to: tableView)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        //Deselect row from tableview to prevent presentating animation when presenting by peek and pop.
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        //Push to DeliveryDetailViewController
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
}
