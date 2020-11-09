//
//  DetailsViewController.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var openAtTimeStackView: UIStackView!
    @IBOutlet weak var lastUpdatedAtTimeStackView: UIStackView!
    @IBOutlet weak var closedAtTimeStackView: UIStackView!
    @IBOutlet weak var mergedAtTimeStackView: UIStackView!
    
    @IBOutlet weak var backButtonTitleLabel: UILabel!
    @IBOutlet weak var prStateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var baseBranchLabel: UILabel!
    @IBOutlet weak var headBranchLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var prStateImageView: UIImageView!
    
    @IBOutlet weak var readFullPageButton: UIButton!
    
    var pullRequest : PullRequest?
    
    var animationsStopped : Bool = false {
        didSet {
            if animationsStopped == true {
                self.readFullPageButton.layer.removeAllAnimations()
                self.readFullPageButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIForSubView()
        loadContent()
        setUpGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropButtonAnimation()
    }
    
    func dropButtonAnimation() {
        if animationsStopped {
            return
        }
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       options: [.allowUserInteraction, .repeat, .transitionCurlDown, .autoreverse],
                       animations: {
                        self.readFullPageButton.transform = CGAffineTransform(translationX: 0, y: -20)
                       },
                       completion: { Void in()  }
        )
    }
    
    func configureUIForSubView() {
        let gradientColors : [CGColor] = [UIColor.black.cgColor,
            UIColor(displayP3Red: 32/255, green: 32/255, blue: 32/255, alpha: 1).cgColor
        ]
        
        view.addGradientView(withColors: gradientColors, andLocations: [0.1, 0.4])
        readFullPageButton.setCorners(withRadius: 20)
        profileView.setCorners(withRadius: 15)
        profileView.clipsToBounds = true
        profileView.backgroundColor = pullRequest?.getPRSymbolColor()
        if let imageURL = pullRequest?.createdBy?.avatarURL {
            userAvatarImageView.loadImageUsingCache(withUrl: imageURL)
        }
        prStateImageView.image = pullRequest?.getPRSymbolImage()
        baseBranchLabel.setCorners(withRadius: 10)
        baseBranchLabel.setCorners(withRadius: 10)
        
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        
    }
    
    func setUpGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backToAllPRsDidTapped))
        tap.delegate = self
        headerView.addGestureRecognizer(tap)
    }
    
    func loadContent() {
        if let pr = pullRequest {
            titleLabel.setAttributedText(withBoldedPart: pr.title, andOtherPart: "#" + pr.number, isBoldStringFirst: true, fontSize: 25)
            let mergeInformation = pr.getMergeStatusString()
            infoLabel.setAttributedText(withBoldedPart: mergeInformation.0, andOtherPart: mergeInformation.1, isBoldStringFirst: true, fontSize: 14)
            baseBranchLabel.text = pr.base.label
            headBranchLabel.text = pr.head.label
            descriptionTextView.text = pr.body
            displayTimelines(withDate: pr.createdAt, intoStackView: openAtTimeStackView, andtitleLabelText: "Opened At:")
            displayTimelines(withDate: pr.closedAt, intoStackView: closedAtTimeStackView, andtitleLabelText: "Closed At:")
            displayTimelines(withDate: pr.mergedAt, intoStackView: mergedAtTimeStackView, andtitleLabelText: "Merged At:")
            displayTimelines(withDate: pr.updatedAt, intoStackView: lastUpdatedAtTimeStackView, andtitleLabelText: "Last updated at:")
            prStateLabel.text = pr.getPRStatusString()
            let descriptionHead = pr.getDescriptionTitle()
            descriptionTitleLabel.setAttributedText(withBoldedPart: descriptionHead.0, andOtherPart: descriptionHead.1, isBoldStringFirst: true, fontSize: 14)
            backButtonTitleLabel.text = RepoManager.shared.getRepoPath() + "/#" + pr.number
        }
        
    }
    
    func displayTimelines(withDate date : Date?, intoStackView stack : UIStackView, andtitleLabelText text : String) {
        if let dateTime = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            for subView in stack.arrangedSubviews {
                if let label = subView as? UILabel {
                    switch subView.tag {
                    case 11:
                        label.text = text
                    default:
                        label.setAttributedText(withBoldedPart: timeFormatter.string(from: dateTime), andOtherPart: dateFormatter.string(from: dateTime) + " ,", isBoldStringFirst: false, fontSize: 14)
                    }
                }
            }
        } else {
            stack.isHidden = true
        }
        
    }
    
    //MARK:- SFSafariViewControllerDelegate
    
    func open(URL urlString : String?) {
        if let url = urlString, let supportUrl = URL(string: url) {
            let svc = SFSafariViewController(url: supportUrl)
            svc.delegate = self
            svc.preferredBarTintColor = .black
            self.present(svc, animated: true, completion: nil)
        } else {
            // show alert for failure
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func readButtonDidTap(_ sender: Any) {
        animationsStopped = true
        open(URL: pullRequest?.htmlURL)
    }
    
    @objc func backToAllPRsDidTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isKind(of: UILabel.self) ?? false || touch.view?.isKind(of: UIImageView.self) ?? false {
            return true
        }
        return false
    }
}
