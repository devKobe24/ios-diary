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
        
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
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
    
    func saveDiaryData() {
        let splitedText = diaryTextView.text.split(separator: "\n")
        let title = String(splitedText[safe: 0] ?? .init())
        let body = String(diaryTextView.text.dropFirst(title.count))
        
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
    
    @objc private func didHideKeyboard() {
        saveDiaryData()
    }
    
    @objc private func didTapShowMoreButton() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(makeShareAlertAction())
        sheet.addAction(makeDeleteAlertAction())
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(sheet, animated: true)
    }
    
    private func makeShareAlertAction() -> UIAlertAction {
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            guard let title = self.diary.title,
                  let body = self.diary.body else {
                return
            }
            
            let activityController = UIActivityViewController(activityItems: [title, body], applicationActivities: nil)
            
            self.present(activityController, animated: true)
        }
        
        return shareAction
    }
    
    private func makeDeleteAlertAction() -> UIAlertAction {
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let alert = UIAlertController(title: "진짜요?", message: "정말 삭제하시겠어요?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.persistentContainer?.deleteItem(self.diary)
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        }
        
        return deleteAction
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(didTapShowMoreButton))
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
