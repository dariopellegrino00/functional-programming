
//TODO infinte sets checks
trait AlgebraicStructure[T] {
    def set: Set[T]
}

class Monoid[T](val set: Set[T], val add: (T, T) => T, val identity: T) extends AlgebraicStructure[T] {
    def isAssociative: Boolean = 
        set.forall(
            x => set.forall(
                y => set.forall(
                    z => add(x, add(y, z)) == add(add(x, y), z)
                )
            )
        )
    
    def hasIdentity: Boolean = 
        set.forall(
            x => add(x, identity) == x && add(identity, x) == x
        )
}

//class Group[T] extends Monoid[T]

//class Ring[T] extends Group[T]

class Group[T](override val set: Set[T], override val add: (T, T) => T, override val identity: T) extends Monoid[T](set, add, identity) {
    def hasInverse: Boolean = 
        set.forall(
            x => set.exists(y => add(x, y) == identity && add(y, x) == identity)
        )

    def isAbellian: Boolean = 
        set.forall(
            x => set.forall(y => add(x, y) == add(y, x))
        )
}

class Ring[T](override val set: Set[T], override val add: (T, T) => T, override val identity: T, val mul: (T, T) => T) extends Group[T](set, add, identity) {
    
    def isDistributiveOverAdd: Boolean = 
        set.forall(
            x => set.forall(
                y => set.forall(
                    z => 
                        mul(x, add(y, z)) == add(mul(x, y), mul(x, z)) &&
                        mul(add(x, y), z) == add(mul(x, z), mul(y, z))
                )
            )
        )

    def prodIsAssociative: Boolean =
        set.forall(
            x => set.forall(
                y => set.forall(
                    z => mul(x, mul(y, z)) == mul(mul(x, y), z)
                )
            )
        )

}

object Main { // fast testing
    def main(args: Array[String]): Unit = {
        val aMonoid = new Monoid[Int](Set(1, 2, 3, 4), (x, y) => x + y, 0)
        println(aMonoid.isAssociative)
        println(aMonoid.hasIdentity)
        val notAMonoid = new Monoid[Int](Set(1, 2, 3, 4), (x, y) => x - y, 0)
        println(notAMonoid.isAssociative)
        println(notAMonoid.hasIdentity)

        
        val notAGroup = new Group[Boolean](Set(true, false), (x, y) => x || y, false)
        println(notAGroup.isAssociative)
        println(notAGroup.hasIdentity)
        println(notAGroup.hasInverse)

        val z = -50 to 50
        val aGroup = new Group[Int](Set.from(z), (x, y) => x + y , 0)
        println(aGroup.isAssociative)
        println(aGroup.hasIdentity)
        println(aGroup.hasInverse)
        println()

        val aRing = new Ring[Int](Set(0), (x, y) => x + y, 0, (x, y) => x * y)
        println(aRing.isAssociative)
        println(aRing.hasIdentity)
        println(aRing.hasInverse)
        println(aRing.isAbellian)
        println(aRing.isDistributiveOverAdd)
        println(aRing.prodIsAssociative)
        println()

        val aRing2 = new Ring[Int](Set.from(z), (x, y) => x + y, 0, (x, y) => x * y)
        println(aRing.isAssociative)
        println(aRing.hasIdentity)
        println(aRing.hasInverse)
        println(aRing.isAbellian)
        println(aRing.isDistributiveOverAdd)
        println(aRing.prodIsAssociative)
        println()

    }
}


