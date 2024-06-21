import wollok.game.*

class Direction {

	method nextMove(position) {
		return self.nextMove(position, 1)
	}

	method nextMove(position, cant)

}

object leftDirection inherits Direction {

	override method nextMove(position, cant) {
		return position.left(cant)
	}

	method say() {
		return 'left'
	}

	method opossite() {
		return rightDirection
	}

}

object downDirection inherits Direction {

	override method nextMove(position, cant) {
		return position.down(cant)
	}

	method say() {
		return 'down'
	}

	method opossite() {
		return upDirection
	}

}

object rightDirection inherits Direction {

	override method nextMove(position, cant) {
		return position.right(cant)
	}

	method opossite() {
		return leftDirection
	}

	method say() {
		return 'right'
	}

}

object upDirection inherits Direction {

	override method nextMove(position, cant) {
		return position.up(cant)
	}

	method opossite() {
		return downDirection
	}

	method say() {
		return 'up'
	}

}

class Axis {

	method nextDirection(target, owner)

	method nextMove(owner, target) {
		return self.nextDirection(target, owner).nextMove(owner.position())
	}

}

object axisX inherits Axis {

	method distance(target, owner) {
		return (target.position().x() - owner.position().x()).abs()
	}

	override method nextDirection(target, owner) {
		if (target.position().x() > owner.position().x()) {
			return rightDirection
		} else {
			return leftDirection
		}
	}

	method opossite() {
		return axisY
	}

}

object axisY inherits Axis {

	method distance(target, owner) {
		return (target.position().y() - owner.position().y()).abs()
	}

	override method nextDirection(target, owner) {
		if (target.position().y() > owner.position().y()) {
			return upDirection
		} else {
			return downDirection
		}
	}

	method opossite() {
		return axisX
	}

}

