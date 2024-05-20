import wollok.game.*

//object tablero {
//	
//	method pertenece(position) {
//		return position.x().between(0, game.width() - 1) &&
//			   position.y().between(0, game.height() -1 ) 
//	}
//	
//	method puedeIr(desde, direccion) {
//		const aDondeVoy = direccion.siguiente(desde) 
//		return self.pertenece(aDondeVoy)
//				&& not self.hayObstaculo(aDondeVoy) 
//	}
//	
//	method hayObstaculo(position) {
//		const visuales = game.getObjectsIn(position)
//		return visuales.any({visual => not visual.esAtravesable()})
//	}
//	
//}

object leftDirection {

	method nextMove(position) {
		return position.left(1)

	}

	method say() {
		return 'left'
	}

	method opossite() {
		return rightDirection
	}

}

object downDirection {

	method nextMove(position) {
		return position.down(1)

	}

	method say() {
		return 'down'
	}

	method opossite() {
		return upDirection
	}

}

object rightDirection {

	method nextMove(position) {
		return position.right(1)

	}

	method opossite() {
		return leftDirection
	}

	method say() {
		return 'right'
	}

}

object upDirection {

	method nextMove(position) {
		return position.up(1)
	}

	method opossite() {
		return downDirection
	}

	method say() {
		return 'up'
	}

}

