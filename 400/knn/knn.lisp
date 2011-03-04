(defparameter *dimension* 3)
(defparameter *k* 5)

(defun read-data (path)
  (let ((acc nil))
    (with-open-file (str path :direction :input)
      (loop for line = (read-line str nil :eof) 
         until (eql :eof line) do
           (let ((words (split-by line #\Space)))
             (push (cons (car words)
                         (apply #'vector (mapcar #'read-from-string (cdr words))))
                   acc)))
         acc)))

(defun split-by (string char)
  (loop for i = 0 then (1+ j)
     as j = (position char string :start i)
     collect (subseq string i j)
     while j))

(defun dist (v1 v2)
  (apply #'+ (loop for i from 0 to (1- *dimension*)
                  collect (sq (- (svref v2 i) (svref v1 i))))))

(defun k-nearest (pt data)
  (let ((best-k 
         (sort (mapcar #'(lambda (dpt)
                           (cons dpt
                                 (dist pt (cdr dpt))))
                       (subseq data 0 *k*))
               #'<
               :key #'cdr)))
    (print best-k)
    (dolist (dpt (subseq data *k*))
      (dolist (bkpt best-k)
        (when (eql -1 (cmp dpt bkpt #'cdr))
          (
      best-k))

(defmacro cmp (a b fn)
  (let ((af (gensym))
        (bf (gensym)))
    `(let ((,af (funcall ,fn ,a))
           (,bf (funcall ,fn ,b)))
       (cond ((> ,af ,bf) 1)
             ((< ,af ,bf) -1)
             (t 0)))))
       
(defun compose (&rest fns)
  #'(lambda (&rest args)
      (reduce #'(lambda (acc fn) (funcall fn acc)) 
              (cdr fns)
              :initial-value (apply (car fns) args))))

(defun curry (fn &rest args)
  #'(lambda (&rest more-args)
      (apply fn (append args more-args))))

(defmacro sq (x)
  (let ((s (gensym)))
    `(let ((,s ,x))
       (* ,s ,s))))