import wollok.game.*
import posiciones.*
import globalConfig.*
import mosquito.*

object mainCharacter inherits Character{

	var property direction = null
	var property position = game.at(4, 4)
	var property lives = 2
	var estaInvertido = false

	method image() = "characterfront.png"

	method goesTo(newDirection) {
		const newPosition = self.nextMove(newDirection)
		if (self.canGo(newPosition)) {
			self.direction(newDirection)
			self.position(newPosition)
		}
	}

	method nextMove(newDirection) {
		return if (estaInvertido) {
			newDirection.opossite().nextMove(position)
		} else {
			newDirection.nextMove(position)
		}
	}

	method sayDirection() {
		game.say(self, direction.say())
	}

	method evadeCollide() {
		const newDirection = self.direction().opossite()
		self.goesTo(newDirection)
	}

	method colition(algo) {
		
	}

	method changeMoving() {
		estaInvertido = true
	}
	
	method restarVida(){
		if(lives == 1){
			self.morir()
		} else {
			lives-= 1 
		}
	}
	
	method morir(){
		game.removeVisual(self)
		//CONFIGURAR FINAL 
	}
	
	override method isTakeable(){
		return false 
	}

}

