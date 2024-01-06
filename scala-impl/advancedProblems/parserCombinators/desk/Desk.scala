
import scala.util.parsing.combinator._
import scala.util.matching.Regex

class DeskParser extends JavaTokenParsers{

    private var symbol_table = Map[String, Int]()

    def start = ("print" ~> expr) ~ ("where" ~> variable_definition ~ rep("," ~> variable_definition)) ^^ {case e ~ _ => println(e()); symbol_table}

    def expr: Parser[() => Int] = 
        (
        (((number ~ ("+" ~> expr)) |
        (x ~ ("+" ~> expr))
        ) ^^ {
            case f1 ~ f2 => () => f1() + f2()}:Parser[() => Int]) | x | number)

    def x = var_name ^^ {v => () => symbol_table(v)}

    def var_name = """[a-zA-z]""".r

    def number = wholeNumber ^^ {n => () => n.toInt} 

    def variable_definition = var_name ~ ("=" ~> wholeNumber) ^^ {case n ~ v => symbol_table += (n -> v.toInt) } 
}

object Main{
    def main(args: Array[String]): Unit = {
        val p = new DeskParser
        p.parseAll(p.start, "print x+y+z+1+x+-3 where x = 25, y = 1, z=-7") match {
            case p.Success(r, _) => println(r.toString)
            case f => println(f.toString)
        }
    }
}