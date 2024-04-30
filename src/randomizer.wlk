import wollok.game.*
object randomizer {
		
	method position() {
		const gameWidth = game.width() - 2
		const gameHeight = game.height() - 4
		return 	game.at( 
					(1 .. gameWidth).anyOne(),
					(1 ..  gameHeight).anyOne()
		) 
	}
	
	method emptyPosition() {
		const position = self.position()
		if(game.getObjectsIn(position).isEmpty()) {
			return position	
		}
		else {
			return self.emptyPosition()
		}
	}
	
	// NUEVA: Generación de número al azar entre un mínimo y un máximo para alternan sprites
	method randomNumber(min, max){
		return min.randomUpTo(max).roundUp(0)
	}
	
}