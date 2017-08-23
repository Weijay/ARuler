//
//  LineNode.swift
//  ARuler
//
//  Created by Wei Chieh Tseng on 23/08/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class LineNode {
    private let sceneView: ARSCNView!

    private var startNode: SCNNode!
    private var endNode: SCNNode!
    private var lineNode: SCNNode?
    private var textNode: SCNNode!

    
    init(position: SCNVector3, of scene: ARSCNView) {
        sceneView = scene
        
        let dot = SCNSphere(radius: 1)
        dot.firstMaterial?.diffuse.contents = UIColor.green
        dot.firstMaterial?.lightingModel = .constant
        dot.firstMaterial?.isDoubleSided = true
        
        startNode = SCNNode(geometry: dot)
        startNode.scale = SCNVector3(1/400.0, 1/400.0, 1/400.0)
        startNode.position = position
        // Add starting node onscreen
        sceneView.scene.rootNode.addChildNode(startNode)

        // Initial other components
        endNode = SCNNode(geometry: dot)
        endNode.scale = SCNVector3(1/400.0, 1/400.0, 1/400.0)
        
        let text = SCNText(string: "--", extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 8)
        text.firstMaterial?.diffuse.contents = UIColor.magenta
        text.alignmentMode  = kCAAlignmentCenter
        text.truncationMode = kCATruncationMiddle
        text.firstMaterial?.isDoubleSided = true
        textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
    }
    
    func updateEndPoint(_ posEnd: SCNVector3) {
        endNode.position = posEnd
        if endNode.parent == nil {
            sceneView?.scene.rootNode.addChildNode(endNode)
        }
        
        // draw line
        drawLine(start: startNode, end: endNode)
        
        // add Label at middle (slightly below y position)
        let middle = SCNVector3((startNode.position.x + endNode.position.x)/2.0,
                                (startNode.position.y + endNode.position.y)/2.0+0.002,
                                (startNode.position.z + endNode.position.z)/2.0)


        let text = textNode.geometry as! SCNText
        let length = posEnd.distance(from: startNode.position)
        text.string = "\(length * 100) cm"
        textNode.position = middle
        
        if textNode.parent == nil {
            sceneView?.scene.rootNode.addChildNode(textNode)
        }

        
    }
    
    func drawLine(start: SCNNode, end: SCNNode) {

        lineNode?.removeFromParentNode()

        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [start.position, end.position])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        let geometry = SCNGeometry(sources: [source], elements: [element])
        lineNode = SCNNode(geometry: geometry)
        
        sceneView?.scene.rootNode.addChildNode(lineNode!)
    }
}
