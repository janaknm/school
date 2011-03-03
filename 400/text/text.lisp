;;;; Matt Forbes
;;;; February 2011 CS 400

;;;; Use of naiive bayes' classification to categorize text documents
;;;; in to categories

;;;;; Incorrect assumptions made to simply calculations:
;;; 1. relative position of two words has no effect on probability
;;; 2. absolute position of a word in the document has no effect
;;; 3. every word has equal probability of occuring in a document
;;; 4. english vocabulary consists just words contained in training documents

;;;;; Calculations used
;;; V = Set of possible categories
;;; v_map = maximum a posteriori value 
;;; w_i = ith word in document
;;; v_map = argmax(v_j in V): P(v_j)*P(w_1 | v_j)*P(w_2 | v_j)*...*P(w_n | v_j)
;;; P(w_i | v_j) = [occurrences(w_i, v_j) + 1] / [wordcount(v_j) + size(vocabulary)]

(defconstant +non-word+ '(#\space #\newline #\. #\, #\! #\? #\" #\' #\\))

(defstruct (category (:conc-name nil))
  name
  dir
  (num-docs 0)
  (wordcount 0)
  (freq-table (make-hash-table :test #'equalp)))

(defstruct doc
  path
  category)

(defun load-categories ()
  (mapcar #'(lambda (path)
              (make-category
               :name (car (last (pathname-directory path)))
               :dir (make-pathname :directory (pathname-directory path) :name :wild :type :wild)))
          (directory "training/*.*")))

(defun read-word (str)
  (loop for c = (read-char str nil :eof)
     while (member c +non-word+)
     finally (unless (eql c :eof)
               (unread-char c str)))
  (loop for c = (read-char str nil :eof)
     while (and (not (member c +non-word+))
                (not (eql c :eof)))
     collect c into chars
     finally (return (and chars (coerce chars 'string)))))

(defun train-category (cat vocab)
  (mapc #'(lambda (path)
            (incf (num-docs cat))
            (with-open-file (str path :direction :input) 
              (loop for w = (read-word str) while w do
                   (unless (member w '("a" "the"))
                     (incf (wordcount cat))
                     (setf (gethash w (freq-table cat))
                           (1+ (gethash w (freq-table cat) 0)))
                     (setf (gethash w vocab) t)))))
        (directory (dir cat))))
  
(defparameter *categories* nil)
(defparameter *vocab* (make-hash-table :test 'equalp))
(defparameter *total-docs* 0)

(defun train ()
  (setf *categories* (load-categories))
  (dolist (cat *categories*)
    (train-category cat *vocab*))
  (setf *total-docs* (reduce #'+ *categories* :key #'num-docs)))

(defun occurrences (word category)
  (or (gethash word (freq-table category))
      0))

(defun word-prob (word category)
  (/ (1+ (occurrences word category))
     (+ (wordcount category) (hash-table-count *vocab*))))

(defun category-prob (category)
  (/ (num-docs category)
     *total-docs*))
  
(defun classify-doc (doc)
  (let ((prob-alist (mapcar #'(lambda (cat)
                                (cons cat (category-prob cat)))
                            *categories*)))
    (with-open-file (str (doc-path doc) :direction :input)
      (loop for w = (read-word str) while w do
           (dolist (prb prob-alist)
             (setf (cdr prb)
                   (* (cdr prb)
                      (word-prob w (car prb)))))))
    (car (maximum prob-alist :key #'cdr))))

(defun gen-tests ()
  (let ((docs nil))
    (dolist (test-dir (directory "classify/*.*"))
      (let* ((cat-name (car (last (pathname-directory test-dir))))
             (cat (find-if #'(lambda (c) (equal cat-name (name c))) *categories*))
             (more-docs (mapcar #'(lambda (path)
                                    (make-doc :path path
                                              :category cat))
                                (directory (make-pathname :directory (pathname-directory test-dir)
                                                          :name :wild
                                                          :type :wild)))))
        (setf docs (append docs more-docs))))
    docs))

(defun run-classification ()
  (let ((tests (gen-tests))
        (correct 0))
    (dolist (doc tests)
      (when (eql (doc-category doc)
                 (classify-doc doc))
        (incf correct)))
    (format t "Classified ~A/~A documents correctly~%" correct (length tests))))


;utility
(defun id (a) a)

(defun maximum (lst &key (key #'id) (test #'>))
  (reduce #'(lambda (best next)
              (if (funcall test (funcall key next)
                           (funcall key best))
                  next
                  best))
          lst))
