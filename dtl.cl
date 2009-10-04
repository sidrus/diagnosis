;;; This code is based on the algorithms published at:
;;; http://aima.cs.berkeley.edu/
;;;
;;; decision tree learning algorithm - the standard "induction algorithm"
;;; returns a tree in the format
;;;   (a1 (v11 . <tree>) (v12 . <tree>)), bottoming out with goal values.
;;; currently handles only a single goal attribute


;;; Main entry point
(defun decision-tree-learning (problem)
  (dtl (learning-problem-examples problem)
       (learning-problem-attributes problem)
       (first (learning-problem-goals problem))))

;;; 
(defun dtl (examples attributes goal &optional prior &aux (trees nil))
  (cond ((null examples) prior)
        ;;; No attributes to choose from, so calculate the
        ;;; Majority of the examples
        ((null attributes) (majority examples goal))
        
        ;;; If all the examples have the same result,
        ;;; return the first value
        ((every #'(lambda (e) (eq (attribute-value goal e) 
				  (attribute-value goal (first examples))))
		(rest examples))
         (majority examples goal))
        
        ;;; We can build a decision tree, so iterate through
        ;;; the available attributes, selecting the most
        ;;; valuable attribute first.  Remove the attribute from
        ;;; the list once we select it so that we don't enter an 
        ;;; infinite loop.
        (t (let ((best (select-attribute examples attributes goal)))
             (dolist (v (rest best) (cons best trees))
               (push (cons v (dtl (remove-if-not 
				    #'(lambda (e) (eq v (attribute-value best e)))
				    examples)
				  (remove best attributes)
				  goal
				  (majority examples goal)))
                     trees))))))

;;;
(defun distribution (examples goal
                     &aux (l (length (rest goal)))
		          (d (make-list l :initial-element 0)))
  (dolist (e examples) 
    (incf (nth (position (attribute-value goal e) (rest goal)) d)))
  (mapcar #'(lambda (n) (float (/ n (length examples)))) d))

;;; 
(defun majority (examples goal)
  (the-biggest #'(lambda (v) 
		   (count v (mapcar #'(lambda (e) (attribute-value goal e))
				    examples))) 
	       (rest goal)))

;;; This function returns the next remaining attribute with the 
;;; largest information value
(defun select-attribute (examples attributes goal)
  (the-biggest #'(lambda (a) (information-value a examples goal)) 
	       attributes))

;;;  This is an implementation of the informational value formula
;;; found on pg. 659 of the text book.  This function calculates the
;;; 
(defun information-value 
  (a examples goal 
   &aux (i (bits-required (distribution examples goal))))
  (dolist (v (rest a) i)
    (let ((s (remove-if-not #'(lambda (e) (eq (attribute-value a e) v)) examples)))
      (when s (decf i (* (bits-required (distribution s goal))
                         (/ (length s) (length examples))))))))

;;; Determines the number of bits of information required
;;; to find to classify the data (d)
(defun bits-required (d &aux (b 0))
  (dolist (p d (- b))
    (unless (= 0 p)
      (incf b (* p (log p 2))))))

;;; Scan a list of values to find the largest value in the
;;; list using the function provided.
(defun the-biggest (fn l)
  (let ((biggest (first l))
	(best-val (funcall fn (first l))))
    (dolist (x (rest l))
      (let ((val (funcall fn x)))
	(when (> val best-val)
	  (setq best-val val)
	  (setq biggest x))))
    biggest))
