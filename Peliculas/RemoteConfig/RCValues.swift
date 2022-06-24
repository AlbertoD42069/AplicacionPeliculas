//
//  RCValues.swift
//  cencosud.supermercados
//
//  Created by Adrian Dominguez Gómez on 21/06/22.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

enum ValueKey: String {
    case TitleButtonRegister
    case TitleRegisterScreen
}

class RCValues {
  static let sharedInstance = RCValues()
  var loadingDoneCallback: (() -> Void)?
  var fetchComplete = false

  private init() {
    loadDefaultValues()
    fetchCloudValues()
  }

  func loadDefaultValues() {
    let appDefaults: [String: Any?] = [
        ValueKey.TitleButtonRegister.rawValue: "Local",
        ValueKey.TitleRegisterScreen.rawValue: "Loca"
    ]
      
    RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
  }

  func fetchCloudValues() {
    activateDebugMode()
      

      RemoteConfig.remoteConfig().fetch { [weak self] (status, error) in
          if let error = error {
              print("Uh-oh. Got an error fetching remote values \(error)")
              // In a real app, you would probably want to call the loading done callback anyway,
              // and just proceed with the default values. I won't do that here, so we can call attention
              // to the fact that Remote Config isn't loading.
              return
          }
          
          if status == .success {
              print("Config fetched!")
              RemoteConfig.remoteConfig().activate { [weak self] _, _ in
                  print("Retrieved values from the cloud!")
                  self?.fetchComplete = true
                  DispatchQueue.main.async {
                      self?.loadingDoneCallback?()
                  }
              }
          }else{
              print("Config not fetched")
              print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
          
          
      }
  }

  func activateDebugMode() {
    let settings = RemoteConfigSettings()
    // WARNING: Don't actually do this in production!
    settings.minimumFetchInterval = 0
    RemoteConfig.remoteConfig().configSettings = settings
  }

//  func color(forKey key: ValueKey) -> UIColor {
//    let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFFFF"
//    let convertedColor = UIColor(colorAsHexString)
//    return convertedColor
//  }

  func bool(forKey key: ValueKey) -> Bool {
    print(key.rawValue)
    return RemoteConfig.remoteConfig()[key.rawValue].boolValue
  }

  func string(forKey key: ValueKey) -> String {
    RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
  }

  func double(forKey key: ValueKey) -> Double {
    RemoteConfig.remoteConfig()[key.rawValue].numberValue.doubleValue
  }
}
