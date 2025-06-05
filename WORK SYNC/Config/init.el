;; Adjust the garbage collector threshold to 50MB to improve startup time.
;; A higher threshold reduces garbage collection frequency, which can speed up startup.
;; Note: After startup, consider setting this back to a lower value to release unused memory.
(setq gc-cons-threshold 50000000)  ;; 50MB
(setq byte-compile-warnings nil)
;; Initialize package management using `straight.el`.
;; `straight.el` is a modern, purely functional package manager for Emacs.
;; It clones packages directly from Git, offering more control and reproducibility.

;; Declare a variable for the bootstrap version of straight.el.
(defvar bootstrap-version)

;; Set up the bootstrap process for straight.el.
;; This ensures straight.el is installed and loaded properly.
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))  ;; Specify the bootstrap version.
  (unless (file-exists-p bootstrap-file)
    ;; If the bootstrap file doesn't exist, retrieve and install straight.el.
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)  ;; Retrieve the installation script silently without cookies.
      (goto-char (point-max))  ;; Navigate to the end of the buffer.
      (eval-print-last-sexp))) ;; Evaluate the last sexp to install straight.el.
  (load bootstrap-file nil 'nomessage))  ;; Load the bootstrap file without printing messages.

;; Configure straight.el to use `use-package` by default.
;; `use-package` is a declarative configuration tool that simplifies package configuration.
(setq straight-use-package-by-default t)

;; Install `use-package` using straight.el.
;; `use-package` allows organizing package configuration in a clean and easy-to-understand way.
(straight-use-package 'use-package)

(windmove-default-keybindings 'super)

;; Org Mode Configuration [loading later was causing a problem]
(use-package org
  :config
  (require 'ox-md)  ; Markdown export.
  (setq org-confirm-babel-evaluate nil)  ; Don't prompt for confirmation before evaluating code blocks.
  (setq org-startup-folded 'fold)
  ;; Load languages for org-babel.
  (org-babel-do-load-languages
   'org-babel-load-languages '((emacs-lisp . t)
                               (sqlite . t)
			       (shell . t))))
			       
(setq org-confirm-elisp-link-function nil)
(setq org-confirm-shell-link-function nil)

(use-package which-key
  :config
  (which-key-mode))

;; Additional Libraries
(require 'cl-lib)  ; Common Lisp extensions for Emacs.

;; Visual Customizations
(tool-bar-mode -1)        ; Disable the toolbar.
(tooltip-mode -1)         ; Disable tooltips.
(menu-bar-mode -1)        ; Disable the menu bar.
(global-visual-line-mode) ; Enable visual line wrapping globally.
(fringe-mode 0)

;; Frame and Font Settings
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono 12")) ; [IBM Plex Mono] Set default font.
(setq frame-background-mode 'dark) ; Set the default frame background mode to dark.
(setq ns-pop-up-frames nil)        ; Avoid creating new frames for pop-up windows.
(setq-default left-margin-width 2 right-margin-width 2) ; Set default left and right margins.

;; Startup and General UI Settings
(setq inhibit-startup-screen t)         ; Disable the startup screen.
(setq initial-scratch-message nil)      ; Clear the initial message in the scratch buffer.
(setq shr-inhibit-images t)             ; Disable image loading in shr (Simple HTML Renderer).
(setq sentence-end-double-space nil)    ; Single space at the end of sentences.
(setq ring-bell-function 'ignore)       ; Disable the audible bell function.
(display-time-mode t)                   ; Display time in the mode line.
(global-font-lock-mode t)               ; Enable syntax highlighting globally.
(delete-selection-mode 1)               ; Enable delete-selection mode (overwrite selection).
(show-paren-mode 1)                     ; Highlight matching parentheses.
(setq show-paren-style 'parenthesis)    ; Highlight only parentheses, not the text between them.
(setq dired-kill-when-opening-new-dired-buffer t) ; Close previous Dired buffers when opening new ones.
(setq delete-by-moving-to-trash t)      ; Delete files to trash.
(setq backup-directory-alist `(("." . "~/.emacs_backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs_autosaves/\\1" t)))
(setq-default mode-line-format
              '("%e"
                "   "
		mode-line-buffer-identification
		"    L"
                (:eval (format "%s" (line-number-at-pos)))
		"  "
		mode-line-modes
		"       "
                mode-line-misc-info
		mode-line-end-spaces))

(server-start)

;; Package Configurations
;; `exec-path-from-shell` - Ensures environment variables inside Emacs look the same as in the user's shell.
 (use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))  ; If on macOS or similar window systems,
    (exec-path-from-shell-initialize)))   ; Initialize the path from the shell.

;; `all-the-icons` - Provides icons for Emacs.
(use-package all-the-icons)
;; Note: Run (all-the-icons-install-fonts) once after installation.

;; Theme and Modeline Configurations

(load-theme 'modus-vivendi)

;; Display Time Format
(setq display-time-format "%d %b %l:%M %p")  ; Set the format for display time.
(setq display-time-default-load-average nil)   ; Don't display load average.
(display-time-mode 1)

;; Window Management
(setq even-window-sizes nil)  ; Allow uneven window sizes when splitting.

;; Custom Function Definitions
;; ----------------------------

;; Date and Time Insertion
(defvar current-date-time-format "%a %b %d %H:%M:%S %Z %Y"
  "Format of date and time to insert with `insert-current-date-time' function.")
(defvar current-time-format "%a %H:%M:%S"
  "Format of time to insert with `insert-current-time' function.")

(defun pdm/insert-current-date-time ()
  "Insert the current date and time into the current buffer."
  (interactive)
  (insert (format-time-string current-date-time-format (current-time)))
  (insert "\n"))

(defun pdm/insert-current-time ()
  "Insert the current time into the current buffer."
  (interactive)
  (insert (format-time-string current-time-format (current-time)))
  (insert "\n"))

;; UUID
(defun pdm/insert-random-uuid ()
  "Insert a random UUID at the point."
  (interactive)
  (shell-command "uuidgen" t))

;; unfill paragraph
(defun unfill-paragraph (&optional region)
  "Convert a multi-line paragraph into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

;; Key Bindings
;; ----------------------------

;; Basic text editing and navigation
(global-set-key [remap dabbrev-expand] 'hippie-expand)  ; Remap M-/ to hippie-expand.

;; Org-mode specific
(global-set-key (kbd "<M-right>") 'org-timestamp-up-day)    ; Bind M-right arrow to increase date in org timestamp.
(global-set-key (kbd "<M-left>") 'org-timestamp-down-day)   ; Bind M-left arrow to decrease date in org timestamp.

;; Custom utility functions
(global-set-key (kbd "C-c d") 'insert-current-date-time)    ; Bind C-c d to insert current date and time.
(global-set-key (kbd "C-c t") 'insert-current-time)         ; Bind C-c t to insert current time.

;; Key binding for unfill-paragraph
(define-key global-map "\M-Q" 'unfill-paragraph)

;; Better Buffer Management
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Package Configurations
;; ----------------------------

;; Persistent Scratch Buffer
(use-package persistent-scratch
  :config
  (persistent-scratch-setup-default))  ; Keep scratch buffer content across sessions.

;; Diminish Utility
(use-package diminish
  :diminish eldoc-mode
  :diminish emacs-lisp-mode
  :diminish visual-line-mode)

(use-package magit
  :bind (("C-x g" . magit)))  ; Bind C-x g to open magit.

;; PDF Tools for Emacs
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-annot-activate-created-annotations t)
  (pdf-tools-install :no-query)
  (require 'pdf-occur))

;; Ripgrep Integration
(use-package rg
  :config
  (rg-enable-default-bindings))  ; Enable default keybindings for ripgrep.

;; Markdown Mode
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "/opt/homebrew/bin/multimarkdown")
  (setq markdown-enable-wiki-links nil)
  (setq markdown-use-pandoc-style-yaml-metadata t))

(custom-set-faces
      '(markdown-header-face-1 ((t (:foreground "red"))))
      '(markdown-header-face-2 ((t (:foreground "green"))))
      '(markdown-header-face-3 ((t (:foreground "green"))))
      )

(defun my-markdown-highlight ()
   "Function to highlight specific patterns in Markdown mode."
   (highlight-regexp "\\[Todo\\]" 'success) 
   (highlight-regexp "\\[Deadline\\]" 'success) 
   (highlight-regexp "\\[Follow\\]" 'success) 
   (highlight-regexp "\\[Event\\]" 'success) 
;; Add more patterns here
)

(add-hook 'markdown-mode-hook 'my-markdown-highlight)

;; Pandoc Mode

(use-package pandoc-mode
  :init
  (add-hook 'markdown-mode-hook 'pandoc-mode))

;; Completion Packages

;; Consult for Enhanced Searching and Navigation
(use-package consult
  :bind
  ("C-x b" . consult-buffer)
  ("M-l" . consult-line)
  ("C-M-l" . consult-imenu)
  ("M-y" . consult-yank-from-kill-ring)
  :config
  (setq consult-line-start-from-top t)
  (setq consult-locate-args "mdfind -name")
  ;; Additional Consult configurations...
  (consult-customize consult-buffer :preview-key nil)
  )

;; Vertico for Completion UI
(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-count 20)
  (setq vertico-sort-override-function 'vertico-sort-history-alpha)
  ;; Additional Vertico configurations...
  )

;; Orderless Completion Style
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles partial-completion)))))

;; Marginalia for Richer Annotations
(use-package marginalia
  :config
  (marginalia-mode))

;; Embark for Contextual Actions
(use-package embark
  :bind (("C-." . embark-act)
	 ("C-;" . embark-dwim)        ;; good alternative: M-.
	 ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
)

;; Embark Consult Integration
(use-package embark-consult
  :after (embark consult))

;; Save History for completion 
(use-package savehist ; saves minibuffer history between sessions
  :init
  (savehist-mode))

;; Ctrlf for Improved Searching
(use-package ctrlf
  :init
  (ctrlf-mode +1))

;; Multi-Terminal Emulator
(use-package multi-vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

;; ;; TRAMP for Remote File Editing
;; (use-package tramp
;;   :config
;;   (setq tramp-default-method "ssh"))

;; Web Mode for HTML, CSS, and JS
(use-package web-mode
  :config
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-attribute-indent-offset 2)
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

;; Helpful for Enhanced Help
(use-package helpful)

;; ESXML for XML and HTML Manipulation
(use-package esxml
  :straight (esxml :type git :host github :repo "tali713/esxml"))

;; JSON Mode for JSON Files
(use-package json-mode)

;; Python Configuration
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")
(setq python-shell-completion-native-enable nil)
(setq python-indent-guess-indent-offset-verbose nil)

(add-hook 'eshell-mode-hook
          (lambda ()
            (eshell/alias "llmg" "llm $* | glow")))

;; JavaScript Development
(use-package js2-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))

(add-hook 'dired-mode-hook
	  (lambda ()
	    (dired-hide-details-mode)
	    (hl-line-mode)))

(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq delete-by-moving-to-trash t)
(setq dired-dwim-target t)

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))



;; (when (executable-find "mu")
;;   (use-package mu4e
;;     :load-path  "/opt/homebrew/Cellar/mu/1.12.3/share/emacs/site-lisp/mu/mu4e/"
;;     :config
;; ;     (setq mu4e-update-interval (* 10 60))
;;      (require 'smtpmail)
;;      (setq mu4e-get-mail-command "mbsync -a")
;;      (setq mu4e-maildir "~/Mail")
;;      (setq mu4e-completing-read-function #'consult-completing-read-multiple)
;;      (setq mu4e-change-filenames-when-moving t)
;;      (setq mu4e-index-lazy-check nil)
;;      (add-hook 'mu4e-view-mode-hook #'visual-line-mode)
;;      (add-hook 'mu4e-compose-mode-hook (lambda () (auto-fill-mode -1)))
;;      (setq user-full-name "Paul Menair")
;;      (setq user-mail-address "paul@leibel.com")
;;      (setq mu4e-contexts
;;  	  `( ,(make-mu4e-context
;;  	       :name "OutlookNew"
;;  	       :match-func (lambda (msg) (when msg
;;  					   (string-prefix-p "/OutlookNew" (mu4e-message-field msg :maildir))))
;;  	       :vars '(
;;  		       (mu4e-refile-folder . "/Archive")
;;  		       (mu4e-sent-folder . "/Sent")
;;  		       (mu4e-trash-folder . "/Trash")
;;  		       (mu4e-sent-messages-behavior . sent)
;;  		       ))))
;;      (setq mu4e-sent-messages-behavior 'sent)
;;      (setq mu4e-view-show-images nil)
;;      (setq mu4e-view-show-addresses t)
;;      (setq mu4e-user-agent-string nil)
;;      (setq mu4e-compose-dont-reply-to-self t)
;;      (setq mu4e-headers-include-related nil)
;;      (setq mu4e-index-update-error-warning nil)
;;      (setq mu4e-search-threads nil)
;;      (with-eval-after-load "mm-decode"
;;        (add-to-list 'mm-discouraged-alternatives "text/html")
;;        (add-to-list 'mm-discouraged-alternatives "text/richtext"))
;;      (advice-add #'shr-colorize-region :around (defun shr-no-colourise-region (&rest ignore)))
;;      (setq mu4e-headers-fields '((:human-date . 12)
;;  				(:flags . 6)
;;  				(:from-or-to . 22)
;;  				(:subject . 22)
;; 				(:maildir)))	
;;      (setq message-send-mail-function 'message-send-mail-with-sendmail
;;  	  message-sendmail-extra-arguments '("--read-envelope-from")
;;  	  message-sendmail-f-is-evil 't
;;  	  sendmail-program "/opt/homebrew/bin/msmtp")
;;      (setq mu4e-maildir-shortcuts
;;            '(("/INBOX"       . ?i)
;;              ("/Archive"     . ?a)
;; 	    ("/Action - Follow up" . ?f)
;; 	    ("/Sent" . ?s)))
;;      (setq message-kill-buffer-on-exit t)
;;      (setq mu4e-compose-format-flowed t)
;;      (setq mu4e-attachment-dir "~/Desktop")
;;      (setq mu4e-compose-signature "Paul Menair\nLeibel Law\nFolger House\n3619 S Chestatee\nDahlonega, Ga 30533\n404-892-0700, Phone\n770-844-0015, Fax")
;;      (setq mu4e-compose-signature-auto-include nil)
;;      (defun insert-mu4e-sig-here ()
;;        "Insert the mu4e signature here, assuming it is a string."
;;        (interactive)
;;        (when (stringp mu4e-compose-signature)
;;  	 (insert mu4e-compose-signature)))
;; ))

;; (add-to-list 'auto-mode-alist 
;;              '("\\.*mutt-*\\|.article\\|\\.followup" 
;;                 . mail-mode))

(recentf-mode 1)

(use-package denote
  :config
  (setq denote-directory (expand-file-name "~/Documents/Claude/WORK SYNC/projects/6-denote/"))
  (setq denote-prompts '(title keywords))
  (setq denote-known-keywords '("casenotes"))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-excluded-keywords-regexp nil)
  (setq denote-date-prompt-use-org-read-date t)
  (setq denote-file-type 'org)
  (setq denote-date-format nil) ; read doc string
)

(defun denote-link-markdown-follow (link)
"Function to open Denote file present in LINK.
To be assigned to `markdown-follow-link-functions'."
(when (ignore-errors (string-match denote-id-regexp link))
(funcall denote-link-button-action
(denote-get-path-by-id (match-string 0 link)))))

(add-hook 'markdown-follow-link-functions #'denote-link-markdown-follow)

(use-package expand-region)

(global-set-key (kbd "M-+") 'er/expand-region)

(defun open-docx-with-pandoc ()
  "Open the current docx file by converting it to markdown with pandoc."
  (interactive)
  (let* ((filename (buffer-file-name))
         (quoted-filename (shell-quote-argument filename))
         (output-buffer (get-buffer-create "*docx-view*")))
    (with-current-buffer output-buffer
      (erase-buffer)
      (insert (shell-command-to-string (concat "pandoc " quoted-filename " -t markdown")))
      (markdown-mode))
    (switch-to-buffer output-buffer)))

;; ;; Required dependencies
;; (require 'org)
;; (require 'org-element)
;; (require 'ox)
;; (require 'json)
;; (require 'cl-lib)

;; (defun org-rdfa-follow (path)
;;   "Follow an RDFa link by opening its URL in a browser.
;; The URL is assumed to be the first component in PATH."
;;   (browse-url (car (split-string path "::"))))

;; (defun org-rdfa-face (path)
;;   "Return a face property list for an RDFa link.
;; You can customize this as needed."
;;   '(:foreground "green" :underline t))

;; (org-link-set-parameters
;;  "rdfa"
;;  :follow #'org-rdfa-follow
;;  :face #'org-rdfa-face
;;  :export (lambda (path desc backend)
;;            (cond
;;             ((eq backend 'html)
;;              ;; For HTML export, build an <a> tag (or <span> if no description)
;;              (let* ((components (split-string path "::"))
;;                     (url (car components))
;;                     (attrs (mapconcat
;;                             (lambda (attr)
;;                               (let* ((pair (split-string attr "="))
;;                                      (key (car pair))
;;                                      (val (cadr pair)))
;;                                 (if (and key val)
;;                                     (format "%s=\"%s\"" key val)
;;                                   "")))
;;                             (cdr components) " "))
;;                     (html (if (string= desc "")
;;                               (format "<span %s>%s</span>" attrs url)
;;                             (format "<a href=\"%s\" %s>%s</a>" url attrs desc))))
;;                html)))))
;;            ;; ((eq backend 'json-ld)
;;            ;;   ;; For JSON-LD export, convert the URL and any attributes into a JSON object.
;;            ;;   ;; The JSON is then wrapped in a <script> tag.
;;            ;;   (let* ((components (split-string path "::"))
;;            ;;          (url (car components))
;;            ;;          (attr-pairs (cl-remove-if-not
;;            ;;                       #'identity
;;            ;;                       (mapcar
;;            ;;                        (lambda (attr)
;;            ;;                          (let* ((pair (split-string attr "="))
;;            ;;                                 (key (car pair))
;;            ;;                                 (val (cadr pair)))
;;            ;;                            (if (and key val)
;;            ;;                                (cons key val)
;;            ;;                              nil)))
;;            ;;                        (cdr components))))
;;            ;;          (json-data (json-encode (cons (cons "url" url) attr-pairs))))
;;            ;;     (format "<script type=\"application/ld+json\">%s</script>" json-data)))
;;             ;;  (t (error "Unsupported backend: %s" backend)))))
;; 	    ;; CURRENTLY NO WAY TO PICK THIS AND IT'S UNTESTED, PROBABLY JUST WANT TO USE THE HTML
;; 	    ;; BACKEND AND ADAPT

;;  (setq org-startup-folded 'fold)
