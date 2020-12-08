//
//  RecentQuestionsViewController.swift
//  HCA_Interview_ Assignment
//
//  Created by Bharath Nallatheegala on 12/6/20.
//

import UIKit

class RecentQuestionsViewController: UIViewController {
    
    
    private let viewModel = RecentQuestionsViewModel()
    private var dataSource: [Item] = [Item]()
    @IBOutlet weak var recentQuestionsListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recentQuestionsListView.tableFooterView = UIView()
        recentQuestionsListView.rowHeight = UITableView.automaticDimension
        recentQuestionsListView.estimatedRowHeight = 50
        recentQuestionsListView.register(UITableViewCell.self, forCellReuseIdentifier: "ResuableIdentifier")
        fetchService()
    }
    
    func fetchService() {
        ServiceManager.sharedInstance.getResponce { [weak self](result) in
            switch result {
            case .success(let responseObject):
                self?.updateListView(responseObject)
            case .failure(let error):
                self?.handleFailure(for: error)
            }
        }
    }
    
    func updateListView(_ responce: QuestionsModel) {
        if let filteredItems = self.viewModel.filter(with: responce) {
            dataSource = filteredItems
            recentQuestionsListView.reloadData()
            return
        }
        dataSource.removeAll()
        recentQuestionsListView.reloadData()
        handleFailure(for: .emptyResults)
        
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        fetchService()
    }
    
    func handleFailure(for error: ApplicationError) {
        
        let alert = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Re-try", style: .default, handler: { [weak self](_) in
            self?.fetchService()
        }))
        self.present(alert, animated: true)
    }
    
}

extension RecentQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResuableIdentifier", for: indexPath) as? UITableViewCell {
            cell.textLabel?.text = dataSource[indexPath.row].title ?? "title missing"
            cell.textLabel?.numberOfLines = 0
            return cell 
        }
        return UITableViewCell()
    }
}

