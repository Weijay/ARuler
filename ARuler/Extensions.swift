//
//  Extensions.swift
//  ARuler
//
//  Created by Wei Chieh Tseng on 22/08/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import ARKit

extension SCNVector3 {
    func distance(from vector: SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        
        return sqrtf( (distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
    }
}


extension ARSCNView {
    // create real world position of the point
    func realWorldPosition(for point: CGPoint) -> SCNVector3? {
        let result = self.hitTest(point, types: [.featurePoint])
        guard let hitResult = result.last else { return nil }
        let hitTransform = SCNMatrix4(hitResult.worldTransform)
        
        // m4x -> position ;; 1: x, 2: y, 3: z
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        return hitVector
    }
}
