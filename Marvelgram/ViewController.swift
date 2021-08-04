//
//  ViewController.swift
//  Marvelgram
//
//  Created by Иван Карамазов on 02.08.2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    var heroesArray: [MarvelInfo] = []
    var selectedHero: MarvelInfo?
    var filteredHeroesArray: [MarvelInfo] = []
    @IBOutlet weak var heroes: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredHeroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hero", for: indexPath) as! HeroCardCollectionViewCell
        let hero = filteredHeroesArray[indexPath.row]
        cell.heroImage.sd_setImage(with: URL(string: hero.thumbnail.path + "." + hero.thumbnail.extension) , completed: nil)
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let collectionViewWidth: CGFloat = collectionView.frame.width
        let widthPerItem: CGFloat = collectionViewWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "detailViewController") as! DetailViewController
        let hero = filteredHeroesArray[indexPath.row]
        vc.marvel = hero
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        heroes.delegate = self
        heroes.dataSource = self
        NetworkService.shared.getMarvelHeroInfo { heroOption in
            guard let marvel = heroOption else {
                print("Can't get MarvelInfo")
                return
            }
            let filteredMarvel = marvel.filter {
                !$0.thumbnail.path.contains("image_not_available")
            }
            let encoder = JSONEncoder()
            if let results: Data = try? encoder.encode(filteredMarvel) {
                UserDefaults.standard.set(results, forKey: "marvelArray")
            }
            self.heroesArray = filteredMarvel
            self.filteredHeroesArray = filteredMarvel
            DispatchQueue.main.async {
                self.heroes.reloadData()
            }
        }
        
        setUpNavigationBar()
        self.searchBar.placeholder = "Search"
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            filteredHeroesArray = heroesArray.filter { $0.name.lowercased().contains(searchText.lowercased())}
            heroes.reloadData()
        }
        else {
            filteredHeroesArray = heroesArray
            heroes.reloadData()
        }
    }
    
    func setUpNavigationBar() {
        let nav = navigationController?.navigationBar
        //nav?.barTintColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.94)
        nav?.barTintColor = .clear
        nav?.tintColor = .clear
        nav?.tintColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70.51, height: 25.38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "marvel-logo")
        imageView.image = image
        
        let imageItem = UIBarButtonItem.init(customView: imageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        navigationItem.backButtonTitle = ""
        
    }


}

