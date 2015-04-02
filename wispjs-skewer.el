;; (setq httpd-root default-directory)

(defun wispjs-skewer-send-region (beg end)
  (let ((sbuf (current-buffer)))
    (with-temp-buffer
      (let ((tbuf (current-buffer)))
        (set-buffer sbuf)
        (call-process-region beg end
                             wisp-program nil tbuf nil "--no-map")
        (set-buffer tbuf)
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

