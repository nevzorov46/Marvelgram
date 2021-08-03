//
//  ViewController.swift
//  Marvelgram
//
//  Created by Иван Карамазов on 02.08.2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var heroesArray: [MarvelInfo] = []
    var selectedHero: MarvelInfo?
    @IBOutlet weak var heroes: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hero", for: indexPath) as! HeroCardCollectionViewCell
        let hero = heroesArray[indexPath.row]
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
        let hero = heroesArray[indexPath.row]
        vc.marvel = hero
        vc.marvelArray = heroesArray
        self.navigationController?.pushViewController(vc, animated: true)
        //selectedHero = hero
        //performSegue(withIdentifier: "openDetail", sender: nil)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetail", let vc = segue.destination as? DetailViewController, let hero = selectedHero {
            vc.marvel = hero
            vc.marvelArray = heroesArray
        }
    }
 */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.heroesArray = filteredMarvel
            DispatchQueue.main.async {
                self.heroes.reloadData()
            }
        }
        
        setUpNavigationBar()
        
    }
    
    func setUpNavigationBar() {
        let nav = navigationController?.navigationBar
        nav?.barTintColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.94)
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

