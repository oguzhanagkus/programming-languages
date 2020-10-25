; CSE341 - Assignment 0 - Part 3
; Oğuzhan Agkuş - 16104003

; Reads and returns first line from given file
(defun read-from-file (filename)
  (with-open-file (input filename :direction :input)
    (read-line input)))

; Reads given line and parse integers, returns a list
(defun get-numbers (line)
  (with-input-from-string (input line)
    (loop for k = (read input nil nil) 
      while k collect k)))

; Takes an integer and return its collatz sequence
(defun collatz (number)
  (if (not (eql 1 number))
    (if (eql 1 (mod number 2))
      (let ((temp (+ 1 (* 3 number))))
        (append (list number) (collatz temp)))
      (let ((temp (/ number 2)))
        (append (list number) (collatz temp))))
  (list 1)))

; Sequence finder
(defun sequence-finder (input-file output-file)
  (let* ((input-list (get-numbers (read-from-file input-file)))
         (len (list-length input-list))
         (maximum (if (> len 5 ) 5 len)))
        (with-open-file (output output-file :direction :output :if-does-not-exist :create)
          (loop for n from 0 to (- maximum 1)
            do (write-sequence (format nil "~d: ~{~a~^ ~}~%" (nth n input-list) (collatz (nth n input-list))) output)))))

; Wrapper call
(sequence-finder "integer_inputs.txt" "collatz_outputs.txt")