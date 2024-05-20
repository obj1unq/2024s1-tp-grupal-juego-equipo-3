import wollok.game.*

object limit { // ver si es necesaria con el objeto character

	const property maxX = game.width() - 2
	const property minX = 1
	const property maxY = game.height() - 4
	const property minY = 1

	method in(position) {
		return position.x().between(minX, maxX) and position.y().between(minY, maxY)
	}

}

