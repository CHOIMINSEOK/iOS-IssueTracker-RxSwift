//
//  IssueTrackerModel.swift
//  Sample-iOS-with-Redux
//
//  Created by Minseok Choi on 24/08/2018.
//  Copyright © 2018 Minseok Choi. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTracker {
    let provider: MoyaProvider<Github>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
        .observeOn(MainScheduler.instance)
            .flatMapLatest { (name) -> Observable<Repository?> in
                return self.findRepository(name: name)
            }
            .flatMapLatest { (repository) -> Observable<[Issue]?> in
                guard let repository = repository else {
                    return Observable.just(nil)
                }
                
                return self.findIssues(repository: repository)
            }
            .replaceNilWith([])
    }
    
    internal func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider.rx
            .request(Github.issues(repositoryFullName: repository.fullName))
            .mapOptional(to: [Issue].self)
            .asObservable()
    }
    
    internal func findRepository(name: String) -> Observable<Repository?> {
        return self.provider.rx
            .request(Github.repo(fullName: name))
            .mapOptional(to: Repository.self)
            .asObservable()
    }
}
