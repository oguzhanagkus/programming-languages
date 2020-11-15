; CSE341 - Assignment 1 - Part 2
; Oğuzhan Agkuş - 161044003
; 
; G++ Lexer/Tokenizer

(defvar keywords
  (list "and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "deffun" 
        "for" "if" "exit" "load" "disp" "true" "false"))

(defvar operator
  (list "+" "-" "/" "*" "**" "," "(" ")" "\"" "\""))

(defvar keyword-tokens 
  (list "KW_AND" "KW_OR" "KW_NOT" "KW_EQUAL" "KW_LESS" "KW_NIL" 
        "KW_LIST" "KW_APPEND" "KW_CONCAT" "KW_SET" "KW_DEFFUN" "KW_FOR" 
        "KW_IF" "KW_EXIT" "KW_LOAD" "KW_DISP" "KW_TRUE" "KW_FALSE"))

(defvar operator-tokens
  (list "OP_PLUS" "OP_MINUS" "OP_DIV" "OP_MULT" "OP_DBLMULT" 
        "OP_COMMA" "OP_OP" "OP_CP" "OP_OC" "OP_CC"))

; Global input and output files
(defvar input-file nil)
(defvar output-file (open "./output" :direction :output :if-does-not-exist :create ))

; Checks if there is an arguments, returns input stream
(defun mode-check ()
  (let ((len (length *args*)))
    (cond ((eql 0 len)  *standard-input*)
          ((eql 1 len)  (setq input-file (open (nth 0 *args*) :direction :input )))
          (t  (format t "G++ lexer cannot be started!~%You can only run \"clisp gpp_lexer\" or \"clisp ./gpp_lexer filename\"")
              (exit)))))

; Close open files
(defun exit-handler ()
  (if (not (eql input-file nil))
    (close input-file))
  (close output-file))

; Print both terminal and output file
(defun print-handler (text)
  (format t "~a~%" text)
  (write-line text output-file))

; Call lexer for each word
(defun line-handler (line)
  (let ((words) (temp))
    (setq line (string-trim '(#\Space #\Tab #\Newline) line))
    (setq words (splitter line))
    (loop for word in words
      do 
        (setq temp (string-trim '(#\Space #\Tab #\Newline) word))
        (lexer temp))))

; Split line with one space
(defun splitter (line)
  (loop for i = 0 then (1+ j)
    as j = (position #\Space line :start i)
    collect (subseq line i j)
    while j))

; Tokenizer
(defun lexer (word)
  (print-handler word))

; Reads a line from an input stream and call line-handler
(defun gppinterpreter (input)
  (if (equal input *standard-input*)
          (format t "> "))
  (loop for line = (read-line input nil)
    until (or (equal line nil) (equal line ""))
      do 
        (line-handler line)
        (if (equal input *standard-input*)
          (format t "> "))))

; Main function, wraps gppinterpreter and exit-handler
(defun main ()
  (gppinterpreter (mode-check))
  (exit-handler))

(main)