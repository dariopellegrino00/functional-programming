
class Functional{
    def isPalindrome(str: String) = {
        val s = str.toLowerCase().filter(_.isLetterOrDigit)
        s.reverse == s 
    }

    def isAnagram(str: String, strList: List[String]) = {
        strList.exists(x => x.toSet.equals(str.toSet) && x.length() == str.length())
    } 


    
        
    def factors(n: Int): List[Int] = n match{
        case 1 => List.empty
        case n => 
            val primes = 2 :: (3 to n).filter(x => ((2 to x-1).filter(y => x % y == 0)).isEmpty).toList
            val pf = primes.find(x => n % x == 0)
            pf match{
                case Some(x) => x :: (factors(n/x))
                case None => List(n)
            }          
    }

    def isProper(n: Int) = {
        (1 to n-1).filter(x => n % x == 0).sum == n 
    }
}

object Functional {
    def main(args: Array[String]): Unit = {
        val func = new Functional
        println("isPalindrome()")
        println("rise to vote, sir : is palindrome? " + func.isPalindrome("rise to vote sir"))
        println("abba : is palindrome? " + func.isPalindrome("abba"))
        println("kattarak : is palindrome? " + (func.isPalindrome("kattarak")))
        println("Rise to vote, SIR! : is palindrome? " + func.isPalindrome("Rise to vote, SIR!"))
        println()

        println("isAnagram()")
        val words1 = List("cioa", "ciso", "oiac", "oooo")
        val word1 = "ciao"
        println(s"Is there an anagram for '$word1' in $words1 " + func.isAnagram(word1, words1))

        val words2 = List("katatrku", "katta", "romepes", "aafpppp")
        val word2 = "kattabun"
        println(s"Is there an anagram for '$word2' in $words2 " + func.isAnagram(word2, words2))
        println()
        
        println("factors() (prime factors of n)")
        println("10: " + func.factors(10))
        println("120: " + func.factors(120))
        println("17: " + func.factors(17))

        println(("isProper() (is a perfect number)"))
        println("the perfect numbers between 1 and 10000 are")
        println((1 to 10000).filter(x => func.isProper(x)).toList)
    }
}
