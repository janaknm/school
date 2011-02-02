;;;; solution to problem 2.7 in Russell.

;;; performance measuring environment simulator for vacuum-cleaner
;;; environment. Modularized to allow easy changes to sensors,
;;; actuators, and environment characteristics can be easily changed.

(require 'cl-utilities)

(defstruct (vacuum (:print-function
                    (lambda (vac s d)
                      (format s "#V<~A,~A>"
                              (vacuum-x vac)
                              (vacuum-y vac)))))
  (x 0) (y 0))

(defvar *env* (make-array '(0 0))
  "environment for the vacuum-cleaner")

(defvar *vac* (make-vacuum)
  "vacuum agent")

(defvar *lifetime* 1000
  "number of steps in a simulation")

(defun vacuum-location ()
  "helper to get (x,y)"
  (list (vacuum-x *vac*) (vacuum-y *vac*)))
   
(defun initialize (env x y)
  "initialize the simulation"
  (setf *env* (cl-utilities:copy-array env))
  (setf *vac* (make-vacuum :x x :y y)))

(defun performance-measure ()
  (let ((score 0))
    (loop for i from 0 to (1- (reduce #'* (array-dimensions *env*))) do
         (when (eql 'clean (row-major-aref *env* i))
           (incf score)))
    score))

(defun run-simulation (fn &key (steps *lifetime*)
                               (env #2A((clean dirty)))
                               (x 0)
                               (y 0))
  "run the vacuum simulation"
  (initialize env x y)
  (let ((performance 0))
    (dotimes (i steps)
      (incf performance (perform-action (funcall fn)))
      (incf performance (performance-measure)))
    (format t "<~A,~A> ~A: ~A~%" x y env performance) 
    performance))

(defun use-sensors ()
  "observe the world. return percept"
  (aref *env*
        (vacuum-y *vac*)
        (vacuum-x *vac*)))

(defun perform-action (action)
  "perform an action."
  (case action
    (clean (clean))
    (left (move-left))
    (right (move-right))
    (up (move-up))
    (down (move-down))
    ('nil 0)))

(defun clean ()
  "clean spot that vacuum is occupying"
  (setf (aref *env*
              (vacuum-y *vac*)
              (vacuum-x *vac*))
        'clean)
  0)

(defun move-left ()
  "move vacuum to the left"
  (if (> (vacuum-x *vac*) 0)
      (progn
        (decf (vacuum-x *vac*))
        -1)
      0))

(defun move-right ()
  "move vacuum to the right"
  (if (< (vacuum-x *vac*) (1- (array-dimension *env* 1)))
    (progn
      (incf (vacuum-x *vac*))
      -1)
    0))

(defun move-up ()
  "move vacuum up"
  (if (> (vacuum-y *vac*) 0)
    (progn
      (decf (vacuum-y *vac*))
      -1)
    0))

(defun move-down ()
  "move vacuum down"
  (if (< (vacuum-y *vac*) (1- (array-dimension *env* 0)))
    (progn
      (incf (vacuum-y *vac*))
      -1)
    0))

;;; utilities

(defun to-row-major (arr x y)
  (let ((dim (array-dimensions arr)))
    (+ x (* y (first dim)))))

(defun generate-rooms (n)
  (defun helper (n)
    (if (zerop n)
        '(())
        (let ((next (helper (1- n))))
          (append
           (map 'list
                #'(lambda (lst) (cons 'dirty lst))
                next)
           (map 'list
                #'(lambda (lst) (cons 'clean lst))
                next)))))
  (map 'list
       #'(lambda (lst)
           (make-array (list 1 n) :initial-contents (list lst)))
       (helper n)))

(defun generate-positions (n)
  (and (> n 0)
       (cons (list n 0) (generate-positions (1- n)))))
  
(defun all-combinations (fn lst1 lst2)
  "call fn with all combinations of elements from two lists"
  (and lst1
       (progn (let ((elt1 (car lst1)))
                (dolist (elt2 lst2)
                  (funcall fn elt1 elt2)))
              (all-combinations fn (cdr lst1) lst2))))
         

;;; tests

(defun run-tests (fn size)
  (all-combinations
   #'(lambda (location room)
       (run-simulation (funcall fn)
                       :x (first location)
                       :y (second location)
                       :env room))
   (generate-positions (1- size))
   (generate-rooms size)))


;;; agent functions

;; simple reflex agent function described for 2.7
(defun gen-simple-agent ()
  "simple reflex vacuum agent"
  (lambda ()
    (if (eql 'dirty (use-sensors))
        'clean
        (if (eql 0 (vacuum-x *vac*))
            'right
            'left))))

(defun gen-stateful-agent ()
  "stateful mode-based agent"
  (let ((cleaned (make-hash-table :test #'equal)))
    (lambda ()
      (let ((pos (apply #'to-row-major *env* (vacuum-location))))
        (setf (gethash pos cleaned) t)
        (if (eql 'dirty (use-sensors))
            'clean
            ;where to move
            (dotimes (i (reduce #'* (array-dimensions *env*)))
              (when (and (not (gethash i cleaned))
                         (row-major-aref *env* i))
                (if (< i pos)
                    (return 'left)
                    (return 'right)))))))))
              