//
//  TianDiTuLayerInfo.swift
//  CustomTianDiTuLayerV100.0-Swift
//
//  Created by maklMac on 2/7/17.
//  Copyright © 2017 esrichina.com. All rights reserved.
//

import Foundation
import ArcGIS

enum TianDiTuLayerType{
    case TDT_VECTOR  ///<天地图矢量服务>
    case TDT_IMAGE   ///<天地图影像务>
    case TDT_TERRAIN  ///<天地图地形服务>
}

enum TianDiTuLanguageType{
    case TDT_CN  ///<天地图中文标注服务>
    case TDT_EN ///<天地图英文标注服务>
}

enum TianDiTuSpatialReferenceType{
    case TDT_MERCATOR ///<天地图墨卡托服务>
    case TDT_2000 ///<天地图2000服务>

}



class TianDiTuLayerInfo{
    
    let kURLGetTile = "http://t0.tianditu.com/%@/wmts?service=wmts&request=gettile&version=1.0.0&layer=%@&format=tiles&tilematrixset=%@"
    
    let tiandituURL = "http://t0.tianditu.com/%@/wmts"
    
    let X_MIN_MERCATOR = -20037508.3427892
    let Y_MIN_MERCATOR = -20037508.3427892
    let X_MAX_MERCATOR = 20037508.3427892
    let Y_MAX_MERCATOR = 20037508.3427892
    
    let X_MIN_2000 = -180.0
    let Y_MIN_2000 = -90.0
    let X_MAX_2000 = 180.0
    let Y_MAX_2000 = 90.0
    
    let _minZoomLevel = 0
    let _maxZoomLevel = 16
    let _tileWidth = 256
    let _tileHeight = 256
    let _dpi = 96
    
    let _WebMercator = 102100
    let _GCS2000 = 2000
    
    let kTILE_MATRIX_SET_MERCATOR = "w"
    let kTILE_MATRIX_SET_2000 = "c"
    
 

    
    private var layername:String!
    private var servicename:String!
    private var tilematrixset:String!
    private var sp:AGSSpatialReference!
    public var fullExtent: AGSEnvelope!
    private var origin: AGSPoint!
    private var lods:NSMutableArray!
    public var tileInfo:AGSTileInfo!
    
    init(layerType:TianDiTuLayerType, spttype:TianDiTuSpatialReferenceType) {
        self.layername = ""
        
        switch layerType{
            
        case TianDiTuLayerType.TDT_VECTOR :
            self.layername = "vec"
           
        case TianDiTuLayerType.TDT_IMAGE :
            self.layername = "img"
            
        case TianDiTuLayerType.TDT_TERRAIN:
            self.layername = "ter"
            
        }
        
        self.setSpatialReference(sptype: spttype)
        self.tileInfo = self.getTianDiTuLayerInfo()
        
    }
    
    init(layerType:TianDiTuLayerType, lan:TianDiTuLanguageType, spttype:TianDiTuSpatialReferenceType){
        
        self.layername = ""
        
        switch layerType{
            
        case TianDiTuLayerType.TDT_VECTOR :
            switch lan {
                case TianDiTuLanguageType.TDT_CN:
                    self.layername = "cva"
                case TianDiTuLanguageType.TDT_EN:
                    self.layername = "eva"
            }
         
        case TianDiTuLayerType.TDT_IMAGE :
            switch lan {
                case TianDiTuLanguageType.TDT_CN:
                    self.layername = "cia"
                case TianDiTuLanguageType.TDT_EN:
                    self.layername = "eia"
            }
            
        case TianDiTuLayerType.TDT_TERRAIN:
            self.layername = "cta"
            
        }

        self.setSpatialReference(sptype: spttype)
        self.tileInfo = self.getTianDiTuLayerInfo()

    }
    
    func getTianDiTuServiceURL()->(String){
        
        let wmtsURL = String(format: kURLGetTile, self.servicename, self.layername, self.tilematrixset)

        
      return wmtsURL
    }
    
    func getTianDiTuLayerInfo() -> (AGSTileInfo){
        
        let tileInfo = AGSTileInfo(dpi: _dpi, format: AGSTileImageFormat.PNG32, levelsOfDetail: self.lods as! [AGSLevelOfDetail], origin: self.origin, spatialReference: self.sp, tileHeight: _tileHeight, tileWidth: _tileWidth)
        
        return tileInfo
    }
    
    func setSpatialReference(sptype:TianDiTuSpatialReferenceType){
        
        self.sp = AGSSpatialReference(wkid: 102100)
        self.lods = NSMutableArray()
        
        var _baseScale = 2.958293554545656E8
        var _baseRelu = 78271.51696402048
        
        
        switch sptype {
        case TianDiTuSpatialReferenceType.TDT_MERCATOR :
            self.sp = AGSSpatialReference(wkid: _WebMercator)
            self.servicename = self.layername.appending("_").appending(kTILE_MATRIX_SET_MERCATOR)
            
            self.tilematrixset = kTILE_MATRIX_SET_MERCATOR;
            self.origin = AGSPoint(x: X_MIN_MERCATOR, y: Y_MAX_MERCATOR, spatialReference: self.sp)
            
            self.fullExtent = AGSEnvelope(xMin: X_MIN_MERCATOR, yMin: Y_MIN_MERCATOR, xMax: X_MAX_MERCATOR, yMax: Y_MAX_MERCATOR, spatialReference: self.sp)
            
            _baseRelu = 78271.51696402048
            
        case TianDiTuSpatialReferenceType.TDT_2000 :
            self.sp = AGSSpatialReference(wkid: _GCS2000)
            self.servicename = self.layername.appending("_").appending(kTILE_MATRIX_SET_2000)
            
            self.tilematrixset = kTILE_MATRIX_SET_2000;
            self.origin = AGSPoint(x: X_MIN_2000, y: Y_MAX_2000, spatialReference: self.sp)
            
            self.fullExtent = AGSEnvelope(xMin: X_MIN_2000, yMin: Y_MIN_2000, xMax: X_MAX_2000, yMax: Y_MAX_2000, spatialReference: self.sp)
            
            _baseRelu = 0.7031249999891485
          
        }
        
        //build lods by for loop from 0 to 17 level
        for i in 0...17
        {
            let level = AGSLevelOfDetail(level: i, resolution: _baseRelu, scale: _baseScale)
            self.lods.add(level)
            
            _baseRelu = _baseRelu / 2
            _baseScale = _baseScale / 2
            

            
            
//            print(_baseRelu, " :", _baseScale)
//            print(_baseScale)
        }
    }

    
}
