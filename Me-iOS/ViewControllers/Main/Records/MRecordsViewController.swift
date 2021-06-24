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
    
    // MARK: - Properties
    let closeButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setImage(Image.closeBlackIcon, for: .normal)
        return button
    }()
    
    var titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.personal()
        label.font = R.font.googleSansBold(size: 38)
        return label
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
    
    private let refreshControl = UIRefreshControl()
    
    var dataSource: RecordsDataSource!
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func setupView() {
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
            
            DispatchQueue.main.async {
                self?.dataSource = RecordsDataSource(records: records)
                self?.tableView.dataSource = self?.dataSource
                self?.tableView.delegate = self?.dataSource
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recordVC = segue.destination as? MRecordDetailViewController {
            let record = self.dataSource.records[tableView.indexPathForSelectedRow?.row ?? 0]
            recordVC.recordId = String(record.id ?? 0)
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
        titleLabel.setupAccesibility(description: Localize.personal(), accessibilityTraits: .header)
    }
}

extension MRecordsViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [closeButton, titleLabel, newRecordButton, tableView]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MRecordsViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(view).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            make.left.equalTo(self.view).offset(16)
        }
        
        newRecordButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        
        tableView.snp.makeConstraints { make in
            #if ALPHA
            make.top.equalTo(newRecordButton.snp.bottom)
            #else
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
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

