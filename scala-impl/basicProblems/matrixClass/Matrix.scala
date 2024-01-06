
class Matrix(val rows: Int, val columns: Int) {

    private var M: Array[Array[Int]] = Array.ofDim(rows, columns)
    
    def get(i: Int, j: Int) = {
        (M(i))(j)
    }

    def set(i: Int, j: Int)(v: Int) = {
        (M(i))(j) = v
    }

    def multiply_scalar(x: Int) = {
        val B = new Matrix(rows, columns)
        (0 until rows).foreach(
            i => (0 until columns).foreach(
               j => B.set(i,j)(get(i,j) * x)
            )
        )
        B
    }

    def transpose = {
       val T = new Matrix(columns, rows)
        (0 until columns).foreach(
            j => (0 until rows).foreach(
                i => T.set(j, i)(get(i, j))
            )
        )
        T
    }

    def copy = {
        val B = new Matrix(rows, columns)
        (0 until rows).foreach(
            i => (0 until columns).foreach(
               j => B.set(i,j)(get(i,j))
            )
        )
        B
    }

    def norm = {
        var norm = 0
        var newNorm = 0
        M.transpose.maxBy(x => x.map(x => x.abs).sum).sum 
    }

    
    override def toString(): String = // remove final space
        M.foldLeft("")((acc, r) => acc 
        ++ "[" 
        ++ ((r.take(r.length - 1).foldLeft("")((acc, e) => acc ++ e.toString() ++ " ")) 
        ++ r(r.length - 1).toString() 
        ++ "]\n"))    
}

object Matrix {

    def apply(xss: Array[Int]*) = {
        if(xss.length == 0) throw new Exception("can not create matrix of 0 rows")
        if(xss.exists(_.length == 0)) throw new Exception("can not create matrix of 0 columns")
        if(xss.exists(_.length != xss(0).length)) throw new Exception("rows must have all the same length")

        val matrix = new Matrix(xss.length, xss(0).length) 
        
        (0 until xss.length).foreach(
           i => matrix.M(i) = xss(i)
        )
        matrix
    }
    
    def equivalence(m1: Matrix, m2: Matrix) = {
        m1.rows == m2.rows && m1.columns == m2.columns && {
            (0 until m1.rows).forall(
                i => (0 until m1.columns).forall(
                    j => m1.get(i, j) == m2.get(i, j)
                )
            )
        }
    }

    def addiction(m1: Matrix, m2: Matrix) = {
        if (m1.rows != m2.rows || m1.columns != m2.columns) throw new Exception("Matrix m1 and m2 have different sizes")

        val B = new Matrix(m1.rows, m1.columns)
        (0 until m1.rows).foreach(
            i => (0 until m1.columns).foreach(
                j => B.set(i,j)(m1.get(i,j) + m2.get(i,j))
            )
        )
        B
    }

    def multiplication(m1: Matrix, m2: Matrix) = {
        if (m1.rows != m2.columns) throw new Exception("Matrix m1 and m2 cant be multiplied, the m1 row size is different from the m2 column size")
        
        val B = new Matrix(m1.rows, m2.columns)
        (0 until m2.columns).foreach(
            jm2 => (0 until m1.rows).foreach(
                im1 => (0 until m1.columns).foreach(
                    jm1 => B.set(im1,jm2)(B.get(im1,jm2) + m1.get(im1,jm1) * m2.get(jm1,jm2))
                )
            )
        )
        B
    }
}

object Main{

    def main(args: Array[String]): Unit = {
        val matrisa = new Matrix(2, 2)
        val matrize = new Matrix(2, 2)
        matrisa.set(0,0)(2)
        matrisa.set(0,1)(4)
        matrisa.set(1,1)(1)

        matrize.set(1,0)(3)
        matrize.set(0,1)(1)
        matrize.set(1,1)(7)
        
        println("A")
        println(matrisa)
        println()

        println("B")
        println(matrize)
        println()

        println("A == B?")
        println(Matrix.equivalence(matrisa, matrize))
        println()

        println("A")
        println(matrisa)
        println()
        println("B")
        println(matrize)
        println()

        println("A == B?")
        println(Matrix.equivalence(matrisa, matrize))
        println()

        
        println("A Hashcode")
        println(matrisa.hashCode())
        println("A")
        println(matrisa)

        println("A Copy")
        val a = matrisa.copy
        println(a)
        println("A Copy Hashcode")
        println(a.hashCode())
        println()
        
        println("A + B")
        println(Matrix.addiction(matrisa, matrize))

        println("B + A")
        println(Matrix.addiction(matrize, matrisa))

        println("3A")
        println(matrisa.multiply_scalar(3))


        println("A")
        println(matrisa)
        println()
        println("B")
        println(matrize)
        println()

        println("A x B")
        println(Matrix.multiplication(matrisa, matrize))

        val C = Matrix(Array(1, 2, 3), Array(5, 5, 6))
        println(C)
        println(C.transpose)
        // println(Matrix(Array(), Array(3, 4), Array(2, 5, 3))) // EXCEPTION
        // println(Matrix(Array(1, 2), Array(3, 4), Array(2, 5, 3))) // EXCEPTION
        // println(Matrix()) // EXCEPTION

        val D = Matrix(Array(-3, 5, 7), Array(2, 6, 4), Array(0, 2, 8))
        println(D)
        println(D.norm)
    }
}
