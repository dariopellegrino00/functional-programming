
import scala.util.parsing.combinator._
import scala.util.matching.Regex
import java.io.FileReader
import java.io.File

class LogLangParser extends JavaTokenParsers {

    override protected val whiteSpace: Regex = """\s+""".r

    def start = rep(task) 

    def task = "task" ~> """[a-zA-Z]+""".r ~ ("{" ~> rep(operation)) <~ "}" 
    
    def operation = (remove | rename) // | backub | merge)

    
    def remove = "remove" ~> unquoted ^^ {
        case name => 
            try {
                new File(name).delete()
            } catch {
                case e: Exception => 
                    println(e.toString)
                    false
            }
    }

    def rename = "rename" ~> unquoted ~ unquoted ^^ {
        case name1 ~ name2 => 
            try {
                (new File(name1).renameTo(new File(name2)))
            } catch {
                case e: Exception => 
                    println(e.toString)
                    false
            }
    }

    def unquoted = """["]""".r ~> """[a-zA-Z/.]+""".r <~ """["]""".r ^^ {s => s}
}

object Main {
    def main(args: Array[String]): Unit = {
        val p = new LogLangParser
        val r = new FileReader(args(0))
        p.parseAll(p.start, r) match {
            case p.Success(r, _) => println(r.toString)
            case x => println(x.toString)
        }
    }
}