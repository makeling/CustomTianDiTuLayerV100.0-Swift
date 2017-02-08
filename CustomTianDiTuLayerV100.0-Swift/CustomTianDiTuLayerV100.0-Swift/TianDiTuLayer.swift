//
//  TianDiTuLayer.swift
//  CustomTianDiTuLayerV100.0-Swift
//
//  Created by maklMac on 2/7/17.
//  Copyright © 2017 esrichina.com. All rights reserved.
//

import Foundation
import ArcGIS

class TianDiTuLayer:AGSImageTiledLayer{
    
    init(tiandituLayerInfo:TianDiTuLayerInfo){
        
        super.init(tileInfo: tiandituLayerInfo.tileInfo, fullExtent:tiandituLayerInfo.fullExtent)
        
        self.tileRequestHandler = {[weak self](tileKey:AGSTileKey) -> () in
            
            let mainURL = tiandituLayerInfo.getTianDiTuServiceURL()
            
            let requestUrl1 = mainURL.appending("&tilecol=%ld&tilerow=%ld&tilematrix=%ld")
            
            let requestUrl = String(format: requestUrl1, tileKey.column,tileKey.row, (tileKey.level + 1))
            
            let aURL = NSURL(string: requestUrl)
            
            let imageData = NSData(contentsOf: aURL as! URL)
            
            let img = UIImage(data: imageData as! Data)
            
            self?.respond(with: tileKey, data: UIImagePNGRepresentation(img!), error: nil)
            
        }
        
    }
}

