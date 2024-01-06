
class Lists { 
    def squared_numbers(lst: List[Any]): List[Any] =
        lst match{
            case (n: Int)       :: xs => n * n :: squared_numbers(xs)
            case (x: Double)    :: xs => x * x :: squared_numbers(xs)
            case (f: Float)     :: xs => f * f :: squared_numbers(xs)
            case (subList: Seq[_]) :: xs => squared_numbers(subList.toList) :: squared_numbers(xs)
            case (tuple : Product) :: xs => squared_numbers(tuple.productIterator.toList) :: squared_numbers(xs)
            case _ :: xs => squared_numbers(xs)
            case nil => nil
        }

    def intersect(list1: List[Any], list2: List[Any]): List[Any] = 
        for (y <- list1 if !{for {x <- list2 if (x == y)} yield x}.isEmpty) yield y
        //list1.intersect(list2)

    def symmetric_difference(list1: List[Any], list2: List[Any]): List[Any] = 
        for (x <- list1) yield x
        //list1.diff(list2) ++ (list2.diff(list1))
}



object Lists {
    def main(args: Array[String]): Unit = {
        val listCompr = new Lists
        val list1 = (1 :: "hello" :: 100 :: 3.14 :: ('a'::10::Nil) :: 'c' :: (5,7,'a') :: Nil)
        println(s"squared_numbers of $list1")
        println(listCompr.squared_numbers(list1))
        
        val list2 = 1 :: 4 :: 5 :: "alora" :: Nil
        val list3 = 1 :: 7 :: 9 :: "alora" ::  101 :: (1, 2) :: Nil
        println(s"intersect between $list2 and $list3")
        println(listCompr.intersect(list2, list3))

        println(s"symmetric difference between $list2 and $list3")
        println(listCompr.symmetric_difference(list2, list3))


    }
}