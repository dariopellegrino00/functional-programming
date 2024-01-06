import scala.util.parsing.combinator._
import java.io.FileReader


class WTFEValuator extends JavaTokenParsers {
    //def start = opt(functions_def) ~

    var symbol_table = Map[Char, () => AnyVal]

    def start = line // rep

    def line = conditional | block ^^ {b => b()}
    
    def term = successor 

    def functions_def = "def" ~> " " ~> fun_name ~ (" " ~> param_number <~ "=") ~ fun_block

    def param_number = """[0-9]""".r

    def fun_name = """[A-Z]""".r 

    def successor = "0" ~> rep(operator) ^^ {
        case ops => () => ops.foldLeft(0)((acc, o) => o(acc))
    }

    def operator = ("+" | "-") ^^ {
        case "+" => (n: Int) => n + 1
        case "-" => (n: Int) => n - 1
    }

    def wtfPrint = term <~ "!" ^^ {t => () => println(t())}

    def block = wtfPrint | term

    def conditional = term ~ ("?" ~> "[" ~> block <~ "]" ) ~ (":" ~> "[" ~> block <~ "]") ^^ {
        case t ~ b1 ~ b2 => if (t() == 0) b1() else b2()
    }
    

}

object Main {
    def main(args: Array[String]): Unit = {
        val p = new WTFEValuator
        args.foreach(
            filename => {
                val r = new FileReader(filename)
                p.parseAll(p.start, "0- ? [0+!] : [0-!]") match {
                    case p.Success(r, _) => r
                    case x => println(x)
                }
            }
        )
       
    }
}