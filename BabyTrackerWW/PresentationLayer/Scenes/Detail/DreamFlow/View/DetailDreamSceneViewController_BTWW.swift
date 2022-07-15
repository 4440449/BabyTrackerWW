//
//  DetailDreamSceneViewController_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class DetailDreamSceneViewController_BTWW: UIViewController,
                                                 DetailDreamScenePresenterOutputProtocol_BTWW {
    
    // MARK: - Dependencies
    
    let configurator = DetailDreamSceneConfigurator_BTWW()
    private var presenter: DetailDreamScenePresenterInputProtocol_BTWW!
    
    func setupPresenter(_ presenter: DetailDreamScenePresenterInputProtocol_BTWW) {
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
    
    
    // MARK: - Input data flow / Presenter Output interface
    
    func reloadData() {
        fallAsleepOutletButton.setTitle(presenter.getFallAsleepOutletButtonLabel(), for: .normal)
        putDownOutletButton.setTitle(presenter.getPutDownOutletButtonLabel(), for: .normal)
        textView.text = presenter.getTexForTextView()
        counterTextViewLabel.text = "\(maxTextViewLenghtCount - presenter.getCounterForTextViewLabel())"
        manageTextViewPlaceholder()
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var fallAsleepLabel: UILabel!
    @IBOutlet weak var putDownLabel: UILabel!
    @IBOutlet weak var fallAsleepOutletButton: UIButton!
    @IBOutlet weak var putDownOutletButton: UIButton!
    @IBOutlet weak var saveOutletButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var placeholderTextViewLabel: UILabel!
    @IBOutlet weak var counterTextViewLabel: UILabel!
    
    private func setupLabels() {
        fallAsleepLabel.font = UIFont(name: "Montserrat-Regular", size: 22)!
        putDownLabel.font = UIFont(name: "Montserrat-Regular", size: 22)!
    }
    
    private func setupOutletButtons() {
        fallAsleepOutletButton.layer.cornerRadius = 5
        fallAsleepOutletButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 22)!
        putDownOutletButton.layer.cornerRadius = 5
        putDownOutletButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 22)!
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
    
    @IBAction func fallAsleepButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Dream.FallAsleep.self), sender: nil)
    }
    
    @IBAction func putDownButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Dream.PutDown.self), sender: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
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
//        print("DreamDetailSceneViewController - is Deinit!")
    }
    
}




// MARK: - TextView Delegate

extension DetailDreamSceneViewController_BTWW: UITextViewDelegate {
    
    //Keyboard frame observing
    func setupObservers() {
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
    var maxTextViewLenghtCount: Int { get { 500 } }
    
    // UI Logic
    func manageTextViewPlaceholder() {
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

