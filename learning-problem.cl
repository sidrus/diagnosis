;;; This file defines a learning problem
;;; This code is based on the algorithms published at:
;;; http://aima.cs.berkeley.edu/

(defstruct (learning-problem (:print-function print-learning-problem))
  examples
  attributes
  goals)

(defun attribute-name (attribute) (first attribute))
(defun attribute-values (attribute) (rest attribute))

(defun attribute-value (attribute example)
  (cdr (assoc (attribute-name attribute) example :test #'eq)))

(defun print-learning-problem (problem &optional stream depth)
  (declare (ignore depth))
  (format stream "#<~A with ~D examples and ~D attributes>"
	  (type-of problem)
	  (length (learning-problem-examples problem))
	  (length (learning-problem-attributes problem))))