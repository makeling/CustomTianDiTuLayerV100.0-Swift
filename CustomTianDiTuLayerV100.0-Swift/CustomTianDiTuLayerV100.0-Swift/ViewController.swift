//
//  ViewController.swift
//  CustomTianDiTuLayerV100.0-Swift
//
//  Created by maklMac on 2/7/17.
//  Copyright © 2017 esrichina.com. All rights reserved.
//

import UIKit
import ArcGIS


class ViewController: UIViewController {

    @IBOutlet weak var mapView: AGSMapView!
    
    private var map: AGSMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.map = AGSMap()
        
        let tdtInfo = TianDiTuLayerInfo(layerType: TianDiTuLayerType.TDT_VECTOR, spttype: TianDiTuSpatialReferenceType.TDT_MERCATOR)
        
        let tdtannoInfo = TianDiTuLayerInfo(layerType: TianDiTuLayerType.TDT_VECTOR, lan: TianDiTuLanguageType.TDT_CN, spttype: TianDiTuSpatialReferenceType.TDT_MERCATOR)
        
        let ltl1 = TianDiTuLayer(tiandituLayerInfo: tdtInfo)
        
        let ltl2 = TianDiTuLayer(tiandituLayerInfo: tdtannoInfo)
        
        self.map.operationalLayers.add(ltl1)
        self.map.operationalLayers.add(ltl2)
        
        self.mapView.map = self.map
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

