//
//  SearchViewController.swift
//  Tokopedia-Julian
//
//  Created by Ignatio Julian on 1/2/21.
//

import UIKit
import SwiftyJSON
import Kingfisher
import ESPullToRefresh

class SearchViewController: ViewController {
    
    
    
    
    @IBOutlet weak var productItem: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    var query = ""
    var count = 0
    var result = [JSON]()
    var minPrice = 1000
    var maxPrice = 30000000
    var wholesale = false
    var official = false
    var gold = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productItem.delegate = self
        self.productItem.dataSource = self
        
        productItem.es.addInfiniteScrolling {
            // Scrolling code
            let apiURL = "https://ace.tokopedia.com/search/v2.5/product?q=\(self.query)&pmin=\(self.minPrice)&pmax=\(self.maxPrice)&wholesale=\(self.wholesale)&official=\(self.official)&fshop=\(self.gold)&start=\(self.count)&rows=10"
            
            let url = URL(string: apiURL)
            let urlRequest = URLRequest(url: url!)
            let session = URLSession(configuration: .default)
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let task = session.dataTask(with: urlRequest,completionHandler: {(data, response, error) in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                guard let responseData = data else {
                    print("Did not receive any data")
                    return
                }
                let json = JSON(responseData)
                self.result.append(contentsOf: json["data"].array!)
                
                if json.count == 0 {
                    print("Empty")
                } else if json.count > 3 {
                    DispatchQueue.main.async {
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.count += (self.result.count)
                        self.productItem.reloadData()
                    }
                }
            })
            task.resume()
            self.productItem.es.noticeNoMoreData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let urlString = "https://ace.tokopedia.com/search/v2.5/product?q=\(self.query)&pmin=\(self.minPrice)&pmax=\(self.maxPrice)&wholesale=\(self.wholesale)&official=\(self.official)&fshop=\(self.gold)&start=\(self.count)&rows=10"
        
        
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let responseData = data else {
                print("Did not receive any data")
                return
            }
            let json = JSON(responseData)
            self.result.append(contentsOf: json["data"].array!)
            
            if json.count == 0 {
                print("empty")
            }else if json.count > 3{
                DispatchQueue.main.sync {
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.count += (self.result.count)
                    self.productItem.reloadData()
                }
            }
            
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func showFilter(_ sender: Any) {
        let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "filter") as! FilterViewController
        viewcontroller.query = query
        viewcontroller.minPrice = minPrice
        viewcontroller.maxPrice = maxPrice
        viewcontroller.gold = gold
        viewcontroller.wholesale = wholesale
        viewcontroller.official = official
   navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ItemsCollectionViewCell
        cell.image.kf.setImage(with: result[indexPath.row]["image_uri"].url)
        cell.lblProduct.text = result[indexPath.row]["name"].stringValue
        cell.lblPrice.text = result[indexPath.row]["price"].stringValue
        
    
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
}
