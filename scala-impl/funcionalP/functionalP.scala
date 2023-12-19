
class Person(name: String){
    def apply(age: Int) = println(s"I have aged $age years")
}

val bob = new Person("Bob")
bob.apply(43)
bob(43) // bob.apply(43)

// FunctionX to use functional p on the jvm

val simpleIncrementer = new Function1[Int, Int] {
    override def apply(arg: Int): Int = arg + 1
}

simpleIncrementer.apply(23)
simpleIncrementer(23)

//basically we defined a function
//ALL SCALA FUNCTIONS ARE INSTANCES OF THESE FUNCTION_X TYPESs

val stringConcatenator = new Function2[String, String, String] {
    override def apply(arg1: String, arg2: String): String = arg1 + arg2
}

println(stringConcatenator("Kattarak ", "El babun"))
/* this doubler below is equivalen to this 
val doubler = new Function1[Int, Int] {
    override def apply(x: Int) = 2 * x
}

*/
//functional doubler
val doubler: Function1[Int, Int] = (x: Int) => 2 * x
println("functional doubler: " + doubler(4))

// another syntax sugar

val doublerSwetened: Int => Int = (x: Int) => 2 * x
println("functional doubler sweetened: " + doublerSwetened(4))

//automatically inferred by the compiler
val doublerMoreSwetened = (x: Int) => 2 * x
println("functional doubler more sweetened: " + doublerSwetened(4))

val aMappedList = List(1,2,3).map(x => x + 1)
println(aMappedList)

val aFlatMappedList = List(1,2,3).flatMap { 
    x => List(x, x * 2)
}
println(aFlatMappedList)

val aFilteredList = List(1,2,3,4,5).filter(x => x <= 3)
println(aFilteredList)

//shorted sintax for filter equivalent
val aFilteredList2 = List(1,2,3,4,5).filter(_ <= 3)

// all pairs between 1,2,3 and letters a,b,c

val allPairs = List(1,2,3).flatMap(num => List('a','b','c').map(let => s"$num-$let"))
println(allPairs)

// allPairs with for comprehensions 
// IDENTICAL FOR THE COMPILER
// for DOES NOT mean for loop 
val alternativePairs = for {
    number <- List(1,2,3)
    letter <- List('a','b','c')    
} yield s"$number-$letter"

println(alternativePairs)

// Collections 
// (map and flatmap workds for all the collection below)

val aList = List(1,2,3,4,5)
println("list: " + aList)
println("head: " + aList.head)
println("tail: " + aList.tail)
val aPrependedList = 0 :: aList
val anExtendedList = 0 +: aList :+ 6
println("prepended appended: " + anExtendedList)

//sequence
val aSequence: Seq[Int] = Seq(1,2,3) // is a Seq.apply(1,2,3) 
// so Seq is a Trait
val accessedElement = aSequence(1) // aSequence.apply(1)
println("a Sequence: " + aSequence)

val aVector = Vector(1,2,3,4,5) // Vector has fast acces time
println("a Vector: "+ aVector)

val aSet = Set(1,2,3,4,5,1,2,3)
println("a Set: " + aSet)
val setHas5 = aSet.contains(5)
val anAddedSet = aSet + 5 // set plus
val aRemovedSet = aSet -3 // set minus

//aRange
val aRange = 1 to 1000
// these does not contain 1000 elements, but can be processed as if it has
val twoByTwo = aRange.map(x => 2 * x).toList

//tuples 
val aTuple = ("kattarak", "el", "babun", 746)

val aMap: Map[String, Int] = Map(
    ("Kattarak", 4423511),
    ("rompe", 7869933),
    "gambi" -> 1528825
)