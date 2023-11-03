//
//  MRecordsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import BWWalkthrough

class MRecordsViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    
    var dataSource: RecordsDataSource!
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    var navigator: Navigator
    
    // MARK: - Properties
    let closeButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setImage(Image.closeBlackIcon, for: .normal)
        return button
    }()
    
    var newRecordButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.titleLabel?.font = R.font.googleSansBold(size: 12)
        button.setTitle(Localize.new_records(), for: .normal)
        return button
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    
    
    // MARK: - Init
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
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
        setupActions()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(walkthroughCloseButtonPressed), name: NotificationName.ClosePageControll, object: nil)
        #if ALPHA
        newRecordButton.isHidden = false
        #else
        newRecordButton.isHidden = true
        #endif
    }
    
    private func setupTableView() {
        self.tableView.separatorStyle = .none
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        self.tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initFetch()
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    func initFetch() {
        if isReachable() {
            KVSpinnerView.show()
            recordViewModel.vc = self
            recordViewModel.initFitch()
            fetch()
        }else {
            showInternetUnable()
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        initFetch()
    }
    
    private func fetch() {
        recordViewModel.complete = { [weak self] (records) in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.dataSource = RecordsDataSource(records: records, navigator: self.navigator)
                self.tableView.dataSource = self.dataSource
                self.tableView.delegate = self.dataSource
                self.tableView.reloadData()
                KVSpinnerView.dismiss()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension MRecordsViewController: BWWalkthroughViewControllerDelegate{
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber == 3{
            NotificationCenter.default.post(name: Notification.Name("HidePageNumber"), object: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MRecordsViewController {
    func setupAccessibility() {
    }
}

extension MRecordsViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [ tableView, newRecordButton]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MRecordsViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        newRecordButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        
        tableView.snp.makeConstraints { make in
            #if ALPHA
            make.top.equalTo(newRecordButton.snp.bottom)
            #else
            make.top.equalTo(view.safeAreaLayoutGuide)
            #endif
            make.top.equalTo(newRecordButton.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }
}

extension MRecordsViewController {
    // MARK: - Setup Actions
    private func setupActions() {
        closeButton.actionHandleBlock = { [weak self] (button) in
            self?.dismiss(button)
        }
        
        newRecordButton.actionHandleBlock = { [weak self] (_) in
            self?.didCreateRecord()
        }
    }
    
    private func didCreateRecord() {
        if let walkthrough = R.storyboard.chooseTypeRecord.walk() {
            walkthrough.delegate = self
            walkthrough.scrollview.isScrollEnabled = false
            
            if let pageOne = R.storyboard.chooseTypeRecord.types() {
                walkthrough.add(viewController:pageOne)
            }
            
            if let pageTwo = R.storyboard.textRecord.text() {
                walkthrough.add(viewController:pageTwo)
            }
            
            self.present(walkthrough, animated: true, completion: nil)
        }
    }
}

