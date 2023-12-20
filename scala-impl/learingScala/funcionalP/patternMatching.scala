class PM{
    val anInt = 55
    val order = anInt match {
        case 1 => "first"
        case 2 => "second"
        case 3 => "third"
        case _ => anInt + "th"
    }
    println(order)

    case class Person(name: String, age: Int)
    val bob = Person("bob", 43)

    val personGreeting = bob match {
        case Person(n, a) => s"Hi my name is $n and I ame $a years old." 
        case _ => "Not a person?"
    }
    println(personGreeting)

    val aTuple = ("Bon Jovi", "Rock")
    val bandDescription = aTuple match {
        case(band, genre) => s"$band belongs to the genre $genre"
        case _ => "not a band?"
    }
}


