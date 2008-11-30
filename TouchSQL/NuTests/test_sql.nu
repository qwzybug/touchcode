(load "TouchSQL")

(class TestSQL is NuTestCase
     
     (- testInMemoryDB is
        ;; create and open a database
        (set theDB ((CSqliteDatabase alloc) initInMemory))
        (theDB open:(set errorp (NuReference new)))
        ;; make and add data to a table
        (theDB executeExpression:"create table foo (name varchar(100), value integer)" error:errorp)
        (theDB executeExpression:"insert into foo values('one', 1)" error:errorp)
        (theDB executeExpression:"insert into foo values('two', 2)" error:errorp)
        (theDB executeExpression:"insert into foo values('three', 3)" error:errorp)
        ;; fetch all the rows into an array
        (set a (theDB rowsForExpression:"select * from foo" error:errorp))
        (assert_equal 3 (a count))
        ;; fetch all the rows with an enumerator
        (set e (theDB enumeratorForExpression:"select * from foo" error:errorp))
        (while (set o (e nextObject))
               (case (o "name") ;; it seems to me that these values should be numbers.
                     ("one" (assert_equal "1" (o "value")))
                     ("two" (assert_equal "2" (o "value")))
                     ("three" (assert_equal "3" (o "value")))
                     (t (puts (+ "unrecognized object:" (o description))) nil)))
        ;; fetch qualified rows and values into an array
        (set a (theDB rowsForExpression:"select (value) from foo where (name = 'two')" error:errorp))
        (assert_equal 1 (a count))
	;; this seems inconsistent with the result of enumeratorForExpression.
	;; rowsForExpression returns a number value while the enumerator returns a string value.
        (assert_equal 2 ((a 0) "value"))))
