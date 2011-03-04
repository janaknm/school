(defun split-lst (lst &optional acc) 
  (cond ((null lst) (nreverse acc))
        (t 
         (when (= 0 (random 2))
           (push (cadr lst) acc)
           (setf (cdr lst) (cddr lst))
           (setf lst (cdr lst)))
         (split-lst (cdr lst) acc))))
             