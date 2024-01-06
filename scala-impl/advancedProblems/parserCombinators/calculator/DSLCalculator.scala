
import scala.util.parsing.combinator._
import scala.util.matching.Regex
import scala.language.experimental

class ExpressionParser extends JavaTokenParsers {

    override protected val whiteSpace: Regex = """[ ]""".r

    var symbol_table = Map[String, Double]() 

    def number = """[0-9]+(\.[0-9]+)?""".r ^^ {s => s.toDouble}
    
    def start = line ~ rep("\n" ~ line)

    def line = variableDefinition | (expressionStarter ^^ {e => println(e)})
    
    def variableDefinition = variableName ~ ("=" ~> expressionStarter) ^^ {
        case name ~ value => symbol_table += name -> value
    }

    def variableName = """[A-Za-z]""".r

    def expression: Parser[Double] = number | unaryExpression | "(" ~> expressionStarter <~ ")" | (variableName ^^ {name => symbol_table(name)})

    def expressionStarter = expression ~ rep(binaryExpressionPrio) ^^ {
        case e ~ Nil => e
        case e ~ exps => { 
            val e1 = (exps(0))(e)
            exps.drop(1).foldLeft(e1)((acc, en) => en(acc))
        }
          
    }

    def binaryExpressionPrio = {
        binaryExpression |
        (operation ~ expression ~ rep(binaryExpression) ^^ {  
            case op ~ e ~ Nil => (o: Double) => op(o, e)
            case op ~ e ~ exps => { 
                val e1 = (exps(0))(e)
                val res = exps.drop(1).foldLeft(e1)((acc, en) => en(acc))
                (o: Double) => op(o, res)
            }
        }) | 
        (operation ~ expression ^^ {
            case op ~ e => (o: Double) => op(o, e)
        })
    }

    def binaryExpression = operationPrio ~ expression ^^ {
        case op ~ e => (o: Double) => op(o, e)
    }

    def operationPrio = ("*" | "/" | "^") ^^ {
        case "*" => (o1: Double, o2: Double) => (o1 * o2)
        case "/" => (o1: Double, o2: Double) => (o1 / o2)
        case "^" => (o1: Double, o2: Double) => Math.pow(o1, o2)
    } 

    def operation = ("+" | "-") ^^ {
        case "+" => (o1 : Double, o2: Double) => (o1 + o2)
        case "-" => (o1: Double, o2: Double) => (o1 - o2)
    }

    def unaryExpression = ("sqrt" | "sin" | "cos" | "tan" | "-") ~ expression ^^ {
        case "sqrt" ~ e => Math.sqrt(e)  
        case "sin" ~ e => Math.sin(e)
        case "cos" ~ e => Math.cos(e)
        case "tan" ~ e => Math.tan(e)
        case "-" ~ e => -e
        case _ => throw new IllegalArgumentException("rotto")
    }
}

object Main {
    def main(args: Array[String]): Unit = {
        val p = new ExpressionParser
        p.parseAll(p.start, "3 + 3 * 2\n3 + 2 -1 - sqrt 9 * 2\nA=5 + 2\nA") match {
            case p.Success(r,_) => {}
            case x => println("sbagliato\n" ++ x.toString)
        }
    }
}

