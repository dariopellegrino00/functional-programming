
// Class and instance (below)
class Animal {
    val age: Int = 0

    def eat() = println("I'm eating")
}

val anAnimal = new Animal

//inheritance 
class Dog(val name: String) extends Animal 
val aDog = new Dog("Lassie") // constructors argument are not fields
// you need to put val before the constructor argument to do this
println(aDog.name)

// subtype polymorfism
val aDeclaredAnimal: Animal = new Dog("KAttarak")
aDeclaredAnimal.eat()

abstract class WalkingAnimal {
    private val hasLegs = true //all fields and methods are by default public
    def walk(): Unit  //you can restric the access with protected and private
}

//similar to interface
trait Carnivore{
    def eat(aimal: Animal): Unit
}

trait Philosopher{
    def ?!(thought: String): Unit // valid method name
}

/*
we can extends one class 
but multiple traits (with Trait)
*/
class Crocodile extends Animal with Carnivore with Philosopher{
    override def eat(animal: Animal): Unit = println("I am eating you, animal!")

    override def ?!(thought: String): Unit = println("I am thinking: $thought")
}

val aCroc = new Crocodile
aCroc.eat(aDog)
aCroc eat aDog // this two are equal but only for method with one argument

//operators like + - exc... are methods 
val BasicMath = 1 + 2

// anonymous class
val dinosaur = new Carnivore {
    override def eat(animal: Animal): Unit = println("i can eat anything")
}

//singleton object
object MySingleton {
    val mySpecialValue = 42
    def mySpecialMethod(): Int = 43
    def apply(x: Int): Int = x + 1 //a special method for any object
} 

MySingleton.mySpecialMethod()
MySingleton.apply(45)
MySingleton(45) // equivalent to Mysingleton.apply()

object Animal { //this is a companion, has the same name of a class or a trait
    // companions can acces same private fields and methods of the corresponding class
    //but singleton Animal and instances of Animal are different
    val canLiveIndefenetly = false
}

val animalCanLiveForver = Animal.canLiveIndefenetly // same as static methods and fields in java
/* case class are light data structure
- sensible equals and hash code
- used in serialization
- companion with apply
- usedfull for pattern matching (Important) 
*/
case class Person(name: String, age: Int)
// can be constructed without new 
val bob = Person("bob", 54) //Person.apply

// exceptions similar to java
try {
    val x: String = null
    x.length
} catch {
    case e: Exception => "Some errore message"
} finally {
    println("finally!!")
}

// generics 
abstract class MyList[T] {
    def head: T
    def tail: MyList[T]
}

// using a generic with a concrete type
val aList: List[Int] = List(1,2,3) // List.apply(1,2,3)
val first = aList.head
val rest = aList.tail

// Point #1: in scala we operate with immutable values
// any change in an object should return a new object
val reversedList = aList.reverse // this returns a new list
/*
    Benefirs 
    1) are for multiThreaded/distributed env
    2) helps making sense of the code 
*/

// Point #2 Scala is closest to the OOP ideal 


