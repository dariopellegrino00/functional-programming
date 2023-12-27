
object Goldbach {
     
    private def isPrime(n: Int) = {
        val factors = for (x <- 1 to n if n % x == 0) yield x
        factors match {
            case Vector(1, x) if x == n => true
            case _                    => false
        }
    }

    def goldbach(n: Int) = {
        if (n % 2 != 0 || n < 2) throw new Exception("can not use goldbath on odd numbers or less than 2")
        val ns = for (x <- (1 to n) if isPrime(x)) yield x
        val first = ns.find(x => ns.exists(y => y + x == n)).get
        val second = ns.find(x => x + first == n).get
        (first, second)
    }

    def goldbach_partitions(n: Int, m: Int) = {
        for (x <- n to m if x % 2 == 0 && x > 2) yield (goldbach(x))
    }
}

object Main{
    def main(args: Array[String]): Unit = {
        println(Goldbach.goldbach_partitions(1, 20))
        //println(Goldbath.goldbath(7)) // exception
    }
}