;;;;;;;;;;;;;;;;;;;;;;;;
;;; REQUIRED IMPORTS ;;;
;;;;;;;;;;;;;;;;;;;;;;;;
(load (compile-file "G:/Projects/School/CS305/diagnosis/data.cl"))
(load (compile-file "G:/Projects/School/CS305/diagnosis/learning-problem.cl"))
(load (compile-file "G:/Projects/School/CS305/diagnosis/dtl.cl"))

;;;;;;;;;;;;;;;;;;;;;;;
;;; PROGRAM GLOBALS ;;;
;;;;;;;;;;;;;;;;;;;;;;;
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

;;; Top-level entry into the program.  It initializes
;;; the decision tree and starts a new diagnosis loop.
(defun new-diagnosis ()
  (initialize)
  (diagnose))

;;; Present the current query to the user.  This funcion is 
;;; called recursively to traverse the decision tree based
;;; on the input from the user.
(defun diagnose()
  "Presents the user with a question to help identify the illness."
  (format t "Does the patient exhibit the symptom -- has ~a (~{~a~^, ~}): "
    (first *current-symptom*) 
    (rest *current-symptom*))
  (force-output)
  
  ;;; Read the user input
  (let ((input (read)))        
        ;;; Validate the input against the value list.
        ;;; If the input is invalid, ask the question again.
        (unless (find input (rest *current-symptom*))
          (format t "Your description must be a member of the symptom's list.~&")
          (force-output)
          (diagnose))        
        
        ;;; Choose the next branch of the decision tree
        (select-branch input)
  
        ;;; If we've reached another branch node, then
        ;;; continue the diagnosis.  Otherwise, display
        ;;; the result of the leaf node.
        (if (listp *current-node*)
            (diagnose)
          (print-diagnosis))))

;;; Make the branch specified by the value parameter
;;; the active root node for the decision tree.
(defun select-branch (value)
  "Selects a branch from the current node based on user input."
  (setq *current-symptom* nil)
  (setq *current-node* (rest (assoc value *current-node*)))
  (if (listp *current-node*)
      (setq *current-symptom* (first *current-node*))))

;;; Print the diagnosis to the default output stream.
(defun print-diagnosis ()
  (format t "Diagnosis: ~a" *current-node*))
  


;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MAIN PROGRAM LOGIC ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
(initialize)