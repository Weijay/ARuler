//
//  ViewController.swift
//  ARuler
//
//  Created by Wei Chieh Tseng on 22/08/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var resultLabel: UILabel!
    
    private var startPoint = SCNVector3Zero
    private var endPoint = SCNVector3Zero
    private var previousPoint: SCNVector3?
    
    private var lineNode: LineNode?
    
    private var startMeasuring: Bool = false {
        didSet {
            if startMeasuring {
                reset()
                lineNode = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func reset() {
        updateLabel(0)
        startPoint = SCNVector3Zero
        endPoint = SCNVector3Zero
        previousPoint = nil
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startMeasuring = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startMeasuring = false
    }

    // MARK: - Draw Line on Plane
    @IBAction func startDrawing(_ sender: CustomButton) {
        if let startPos = sceneView.realWorldPosition(for: view.center) {
            lineNode = LineNode(position: startPos, of: sceneView)
        }
    }
    
    func updateLine() {
        if let currentPosition = sceneView.realWorldPosition(for: view.center) {
            lineNode?.updateEndPoint(currentPosition)
        }
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.measuringARWorld()
            self.updateLine()
        }
    }
    
    // MARK: - Detect
    func measuringARWorld() {
        let anchorPoint = view.center
        guard let realWorldPosition = sceneView.realWorldPosition(for: anchorPoint) else { return }
        
        if startMeasuring {
            if SCNVector3EqualToVector3(startPoint, SCNVector3Zero) { // set startPoint if it is null
                startPoint = realWorldPosition
            }
            
            endPoint = realWorldPosition
            updateLabel(endPoint.distance(from: startPoint))
            
            
        }
    }
    
    // MARK: - Update UI
    func updateLabel(_ value: Float) {
        let cm = value * 100.0
        let inch = cm * 0.3937007874
        resultLabel.text = String(format: "%.2f cm / %.2f\"", cm, inch)
    }
    
    // MARK: - Draw 3D Line
    func draw3DLine(at currentPosition: SCNVector3) {
        if let previousPoint = previousPoint {
            let line = lineFrom(vector: previousPoint, toVector: currentPosition)
            let lineNode = SCNNode(geometry: line)
            lineNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            sceneView.scene.rootNode.addChildNode(lineNode)
        }
        previousPoint = currentPosition
        glLineWidth(40)
    }
    
    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
        
    }
    
}

