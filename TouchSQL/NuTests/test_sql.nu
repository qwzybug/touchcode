(load "TouchSQL")

(class TestSQL is NuTestCase
     
     (- testInMemoryDB is
        ;; create and open a database
        (set theDB ((CSqliteDatabase alloc) initInMemory))
        (theDB open)
        ;; make and add data to a table
        (theDB executeExpression:"create table foo (name varchar(100), value integer)")
        (theDB executeExpression:"insert into foo values('one', 1)")
        (theDB executeExpression:"insert into foo values('two', 2)")
        (theDB executeExpression:"insert into foo values('three', 3)")
        ;; fetch all the rows into an array
        (set a (theDB rowsForExpression:"select * from foo"))
        (assert_equal 3 (a count))
        ;; fetch all the rows with an enumerator
        (set e (theDB enumeratorForExpression:"select * from foo"))
        (while (set o (e nextObject))
               (case (o "name") ;; it seems to me that these values should be numbers.
                     ("one" (assert_equal "1" (o "value")))
                     ("two" (assert_equal "2" (o "value")))
                     ("three" (assert_equal "3" (o "value")))
                     (t nil)))
        ;; fetch qualified rows and values into an array
        (set a (theDB rowsForExpression:"select (value) from foo where (name = 'two')"))
        (assert_equal 1 (a count))
        (assert_equal "2" ((a 0) "value"))))