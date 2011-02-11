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

(defparameter categories '(like dislike))
