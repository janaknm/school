(require 'cgn)

(defparameter *dimension* 2)
(defparameter *k* 5)
(defparameter *data-path* ".data.db")

(defmacro cmp (a b fn)
  (let ((af (gensym))
        (bf (gensym)))
    `(let ((,af (funcall ,fn ,a))
           (,bf (funcall ,fn ,b)))
       (cond ((> ,af ,bf) 'gt)
             ((< ,af ,bf) 'lt)
             (t 'eq)))))

;; shortcut for less-than
(defmacro lt (a b fn)
  `(eql 'lt (cmp ,a ,b ,fn)))

(defun id (e) e)

(defun maximum (lst &key (key #'id))
  (let ((best-val (funcall key (car lst)))
        (best (car lst)))
    (dolist (el lst)
      (let ((new-val (funcall key el)))
        (when (> new-val best-val)
          (setf best-val new-val
                best el))))
    best))

;; read data file in line format: classifier x y z. produce list of
;; points in format (classifier . #(x y z))
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

;; split string by character (not robust, single character split only
(defun split-by (string char)
  (loop for i = 0 then (1+ j)
     as j = (position char string :start i)
     collect (subseq string i j)
     while j))

;;
(defun sq-dist (v1 v2)
  (apply #'+ (loop for i from 0 to (1- *dimension*)
                  collect (sq (- (svref v2 i) (svref v1 i))))))

(defun classify (pt data)
  (let ((best-k (k-nearest pt data))
        (weights nil)
        (exact-match nil))
    (dolist (k best-k)
      (when (zerop (cdr k))
        (setf exact-match (caar k))
        (return))
      (let ((group (assoc (caar k) weights :test #'equal)))
        (if group
            (incf (cdr group) (/ 1 (cdr k)))
            (push (cons (caar k) (/ 1 (cdr k))) weights))))
    (or exact-match
        (car (maximum weights :key #'cdr)))))
        

;; alternative way would to take k items from the list created by
;; sorting the data using the distance function. Slower as n -> inf.
(defun k-nearest-sort (pt data)
  (subseq 
   (sort (mapcar #'(lambda (d) (cons d (sq-dist (cdr d) pt))) data)
         #'< 
         :key #'cdr)
   0 *k*))

;; asuming format of data to be (classifier . #(x y z)), return the *k*
;; nearest neighbors to point pt: #(x y z)
(defun k-nearest (pt data)
  (let ((best-k 
         (sort (mapcar #'(lambda (dpt)
                           (cons dpt
                                 (sq-dist pt (cdr dpt))))
                       (subseq data 0 *k*))
               #'<
               :key #'cdr)))
    (dolist (dpt (subseq data *k*))
      ;; calculate dist to pt, and calculate new list of *k*
      ;; best points
      (setf best-k 
            (new-best-k (cons dpt (sq-dist (cdr dpt) pt)) 
                        best-k 
                        #'cdr)))
     best-k))

;; helper for k-nearest
(defun new-best-k (pt best-k cmp-fn)
  (let ((check-pt pt))
    (mapcar 
     #'(lambda (obj)
         (if (lt check-pt obj cmp-fn)
             (prog1
                 check-pt
               (setf check-pt obj))
             obj))
     best-k)))
        
;; generate random data points within cube; save to *data-path*
(defun write-random-points (n max-val classifiers)
  (let ((n-classifiers (length classifiers)))
    (with-open-file (str *data-path* :direction :output
                                     :if-exists :supersede)
      (dotimes (i n)
        (format str "~A " (elt classifiers (random n-classifiers)))
        (dotimes (j (1- *dimension*))
          (format str "~A " (random (float max-val))))
        (format str "~A~%" (random (float max-val)))))))

(defun write-corner-points (n &optional (prob 0.8))
  (write-constraints n '(((0 0.5) (0 0.5))
                         ((0.5 1) (0 0.5))
                         ((0 0.5) (0.5 1))
                         ((0.5 1) (0.5 1)))
                     prob))

(defun write-constraints (n constraints max-val &optional (prob 0.8))
  (with-open-file (str *data-path* :direction :output
                                   :if-exists :supersede)
    (let ((i 1))
      (dolist (bounds constraints)
        (destructuring-bind ((x0 x1) (y0 y1)) bounds
          (dotimes (j (ceiling (/ n (length constraints))))
            (if (< (random 1.0) prob)
                (format str "~a ~a ~a~%" i 
                        (+ x0 (random (- x1 x0)))
                        (+ y0 (random (- y1 y0))))
                (format str "~a ~a ~a~%" i 
                        (random max-val) 
                        (random max-val)))))
        (incf i)))))
                        
(defun to-gnuplot (data &optional filename)
  (let ((grouped (group-data data)))
    ;; write temp data file
    (with-open-file (str ".tmp.dat"
                         :direction :output
                         :if-exists :supersede)
      (dolist (group grouped)
        (dolist (pt (cdr group))
          (format str "~a ~a~%" (svref pt 0) (svref pt 1)))
        (format str "~%")))
    
    (cgn:with-gnuplot ('linux)
      (when filename
        (cgn:format-gnuplot "set terminal png")
        (cgn:format-gnuplot "set output '~a'" filename))
      (cgn:format-gnuplot "set style data points")
      (cgn:format-gnuplot "set xrange [0:1]")
      (cgn:format-gnuplot "set yrange [0:1]")
      (cgn:format-gnuplot "set key outside top")
      (cgn:format-gnuplot "set grid")
      (cgn:format-gnuplot "set xtics 0.5")
      (cgn:format-gnuplot "set ytics 0.5")
      (cgn:format-gnuplot "plot ")
      (let ((str (make-string-output-stream)))
        (dotimes (i (length grouped))
          (format 
           str 
           "'.tmp.dat' every :::~a::~a using 1:2 title '~a' with points lw 0.2 lc ~a pt 6" 
           i i (car (elt grouped i)) (car (elt grouped i)))
          (unless (eql i (1- (length grouped)))
            (format str ", ")))
        (cgn:format-gnuplot (get-output-stream-string str)))
      (cgn:print-graphic))))
  
      
      
(defun group-data (data)
  (let ((grouped nil))
    (dolist (pt data)
      (let ((g (assoc (car pt) grouped :test #'equal)))
        (if g
            (setf (cdr g) (cons (cdr pt) (cdr g)))
            (push (cons (car pt) (list (cdr pt))) grouped))))
    grouped))

;; main 
(defun run (n n-tests &optional (prob 0.8))
  (write-corner-points n prob)
  (let ((data (read-data *data-path*))
        (correct 0))
    (to-gnuplot data "initial.png")
    (dotimes (i n-tests)
      (let* ((rnd-point (vector (random 1.0) (random 1.0)))
            (group (classify rnd-point data)))
        (push (cons group
                    rnd-point)
              data)
        (when (correct-p rnd-point group)
          (incf correct))))
    (to-gnuplot data "classified.png")
    (format t "classified ~a/~a correctly" correct n-tests)))

(defun correct-p (pt group)
  (let ((x (svref pt 0))
        (y (svref pt 1))
        (g (read-from-string group)))
    (cond ((and (< x 0.5)
                (< y 0.5))
           (eql 1 g))
          ((and (> x 0.5)
                (< y 0.5))
           (eql 2 g))
          ((and (< x 0.5)
                (> y 0.5))
           (eql 3 g))
          ((and (> x 0.5)
                (> y 0.5))
           (eql 4 g)))))
           
               
(defun sq (x)
  (* x x))

(defun compose (&rest fns)
  #'(lambda (&rest args)
      (reduce #'(lambda (acc fn) (funcall fn acc)) 
              (cdr fns)
              :initial-value (apply (car fns) args))))

;; from CL cookbook - optimization
(declaim (ftype (function (function &rest t) function) curry)
         (inline curry))

(defun curry (fn &rest args)
  #'(lambda (&rest more-args)
      (apply fn (append args more-args))))

