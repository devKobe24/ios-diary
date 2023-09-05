//
//  Diary - DiaryMainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryMainViewController: UIViewController {
    private let diaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        
        return tableView
    }()

    private let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var diarylist: [Diary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.delegate = self
        diaryTableView.dataSource = self

        configureUI()
        
//        do {
//            try decodeDiary()
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        diarylist = persistentContainer?.getAllItems()
        diaryTableView.reloadData()
    }
    
    @objc private func didTapAddDiaryButton() {
        let detailDiaryViewController = DetailDiaryViewController()
        self.navigationController?.pushViewController(detailDiaryViewController, animated: true)
    }
    
//    private func decodeDiary() throws {
//        let decoder = JSONDecoder()
//
//        guard let dataAsset = NSDataAsset(name: "sample") else {
//            throw DecodeError.assetNotFound
//        }
//
//        guard let decodedData = try? decoder.decode([Diary].self, from: dataAsset.data) else {
//            throw DecodeError.failed
//        }
//
//        diarylist = decodedData
//    }
}

extension DiaryMainViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        diaryTableViewConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddDiaryButton))
    }
    
    private func addSubViews() {
        view.addSubview(diaryTableView)
    }
    
    private func diaryTableViewConstraints() {
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DiaryMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let diarylist else {
            return .zero
        }
        
        return diarylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        guard let diarylist,
              let diary = diarylist[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.fetchData(diary)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let diarylist,
              let diary = diarylist[safe: indexPath.row] else {
            return
        }
        
        let detailDiaryViewController = DetailDiaryViewController()
        detailDiaryViewController.fetchDiaryData(diary)
        
        navigationController?.pushViewController(detailDiaryViewController, animated: true)
    }
}
