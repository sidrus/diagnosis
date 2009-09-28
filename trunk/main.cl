;;;;;;;;;;;;;;;;;;;;;;;;
;;; REQUIRED IMPORTS ;;;
;;;;;;;;;;;;;;;;;;;;;;;;
(load (compile-file "G:/Projects/School/CS305/diagnosis/data.cl"))
(load (compile-file "G:/Projects/School/CS305/diagnosis/learning-problem.cl"))
(load (compile-file "G:/Projects/School/CS305/diagnosis/dtl.cl"))

;;;;;;;;;;;;;;;;;;;;;;;
;;; PROGRAM GLOBALS ;;;
;;;;;;;;;;;;;;;;;;;;;;;
(defparameter *goals* '((diagnosis chicken-pox measles mumps influenza pneumonia no-illness common-cold)))
(defvar *diagnosis-problem*)
(defvar *decision-tree*)
(defvar *current-node*)
(defvar *current-symptom*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Some utility functions ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun initialize ()
  "Initialize the expert system."
  
  ;;; Define a problem set based on observation data
  (setq *diagnosis-problem*
      (make-learning-problem
       :attributes *attributes*
       :goals *goals*
       :examples *examples*))
  
  ;;; Use the problem to build a decision tree
  (setq *decision-tree*
        (decision-tree-learning *diagnosis-problem*))
  
  ;;; Make our decision tree the default root node
  (setq *current-node* *decision-tree*)
  (setq *current-symptom* (first *current-node*)))

(defun new-diagnosis ()
  (initialize)
  (diagnose))

(defun diagnose()
  "Presents the user with a question to help identify the illness."
  (format t "Patient has ~a (~{~a~^, ~}): "
    (first *current-symptom*) 
    (rest *current-symptom*))
  (force-output)
  (select-branch (read))
  (if (listp *current-node*)
      (diagnose)
    (print-diagnosis)))

(defun select-branch (value)
  "Selects a branch from the current node based on user input."
  (setq *current-symptom* nil)
  (setq *current-node* (rest (assoc value *current-node*)))
  (if (listp *current-node*)
      (setq *current-symptom* (first *current-node*))))

(defun print-diagnosis ()
  (format t "Patient has ~a" *current-node*))
  


;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MAIN PROGRAM LOGIC ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
(initialize)