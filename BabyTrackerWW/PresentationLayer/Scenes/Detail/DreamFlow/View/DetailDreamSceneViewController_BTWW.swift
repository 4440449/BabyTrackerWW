//
//  DetailDreamSceneViewController_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit
import MommysEye


final class DetailDreamSceneViewController_BTWW: UIViewController {
    
    // MARK: - Dependencies
    
    let configurator = DetailDreamSceneConfigurator_BTWW()
    var viewModel: DetailDreamSceneViewModelProtocol_BTWW!
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutletButtons()
        setupTextView()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        viewModel.dream.unsubscribe(observer: self)
    }
    
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        viewModel.dream.subscribe(observer: self) { [weak self] dream in
            guard let self = self else { return }
            self.fallAsleepOutletButton.setTitle(dream.fallAsleep, for: .normal)
            self.putDownOutletButton.setTitle(dream.putDown, for: .normal)
            self.textView.text = dream.note
            self.counterTextViewLabel.text = "\(self.maxTextViewLenghtCount - dream.note.count)"
            self.manageTextViewPlaceholder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboardFrame(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var fallAsleepOutletButton: UIButton!
    @IBOutlet weak var putDownOutletButton: UIButton!
    @IBOutlet weak var saveOutletButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var placeholderTextViewLabel: UILabel!
    @IBOutlet weak var counterTextViewLabel: UILabel!
    
    
    @IBAction func fallAsleepButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Dream.FallAsleep.self), sender: nil)
    }
    
    @IBAction func putDownButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Dream.PutDown.self), sender: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
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
        print("DreamDetailSceneViewController - is Deinit!")
    }
    
}



// MARK: - UI Setup

extension DetailDreamSceneViewController_BTWW: UITextViewDelegate {
    
    // MARK: - Buttons
    
    private func setupOutletButtons() {
        fallAsleepOutletButton.layer.cornerRadius = 5
        putDownOutletButton.layer.cornerRadius = 5
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
