//
//  MakeDiaryViewController.swift
//  Diary
//
//  Created by Minseong Kang on 2023/09/01.
//

import UIKit

class MakeDiaryViewController: UIViewController {
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
       
        return textView
    }()
    
    var date: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    convenience init(date: String?) {
        self.init()
        self.date = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.diaryTextView.delegate = self
        
        diaryTitle()
        addSubViews()
        diaryTextViewConstraints()
        diaryTextView.keyboardDismissMode = .onDrag
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print(diaryTextView.selectedRange)
//        let newPosition = diaryTextView.selectedRange.location
//        var textViewPositionStart = UITextPosition()
//        textViewPosition = UITextRange().start
//        diaryTextView.textRange(from: textViewPosition, to: textViewPosition)
        
    }
}

extension MakeDiaryViewController {
    private func diaryTitle() {
        guard let createDiaryDate = self.date else {
            return
        }
        
        self.navigationItem.title = createDiaryDate
    }
    
    private func addSubViews() {
        self.view.addSubview(diaryTextView)
    }
    
    private func diaryTextViewConstraints() {
        self.diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
        ])
    }
}

extension MakeDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
}
