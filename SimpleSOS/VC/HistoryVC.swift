//
//  HistoryVC.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit

class HistoryVC: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    var data: [CallData]? = Archiver.retrieveContacts(of: .callData) 
    
    var testData: [CallData] = [
        .init(fullName: "Petra", phoneNumber: "052682072", time: "05:24"),
        .init(fullName: "Joel", phoneNumber: "4234324", time: "12:15"),
        .init(fullName: "Foonai", phoneNumber: "42432546", time: "03:24"),
        .init(fullName: "Chz", phoneNumber: "21312", time: "16:20"),
        .init(fullName: "Lel", phoneNumber: "9789087", time: "16:24")
    ]
    
    private let mainTitle = MainTitleLabel()
    
    private var tableView = UITableView()
    
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .softRed
        setUp()
    }
    
    
    //MARK: - Body
    private func setUp() {
        configureMainTitle()
        configureTableView()
    }
    
    private func configureMainTitle() {
        mainTitle.fix(in: view)
        mainTitle.text = "History"
    }
    
    private func configureTableView() {
        tableView = .init()
        tableView.register(HistoryCell.nib, forCellReuseIdentifier: HistoryCell.cellIdentifier)
        tableView.delegate   = self
        tableView.dataSource = self
        
        fixTableView()
    }
    
    private func fixTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor  = .init(white: 1, alpha: 0.4)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else { return 0}
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.cellIdentifier) as? HistoryCell else { return .init() }
        guard let data = data else { return .init() }
        cell.data = data[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 5
    }
}


extension HistoryVC: HistoryCellDelegate {
    func cellTapped() {
        
    }
}
