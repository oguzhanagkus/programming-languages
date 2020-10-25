; CSE341 - Assignment 0 - Part 2
; Oğuzhan Agkuş - 16104003

; Reads and returns first line from given file
(defun read-from-file (filename)
  (with-open-file (input filename :direction :input)
    (read-line input)))

; Reads given line and parse integers, returns a list
(defun parse-boundaries (line)
  (with-input-from-string (input line)
    (loop for k = (read input nil nil) while k collect k)))

; Splits the list, returns two integers
(defun get-boundaries (list)
  (values (car list) (cadr list)))

; Checks if given number is prime
(defun is-prime (number)
  (if (< number 2)
    nil
    (not (loop for divisor from 2 to (floor (sqrt number))
      if (= 0 (mod number divisor))
        do (return t)))))

; Checks if given number is semiprime
(defun is-semiprime (number)
  (loop for divisor from 2 to (floor (sqrt number))
    if (= 0 (mod number divisor))
      do (return (and (is-prime divisor) (is-prime (/ number divisor))))))

; Checks that given number is prime/semi-prime/other
(defun check (number)
  (if (is-prime number)
    1
    (if (is-semiprime number)
      2 0)))

; Wrapper function
(defun prime-crawler (input-file output-file)
  (with-open-file (output output-file :direction :output :if-does-not-exist :create)
    (multiple-value-bind (lower upper) (get-boundaries (parse-boundaries (read-from-file input-file)))
      (loop for n from lower to upper
        while n
          do (let ((result (check n)))
            (cond ((eql 1 result) (write-sequence (format nil "~d is Prime ~%" n) output))
                  ((eql 2 result) (write-sequence (format nil "~d is Semi-prime ~%" n) output))))))))

; Wrapper call
(prime-crawler "./boundaries.txt" "./prime_distribution.txt")
