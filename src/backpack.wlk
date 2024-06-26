import wollok.game.*
import randomizer.*
import mainCharacter.*
import mosquitoes.*
import obstacles.*
import globalConfig.*

object backpack {

	var property spirals
	var property trashes
	var property mosquitoes

	method build() {
		self.spirals(0)
		self.trashes(0)
		self.mosquitoes(0)
	}

	method reloadSpirals() {
		spirals = 5
	}

	method discountSpiral() {
		spirals -= 1
	}

	method hasSpirals() {
		return spirals > 0
	}

	method addMosquito() {
		mosquitoes += 1
	}

	method storeTrash() {
		trashes += 1
	}

}

