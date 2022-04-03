//
//  ViewController.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import UIKit
import Combine

class PageTableViewController: UIViewController{
    //MARK: PARAMETER DEFINED
    private var  postViewModel:  PostViewModelDelegate?
    private var  subscribers = Set<AnyCancellable>()
    
    private lazy var refreshAction:UIAction = UIAction{[weak self] _ in
        self?.refreshData()
    }
    
    private lazy var refreshControl:UIRefreshControl = {
        let refresh = UIRefreshControl(frame:.zero, primaryAction: refreshAction)
        return refresh
    }()
    
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PagePostCell.self, forCellReuseIdentifier: PagePostCell.identifer)
        tableView.register(PagePostImageCell.self, forCellReuseIdentifier: PagePostImageCell.identifer)
        tableView.backgroundColor = .lightGray
        //tableView.rowHeight = UITableView.automaticDimension
        // tableView.rowHeight = tableViewCellTitleHeight + tableViewCellImageHeight
        //tableView.rowHeight = tableViewCellTitleHeight
        //tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        tableView.estimatedRowHeight = tableViewCellTitleHeight + tableViewCellImageHeight
        tableView.addSubview(refreshControl)
        tableView.isPagingEnabled = true
        /*  for gesture in cell
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewController.tapEdit(_:)))
        tableView.addGestureRecognizer(tapGesture!)
        tapGesture!.delegate = self
         */
        return tableView
    }()
    
    
    
    //MARK: FUNCTION DEFINED
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureMVVC()
        setupUI()
        setupBinding()
    }
    
    private func configureMVVC(){
        let downloader = NetworkManager()
        postViewModel = PostViewModel(downloader:downloader)
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
    }
    private func setupBinding(){
        postViewModel?
            .postPublisher
            //.dropFirst()// don't need update for first load
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscribers)
        postViewModel?
            .imagePublisher
            //.dropFirst()// don't need update for first load
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscribers)
        
        postViewModel?.loadPost()
    }
    
    private func refreshData(){
        postViewModel?.forceUpdate()
    }
    /* for gesture action in cell
    func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizerState.Ended {
            let tapLocation = recognizer.locationInView(self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRowAtPoint(tapLocation) {
                if let tappedCell = self.tableView.cellForRowAtIndexPath(tapIndexPath) as? MyTableViewCell {
                    //do what you want to cell here

                }
            }
        }
    }
     */
}

extension PageTableViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let data:PostModel? = postViewModel?.postData[row]
        let cell = data?.thumbnail == "self" ? tableView.dequeueReusableCell(withIdentifier: PagePostCell.identifer, for: indexPath) as! PagePostCell : tableView.dequeueReusableCell(withIdentifier: PagePostImageCell.identifer, for: indexPath) as! PagePostImageCell
        //print(data?.thumbnail)
        //print(type(of:cell))
        //cell.titleLabel.text = data?.title ?? ""
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.backgroundColor = .white
    
        if cell is PagePostImageCell{
            if let cell = cell as? PagePostImageCell,let imageData = postViewModel?.imageData,row < imageData.count, let rowdata = imageData[row]{
                cell.configure(data: data!,imageView: UIImage(data:rowdata) ?? UIImage())
            }
        }else{
            cell.configure(data:data!)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postViewModel?.postData.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        let data = postViewModel?.postData[row]
        let titleText = data?.title
        let textHeight = titleText?.getSize(with:titleFont).height
        
        
        //print(textHeight)
        
        if let name = data?.thumbnail, name.starts(with: "https://"){
            //return tableViewCellTitleHeight + tableViewCellImageHeight
            return textHeight! + tableViewCellBottomHeight + tableViewCellImageHeight
        }else{
            //return UITableView.automaticDimension
            return textHeight! + tableViewCellBottomHeight
        }

    }
    
}

extension PageTableViewController:UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexs = indexPaths.map{$0.row}
        let total = postViewModel?.postData.count ?? 0
        if indexs.contains(total-1){
            postViewModel?.loadMorePost()
        }
    }
}

extension PageTableViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        postViewModel?.deleteData(row:row)
        tableView.reloadData()
    }
}

