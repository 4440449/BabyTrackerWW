//
//  DetailWakeSceneViewController_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit
import MommysEye


class DetailWakeSceneViewController_BTWW: UIViewController,
                                          DetailWakeScenePresenterOutputProtocol_BTWW {
    
    // MARK: - Dependencies
    
    let configurator = DetailWakeSceneConfigurator_BTWW()
    private var presenter: DetailWakeScenePresenterInputProtocol_BTWW!
    
    func setupPresenter(_ presenter: DetailWakeScenePresenterInputProtocol_BTWW) {
        self.presenter = presenter
    }
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupOutletButtons()
        setupTextView()
        setupObservers()
        presenter.viewDidLoad()
    }
    
    
    // MARK: - Input data flow
    
    func reloadData() {
        wakeUpOutletButton.setTitle(presenter.getWakeUpOutletButtonText(), for: .normal)
        wakeWindowOutletButton.setTitle(presenter.getWakeWindowOutletButtonText(), for: .normal)
        signsOutletButton.setTitle(presenter.getSignsOutletButtonText(), for: .normal)
        textView.text = presenter.getTexForTextView()
        counterTextViewLabel.text = "\(maxTextViewLenghtCount - presenter.getCounterForTextViewLabel())"
        manageTextViewPlaceholder()
    }
    
    
    // MARK: - UI
    @IBOutlet weak var wakeUpLabel: UILabel!
    @IBOutlet weak var wakeWindowLabel: UILabel!
    @IBOutlet weak var signsLabel: UILabel!
    @IBOutlet weak var wakeUpOutletButton: UIButton!
    @IBOutlet weak var wakeWindowOutletButton: UIButton!
    @IBOutlet weak var signsOutletButton: UIButton!
    @IBOutlet weak var saveOutletButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var placeholderTextViewLabel: UILabel!
    @IBOutlet weak var counterTextViewLabel: UILabel!
    
    private func setupLabels() {
        wakeUpLabel.font = UIFont(name: "Montserrat-Regular", size: 22)!
        wakeWindowLabel.font = UIFont(name: "Montserrat-Regular", size: 22)!
        signsLabel.font = UIFont(name: "Montserrat-Regular", size: 22)!
    }
    
    private func setupOutletButtons() {
        wakeUpOutletButton.layer.cornerRadius = 5
        wakeUpOutletButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 22)!
        wakeWindowOutletButton.layer.cornerRadius = 5
        wakeWindowOutletButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 22)!
        signsOutletButton.layer.cornerRadius = 5
        signsOutletButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 22)!
        saveOutletButton.layer.cornerRadius = 5
        saveOutletButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)!
    }
    
    private func setupTextView() {
        textView.delegate = self
        backgroundView.layer.cornerRadius = 10
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
    
    @IBAction func wakeUpButton(_ sender: Any) {
        performSegue(withIdentifier: String.init(describing: Wake.WakeUp.self), sender: nil)
    }
    
    @IBAction func wakeWindowButton(_ sender: Any) {
        performSegue(withIdentifier: String.init(describing: Wake.WakeWindow.self), sender: nil)
    }
    
    @IBAction func signsButton(_ sender: Any) {
        performSegue(withIdentifier: String.init(describing: Wake.Signs.self), sender: nil)
    }
    
    @IBAction func saveWakeButton(_ sender: Any) {
        presenter.saveButtonTapped()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
    }
    
    
    // MARK: - Deinit
    
    deinit {
//        print("WakeDetailSceneViewController - is Deinit!")
    }
    
}




// MARK: - TextView Delegate

extension DetailWakeSceneViewController_BTWW: UITextViewDelegate {
    
    //Keyboard frame observing
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    // Initial setup
    private var maxTextViewLenghtCount: Int { get { 500 } }
    
    // UI Logic
    private func manageTextViewPlaceholder() {
        if textView.text.isEmpty {
            placeholderTextViewLabel.isHidden = false
        } else {
            placeholderTextViewLabel.isHidden = true
        }
    }
    
    // Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderTextViewLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        manageTextViewPlaceholder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //Text validation
        let validatedText = String(textView.text.prefix(maxTextViewLenghtCount))
        presenter.textViewDidChange(text: validatedText)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView.text.count <= maxTextViewLenghtCount) || (range.length >= 1) {
            return true
        } else {
            return false
        }
    }
    
}



