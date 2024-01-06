import scala.util.parsing.combinator._



class CalculatorParser extends JavaTokenParsers {
    /*def walkDefaultOutput(a: Any): Unit = a match {
        case s: String => print(s)
        case ~(a, b) => 
            walkDefaultOutput(a)
            walkDefaultOutput(b)
        case lst: List[Any] => 
            lst foreach walkDefaultOutput
    }

    def form: Parser[Any] = term ~ rep(("+" | "-") ~ term)
    def term: Parser[Any] = factor ~ rep(("*" | "/") ~ factor)
    def factor: Parser[Any] = floatingPointNumber | "(" ~ form ~ ")"*/

    def formD: Parser[Double] = termD ~ rep(("+" | "-") ~ termD) ^^ {
        case t1~lst => lst.foldLeft(t1)((x, t) => if(t._1=="+") x + t._2 else x - t._2) 
    }

    def termD: Parser[Double] = factorD ~ rep(("*" | "/") ~ factorD) ^^ {
        case f1~lst => lst.foldLeft(f1)((x, t) => if(t._1=="*") x * t._2 else x / t._2) 
    }

    def factorD: Parser[Double] = 
        floatingPointNumber ^^ {s => s.toDouble} |
        unaryFactor | 
        "(" ~> formD <~ ")" ^^ {x => x}

    def unaryFactor = ("tan" | "sqrt" | "sin" | "cos" | "tan" | "-") ~ factorD ^^ {
        case "sqrt" ~ f => Math.sqrt(f)  
        case "sin" ~ f => Math.sin(f)
        case "cos" ~ f => Math.cos(f)
        case "tan" ~ f => Math.tan(f)
        case "-" ~ f => -f 
        case _ => throw new IllegalArgumentException("not a unaryFactor")
    }
}

object Main {
    def main(args: Array[String]): Unit = {
        val p = new CalculatorParser
        //p.walkDefaultOutput(p.parseAll(p.form, "1+4/2-2+3*5").get)
        println(p.parseAll(p.formD, "3+3*5").get)

        println(p.parseAll(p.formD, "1+4/2-2+3*5").get)
        //p.walkDefaultOutput(p.parseAll(p.form, "2+3*8/2").get)
        println()
        println(p.parseAll(p.formD, "-2+3-1*8/sqrt64").get)
        println(p.parseAll(p.formD, "(-2+3-23)*16/sqrt64").get)
    }
}