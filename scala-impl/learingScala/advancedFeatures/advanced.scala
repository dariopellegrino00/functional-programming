
// lazy evaluation 
lazy val aLazyValue = 2
lazy val lazyValueWithSideEffect = {
    println("I am so very lazy")
    43
}

val eagerValue = lazyValueWithSideEffect + 1
// usefull in infinte collections 

// "pseudo-collections" Option, Try 
def methodWitchCanReturnNull(): String = "hello, scala"
val anOption = Option(methodWitchCanReturnNull()) // Some("hello, Scala") or None

val StringProcessed = anOption match {
    case Some(string) => s"i have obtained $string"
    case None => "i have obtained nothing"
}

