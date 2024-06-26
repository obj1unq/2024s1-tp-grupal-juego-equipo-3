import wollok.game.*

class Direction {

	method nextMove(position) {
		return self.nextMove(position, 1)
	}

	method nextMove(position, transfer)

}

object leftDirection inherits Direction {

	override method nextMove(position, transfer) {
		return position.left(transfer)
	}

	method opossite() {
		return rightDirection
	}

}

object downDirection inherits Direction {

	override method nextMove(position, transfer) {
		return position.down(transfer)
	}

	method opossite() {
		return upDirection
	}

}

object rightDirection inherits Direction {

	override method nextMove(position, transfer) {
		return position.right(transfer)
	}

	method opossite() {
		return leftDirection
	}

}

object upDirection inherits Direction {

	override method nextMove(position, transfer) {
		return position.up(transfer)
	}

	method opossite() {
		return downDirection
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

