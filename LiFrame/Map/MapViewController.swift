//
//  MapViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/18.
//

import UIKit
import MapKit
import WeatherKit
class MapViewController: UIViewController {
    lazy var constraint = miniView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 300)
    let weatherService = WeatherService()
    var citiesArray = [City]()
    let dateFormatter = DateFormatter()
    let miniView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColorSet
        view.clipsToBounds = true
        view.alpha = 0.9
        view.layer.cornerRadius = 30
        return view
    }()
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0.3, height: 1.5)
        return label
    }()
    let moonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0.3, height: 1.5)
        return label
    }()
    let moonImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.size(40)
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "moon.haze")
        return imageView
    }()
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0.3, height: 1.5)
        return label
    }()
    let tempImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.size(40)
        imageView.image = UIImage(systemName: "thermometer.sun")
        return imageView
    }()
    let cloudLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0.3, height: 1.5)
        return label
    }()
    let cloudImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.size(40)
        imageView.image = UIImage(systemName: "smoke")
        return imageView
    }()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addSubview(miniView)
        miniView.addSubview(cityNameLabel)
        miniView.addSubview(moonLabel)
        miniView.addSubview(moonImage)
        miniView.addSubview(tempLabel)
        miniView.addSubview(tempImage)
        miniView.addSubview(cloudLabel)
        miniView.addSubview(cloudImage)
        setMiniViewLayout()
        cityNameLabel.text = "請點選城市"
        citiesToMap()
        moonImage.isHidden = true
        cloudImage.isHidden = true
        tempImage.isHidden = true
        NSLayoutConstraint.activate([
        constraint,
        miniView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 0),
        miniView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 0),
        miniView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 0.3)
        ])
    }
    func setMiniViewLayout() {
        let screenSize = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: miniView.topAnchor, constant: 10),
            cityNameLabel.centerXAnchor.constraint(equalTo: miniView.centerXAnchor),
            moonImage.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            moonImage.centerXAnchor.constraint(equalTo: miniView.centerXAnchor, constant: -screenSize.width/4.5),
            moonLabel.centerYAnchor.constraint(equalTo: moonImage.centerYAnchor),
            moonLabel.centerXAnchor.constraint(equalTo: miniView.centerXAnchor, constant: screenSize.width/5),
            tempImage.topAnchor.constraint(equalTo: moonImage.bottomAnchor, constant: 5),
            tempImage.centerXAnchor.constraint(equalTo: miniView.centerXAnchor, constant: -screenSize.width/4.5),
            tempLabel.centerYAnchor.constraint(equalTo: tempImage.centerYAnchor),
            tempLabel.centerXAnchor.constraint(equalTo: miniView.centerXAnchor, constant: screenSize.width/6),
            cloudImage.topAnchor.constraint(equalTo: tempImage.bottomAnchor, constant: 5),
            cloudImage.centerXAnchor.constraint(equalTo: miniView.centerXAnchor, constant: -screenSize.width/4.5),
            cloudLabel.centerYAnchor.constraint(equalTo: cloudImage.centerYAnchor),
            cloudLabel.centerXAnchor.constraint(equalTo: miniView.centerXAnchor, constant: screenSize.width/6)
        ])
    }
    func fetchMoonApi(city: String) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        let apiKey = APIManager.shared.apiKey
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            return
        }
        let baseURL = "https://opendata.cwa.gov.tw/api/v1/rest/datastore/A-B0063-001?Authorization=\(key)&limit=1&format=JSON&CountyName=\(city)&Date=\(todayDate)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let baseURL = baseURL,
           let url = URL(string: baseURL) {
           let request = URLRequest(url: url)
             URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,let content = String(data: data, encoding: .utf8) {
                    do {
                        let result = try JSONDecoder().decode(Weather.self, from: data)
                        DispatchQueue.main.async {
                            let moonRiseTime = result.records.locations.location[0].time[0].moonRiseTime
                            let moonSetTime = result.records.locations.location[0].time[0].moonSetTime
                            self.moonLabel.text = "\(moonRiseTime) - " + "\(moonSetTime)    "
                            self.cityNameLabel.text = city
                        }
                        print("===",result.records.locations.location[0].time[0])
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
                            let longitude = Double(city.longitudinal) {
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
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mapView.resignFirstResponder()
        UIView.animate(withDuration: 0.6) {
            self.constraint.constant = 300
            self.mapView.layoutIfNeeded()
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotaiotn = view.annotation,
           let title = annotaiotn.title,
           let newTitle = title {
            fetchMoonApi(city: newTitle)
            let coordinate = CLLocation(latitude: annotaiotn.coordinate.latitude, longitude: annotaiotn.coordinate.longitude)
            mapView.centerToLocation(coordinate)
            getWeather(location: coordinate)
            moonImage.isHidden = false
            cloudImage.isHidden = false
            tempImage.isHidden = false

            mapView.layoutIfNeeded()
            UIView.animate(withDuration: 0.6) {
                self.constraint.constant = -30
                self.mapView.layoutIfNeeded()
            }
        }
    }
    func getWeather(location: CLLocation) {
        Task {
            do {
                let result = try await weatherService.weather(for: location)
                tempLabel.text = result.currentWeather.temperature.description
                cloudLabel.text = result.currentWeather.condition.description
            } catch {
                 print(String(describing: error))
            }
        }
    }
}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 100000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
