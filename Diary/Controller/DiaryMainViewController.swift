//
//  Diary - DiaryMainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class DiaryMainViewController: UIViewController {
    private let diaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        
        return tableView
    }()

    private var diarylist: [Diary]?
    
    private var container: NSPersistentContainer?
    
    private var diaryContentsCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureDelegates()
        diaryListFromJSON()
    }
    
    private func configureDelegates() {
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
    }
    
    @objc private func didTapAddDiaryButton() {
        let detailDiaryViewController = DetailDiaryViewController()
        self.navigationController?.pushViewController(detailDiaryViewController, animated: true)
    }
    
    private func decodeDiary() throws {
        let decoder = JSONDecoder()
        
        guard let dataAsset = NSDataAsset(name: "sample") else {
            throw DecodeError.assetNotFound
        }
        
        guard let decodedData = try? decoder.decode([Diary].self, from: dataAsset.data) else {
            throw DecodeError.failed
        }
        
        diarylist = decodedData
    }
    
    private func diaryListFromJSON() {
        do {
            try decodeDiary()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DiaryMainViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        diaryTableViewConstraints()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddDiaryButton))
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
//        guard let diarylist else {
//
//            return .zero
//        }
//
//        return diarylist.count
        
        guard let numberOfRows = try? fetchNumberOfRows() else {

            return .zero
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
            
            return UITableViewCell()
        }
        
        guard let diarylist,
              let diary = diarylist[safe: indexPath.row] else {
            
            return UITableViewCell()
        }
        
        DispatchQueue.main.async {
            cell.fetchData(diary)
        }
        
        do {
            try fetchDiaryContentsData(completion: { (titleDataList, bodyDataList, createdAtDataList) in
                guard let title = titleDataList[safe: indexPath.row],
                      let body = bodyDataList[safe: indexPath.row],
                      let createdAt = createdAtDataList[safe: indexPath.row] else {

                    return
                }
                DispatchQueue.main.async {
                    self.diarylist?.append(Diary(title: title, body: body, createdAt: createdAt))
                }
                
            })
        } catch {
            print(error.localizedDescription)
        }
        return cell
    }
}

extension DiaryMainViewController {
    private func fetchNumberOfRows() throws -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw FetchNumberOfRowsError.accessDenied
        }
        self.container = appDelegate.persistentContainer
        guard let container = self.container else {
            throw FetchNumberOfRowsError.containerEmpty
        }
        
        guard let diaryContentsData = try container.viewContext.fetch(DiaryContents.fetchRequest()) as? [DiaryContents] else {
            throw DiaryContentsDataError.diaryContentsDataEmpty
        }
        return diaryContentsData.count
    }
    
    private func fetchDiaryContentsData(completion: @escaping (_ titleDataList: [String], _ bodyDataList: [String], _ createdAtDataList: [Int]) -> Void) throws {
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            self.container = appDelegate.persistentContainer
            guard let container = self.container else {
                return
            }
            
            guard let diaryContentsData = try container.viewContext.fetch(DiaryContents.fetchRequest()) as? [DiaryContents] else {
                throw DiaryContentsDataError.diaryContentsDataEmpty
            }
            
            diaryContentsCount = diaryContentsData.count
            
            var titleDataList: [String] = []
            var bodyDataList: [String] = []
            var createdAtDataList: [Int] = []
            
            try diaryContentsData.forEach({
                guard let titleData = $0.title else {
                    throw DiaryContentsDataError.titleDataEmpty
                }
                
                guard let bodyData = $0.body else {
                    throw DiaryContentsDataError.bodyDataEmpty
                }
                
                guard let createdAtData = $0.createdAt as? Int else {
                    throw DiaryContentsDataError.createdAtDataEmpty
                }
                
                titleDataList.append(titleData)
                bodyDataList.append(bodyData)
                createdAtDataList.append(createdAtData)
            })
            
            completion(titleDataList, bodyDataList, createdAtDataList)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

enum DiaryContentsDataError: LocalizedError {
    case diaryContentsDataEmpty
    case titleDataEmpty
    case bodyDataEmpty
    case createdAtDataEmpty
}

enum FetchNumberOfRowsError: LocalizedError {
    case accessDenied
    case containerEmpty
}
