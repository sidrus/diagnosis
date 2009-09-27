;;; This is the main code file.
(defparam *kb* (list *kb*)
  "The main symptom/disease knowledge base")


;;; SHORTEST-PATH function determines the least-cost
;;; route between two nodes in a network
(defun shortest-path (start end net)
  (bfs end (list (list start)) net))

;;; BFS function executes a breadth-first search for a 
;;; goal node given a network of nodes.
(defun bfs (end queue net)
  (if (null queue)
      nil
    (let ((path (car queue)))
      (let ((node (car path)))
        (if (eql node end)
            (reverse path)
          (bfs end
               (append (cdr queue)
                       (new-paths path node net))
               net))))))

;;; NEW-PATHS function is a node expansion function that
;;; discovers new paths from a node.
(defun new-paths (path node net)
  (mapcar #'(lambda (n)
              (cons n path))
    (cdr (assoc node net))))

