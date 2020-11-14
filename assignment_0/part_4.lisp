; CSE341 - Assignment 0 - Part 4
; Oğuzhan Agkuş - 161044003

; NOTES:
; I assumed that ecah character is possible and diffirent. I mean capitals and lowers are different.
; Also it reads any character, which has a ASCII value. So, all character cannot be displayed in the output file
; Newline character is printed as an empty line, it is an exception

; A structure that represent Huffman node
(defstruct node
  (item       nil :type t)
  (frequence  nil :type number)
  (encode     nil :type (or null bit-vector))
  (left-node  nil :type (or null node))
  (right-node nil :type (or null node)))

; Read whole file as a single string
(defun read-file (filename)
  (with-open-file (input filename)
    (let ((data (make-string (file-length input))))
      (read-sequence data input)
      data)))

; Get a string and analyze it, then create and return nodes
(defun analyze (input)
  (let* ((input-len (length input))
         (inc-rate (/ 1 input-len))
         (queue '())
         (nodes (make-hash-table :size input-len :test 'eql)))
    (map nil #' (lambda (item)
                  (multiple-value-bind (node exist) (gethash item nodes)
                    (if (not exist)
                      (let ((node (make-node :item item :frequence inc-rate)))
                        (setf (gethash item nodes) node queue (list* node queue)))
                        (incf (node-frequence node) inc-rate))))
      input)
    (values (sort queue '< :key 'node-frequence) nodes)))

; Build Huffman tree
(defun build-tree (queue nodes)
  (do () ((endp (rest queue)) (values nodes (first queue)))
    (destructuring-bind (n1 n2 &rest queue-rest) queue
      (let ((n3 (make-node :left-node n1 :right-node n2 :frequence (+ (node-frequence n1) (node-frequence n2)))))
        (setf queue (merge 'list (list n3) queue-rest '< :key 'node-frequence))))))

; Find Huffman codes
(defun find-codes (nodes tree)
  (labels ((hc (node length bits)
    (let ((left (node-left-node node))
          (right (node-right-node node)))
      (cond ((and (null left) (null right))
              (setf (node-encode node)
              (make-array length :element-type 'bit :initial-contents (reverse bits))))
             (t (hc left (1+ length) (list* 0 bits))
              (hc right (1+ length) (list* 1 bits)))))))
              (hc tree 0 '())
    nodes))

; Compare function for bit-vectors
(defun compare (v1 v2)
  (let ((len1 (length v1))
        (len2 (length v2)))
    (cond ((< len1 len2) t)
          ((> len1 len2) nil)
          (t (loop for i from 0 to (- len1 1)
                do (cond ((< (aref v1 i) (aref v2 i)) (return t))
                         ((> (aref v1 i) (aref v2 i)) (return nil))))))))

; Convert bit-vector to list
(defun vector-to-list (v)
  (let ((len (length v))
        (data '()))
    (loop for i from 0 to (- len 1)
      do (push (aref v i) data))
  (reverse data)))

; Wrapper function
(defun huffman-encoder (input-file output-file)
  (let* ((nodes (multiple-value-bind (queue nodes) (analyze (read-file input-file))
                  (multiple-value-bind (nodes tree) (build-tree queue nodes)
                    (find-codes nodes tree))))
         (ordered-list '()))
    (loop for node being each hash-value of nodes
      do (setf ordered-list (list* node ordered-list)))
    (with-open-file (output output-file :direction :output :if-does-not-exist :create)
      (loop for node in (sort ordered-list 'compare :key 'node-encode)
        do (write-sequence (format nil "~c: ~{~a~^ ~}~%" (character (node-item node)) (vector-to-list (node-encode node))) output )))))

; Wrapper call
(huffman-encoder "paragraph.txt" "huffman_codes.txt")