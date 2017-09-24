//
//  Helpers.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//


import Foundation
import UIKit

extension String {
    
    var doesNOTcontainSpecialCharacters : Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@.١٢٣٤٥٦٧٨٩٠ضصثقفغعهخحجةشسيبلاتنمكظطذدزرو")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            //            print("string contains special characters")
            return false
        }else {
            return true
        }
    }
    
    var ispriceValue : Bool {
        
        let characterset = CharacterSet(charactersIn: "1234567890٠١٢٣٤٥٦٧٨٩")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            //            print("string contains special characters")
            return false
        }else {
            return true
        }
    }
    //let pattern = "^(009665|9665|\\+9665|05|5)?(5|0|3|6|4|9|1|8|7)([0-9]{7})$"
    //    func validate(value: String) -> Bool {
    //        let PHONE_REGEX = "^(009665|9665|\\+9665|05|5)?(5|0|3|6|4|9|1|8|7)([0-9]{7})$"
    //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    //        let result =  phoneTest.evaluate(with: value)
    //        return result
    //    }
    
    var validPhoneNumber : Bool  {
        //        print("that is the phone : \(self)")
        let PHONE_REGEX = "^(009665|9665|\\+9665|05|5)?(5|0|3|6|4|9|1|8|7)([0-9]{7})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        //        print("that is the phone result : \(result)")
        return result
        
    }
    /*
     انا دخلت
     0 5 0 1 4 7 2 5 8 1
     0511853257
     0 5 1 1 2 3 4 5 6 7
     مدخلشى
     */
    
    //To check text field or String is blank or not
    var isBlankOrLessThan3chr: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            guard trimmed.isEmpty , self.characters.count <= 3 else {
                
                return false
            }
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=8 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    
}

//extension UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { () -> Void in
//                self.image = image
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode)
//    }
//}









//public enum ImageFormat {
//    case png
//    case jpeg(CGFloat)
//}

//extension UIImage {
//    
//    public func base64(format: ImageFormat) -> String? {
//        var imageData: Data?
//        switch format {
//        case .png: imageData = UIImagePNGRepresentation(self)
//        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
//        }
//        return imageData?.base64EncodedString()
//    }
//}



//extension UIImageView {
//    
//    func setRounded() {
//        let radius = self.bounds.width / 2
//        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
//    }
//}






//extension UIImage {
//    var base64EncodedString: String? {
//        if let data = UIImagePNGRepresentation(self) {
//            //            let dataStr = data.base64EncodedString(options: [])
//            
//            return data.base64EncodedString(options: [.lineLength64Characters])
//        }
//        return nil
//    }
//}


//extension UIImage {
//    func resized(withPercentage percentage: CGFloat) -> UIImage? {
//        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
//        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: canvasSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//    func resized(toWidth width: CGFloat) -> UIImage? {
//        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
//        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: canvasSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//    
//    
//    
//    func resizeImageWith(newSize: CGSize) -> UIImage {
//        
//        let horizontalRatio = newSize.width / size.width
//        let verticalRatio = newSize.height / size.height
//        
//        let ratio = max(horizontalRatio, verticalRatio)
//        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
//        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
//        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
//    
//}
