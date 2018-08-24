//
//  ViewController.swift
//  Sample-iOS-with-Redux
//
//  Created by Minseok Choi on 24/08/2018.
//  Copyright © 2018 Minseok Choi. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    var provider: MoyaProvider<Github>!
    var latestRepositoryName: Observable<String> {
        return searchBar.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    var issueTracker: IssueTracker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupRx() {
        provider = MoyaProvider<Github>()
        issueTracker = IssueTracker(provider: provider, repositoryName: latestRepositoryName)
        
        issueTracker.trackIssues()
            .bind(to: tableView.rx.items) {
                tableView, row, item in
                // TODO : Reuse Custom Cell
                let cell = UITableViewCell()
                cell.textLabel?.text = item.title
                
                return cell
        }
        .disposed(by: disposeBag)
        
        tableView
            .rx.itemSelected
            .subscribe(onNext: {
                indexPath in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
        
    }


}

