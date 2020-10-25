; CSE341 - Assignment 0 - Part 1
; Oğuzhan Agkuş - 16104003

; Reads and returns first line from given file
(defun read-from-file (filename)
  (with-open-file (input filename :direction :input)
    (read-line input)))

; Converts given string into list recursively
(defun string-to-list (line)
  (if (streamp line)
    (if (listen line)
      (cons (read line) (string-to-list line))
      nil)
    (string-to-list (make-string-input-stream line))))

; Flattens given nested list recursively
(defun flatten (data)
  (if (atom data)
    (list data)
    (append (flatten (car data))
      (if (cdr data) 
            (flatten (cdr data))))))

; Writes given list into file
(defun write-to-file (data filename)
  (with-open-file (output filename :direction :output :if-does-not-exist :create)
  (write-sequence data output)))

; Wrapper function
(defun flattener (input-file output-file)
  (write-to-file (format nil "~a" (flatten (string-to-list (read-from-file input-file)))) output-file))

; Wrapper call
(flattener "./nested_list.txt" "./flattened_list.txt")