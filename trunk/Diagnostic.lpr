;; -*- lisp-version: "8.1 [Windows] (Aug 17, 2009 19:30)"; cg: "1.103.2.29"; -*-

(in-package :cg-user)

(define-project :name :|Diagnostic|
  :modules (list (make-instance 'module :name "data")
                 (make-instance 'module :name "main")
                 (make-instance 'module :name "dtl")
                 (make-instance 'module :name "learning-problem"))
  :projects nil
  :libraries nil
  :distributed-files nil
  :internally-loaded-files nil
  :project-package-name :common-graphics-user
  :main-form 'mainform
  :compilation-unit t
  :verbose nil
  :runtime-modules (list :cg-dde-utils :cg.base :cg.button :cg.caret
                         :cg.clipboard :cg.clipboard-stack
                         :cg.common-control :cg.comtab :cg.dialog-item
                         :cg.editable-text :cg.keyboard-shortcuts
                         :cg.lisp-edit-pane :cg.os-widget
                         :cg.text-edit-pane :cg.text-or-combo
                         :cg.text-widget :cg.toggling-widget)
  :splash-file-module (make-instance 'build-module :name "")
  :icon-file-module (make-instance 'build-module :name "")
  :include-flags (list :top-level :debugger)
  :build-flags nil
  :autoload-warning nil
  :full-recompile-for-runtime-conditionalizations nil
  :include-manifest-file-for-visual-styles t
  :default-command-line-arguments "+M +t \"Console for Debugging\""
  :additional-build-lisp-image-arguments (list :read-init-files nil)
  :old-space-size 256000
  :new-space-size 6144
  :runtime-build-option :standard
  :build-number 4
  :on-initialization 'default-init-function
  :on-restart 'do-default-restart)

;; End of Project Definition
