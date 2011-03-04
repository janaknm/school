(defparameter *dimension* 3)
(defparameter *k* 3)
(defparameter *data-path* "/Users/mattforbes/school/400/knn/data.db")

(defmacro sq (x)
  (let ((s (gensym)))
    `(let ((,s ,x))
       (* ,s ,s))))

(defmacro cmp (a b fn)
  (let ((af (gensym))
        (bf (gensym)))
    `(let ((,af (funcall ,fn ,a))
           (,bf (funcall ,fn ,b)))
       (cond ((> ,af ,bf) 'gt)
             ((< ,af ,bf) 'lt)
             (t 'eq)))))


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

;; alternative way would to take k items from the list created by
;; sorting the data using the distance function. Slower as n -> inf.
(defun k-nearest-sort (pt data)
  (subseq (sort data #'< :key (compose #'cdr (curry #'dist pt)))
          0 *k*))

(defun k-nearest (pt data)
  (let ((best-k 
         (sort (mapcar #'(lambda (dpt)
                           (cons dpt
                                 (dist pt (cdr dpt))))
                       (subseq data 0 *k*))
               #'<
               :key #'cdr)))
    (dolist (dpt (subseq data *k*))
      (setf best-k (new-best-k (cons dpt (dist (cdr dpt) pt)) best-k #'cdr)))
     best-k))

(defun new-best-k (pt best-k cmp-fn)
  (let ((check-pt pt))
    (mapcar 
     #'(lambda (obj)
         (if (eql 'lt (cmp check-pt obj cmp-fn))
             (prog1
                 check-pt
               (setf check-pt obj))
             obj))
     best-k)))
        
       
(defun compose (&rest fns)
  #'(lambda (&rest args)
      (reduce #'(lambda (acc fn) (funcall fn acc)) 
              (cdr fns)
              :initial-value (apply (car fns) args))))

(defun curry (fn &rest args)
  #'(lambda (&rest more-args)
      (apply fn (append args more-args))))

