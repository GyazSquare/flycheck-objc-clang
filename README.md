# flycheck-objc-clang

An Objective-C syntax checker using Clang.

## Requirements

* [Flycheck](http://www.flycheck.org/)

## Installation

If you're an Emacs 24 user or you have a recent version of `package.el`, you can install `flycheck-objc-clang.el` from the [MELPA](https://melpa.org/) or the [MELPA Stable](https://stable.melpa.org/) repository.

In your `init.el`:

```elisp
(require 'flycheck-objc-clang) ; Not necessary if using ELPA package
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-objc-clang-setup))
```

### Configuration

In your `init.el`:

``` elisp
(custom-set-variables
 '(flycheck-objc-clang-modules t) ; The modules feature is disabled by default
 '(flycheck-objc-clang-arc t))    ; The objc arc feature is disabled by default
```

## License

This software is licensed under the MIT License.

See the LICENSE file for details.
