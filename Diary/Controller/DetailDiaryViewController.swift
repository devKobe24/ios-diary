//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/02.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.keyboardDismissMode = .onDrag
        
        return textView
    }()
    
    private let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var diary: DiaryEntity
    
    init(diary: DiaryEntity) {
        self.diary = diary
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        diaryTextView.delegate = self

        configureUI()
        
        if #unavailable(iOS 15.0) {
            NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveDiaryData()
    }
    
    func fetchDiaryData(_ data: DiaryEntity) {
        guard let title = data.title,
              let body = data.body else {
            return
        }
        
        diary = data
        diaryTextView.text = "\(title)\n\(body)"
        
        configureNavigationItem(date: data.createdAt ?? Date())
    }
    
    private func saveDiaryData() {
        let titleAndBody = diaryTextView.text.split(separator: "\n")
        let title = String(titleAndBody[safe: 0] ?? .init())
        let body = String(titleAndBody[safe: 1] ?? .init())
        
        diary.title = title
        diary.body = body
        
        persistentContainer?.saveContext()
    }
    
    @objc private func willShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        diaryTextView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardFrame.height, right: .zero)
    }
    
    @objc private func willHideKeyboard(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets()
    }
}

extension DetailDiaryViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        if #available(iOS 15.0, *) {
            diaryTextViewConstraints()
        } else {
            diaryTextViewConstraintsUnderIOS15()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem(date: Date = Date()) {
        navigationItem.title = DiaryDateFormatter.convertDate(date, Locale.current.identifier)
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    @available(iOS 15.0, *)
    private func diaryTextViewConstraints() {
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    private func diaryTextViewConstraintsUnderIOS15() {
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
}
