(use-modules
  (gnu)
  (gnu services)
  (gnu system)
  (gnu system install)
  (guix)
  (guix channels)
  ((guix licenses) #:prefix license:)
  (guix git-download)
  (guix build-system go)
  (nongnu packages mozilla)
  (nongnu packages linux))
(use-package-modules linux package-management)

(operating-system
  (inherit installation-os)
  (kernel linux)
  (kernel-arguments '("quiet" "net.ifnames=0"))
  (firmware (list linux-firmware))

  (label (string-append "Lassar Guix Installer (nonfree firmware) "
                        (or (getenv "GUIX_DISPLAYED_VERSION")
                            (package-version guix))))

  (packages
    (append (list
              ;(package
              ;  (name "browsh")
              ;  (version "v1.8.2")
              ;  (source (origin
              ;            (method git-fetch)
              ;            (uri (git-reference
              ;                   (url "https://github.com/browsh-org/browsh")
              ;                   (commit version)))
              ;            (sha256
              ;              (base32
              ;                "1r2afqg3as60jsd92wvs6i7x166fyv7cg4dvw3yi4i44vdq5bc19"))
              ;            (file-name (git-file-name name version))))
              ;  (build-system go-build-system)
              ;  (inputs (list firefox))
              ;  (home-page "https://www.brow.sh")
              ;  (synopsis "Browsh is a fully-modern text-based browser")
              ;  (description "Browsh is a fully-modern text-based browser. It renders anything that a modern browser can; HTML5, CSS3, JS, video and even WebGL. Its main purpose is to be run on a remote server and accessed via SSH/Mosh or the in-browser HTML service in order to significantly reduce bandwidth and thus both increase browsing speeds and decrease bandwidth costs.")
              ;  (license license:lgpl2.1))
              ;(specification->package "firefox")
              ;(specification->package "nyxt")
              ;(specification->package "links")
              (specification->package "lynx")
              (specification->package "emacs-no-x-toolkit")
              ;(specification->package "bash")
              (specification->package "fdisk")
              (specification->package "usb-modeswitch")
              (specification->package "network-manager")
              (specification->package "modem-manager")
              (specification->package "mobile-broadband-provider-info")
              (specification->package "git")
              (specification->package "chrony")
              (specification->package "curl")
              (specification->package "stow")
              ;(specification->package "vim")
              (specification->package "neovim")
              (specification->package "nss-certs")
              (specification->package "ncurses"))
            (operating-system-packages installation-os)))

  (services
    (append
      (list
        (simple-service 'channel-file etc-service-type
                        (list `("channels.scm" ,(local-file "channels.scm"))))
        (simple-service 'start-guix-install-file etc-service-type
                        (list `("start-guix-install.sh" ,(local-file "start-guix-install.sh"))))
       (extra-special-file "/usr/bin/start-guix-install.sh"
                            (local-file "start-guix-install.sh"))
        (extra-special-file "/usr/bin/env"
                            (file-append coreutils "/bin/env")))
      (modify-services (operating-system-user-services installation-os)
                       (guix-service-type config => (guix-configuration
                                                      (inherit config)
                                                      (substitute-urls
                                                        (append (list "https://substitutes.nonguix.org")
                                                                %default-substitute-urls))
                                                      (authorized-keys
                                                        (append (list (plain-file "non-guix.pub"
                                                                                  "(public-key 
                                                                                  (ecc 
                                                                                    (curve Ed25519)
                                                                                    (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                                                %default-authorized-guix-keys))))))))

