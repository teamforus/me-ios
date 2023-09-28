import UIKit
import StoreKit

enum VoucherType: Int {
    case vouchers = 0
    case expiredVouchers = 1
}

class MVouchersViewController: UIViewController {
    var isFromLogin: Bool!
    var voucherType: VoucherType! = .vouchers
    var dataSource: VouchersDataSource!
    var wallet: Office!
    var navigator: Navigator
    
    lazy var voucherViewModel: VouchersViewModel = {
        return VouchersViewModel()
    }()
    
    // MARK: - Properties
    private let refreshControl = UIRefreshControl()
    
    var segmentController: HBSegmentedControl = {
        let segment = HBSegmentedControl(frame: .zero)
        return segment
    }()
    
    private let segmentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Color.lightGraySegment
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    var transactionButton: ActionButton = {
        let button = ActionButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(Image.transactionIcon, for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    
    // MARK: - Init
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Viiew
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func setupView() {
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {}
        setupAccessibility()
        if !Preference.tapToSeeTransactionTipHasShown {
            Preference.tapToSeeTransactionTipHasShown = true
            transactionButton.toolTip(message: Localize.tap_here_you_want_to_see_list_transaction(), style: .dark, location: .bottom, offset: CGPoint(x: -50, y: 0))
        }
        
        setupSegmentControll()
        voucherViewModel.completeIdentity = { [unowned self] (response) in
            DispatchQueue.main.async {
                self.wallet = response
            }
        }
        setupAction()
        voucherViewModel.getIndentity()
        setupTableView()
        initFetch()
        receiveFetch()
    }
    
    private func receiveFetch() {
        voucherViewModel.complete = { [weak self] (vouchers) in
            
            DispatchQueue.main.async {
                
                self?.voucherViewModel.sendPushToken(token: UserDefaults.standard.string(forKey: "TOKENPUSH") ?? "")
                self?.dataSource = VouchersDataSource(vouchers: vouchers, wallet: nil)
                self?.tableView.dataSource = self?.dataSource
                self?.tableView.delegate = self
                self?.tableView.reloadData()
                if vouchers.count == 0 {
                    
                    self?.tableView.isHidden = true
                }else {
                    
                    self?.tableView.isHidden = false
                }
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupTableView() {
        registerForPreviewing(with: self, sourceView: tableView)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.register(VoucherTableViewCell.self, forCellReuseIdentifier: VoucherTableViewCell.identifier)
        
    }
    
    private func setupSegmentControll() {
        segmentController.items = ["Geldig", Localize.expired()]
        segmentController.selectedIndex = 0
        segmentController.font = UIFont(name: "GoogleSans-Medium", size: 14)
        segmentController.unselectedLabelColor = #colorLiteral(red: 0.631372549, green: 0.6509803922, blue: 0.6784313725, alpha: 1)
        segmentController.selectedLabelColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.968627451, alpha: 1)
        segmentController.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        segmentController.borderColor = .clear
        segmentView.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    func initFetch() {
        
        if isReachable() {
            
            KVSpinnerView.show()
            voucherViewModel.vc = self
            voucherViewModel.initFetch()
            
        }else {
            
            showInternetUnable()
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        initFetch()
    }
    
    @objc func segmentSelected(sender:HBSegmentedControl) {
        
        switch sender.selectedIndex {
        case VoucherType.vouchers.rawValue:
            voucherType = .vouchers
            self.voucherViewModel.filterVouchers(voucherType: voucherType)
            self.tableView.reloadData()
            self.tableView.isHidden = false
        case VoucherType.expiredVouchers.rawValue:
            voucherType = .expiredVouchers
            self.voucherViewModel.filterVouchers(voucherType: voucherType)
            self.tableView.reloadData()
            break
        default: break
        }
    }
}

extension MVouchersViewController: UITableViewDelegate{
    
    @objc func send(_ sender: UIButton) {
        self.showPopUPWithAnimation(vc: SendEtherViewController(nibName: "SendEtherViewController", bundle: nil))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voucher = self.dataSource.vouchers[indexPath.row]
        
        switch voucherType {
        case .vouchers?:
            if voucher.product != nil {
                navigator.navigate(to: .productVoucher(voucher.address ?? ""))
            }else {
                navigator.navigate(to: .budgetVoucher(voucher))
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}

extension MVouchersViewController: UIViewControllerPreviewingDelegate{
    
    private func createDetailViewControllerIndexPath(vc: UIViewController, indexPath: IndexPath) -> UIViewController {
        
        let detailViewController = vc
        
        return detailViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        switch voucherType {
        case .vouchers?:
            guard let indexPath = tableView.indexPathForRow(at: location) else {
                return nil
            }
            let voucher = self.dataSource.vouchers[indexPath.row]
            var detailViewController = UIViewController()
            if voucherViewModel.selectedVoucher?.product != nil {
                let productVC = ProductVoucherViewController(navigator: navigator)
                productVC.address = voucherViewModel.selectedVoucher?.address ?? ""
                detailViewController = productVC
            }else {
                let productVC = MVoucherViewController(voucher: voucher, navigator: navigator)
                productVC.address = voucherViewModel.selectedVoucher?.address ?? ""
                detailViewController = productVC
            }
            
            return detailViewController
        default:
            return nil
        }
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

// MARK: - Add Subviews

extension MVouchersViewController {
    private func addSubviews() {
        let views = [segmentView, tableView]
        views.forEach { view in
            self.view.addSubview(view)
        }
        view.addSubview(segmentController)
    }
}

// MARK: - Setup Constraintst

extension MVouchersViewController {
    private func setupConstraints() {
        
        segmentView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        segmentController.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.segmentView).inset(4)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(segmentView.snp.bottom).offset(15)
        }
    }
}

extension MVouchersViewController {
    // MARK: - Setup Action
    private func setupAction() {
        transactionButton.actionHandleBlock = { [weak self] (_) in
            self?.transactionButton.removeToolTip(with: Localize.tap_here_you_want_to_see_list_transaction())
            self?.navigator.navigate(to: .transaction)
        }
    }
}

// MARK: - Accessibility Protocol

extension MVouchersViewController: AccessibilityProtocol {
    
    func setupAccessibility() {
//        if let valute = segmentController.accessibilityElement(at: 0) as? UIView {
//            valute.setupAccesibility(description: "Choose to show all valute", accessibilityTraits: .causesPageTurn)
//        }
        
//        if let vouchers = segmentController.accessibilityElement(at: 1) as? UIView {
//            vouchers.setupAccesibility(description: "Choose to show all vouchers", accessibilityTraits: .causesPageTurn)
//        }
    }
}
