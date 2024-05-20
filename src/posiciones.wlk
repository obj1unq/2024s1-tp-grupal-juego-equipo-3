import wollok.game.*

object tablero {
	
	method pertenece(position) {
		return position.x().between(0, game.width() - 1) &&
			   position.y().between(0, game.height() -1 ) 
	}
	
	method puedeIr(desde, direccion) {
		const aDondeVoy = direccion.siguiente(desde) 
		return self.pertenece(aDondeVoy)
				&& not self.hayObstaculo(aDondeVoy) 
	}
	
	method hayObstaculo(position) {
		const visuales = game.getObjectsIn(position)
		return visuales.any({visual => not visual.esAtravesable()})
	}
	
}

//DIRECCIONES 
object arriba {
	method siguiente(position) {
		return position.up(1)
	}
}

object abajo {
	method siguiente(position) {
		return position.down(1)
	}	
}

object izquierda {
	method siguiente(position) {
		return position.left(1)
	}
}
object derecha {
	method siguiente(position) {
		return position.right(1)
	}
}