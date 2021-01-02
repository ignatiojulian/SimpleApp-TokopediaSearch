//
//  ViewController.swift
//  Tokopedia-Julian
//
//  Created by Ignatio Julian on 1/2/21.
//

import UIKit
import SwiftyJSON
import SystemConfiguration

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData: [String]!
    
    let data = ["Baju", "Komputer", "", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filteredData = data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell",for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
//        cell.target(forAction: Selector(("buttonClicked")), withSender: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filteredData[indexPath.row])
        print(indexPath.row)
        
        if isConnectedToNetwork(){
            print("Connected!")
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = mainStoryboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
            let queryFiltered = filteredData[indexPath.row]
            destinationVC.query = queryFiltered
            navigationController?.pushViewController(destinationVC, animated: true)
        } else {
            print("Disconnected!")
            let alert = UIAlertController(title: "Reminder", message: "You need to have an internet connection to use the app", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func buttonClicked(sender:AnyObject) {
//        print("button clicked!")
//    }
    
    
    // MARK: - Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == "" {
            filteredData = data
        } else {
            for myData in data {
                if myData.lowercased().contains(searchText.lowercased()) {
                    
                    filteredData.append(myData)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Checking connnection
    
    func isConnectedToNetwork() -> Bool {
        guard let flags = getFlags() else {return false}
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func getFlags() -> SCNetworkReachabilityFlags? {
        guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
            return nil
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return nil
        }
        return flags
    }
    
    func ipv6Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    
    func ipv4Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
}


