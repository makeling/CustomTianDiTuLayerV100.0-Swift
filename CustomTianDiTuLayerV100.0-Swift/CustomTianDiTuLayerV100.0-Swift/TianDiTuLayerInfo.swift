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
    private var lods:NSArray!
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
        
        switch sptype {
        case TianDiTuSpatialReferenceType.TDT_MERCATOR :
            self.sp = AGSSpatialReference(wkid: _WebMercator)
            self.servicename = self.layername.appending("_").appending(kTILE_MATRIX_SET_MERCATOR)
            
            self.tilematrixset = kTILE_MATRIX_SET_MERCATOR;
            self.origin = AGSPoint(x: X_MIN_MERCATOR, y: Y_MAX_MERCATOR, spatialReference: self.sp)
            
            self.fullExtent = AGSEnvelope(xMin: X_MIN_MERCATOR, yMin: Y_MIN_MERCATOR, xMax: X_MAX_MERCATOR, yMax: Y_MAX_MERCATOR, spatialReference: self.sp)
            

            self.lods = [
                AGSLevelOfDetail(level: 1 , resolution:78271.51696402048 ,scale: 2.958293554545656E8),
                AGSLevelOfDetail(level: 2 , resolution:39135.75848201024 ,scale: 1.479146777272828E8),
                AGSLevelOfDetail(level: 3 , resolution:19567.87924100512 ,scale: 7.39573388636414E7),
                AGSLevelOfDetail(level: 4 , resolution:9783.93962050256 ,scale: 3.69786694318207E7),
                AGSLevelOfDetail(level: 5 , resolution:4891.96981025128 ,scale: 1.848933471591035E7),
                AGSLevelOfDetail(level: 6 , resolution:2445.98490512564 ,scale: 9244667.357955175),
                AGSLevelOfDetail(level: 7 , resolution:1222.99245256282 ,scale: 4622333.678977588),
                AGSLevelOfDetail(level: 8 , resolution:611.49622628141 ,scale: 2311166.839488794),
                AGSLevelOfDetail(level: 9 , resolution:305.748113140705 ,scale: 1155583.419744397),
                AGSLevelOfDetail(level: 10 , resolution:152.8740565703525 ,scale: 577791.7098721985),
                AGSLevelOfDetail(level: 11 , resolution:76.43702828517625 ,scale: 288895.85493609926),
                AGSLevelOfDetail(level: 12 , resolution:38.21851414258813 ,scale: 144447.92746804963),
                AGSLevelOfDetail(level: 13 , resolution:19.109257071294063 ,scale: 72223.96373402482),
                AGSLevelOfDetail(level: 14 , resolution:9.554628535647032 ,scale: 36111.98186701241),
                AGSLevelOfDetail(level: 15 , resolution:4.777314267823516 ,scale: 18055.990933506204),
                AGSLevelOfDetail(level: 16 , resolution:2.388657133911758 ,scale: 9027.995466753102),
                AGSLevelOfDetail(level: 17 , resolution:1.194328566955879 ,scale: 4513.997733376551),
                AGSLevelOfDetail(level: 18 , resolution:0.5971642834779395 ,scale: 2256.998866688275)
                ]
            
        case TianDiTuSpatialReferenceType.TDT_2000 :
            self.sp = AGSSpatialReference(wkid: _GCS2000)
            self.servicename = self.layername.appending("_").appending(kTILE_MATRIX_SET_2000)
            
            self.tilematrixset = kTILE_MATRIX_SET_2000;
            self.origin = AGSPoint(x: X_MIN_2000, y: Y_MAX_2000, spatialReference: self.sp)
            
            self.fullExtent = AGSEnvelope(xMin: X_MIN_2000, yMin: Y_MIN_2000, xMax: X_MAX_2000, yMax: Y_MAX_2000, spatialReference: self.sp)
            
            
            self.lods = [
                AGSLevelOfDetail(level: 1 , resolution:0.7031249999891485 ,scale: 2.958293554545656E8),
                AGSLevelOfDetail(level: 2 , resolution:0.35156249999999994 ,scale: 1.479146777272828E8),
                AGSLevelOfDetail(level: 3 , resolution:0.17578124999999997 ,scale: 7.39573388636414E7),
                AGSLevelOfDetail(level: 4 , resolution:0.08789062500000014 ,scale: 3.69786694318207E7),
                AGSLevelOfDetail(level: 5 , resolution:0.04394531250000007 ,scale: 1.848933471591035E7),
                AGSLevelOfDetail(level: 6 , resolution:0.021972656250000007 ,scale: 9244667.357955175),
                AGSLevelOfDetail(level: 7 , resolution:0.01098632812500002 ,scale: 4622333.678977588),
                AGSLevelOfDetail(level: 8 , resolution:0.00549316406250001 ,scale: 2311166.839488794),
                AGSLevelOfDetail(level: 9 , resolution:0.0027465820312500017 ,scale: 1155583.419744397),
                AGSLevelOfDetail(level: 10 , resolution:0.0013732910156250009 ,scale: 577791.7098721985),
                AGSLevelOfDetail(level: 11 , resolution:0.000686645507812499 ,scale: 288895.85493609926),
                AGSLevelOfDetail(level: 12 , resolution:0.0003433227539062495 ,scale: 144447.92746804963),
                AGSLevelOfDetail(level: 13 , resolution:0.00017166137695312503 ,scale: 72223.96373402482),
                AGSLevelOfDetail(level: 14 , resolution:0.00008583068847656251 ,scale: 36111.98186701241),
                AGSLevelOfDetail(level: 15 , resolution:0.000042915344238281406 ,scale: 18055.990933506204),
                AGSLevelOfDetail(level: 16 , resolution:0.000021457672119140645 ,scale: 9027.995466753102),
                AGSLevelOfDetail(level: 17 , resolution:0.000010728836059570307 ,scale: 4513.997733376551),
                AGSLevelOfDetail(level: 18 , resolution:0.000005364418029785169 ,scale: 2256.998866688275)
            ]
            
            
        }
    }

    
}
