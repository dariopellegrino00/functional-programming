
import scala.util.parsing.combinator._
import java.io.FileReader

class Stack {
    private var stack = List[Int]()
    
    def push(e: Int) = stack = (e :: stack) 
    
    def pop = if(stack.length > 0) stack = stack.drop(1) else throw new IllegalStateException

    def pull = if(stack.length > 0) stack(0) else throw new IllegalStateException

    override
    def toString() : String = {
        stack.toString
    }
}

class ArnoldParser extends JavaTokenParsers {

    private var symbol_table = Map[String, Int]()

    def arnold: Parser[Unit] = "IT'S SHOWTIME" ~> commands <~ "YOU HAVE BEEN TERMINATED" ^^ {
        cmds => {
            cmds()
            println("Stack()")
            println("Symbol Table :-")
            symbol_table.foreach(x => println("       " ++ x.toString))
        }
    }
    
    def commands = rep1(command) ^^ {
        ops => () => ops.foreach(x => x())
    }

    def command: Parser[() => Unit] = (var_declaration | var_assignment | arnold_print | if_statement | loop_statement)

    def operand: Parser[() => Int] = (number | var_name ^^ {v => () => symbol_table(v)})

    def var_name = """[a-zA-Z0-9]*[a-zA-Z][a-zA-Z0-9]*""".r ^^ {s => s.toString} // devo capire

    def number = wholeNumber ^^ {n => () => n.toInt}
    
    def var_declaration: Parser[() => Unit] = "HEY CHRISTMAS TREE" ~> var_name ~ ("YOU SET US UP" ~> number) ^^ {
        case name ~ value => {() => symbol_table += (name -> value())}
    }

    def arnold_print: Parser[() => Unit] = "TALK TO THE HAND" ~> 
        (var_name ^^ {v => () => println(symbol_table(v).toString)} | 
        stringLiteral ^^ {s => () => println(s.toString)})

    def var_assignment: Parser[() => Unit] = "GET TO THE CHOPPER" ~> var_name ~ ("HERE IS MY INVITATION" ~> operand) ~ (rep1(operation) <~ "ENOUGH TALK") ^^ {
        case vname ~ n ~ ops => {
            () => {val res = ops.foldLeft(n())((res, o) => o(res)); symbol_table = symbol_table.updated(vname, res)}
        }
    }

    def operation = logic_operation | arithmetic_operation

    def logic_operation = 
        (
        "YOU ARE NOT YOU YOU ARE ME" | 
        "LET OFF SOME STEAM BENNET" | 
        "CONSIDER THAT A DIVORCE" |
        "KNOCK KNOCK"
        ) ~ operand ^^ {
            case "YOU ARE NOT YOU YOU ARE ME" ~ op => (o: Int) => if (op() == o) 1 else 0
            case "LET OFF SOME STEAM BENNET" ~ op => (o: Int) => if (op() < o) 1 else 0
            case "CONSIDER THAT A DIVORCE" ~ op => (o: Int) => if (op() == 1 && o == 1) 1 else 0
            case "KNOCK KNOCK" ~ op => (o: Int) => if (op() == 1 || o == 1) 1 else 0
            case _ => throw new IllegalArgumentException
        }
    
    def arithmetic_operation: Parser[Int => Int] = ("GET UP" | "GET DOWN" | "YOU'RE FIRED" | "HE HAD TO SPLIT") ~ operand ^^ {
        case "GET UP" ~ x => (o: Int) => (x() + o)
        case "GET DOWN" ~ x => (o: Int) => (x() - o)
        case "YOU'RE FIRED" ~ x => (o: Int) => (x() * o)
        case "HE HAD TO SPLIT" ~ x => (o: Int) => (x() / o)
        case _ => throw new IllegalArgumentException
    }

    def if_statement: Parser[() => Unit] = 
        "BECAUSE I'M GOING TO SAY PLEASE" ~> operand ~ ("[" ~> commands) ~ 
        ("] BULLSHIT [" ~> commands) <~ "] YOU HAVE NO RESPECT FOR LOGIC" ^^ {
            case o ~ cmds1 ~ cmds2 => () => {if (o() != 0) cmds1() else cmds2()}
        }

    def loop_statement: Parser[() => Unit] = "STICK AROUND" ~> (var_name <~ "[") ~ (rep(command) <~ "] CHILL") ^^ {
        case v ~ ops => () => { while (symbol_table(v) > 0) ops.foreach(x => x())}
    }
}

object Main {
    def main(args: Array[String]): Unit = {
        val p = new ArnoldParser
        args.foreach(
            filename => {
                val reader = new FileReader(filename)
                p.parseAll(p.arnold, reader) match {
                   case p.Success(r, _) => r
                   case x => println(x.toString) 
                }
            }         
        )
    }
}
