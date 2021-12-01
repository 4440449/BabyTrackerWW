//
//  WakeDetailSceneViewController.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class DetailWakeSceneViewController: UIViewController {
    
    // MARK: - Dependencies
    
    let configurator = DetailWakeSceneConfiguratorImpl()
    var presenter: DetailWakeScenePresenterProtocol!
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutletButtons()
        setupTextView()
        setupObservers()
    }
    
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        presenter.wake.subscribe(observer: self) { [unowned self] wake in
            self.wakeUpOutletButton.setTitle(wake.wakeUp.rawValue, for: .normal)
            self.wakeWindowOutletButton.setTitle(wake.wakeWindow.rawValue, for: .normal)
            self.signsOutletButton.setTitle(wake.signs.rawValue, for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var wakeUpOutletButton: UIButton!
    @IBOutlet weak var wakeWindowOutletButton: UIButton!
    @IBOutlet weak var signsOutletButton: UIButton!
    @IBOutlet weak var saveOutletButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    @IBAction func wakeUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Wake.WakeUp.self), sender: nil)
    }
    
    @IBAction func wakeWindowButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Wake.WakeWindow.self), sender: nil)
    }
    
    @IBAction func signsButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Wake.Signs.self), sender: nil)
    }
    
    @IBAction func saveWakeButton(_ sender: Any) {
        presenter.saveButtonTapped()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.resignFirstResponder()
    }
    
    @IBAction func tapOnScrollViewGesture(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
    }
    
    
    // MARK: - Deinit

    deinit {
        print("WakeDetailSceneViewController - is Deinit!")
    }
    
}



// MARK: - UI Setup

extension DetailWakeSceneViewController: UITextViewDelegate {
    
    // MARK: - Buttons
    
    private func setupOutletButtons() {
        wakeUpOutletButton.layer.cornerRadius = 5
        wakeWindowOutletButton.layer.cornerRadius = 5
        signsOutletButton.layer.cornerRadius = 5
        saveOutletButton.layer.cornerRadius = 5
    }
    
    
    // MARK: - TextView
    
    private func setupTextView() {
        textView.delegate = self
        //        textView.backgroundColor = .systemGray5
        textView.layer.cornerRadius = 10
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        placeholderLabel.isHidden = false
    }
    
    @objc func adjustKeyboardFrame(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String : Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        //if rotation enabled {
        //        let keyboardViewFrame = view.convert(keyboardFrame, from: view.window)
        //    }
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset.bottom = .zero
        } else
            if notification.name == UIResponder.keyboardWillShowNotification {
                scrollView.contentInset.bottom = (keyboardFrame.height - view.safeAreaInsets.bottom) + 3
                scrollView.scrollRectToVisible(textView.frame, animated: true)
            } else {
                return
        }
    }
    
}
