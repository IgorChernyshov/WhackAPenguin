//
//  WhackSlot.swift
//  WhackAPenguin
//
//  Created by Igor Chernyshov on 15.07.2021.
//

import SpriteKit
import UIKit

final class WhackSlot: SKNode {

	// MARK: - Properties
	var charNode: SKSpriteNode!
	private(set) var isVisible = false
	private(set) var isHit = false

	// MARK: - Slot configuration
	func configure(at position: CGPoint) {
		self.position = position

		let sprite = SKSpriteNode(imageNamed: "whackHole")
		addChild(sprite)

		let cropNode = SKCropNode()
		cropNode.position = CGPoint(x: 0, y: 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

		charNode = SKSpriteNode(imageNamed: "penguinGood")
		charNode.position = CGPoint(x: 0, y: -90)
		charNode.name = "character"
		cropNode.addChild(charNode)

		addChild(cropNode)
	}

	// MARK: - Game Logic
	func show(hideTime: Double) {
		if isVisible { return }
		charNode.xScale = 1
		charNode.yScale = 1
		charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
		isVisible = true
		isHit = false

		if Int.random(in: 0...2) == 0 {
			charNode.texture = SKTexture(imageNamed: "penguinGood")
			charNode.name = "charFriend"
		} else {
			charNode.texture = SKTexture(imageNamed: "penguinEvil")
			charNode.name = "charEnemy"
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
			self?.hide()
		}
	}

	func hide() {
		if !isVisible { return }

		charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
		isVisible = false
	}

	func hit() {
		isHit = true

		if let foe = charNode.name?.dropFirst(4),
		   let smoke = SKEmitterNode(fileNamed: "Smoke\(foe)") {
			smoke.position = charNode.position
			charNode.addChild(smoke)
		}

		let delay = SKAction.wait(forDuration: 0.25)
		let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
		let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
		charNode.run(SKAction.sequence([delay, hide, notVisible]))
	}
}
