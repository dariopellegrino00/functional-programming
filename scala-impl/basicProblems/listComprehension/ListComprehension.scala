
class ListComprehension { 
    def squared_numbers(lst: List[Any]): List[Any] =
        lst match{
            case (n: Int)       :: xs => n * n :: squared_numbers(xs)
            case (x: Double)    :: xs => x * x :: squared_numbers(xs)
            case (f: Float)     :: xs => f * f :: squared_numbers(xs)
            case (l: List[Any]) :: xs => squared_numbers(l) :: squared_numbers(xs)
            case _ :: xs => squared_numbers(xs)
            case nil => nil
        }
}

object ListComprehension {
    def main(args: Array[String]): Unit = {
        val listCompr = new ListComprehension
        val list1 = (1 :: "hello" :: 100 :: 3.14 :: ('a'::10::Nil) :: 'c' :: (5,7,'a') :: Nil)
        println(s"squared_numbers of $list1")
        println(listCompr.squared_numbers(list1))
    }
}