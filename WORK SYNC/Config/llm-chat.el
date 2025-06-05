;;; llm-chat.el --- chat with the llm CLI inside Emacs -*- lexical-binding: t; -*-

(require 'comint)
(require 'ansi-color)
(require 'markdown-mode nil t)           ;; optional

(defgroup llm-chat nil "Chat interface for the llm CLI." :group 'applications)

(defcustom llm-chat-command "llm"
  "Path to the llm executable."
  :type 'string  :group 'llm-chat)

(defcustom llm-chat-args '("chat")
  "Arguments passed to the llm executable."
  :type '(repeat string)  :group 'llm-chat)

(defconst llm-chat-buffer-name "*llm-chat*")

(defun llm-chat--make-comint ()
  (let ((buf (get-buffer-create llm-chat-buffer-name)))
    (with-current-buffer buf
      (apply #'make-comint-in-buffer "llm-chat" buf llm-chat-command nil llm-chat-args)
      (llm-chat-mode))
    buf))

;;;###autoload
(defun llm-chat ()
  (interactive)
  (pop-to-buffer (or (get-buffer llm-chat-buffer-name) (llm-chat--make-comint)))
  (goto-char (point-max)))

(defvar llm-chat-mode-map
  (let ((m (make-sparse-keymap)))
    (set-keymap-parent m comint-mode-map)
    (define-key m (kbd "RET") #'comint-send-input)
    m))

(define-derived-mode llm-chat-mode comint-mode "LLM‑Chat"
  "Major mode for chatting with the llm CLI."
  (setq comint-prompt-regexp "^ *> "          ;; llm prints “> ” with leading spaces
        comint-prompt-read-only t
        comint-scroll-to-bottom-on-input 'this
        comint-scroll-to-bottom-on-output 'this)
  ;; Font‑lock Markdown if available.
  (let* ((kws (cond ((boundp 'markdown-mode-font-lock-keywords)
                     markdown-mode-font-lock-keywords)
                    ((boundp 'markdown-mode-font-lock-keywords-basic)
                     markdown-mode-font-lock-keywords-basic))))
    (when kws (setq-local font-lock-defaults (list kws nil nil nil nil))))
  ;; Strip echoed “User: …” lines before they hit the buffer.
  (add-hook 'comint-preoutput-filter-functions #'llm-chat--drop-echo nil t)
  ;; Colourise and font‑lock everything that *is* kept.
  (add-hook 'comint-output-filter-functions #'llm-chat--postprocess nil t))

(defun llm-chat--drop-echo (s)
  "Remove lines that simply echo the user’s input (they start with “User: ”)."
  (replace-regexp-in-string "^User: .*\\(\n\\|\\'\\)" "" s))

(defun llm-chat--postprocess (output)
  (when comint-last-output-start
    (ansi-color-apply-on-region comint-last-output-start (point))
    (font-lock-ensure comint-last-output-start (point)))
  output)

(provide 'llm-chat)
;;; llm-chat.el ends here
