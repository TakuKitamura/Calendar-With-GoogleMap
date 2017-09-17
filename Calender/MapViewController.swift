import UIKit
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController, GMSPlacePickerViewControllerDelegate {
    
    private var placesClient: GMSPlacesClient!
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    private var nameLabel: UILabel!
    private var addressLabel: UILabel!
    private var testButton: UIButton!
    
    private var placePicker: GMSPlacePickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        self.nameLabel = UILabel()
        
        self.nameLabel.text = "name"
        
        self.nameLabel.frame.origin = CGPoint(x: 200, y: 100)
        
        self.nameLabel.font = UIFont(name: "HiraMinProN-W3", size: 20)
        self.nameLabel.sizeToFit()
        
        self.nameLabel.backgroundColor = UIColor.red
        
        self.view.addSubview(self.nameLabel)
        
        self.addressLabel = UILabel()
        
        self.addressLabel.text = "address"
        
        self.addressLabel.frame.origin = CGPoint(x: 200, y: 200)
        
        self.addressLabel.font = UIFont(name: "HiraMinProN-W3", size: 20)
        self.addressLabel.sizeToFit()
        
        self.addressLabel.backgroundColor = UIColor.red
        
        self.view.addSubview(self.addressLabel)
        
        self.testButton = UIButton()
        
        self.testButton.frame = CGRect(x: 200, y: 113, width: 100, height: 20)
        
        self.testButton.backgroundColor = UIColor.gray
        
        self.testButton.setTitle("ボタン", for: .normal)
        
        self.testButton.addTarget(self, action: #selector(MapViewController.pickPlace(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.testButton)

        
    }
    
    /*
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    func getCurrentPlace(_ sender: UIButton) {
        
        let locationManager = CLLocationManager()
        // For getting the user permission to use location service when the app is running
        locationManager.requestWhenInUseAuthorization()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    print(self.nameLabel)
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                    
                    print(self.addressLabel)
                }
            }
        })
    }
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    func pickPlace(_ sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: 37.788204, longitude: -122.411937)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.nameLabel.text = place.name
                self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
            } else {
                self.nameLabel.text = "No place selected"
                self.addressLabel.text = ""
            }
            
            print(self.nameLabel)
            print(self.addressLabel)
        })
    }
    */
    
    // The code snippet below shows how to create and display a GMSPlacePickerViewController.
    func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
    
        self.placePicker = GMSPlacePickerViewController(config: config)
        
        self.placePicker.delegate = self
        
        present(self.placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ mapViewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        mapViewController.dismiss(animated: true, completion: nil)
        print(place)
        /*
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        */
    }
    
    func placePickerDidCancel(_ mapViewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        mapViewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
}
