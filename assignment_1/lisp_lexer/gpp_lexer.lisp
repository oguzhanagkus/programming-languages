; CSE341 - Assignment 1 - Part 2
; Oğuzhan Agkuş - 161044003
; 
; G++ Lexer/Tokenizer

(defvar keyword-tokens 
  (list "KW_AND" "KW_OR" "KW_NOT" "KW_EQUAL" "KW_LESS" "KW_NIL" 
        "KW_LIST" "KW_APPEND" "KW_CONCAT" "KW_SET" "KW_DEFFUN" "KW_FOR" 
        "KW_IF" "KW_EXIT" "KW_LOAD" "KW_DISP" "KW_TRUE" "KW_FALSE"))

(defvar operator-tokens
  (list "OP_PLUS" "OP_MINUS" "OP_DIV" "OP_MULT" "OP_DBLMULT" 
        "OP_COMMA" "OP_OP" "OP_CP" "OP_OC" "OP_CC" "OP_DIV2"))

(defvar keywords
  (list "and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "deffun" 
        "for" "if" "exit" "load" "disp" "true" "false"))

(defvar operators
  (list "+" "-" "/" "*" "**" "," "(" ")" "\"" "\"" "\\"))

(defvar space 
  (list " " "\t" "\n"))

(defvar allowed 
  (list "(" ")" "\""))

(defvar comment ";")
(defvar quote-count 0)
(defvar tokens (list))

; Global input and output files
(defvar input-file nil)
(defvar output-file (open "./output" :direction :output :if-does-not-exist :create ))

; Close open files
(defun exit-handler ()
  (if (not (equal input-file nil))
    (close input-file))
  (close output-file))

; Print both terminal and output file
(defun print-handler (text)
  (format t "~a~%" text)
  (write-line text output-file))

; Returns index of an element in given list
(defun get-index (element lookup &optional (index 0))
  (if (equal 0 (length lookup))
    nil
    (if (string= element (car lookup))
      index
      (get-index element (cdr lookup) (+ index 1)))))

; Checks if given word is a value
(defun is-value (word)
  (let ((result t) (ch))
    (if (equal nil (every #'digit-char-p word))
      (setq result nil)
      (progn
        (if (equal 1 (length word))
          (setq result t)
          (progn
            (setq ch (char word 0))
            (if (equal 0 (digit-char-p ch))
              (setq result nil)
              (setq result t))))))
    result))

; Checks if given word is an identifier
(defun is-identifier (word)
  (let ((result t) (ch)
        (size (- (length word) 1)))
    (loop for i from 0 to size
      do
        (progn
          (setq ch (char word i))
          (if (equal 0 i)
            (if (or (alpha-char-p ch) (char= ch #\_ ))
              (setq result t)
              (setq result nil))
            (if (or (alpha-char-p ch) (digit-char-p ch) (char= ch #\_ ))
              ()
              (setq result nil)))
          (if (equal nil result)
            (return result))))
    result))

; Split line with one space then return a list of words
(defun splitter (line)
  (loop for i = 0 then (1+ j)
    as j = (position #\Space line :start i)
    collect (subseq line i j)
    while j))

; Helper
(defun decide (check)
  (let ((result check)
        (len (list-length tokens)))
		(if (> len 2)
			(if (and (string= (nth (- len 3) tokens) "(") (string= (nth (- len 2) tokens) "exit")  (string= (nth (- len 1) tokens) ")")) (setq result -1)))
    result))

; Tokenizer
(defun lexer (word)
	(let ((j 0) (id 0) (check 0) (size (length word)) (subword) (result) (temp))
		(loop for i from 1 to size
			do
			(progn
				(if (= check 1)
          (setq check 0))
				(setq subword (string-downcase (subseq word j i)))

				; Checks if subword is a keyword
				(if (= check 0)
					(progn
						(setq result (get-index subword keywords))
						(if (not (equal result nil))
							(if (>= i size)
								(progn
                  (setq tokens (append tokens (list subword)))
                  (print-handler (nth result keyword-tokens))
                  (setq check 1))
								(progn
								 	(setq temp (subseq word i (+ i 1)))

								 	; For other tokens, only allowed tokens are possible after them
								 	(if (and (equal (get-index temp allowed) nil))
								 		(if (equal (is-identifier (concatenate 'string subword temp)) nil) 
								 			(progn
                        (setq check -1)
                        (print-handler (format nil "Error! ~S cannot be tokenized." (subseq word j size)))))
								 		(progn
                      (setq tokens (append tokens (list subword)))
                      (print-handler (nth result keyword-tokens))
                      (setq j i)
                      (setq check 1))))))))
                      
				; Checks if subword is an operator
				(if (= check 0)
					(progn
						(setq result (get-index subword operators))
						(if (not (equal result nil))
							(progn
								; If it is multiplication operator, check next character for double multiplication
								(if (equal result 3)
									(if (and (< i size) (string= (subseq word i (+ i 1)) "*"))
                    (progn
                      (setq i (+ i 1))
                      (setq result 4))))

                ; If it is division operator, check next character for double divison
								(if (equal result 2)
									(if (and (< i size) (string= (subseq word i (+ i 1)) "/"))
                    (progn
                      (setq i (+ i 1))
                      (setq result 10))))

								; If it is quote ("), check it for opening or closing quote
								(if (equal result 7)
                  (progn
                    (setq result (+ result (mod quote-count 2)))
                    (setq quote-count (+ quote-count 1))))

								; If it is one of (phrantesis, quote or comma), any token is possible after it
								(if (or (equal result 5) (equal result 6) (equal result 7) (equal result 9))
									(progn
                    (setq tokens (append tokens (list subword)))
                    (print-handler (nth result operator-tokens))
                    (setq j i)
                    (setq check 1))

									; For other tokens, only allowed tokens are possible after them
									(if (>= i size)
										(progn
                      (setq tokens (append tokens (list subword)))
                      (print-handler (nth result operator-tokens))
                      (setq check 1))
										(progn
										 	(setq temp (subseq word i (+ i 1)))
										 	(if (equal (get-index temp allowed) nil)
										 		(progn 
                          (setq check -1)
                          (print-handler (format nil "Error! ~S cannot be tokenized." (subseq word j size))))
										 		(progn
                          (setq tokens (append tokens (list subword)))
                          (print-handler (nth result operator-tokens))
                          (setq j i)
                          (setq check 1))))))))))

				; Checks if subword is a comment
				(if (and (= check 0) (string= subword comment))
				  (if (and (< i size)
            (string= (subseq word i (+ i 1)) comment))
						(progn 
              (setq tokens (append tokens (list "COMMENT")))
              (print-handler "COMMENT")
              (setq j i)
              (setq check 2))))

				; Checks if subword is a value
				(if (= check 0)
					(progn
						(setq result (is-value subword))
						(if (not (equal result nil))
							(progn
								(loop
									(setq temp (string-downcase (subseq word j i)))
									(setq i (+ i 1))
									(when (or (equal (is-value temp) nil) (> i size)) (return)))

								(setq i (- i 1))
								(if (equal (is-value temp) nil)
                  (setq i (- i 1)))								
								(if (>= i size)
									(progn
                    (setq tokens (append tokens (list subword)))
                    (print-handler "VALUE")
                    (setq check 1))
									(progn
									 	(setq temp (subseq word i (+ i 1)))
									 	(if (equal (get-index temp allowed) nil)
									 		(progn
                        (setq check -1)
                        (print-handler (format nil "Error! ~S cannot be tokenized." (subseq word j size))))
									 		(progn
                        (setq tokens (append tokens (list subword)))
                        (print-handler "VALUE")
                        (setq j i)
                        (setq check 1)))))))))

				; Checks if subword is a identifier
				(if (= check 0)
				  (progn
						(setq result (is-identifier subword))
						(if (equal result t)
							(if (= i size)
								(progn
                  (setq tokens (append tokens (list subword)))
                  (print-handler "IDENTIFIER")
                  (setq check 1))
								(progn
									(setq temp (string-downcase (subseq word j (+ i 1))))
									(setq id (is-identifier temp))
									(if (equal result id)
										()
										(progn
										 	(setq temp (subseq word i (+ i 1)))
										 	(if (equal (get-index temp allowed) nil)
										 		(progn
                          (setq check -1)
                          (print-handler (format nil "Error! ~S cannot be tokenized." (subseq word j size))))
										 		(progn (setq tokens (append tokens (list subword)))
                          (print-handler "IDENTIFIER")
                          (setq j i)
                          (setq check 1)))))))

							(progn
                (setq check -1)
                (print-handler (format nil "Error! ~S cannot be tokenized." (subseq word j size)))))))
        
        (setq check (decide check))
				(if (or (= check -1) (= check 2)) (return check))))
		check))

; Call lexer for each word
(defun line-handler (line)
  (let ((words) (temp) (result 0))
    (setq line (string-trim '(#\Space #\Tab #\Newline) line))
    (setq words (splitter line))
    (loop for word in words
      do
        (progn 
          (setq temp (string-trim '(#\Space #\Tab #\Newline) word))
          (setq result (lexer temp))
          (if (or (= result 2) (= result -1))
					  (return result))))))

; Reads a line from an input stream and call line-handler
(defun gppinterpreter (input)
  (if (equal input *standard-input*)
          (format t "> "))
  (loop for line = (read-line input nil)
    until (or (equal line nil) (and (equal input *standard-input*) (equal line "")))
      do 
        (line-handler line)
        (if (equal input *standard-input*)
          (format t "> "))))

; Checks if there is an arguments, returns input stream
(defun mode-check ()
  (let ((len (length *args*)))
    (cond ((equal 0 len)  *standard-input*)
          ((equal 1 len)  (setq input-file (open (nth 0 *args*) :direction :input )))
          (t  (format t "G++ lexer cannot be started!~%You can only run \"clisp gpp_lexer\" or \"clisp ./gpp_lexer filename\"")
              (exit)))))

; Main function, wraps gppinterpreter and exit-handler
(defun main ()
  (gppinterpreter (mode-check))
  (exit-handler))

(main)