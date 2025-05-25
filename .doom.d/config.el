;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(message "Loading config.el")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;;; Code:
(setq user-full-name "Santhana Krishnan S"
      user-mail-address "i@hashkrish.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code Nerd Font" :size 20))
                                        ; doom-variable-pitch-font (font-spec :family "Fira Code" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)
;; (load-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(add-to-list 'default-frame-alist '(alpha-background . 90)) ; set transparency
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; mmm-mode
(after! mmm-mode
  (setq mmm-global-mode 'maybe)
  (mmm-add-mode-ext-class 'markdown-mode nil 'markdown-lisp)
  (mmm-add-classes '((markdown-lisp :submode lisp-mode :front "^```lisp[\n\r]+" :back "^```$")
                     (markdown-bash :submode sh-mode :front "^```bash[\n\r]+" :back "^```$")
                     (markdown-python :submode python-mode :front "^```python[\n\r]+" :back "^```$"))))


(after! gh
  (setq gh-username "hashkrish"))

(use-package! request)
(use-package! alert)
(use-package! persist)
(use-package! aio)
(use-package! elixir-ts-mode)
(use-package! nushell-mode)
(use-package window-stool
  :config
  (add-hook 'prog-mode-hook #'window-stool-mode))

(setq lsp-enable-file-watchers t)
(setq lsp-file-watch-threshold 10000)

(use-package! dashboard
  :ensure t
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.config/emacs/images/dtmacs-logo.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
				    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))

(use-package! copilot-chat
  :after (request org markdown-mode)
  :config
  (setq copilot-chat-frontend 'org) ; You can choose 'markdown or 'shell-maker instead
  :bind (:map global-map
              ("C-c C-y" . copilot-chat-yank)
              ("C-c M-y" . copilot-chat-yank-pop)
              ("C-c C-M-y" . (lambda () (interactive) (copilot-chat-yank-pop -1)))))

(setq org-babel-default-header-args (cons '(:mkdir . "yes") org-babel-default-header-args))
(setq org-babel-default-header-args:bash (cons '(:mkdir . "yes") org-babel-default-header-args))
(setq org-babel-default-header-args:sh (cons '(:mkdir . "yes") org-babel-default-header-args))

;; Disable format on save in web-mode
;; Append to the list if you want to disable in more modes
(setq +format-on-save-disabled-modes '(web-mode dockerfile-mode))

;; Ignore deps in projectile
(after! projectile
  (add-to-list 'projectile-globally-ignored-directories "deps"))

;; Org-Jira
(after! org-jira
  (setq jiralib-url "https://nptel-hq.atlassian.net")
  (setq jiralib-token
        (cons "Authorization"
              (concat "Bearer "
                      (auth-source-pick-first-password
                       :host "nptel-hq.atlassian.net")))))

(after! consult-gh
  (setq consult-gh-default-orgs-list '("hashkrish"))
  (setq consult-gh-default-orgs-list (append consult-gh-default-orgs-list
                                             (remove "" (split-string
                                                         (or (consult-gh--command-to-string "org" "list") "") "\n"))))
  (setq consult-gh-default-clone-directory "~/sources/"))



;; Mode hook
(add-to-list 'auto-mode-alist '("\.rest$" . restclient-mode))

;; Disable
;; (setq highlight-indent-guides-auto-enabled f)

;; Use zsh as shell
(setq shell-file-name "/usr/bin/zsh")
(setq explicit-shell-file-name "/usr/bin/zsh")


;; Environmental Variables
(setenv "PATH" (concat (getenv "PATH") ":/home/krishnan/go/bin"))


(defun datastore-run-query ()
  "Send a REST request to the datastore and process the response."
  (interactive)
  (let* ((url "http://localhost:8080/v1/projects/test:runQuery")
         (query '(:gqlQuery (:queryString "select * from StudentCredits where account=key(Account, 2571) and level='DEGREE'"
                             :allowLiterals t)))
         (json-data (json-encode query))
         (response-buffer (url-retrieve-synchronously
                           url
                           nil
                           (lambda (_url-request-data)
                             (setq url-request-method "POST")
                             (setq url-request-extra-headers
                                   '(("Content-Type" . "application/json")))
                             (setq url-request-data json-data)))))
    (if response-buffer
        (with-current-buffer response-buffer
          (goto-char (point-min))
          (re-search-forward "\n\n" nil t) ; Skip headers
          (let* ((json-object-type 'alist)
                 (json-array-type 'list)
                 (json-key-type 'symbol)
                 (result (json-read)))
            (kill-buffer response-buffer)
            (message "Response: %s" (pp-to-string result))
            result))
      (error "Failed to retrieve data from datastore"))))

(defun datastore-run-query-debug ()
  "Send a REST request to the datastore and debug the response."
  (interactive)
  (let* ((url "http://localhost:8080/v1/projects/test:runQuery")
         (query '(:gqlQuery (:queryString "select * from StudentCredits where account=key(Account, 2571) and level='DEGREE'"
                             :allowLiterals t)))
         (json-data (json-encode query))
         (response-buffer (url-retrieve-synchronously
                           url
                           nil
                           (lambda (_ignored)
                             (setq url-request-method "POST")
                             (setq url-request-extra-headers
                                   '(("Content-Type" . "application/json")
                                     ))
                             (setq url-request-data json-data)))))
    (if response-buffer
        (with-current-buffer response-buffer
          ;; Show the entire buffer content for debugging
          (message "\n\nRequest:\n%s" json-data)
          (message "Raw Response:\n%s" (buffer-string))
          (kill-buffer response-buffer))
      (error "Failed to retrieve data from datastore"))))

;; data store
(add-load-path! "/home/krishnan/sources/dsq")

(after! request
  (require 'dsq))

(map! :leader
      (:prefix ("m" . "local")
       :desc "Load current file" "l" #'my/load-current-file))


(defun my/load-current-file ()
  "Load the current buffer file."
  (interactive)
  (when (buffer-file-name)
    (load-file (buffer-file-name))
    (message "Loaded %s" (buffer-file-name))))

(map! :leader
      (:prefix ("o" . "open")
       :desc "Show Copilot Chat Buffer" "c" 'copilot-chat-display))

(map! :leader
      (:prefix ("o" . "open")
       :desc "Docker Compose" "C" 'docker-compose))

(map! :leader
      (:prefix ("d" . "dsq")
       :desc "Set Kind (Table)"         "k" #'dsq-select-kind
       :desc "Set Namespace"            "n" #'dsq-select-namespace
       :desc "Add Filter"               "f" #'dsq-add-filter
       :desc "Set Limit"                "l" #'dsq-set-limit
       :desc "Set Order"                "o" #'dsq-set-order
       :desc "Preview Query JSON"        "p" #'dsq-preview-query
       :desc "Run Query"                "r" #'dsq-run-query
       :desc "Put Entity"               "s" #'dsq-put-entity
       :desc "Reset Query"              "x" #'dsq-reset-query
       :desc "Upsert Entity"            "P" #'dsq-upsert-entity))

(map! :n "C-i" #'better-jumper-jump-forward)

;; (use-package codeium
;;   :ensure t
;;   :init
;;   (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;   :config
;;   (setq codeium/metadata `((client_language . "emacs"))))

;; (after! apheleia
;;   (setf (alist-get 'yaml-mode apheleia-mode-alist)
;;         '("prettier" "--stdin-filepath" filepath "--tab-width" "2" "--use-tabs" "false")))
