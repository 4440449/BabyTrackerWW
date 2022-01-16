//
//  DetailWakeSceneViewController_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit
import MommysEye


class DetailWakeSceneViewController_BTWW: UIViewController {
    
    // MARK: - Dependencies
    
    let configurator = DetailWakeSceneConfigurator_BTWW()
    var viewModel: DetailWakeSceneViewModelProtocol_BTWW!
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutletButtons()
        setupTextView()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        viewModel.wake.subscribe(observer: self) { [weak self] wake in
            guard let self = self else { return }
            self.wakeUpOutletButton.setTitle(wake.wakeUp.rawValue, for: .normal)
            self.wakeWindowOutletButton.setTitle(wake.wakeWindow.rawValue, for: .normal)
            self.signsOutletButton.setTitle(wake.signs.rawValue, for: .normal)
            self.textView.text = wake.note
            self.counterTextViewLabel.text = "\(self.maxTextViewLenghtCount - wake.note.count)"
            self.manageTextViewPlaceholder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var wakeUpOutletButton: UIButton!
    @IBOutlet weak var wakeWindowOutletButton: UIButton!
    @IBOutlet weak var signsOutletButton: UIButton!
    @IBOutlet weak var saveOutletButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var placeholderTextViewLabel: UILabel!
    @IBOutlet weak var counterTextViewLabel: UILabel!
    
    
    
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
        viewModel.saveButtonTapped()
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
        viewModel.prepare(for: segue)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
    }
    
    
    // MARK: - Deinit

    deinit {
        print("WakeDetailSceneViewController - is Deinit!")
    }
    
}



// MARK: - UI Setup

extension DetailWakeSceneViewController_BTWW: UITextViewDelegate {
    
    // MARK: - Buttons
    
    private func setupOutletButtons() {
        wakeUpOutletButton.layer.cornerRadius = 5
        wakeWindowOutletButton.layer.cornerRadius = 5
        signsOutletButton.layer.cornerRadius = 5
        saveOutletButton.layer.cornerRadius = 5
    }
    
    
    // MARK: - TextView
    
    private var maxTextViewLenghtCount: Int { get { 500 } }
    
    private func setupTextView() {
        textView.delegate = self
        backgroundView.layer.cornerRadius = 10
    }
    
    private func manageTextViewPlaceholder() {
        if textView.text.isEmpty {
            placeholderTextViewLabel.isHidden = false
        } else {
            placeholderTextViewLabel.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderTextViewLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        manageTextViewPlaceholder()
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
                scrollView.scrollRectToVisible(backgroundView.frame, animated: true)
            } else {
                return
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //Text validation
        let validatedText = String(textView.text.prefix(maxTextViewLenghtCount))
        viewModel.textViewDidChange(text: validatedText)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView.text.count <= maxTextViewLenghtCount) || (range.length >= 1) {
            return true
        } else {
            return false
        }
    }
    
}
