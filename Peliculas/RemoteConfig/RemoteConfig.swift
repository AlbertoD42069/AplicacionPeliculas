//
//  RemoteConfig.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 21/06/22.
//

import Foundation
import FirebaseRemoteConfig

class ConfiguracionRemota {
    
    var remoteconfig: RemoteConfig
    
    init () {
        remoteconfig = RemoteConfig.remoteConfig()
    }
}
