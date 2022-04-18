//
//  MPrivacyViewController.swift
//  Me-iOS
//
//  Created by mac on 20.01.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

enum PrivacyType: Int, CaseIterable{
    
    case sourceOfInformation = 0
    case privacyPolicy = 1
    case privelege = 2
    //  case requestYourData = 3
      case requestToDelete = 4
    case feedbackText = 5
    case sendEmail = 6
    case readAboutPrivacy = 7
    case dataProtection = 8
    
}

enum PrivacyLinkType {
    static let  privacy = "https://media.forus.io/static/Privacybeleid.pdf"
    static let protection = "https://autoriteitpersoonsgegevens.nl/nl/onderwerpen/avg-europese-privacywetgeving"
}


class MPrivacyViewController: UIViewController {
    
    var email: String
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.fill1Copy()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var appNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = "Me"
        label.font = R.font.googleSansBold(size: 17)
        return label
    }()
    
    var companyName: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Forus, 2020"
        label.font = R.font.googleSansRegular(size: 14)
        label.textColor = #colorLiteral(red: 0.431086272, green: 0.4391285777, blue: 0.4474107623, alpha: 1)
        return label
    }()
    
    let closeBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.closeIcon(), style: .plain, target: self, action: #selector(dismiss(_:)))
        button.tintColor = .lightGray
        return button
    }()
    
    // MARK: - Init
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func setupView() {
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "WhiteBackground_DarkTheme")
        } else {
            self.view.backgroundColor = .white
        }
        
        let date = Date()
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "yyyy"
        
        companyName.text = "Forus, \(dateFormater.string(from: date))"
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
        }
        self.navigationItem.rightBarButtonItem = closeBarButton
        self.title = "Privacy"
    }
}


extension MPrivacyViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrivacyType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = PrivacyType.allCases[indexPath.row]
        
        switch section {
        case .sourceOfInformation:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureCellInfo(by: section)
            
            return cell
            
        case .privacyPolicy:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCellInfo(text: Localize.privacy_policy(), by: section)
            
            cell.button.actionHandleBlock = { [weak self] (_) in
                self?.openLink(link: PrivacyLinkType.privacy)
            }
            
            return cell
        case .privelege:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCellInfo(by: section)
            return cell
            //  case .requestYourData:
            //    guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
            //      return UITableViewCell()
            //    }
            //    cell.configureCellInfo(text: "Request your data by email", by: section)
            //
            //    return cell
              case .requestToDelete:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
                  return UITableViewCell()
                }
                cell.configureCellInfo(text: "Request to delete your data", by: section)
            
            cell.button.actionHandleBlock = { [weak self] (_) in
                self?.openDeleteAccount()
            }
                return cell
            
        case .feedbackText:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCellInfo(by: section)
            
            return cell
            
        case .sendEmail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCellInfo(text: Localize.send_mail_to(), by: section)
            
            cell.button.actionHandleBlock = { [weak self] (_) in 
                self?.sendEmail()
            }
            
            return cell
        case .readAboutPrivacy:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCellInfo(by: section)
            return cell
            
        case .dataProtection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCellInfo(text: Localize.date_protection(), by: section)
            
            cell.button.actionHandleBlock = { [weak self] (_) in
                self?.openLink(link: PrivacyLinkType.protection)
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = PrivacyType.allCases[indexPath.row]
        switch section {
        case .privacyPolicy, .sendEmail, .dataProtection, .requestToDelete:
            return 60
        default:
            return UITableView.automaticDimension
        }
        
    }
    
}

extension MPrivacyViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [tableView, iconImageView, appNameLabel, companyName]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
}

extension MPrivacyViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 34),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            iconImageView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 28)
        ])
        
        NSLayoutConstraint.activate([
            appNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 17),
            appNameLabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 28),
            appNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            companyName.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 17),
            companyName.topAnchor.constraint(equalTo: self.appNameLabel.bottomAnchor, constant: 2),
            companyName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            companyName.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -42)
        ])
    }
}

// MARK: - Email Composer
extension MPrivacyViewController: MFMailComposeViewControllerDelegate {
    private func sendEmail() {
        let subject = Localize.my_feedback_about_me_app()
        
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailPrivacy])
            mail.setSubject(Localize.my_feedback_about_me_app())
            mail.setMessageBody("", isHTML: false)
            self.present(mail, animated: true, completion: nil)
            
            
        } else if let emailUrl = createEmailUrl(to: emailPrivacy, subject: subject, body: "") {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func openDeleteAccount() {
        let vc = MDeleteAccountViewController(email: email)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension MPrivacyViewController {
    private func openLink(link: String) {
        if let url = URL(string: link) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}
