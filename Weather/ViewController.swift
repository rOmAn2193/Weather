//
//  ViewController.swift
//  Weather
//
//  Created by Roman on 1/12/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherActivityIndicator: UIActivityIndicatorView!


    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!

    @IBOutlet weak var locationHeaderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var maxTempHeaderLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!

    @IBOutlet weak var minTempHeaderLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!

    @IBOutlet weak var moonriseHeaderLabel: UILabel!
    @IBOutlet weak var moonriseLabel: UILabel!

    @IBOutlet weak var moonsetHeaderLabel: UILabel!
    @IBOutlet weak var moonsetLabel: UILabel!

    @IBOutlet weak var sunriseHeaderLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!

    @IBOutlet weak var sunsetHeaderLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!

    var key: String = "65c85e1239e162125ce55fb77c8c7"

    @IBAction func getWeather(sender: AnyObject)
    {
        self.view.endEditing(true)

        if cityTextField.text == ""
        {
            print("Please provide the city")
        }
        else
        {
            weatherActivityIndicator.startAnimating()

            let urlString1 = "http://api.worldweatheronline.com/free/v2/weather.ashx?q="
            var urlString2 = cityTextField.text
            urlString2 = urlString2?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let urlString3 = "&format=json&num_of_days=1&key="
            let urlString4 = key

            let urlString = urlString1 + urlString2! + urlString3 + urlString4

            let url = NSURL(string: urlString)

            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig)
            let task = session.dataTaskWithURL(url!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

                if error != nil
                {
                    print(error)
                }
                else
                {
                    var jsonResult = NSDictionary()
                    do
                    {
                        jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }
                    catch _ {
                        print("Error Loading Weather Info")
                    }

                    let mainObject: NSDictionary = jsonResult.objectForKey("data")! as! NSDictionary

                    let currentConditions: NSArray = mainObject.objectForKey("current_condition")! as! NSArray

                    // Image Extraction
                    let icon: NSArray = currentConditions[0]["weatherIconUrl"] as! NSArray
                    let iconPathUrlString: String = icon[0]["value"] as! String

                    let iconURL: NSURL = NSURL(string: iconPathUrlString)!
                    let iconData: NSData = NSData(contentsOfURL: iconURL)!

                    self.weatherIconImage.image = UIImage(data: iconData)

                    let currentTemperature: String = currentConditions[0]["temp_C"] as! String
                    self.temperatureLabel.text = currentTemperature + "° C"

                    let weather: NSArray = mainObject.objectForKey("weather")! as! NSArray
                    let weatherDictionary: NSDictionary = weather.objectAtIndex(0) as! NSDictionary
                    let astronomyArray: NSArray = weatherDictionary.objectForKey("astronomy") as! NSArray

                    let moonriseTime: String = astronomyArray[0]["moonrise"] as! String
                    self.labelControl(headerLabel: self.moonriseHeaderLabel, label: self.moonriseLabel, text: moonriseTime)

                    let moonsetTime: String = astronomyArray[0]["moonset"] as! String
                    self.labelControl(headerLabel: self.moonsetHeaderLabel, label: self.moonsetLabel, text: moonsetTime)

                    let sunriseTime: String = astronomyArray[0]["sunrise"] as! String
                    self.labelControl(headerLabel: self.sunriseHeaderLabel, label: self.sunriseLabel, text: sunriseTime)

                    let sunsetTime: String = astronomyArray[0]["sunset"] as! String
                    self.labelControl(headerLabel: self.sunsetHeaderLabel, label: self.sunsetLabel, text: sunsetTime)

                    let maxTemp: String = weatherDictionary.objectForKey("maxtempC")! as! String
                    self.labelControl(headerLabel: self.maxTempHeaderLabel, label: self.maxTempLabel, text: maxTemp)

                    let minTemp: String = weatherDictionary.objectForKey("mintempC")! as! String
                    self.labelControl(headerLabel: self.minTempHeaderLabel, label: self.minTempLabel, text: minTemp)

                    let locationDetails: NSArray = mainObject.objectForKey("request")! as! NSArray
                    let city: String = locationDetails[0]["query"]! as! String
                    self.labelControl(headerLabel: self.locationHeaderLabel, label: self.locationLabel, text: city)
                }

                self.weatherActivityIndicator.stopAnimating()
            })

            task.resume()
        }


    }

    func labelControl(headerLabel headerLabel: UILabel, label: UILabel, text: String)
    {
        headerLabel.hidden = false
        label.text = text
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cityTextField.text = "London"
        temperatureLabel.text = ""
        locationLabel.text = ""
        maxTempLabel.text = ""
        minTempLabel.text = ""
        moonriseLabel.text = ""
        moonsetLabel.text = ""
        sunriseLabel.text = ""
        sunsetLabel.text = ""

        weatherActivityIndicator.hidesWhenStopped = true

        locationHeaderLabel.hidden = true
        maxTempHeaderLabel.hidden = true
        minTempHeaderLabel.hidden = true
        moonriseHeaderLabel.hidden = true
        moonsetHeaderLabel.hidden = true
        sunriseHeaderLabel.hidden = true
        sunsetHeaderLabel.hidden = true

        self.view.backgroundColor = UIColor(red: 150/255, green: 180/255, blue: 228/255, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

