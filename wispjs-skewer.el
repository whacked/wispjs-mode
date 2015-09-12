;; (setq httpd-root default-directory)

(setq wispjs-preamble "")

(defun wispjs-skewer-send-region (beg end)
  (let ((selected (buffer-substring beg end)))
    (with-temp-buffer
      (let ((tbuf (current-buffer)))
        (insert wispjs-preamble)
        (insert selected)
        (call-process-region
         (point-min) (point-max)
         wisp-program
         t ;; delete = replace region with eval output
         tbuf nil "--no-map")
        (skewer-eval (buffer-string) #'skewer-post-minibuffer)))))

(defun wispjs-skewer-eval-preceding-sexp ()
  (interactive)
  (save-excursion
    (let ((beg (progn (beginning-of-sexp)
                      (point)))
          (end (progn (end-of-sexp)
                      (point))))
      (wispjs-skewer-send-region beg end))))

(defun wispjs-skewer-eval-defun ()
  (interactive)
  (save-excursion
    (let ((beg (progn (beginning-of-defun)
                      (point)))
          (end (progn (end-of-defun)
                      (point))))
      (wispjs-skewer-send-region beg end))))

(define-key wispjs-mode-map (kbd "C-x C-e") 'wispjs-skewer-eval-preceding-sexp)
(define-key wispjs-mode-map (kbd "C-M-x") 'wispjs-skewer-eval-defun)

