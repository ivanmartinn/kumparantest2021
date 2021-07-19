//
//  UserDetailVC.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit

class UserDetailVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let dispatchGroup = DispatchGroup()
    private let refreshControl = UIRefreshControl()
    var loadingObj : SpinnerViewController? = nil
    
    var user: User!
    
    var albums: [Album] = []
    var photos: [Photo] = []
    var photosDetails: [PhotoDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        setupRefreshControl()
        requestAPI()
    }

    func setupUI(){
        self.title = user.name
        self.nameLabel.text = user.name
        self.emailLabel.text = user.email
        self.addressLabel.text = "\(user.address.suite)\n\(user.address.street)\n\(user.address.city)\n\(user.address.zipcode)"
        self.companyLabel.text = "\(user.company.name)\n\(user.company.catchPhrase)\n\(user.company.bs)"
        self.scrollView.refreshControl = refreshControl
    }
    
    func setupTable() {
        self.tableView.register(UINib.init(nibName: "AlbumCell", bundle: .main), forCellReuseIdentifier: "AlbumCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
    }
    
    func setupRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
    }
    
    func showLoading() {
        guard loadingObj == nil else { return }
        loadingObj = SpinnerViewController()

        // add the spinner view controller
        addChild(loadingObj!)
        loadingObj!.view.frame = view.frame
        view.addSubview(loadingObj!.view)
        loadingObj!.didMove(toParent: self)
    }
    
    func hideLoading(){
        guard loadingObj != nil else { return }
        DispatchQueue.main.async {
            self.loadingObj!.willMove(toParent: nil)
            self.loadingObj!.view.removeFromSuperview()
            self.loadingObj!.removeFromParent()
            self.loadingObj = nil
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        requestAPI()
    }
    
    func requestAPI(){
        showLoading()
        getAlbums()
        getPhotos()
        dispatchGroup.notify(queue: .main) {
            self.hideLoading()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func getAlbums(){
        dispatchGroup.enter()
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users/\(user.id)/albums")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model = try decoder.decode([Album].self, from: data ?? Data())
                self.albums = model
            } catch {
                print("error",error)
            }
            self.dispatchGroup.leave()
        })

        task.resume()
    }
    
    func getPhotos(){
        dispatchGroup.enter()
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users/1/photos")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photos = try decoder.decode([Photo].self, from: data ?? Data())
                self.photos = photos
            } catch {
                print("error",error)
            }
            self.dispatchGroup.leave()
        })

        task.resume()
    }

}

extension UserDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumCell
        cell.nameLabel.text = self.albums[indexPath.row].title
        cell.photos = self.photos.filter({ (photo) -> Bool in
            photo.albumId == self.albums[indexPath.row].id
        })
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension UserDetailVC: ImageTappedDelegate {
    func imageTapped(photo: Photo) {
        let vc = PhotoDetailVC(nibName: "PhotoDetailVC", bundle: nil)
        vc.photo = photo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
