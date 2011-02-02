;;;;; Matt Forbes - CS 400 GPS - General Problem Solver. *This is
;;;;; highly based off the example in ch.4 of Norvig's "Artificial
;;;;; Intelligence Programming"*

;;;; The GPS is a means-ends solution to planning sequence of
;;;; operations to attain a desired state. In other words, this
;;;; algorithm works backwards from the goal back to the current
;;;; state, determining if it's feasible along the way.

;;;; Operations have a set of preconditions that must be satisfied, as
;;;; well as a set of conditions that are added and removed from the
;;;; state after the operation has been executed.

;;;; States are represented by a set of conditions starting with the
;;;; dummy condition STATE that currently hold in the world, and a
;;;; reversed list of actions that were required to get to that state

(defstruct op
  name
  preconds
  add-list
  del-list)

(defstruct (state (:conc-name nil))
  conds 
  (required-actions nil))

(defvar *ops* nil)
(defvar *debug-level* 'info)

(defun gps-print (conds goals &optional (*ops* *ops*))
  "pretty print gps"
  (let ((actions (gps conds goals *ops*)))
    (when actions
      (do ((i 1 (1+ i))
           (lst actions (cdr lst)))
          ((null lst))
        (format t "~a: ~a~%" i (car lst))))))

(defun gps (conds goals &optional (*ops* *ops*))
  "general problem solver"
  (let ((new-state (achieve-all (make-state :conds conds) goals)))
    (if (null new-state)
        nil
        (reverse (required-actions new-state)))))
           
(defun achieve-all (state goals)
  "try achieving all goals from this state"
  (cond ((null state) nil)
        ((or (null (set-difference goals (conds state)))
             (null goals))
         state)
        (t (achieve-all (achieve state (car goals))
                        (cdr goals)))))

(defun achieve (state goal)
  "try to achieve goal from this state"
  (dbg 'info "trying to achieve ~a~%" goal)
  (or (member goal (conds state))
      (let ((op (appropriate-op goal)))
        (if (null op)
            nil
            (apply-op state op)))))

(defun appropriate-op (goal)
  "find an op that will accomplish goal"
  (find-if #'(lambda (op)
               (member goal (op-add-list op)))
           *ops*))
  
(defun apply-op (state op)
  "satsify op preconds and apply op to state"
  (let ((new-state (achieve-all state (op-preconds op))))
    (if (null new-state)
        nil
        (make-state :conds (set-difference (union (conds new-state) (op-add-list op))
                                           (op-del-list op))
                    :required-actions (cons (op-name op) (required-actions new-state))))))
      
(defun use-ops (ops)
  "use a set of operations in gps"
  (setf *ops* ops))

(defun debug-level (lvl)
  (setf *debug-level* lvl))

(defun dbg (lvl format &rest args)
  (when (eql lvl *debug-level*)
    (apply #'format (append (list 't format) args))))


;;;; tests
(defparameter *pizza-ops* 
  (list
   (make-op :name "eat pizza"
            :preconds '(have-pizza)
            :add-list '(full)
            :del-list '('have-pizza))
   (make-op :name "put pizza in oven"
            :preconds '(have-prepared-pizza)
            :add-list '(have-pizza)
            :del-list '(have-prepared-pizza))
   (make-op :name "add sauce and toppings"
            :preconds '(have-rolled-dough)
            :add-list '(have-prepared-pizza)
            :del-list '(have-rolled-dough))
   (make-op :name "roll dough"
            :preconds '(have-dough)
            :add-list '(have-rolled-dough)
            :del-list '(have-dough))
   (make-op :name "make dough"
            :preconds '(have-flour have-yeast have-water)
            :add-list '(have-dough)
            :del-list '(have four have-yeast have-water))))

(defparameter *drive-ops*
  (list
   (make-op :name "drive to work"
            :preconds '(in-car have-gas)
            :add-list '(at-work)
            :del-list '(in-car))
   (make-op :name "fill gas"
            :preconds '(at-gas-station have-money)
            :add-list '(have-gas)
            :del-list '(have-money))
   (make-op :name "drive to gas station"
            :preconds '(in-car)
            :add-list '(at-gas-station)
            :del-list '())
   (make-op :name "enter car"
            :preconds '(have-car at-home)
            :add-list '(in-car)
            :del-list '(at-home))))
  
            
  