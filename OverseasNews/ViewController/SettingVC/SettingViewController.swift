//
//  ScrapViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import MessageUI
import Toast

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftTitle(title: "Setting")
        configureTableView()
    }
    
    // MARK: - Helper
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
    }
    
    func showToastAlert(message: String) {
        DispatchQueue.main.async {
            self.view.makeToast(message)
        }
    }
    
    func goAppStoreURL(url: String) {
        if let appstoreURL = URL(string: url) {
            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [
              URLQueryItem(name: "action", value: "write-review")
            ]
            guard let writeReviewURL = components?.url else {
                return
            }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            showToastAlert(message: "피드백을 보내기 전에 메일 등록을 먼저 해주세요 ‼️")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["camosss777@gmail.com"])
        present(composer, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            showToastAlert(message: "피드백 보내기를 정상적으로 처리하지 못했습니다 😱")
            controller.dismiss(animated: true)
        }
        
        switch result {
        case .cancelled:
            showToastAlert(message: "피드백 보내기를 취소하였습니다 🥲")
        case .saved:
            showToastAlert(message: "피드백을 정상적으로 저장했습니다 😄")
        case .sent:
            showToastAlert(message: "피드백을 정상적으로 보냈습니다 😆")
        case .failed:
            showToastAlert(message: "피드백 보내기를 실패했습니다 😭")
        @unknown default:
            showToastAlert(message: "😨")
        }
        
        controller.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Version information 1.0.0"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        guard let option = SettingOption(rawValue: indexPath.row) else { return cell }
        cell.titleLabel.text = option.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        
        if row == 0 { // 공지사항
            
        } else if row == 1 { // 피드백 보내기
            showMailComposer()
        } else if row == 2 { // 앱스토어 연결
            goAppStoreURL(url: "itms-apps://itunes.apple.com/app/apple-store/id1596846397")
        } else { // 라이선스
            let sb = UIStoryboard(name: "Setting", bundle: Bundle.main)
            let vc = sb.instantiateViewController(withIdentifier: "LicenseViewController") as! LicenseViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
