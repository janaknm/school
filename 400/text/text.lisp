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

#+:sbcl
(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :asdf))

(defconstant +non-word+ '(#\space #\newline #\. #\, #\! #\? #\" #\' #\\))
(defparameter *compressed* t)

(defstruct (category (:conc-name nil))
  name
  dir
  (wordcount 0)
  (freq-table (make-hash-table :test #'equalp)))

(defun decompress ()
  (asdf:run-shell-command "./script decompress")
  (setf *compressed* nil))

(defun load-categories ()
  (when *compressed*
    (decompress))
  (mapcar #'(lambda (path)
              (make-category
               :name (car (last (pathname-directory path)))
               :dir (make-pathname :directory (pathname-directory path) :name :wild :type :wild)))
          (directory "training/*")))

(defun occurrences (word category)
  (or (gethash word (freq-table category))
      0))

(defun read-word (str)
  (loop for c = (read-char str nil :eof)
     while (member c +non-word+)
     finally (unread-char c str))
  (loop for c = (read-char str nil :eof)
     while (and (not (member c +non-word+))
                (not (eql c :eof)))
     collect c into chars
     finally (return (and chars (coerce chars 'string)))))

(defun train-category (cat vocab)
  "fill freq-table and return # of new words added to vocab" 
  (let ((words-added 0))
    (mapc #'(lambda (path)
              (with-open-file (str path :direction :input) 
                (loop for w = (read-word str) while w do
                     (handler-bind
                         ((sb-int:stream-decoding-error
                           #'(lambda (e)
                               (invoke-restart 'sb-int:attempt-resync))))
                       (when (eql 1 (setf (gethash w vocab)
                                            (1+ (gethash w vocab 0))))
                         (incf words-added))))))
          (directory (dir cat)))
    words-added))

(let (categories vocab-size)
  (defun train ()
    (let ((vocab (make-hash-table :test 'equalp)))
      (setf categories (load-categories))
      (dolist (cat categories)
        (incf vocab-size
              (train-category cat vocab)))
      categories)))
    