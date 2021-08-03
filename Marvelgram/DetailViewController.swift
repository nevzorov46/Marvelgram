//
//  DetailViewController.swift
//  Marvelgram
//
//  Created by Иван Карамазов on 03.08.2021.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   

    @IBOutlet weak var bottomHeroes: UICollectionView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroDescription: UILabel!
    
    var marvel: MarvelInfo?
    //var marvelArray: [MarvelInfo]?
    var marvelArrayFiltered: [MarvelInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let detailMarvel = marvel else { return }
        heroImageView.sd_setImage(with: URL(string: detailMarvel.thumbnail.path + "." + detailMarvel.thumbnail.extension), completed: nil)
        heroDescription.text  = detailMarvel.description
        self.title = detailMarvel.name
        
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "marvelArray"),
           let array = try? decoder.decode([MarvelInfo].self, from: data) {
            marvelArrayFiltered = array.filter {$0.id != detailMarvel.id}.shuffled()
        }
        
        bottomHeroes.dataSource = self
        bottomHeroes.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        marvelArrayFiltered?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomHero", for: indexPath) as! HeroCardCollectionViewCell
        if let hero = marvelArrayFiltered?[indexPath.row] {
            cell.heroImage.sd_setImage(with: URL(string: hero.thumbnail.path + "." + hero.thumbnail.extension), completed: nil)
        }
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
        if let hero = marvelArrayFiltered?[indexPath.row] {
            vc.marvel = hero
            
        }
        //vc.marvelArray = marvelArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
