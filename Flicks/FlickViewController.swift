//
//  FlickViewController.swift
//  Flicks
//
//  Created by hollywoodno on 3/31/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class FlickViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    //Mark: Properties
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allow table view to be fed data and controlled by this view controller
        tableView.dataSource = self
        tableView.delegate = self
        
        //Mark: Network Request
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // The data of interest is stored in the 'results' key.
                        // It will be the movies.
                        let responseFieldDictionary = responseDictionary["results"] as! [NSDictionary]
                        
                        self.movies = responseFieldDictionary
                        
                        // update table view with return network data
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    //Mark: Construct table view and rows
    
    // 1 of 2 required method by UITableViewDataSource Protocol
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    
    // 2 of 2 required method by UITableViewDataSource Protocol
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Flick cell is a resuable custom cell that will display movie specs
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickCell") as! FlickTableViewCell
        
        
        // Cell specs
        let movie_title = movies[indexPath.row]["original_title"] as! String
        cell.titleLabel.text = "\(movie_title)"
        
        return cell
    }

    //Mark: TODOs
    /* Safety checks for API calls */
    /* Update cell specs */
    /* Create details view */
}