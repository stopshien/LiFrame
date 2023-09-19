//
//  MapViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/18.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    var citiesArray = [City]()
    let dateFormatter = DateFormatter()
    let miniView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.clipsToBounds = true
        view.alpha = 0.9
        view.layer.cornerRadius = 30
        return view
    }()
    let moonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0.3, height: 1.5)
        return label
    }()
    let moonImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "moon.haze")
        return imageView
    }()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addSubview(miniView)
        miniView.addSubview(moonLabel)
        miniView.addSubview(moonImage)
        setMiniViewLayout()
        fectch(city: "臺北市")
        citiesToMap()
    }
    func setMiniViewLayout() {
        NSLayoutConstraint.activate([
            miniView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            miniView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            miniView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            miniView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            moonLabel.bottomAnchor.constraint(equalTo: miniView.bottomAnchor, constant: -10),
            moonLabel.centerXAnchor.constraint(equalTo: miniView.centerXAnchor),
            moonLabel.heightAnchor.constraint(equalTo: miniView.heightAnchor, multiplier: 0.3),
            moonImage.topAnchor.constraint(equalTo: miniView.topAnchor, constant: 10),
            moonImage.bottomAnchor.constraint(equalTo: moonLabel.topAnchor, constant: 0),
            moonImage.centerXAnchor.constraint(equalTo: miniView.centerXAnchor),
            moonImage.widthAnchor.constraint(equalTo: moonImage.heightAnchor, multiplier: 1)
        ])
    }
    func fectch(city: String) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        let apiKey = APIManager.shared.apiKey
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            return
        }
        let baseURL = "https://opendata.cwa.gov.tw/api/v1/rest/datastore/A-B0063-001?Authorization=\(key)&limit=3&format=JSON&CountyName=\(city)&Date=\(todayDate)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let baseURL = baseURL,
           let url = URL(string: baseURL) {
           let request = URLRequest(url: url)
             URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,let content = String(data: data, encoding: .utf8) {
                    do {
                        let result = try JSONDecoder().decode(Whether.self, from: data)
                        DispatchQueue.main.async {
                            self.moonLabel.text = "\(result.records.locations.location[0].time[0].moonSetTime) - " + "\(result.records.locations.location[0].time[0].moonRiseTime)"
                        }
                        print("===",result.records.locations.location[0].time[0].moonRiseTime)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    func citiesToMap() {
        if let data = NSDataAsset(name: "cities")?.data {
                 do {
                     let decoder = JSONDecoder()
                     let cities = try decoder.decode(Cities.self, from: data)
                     self.citiesArray = cities.cities
                     for city in citiesArray {
                         if let latitudinal = Double(city.latitudinal),
                            let longitude = Double(city.longitudinal){
                             let pin = MKPointAnnotation()
                             let coordinate = CLLocation(latitude: latitudinal, longitude: longitude).coordinate
                             pin.coordinate = coordinate
                             pin.title = city.name
                             mapView.addAnnotation(pin)
                         }
                     }
                 } catch {
                     print("==解析JSON時出錯：\(error)")
                 }
             } else {
                 print("==找不到JSON檔案")
             }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotaiotn = view.annotation,
           let title = annotaiotn.title,
           let newTitle = title {
            fectch(city: newTitle)
        }
    }
}
