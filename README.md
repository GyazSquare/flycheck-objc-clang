# flycheck-objc-clang

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MELPA](https://melpa.org/packages/flycheck-objc-clang-badge.svg)](https://melpa.org/#/flycheck-objc-clang)
[![MELPA Stable](https://stable.melpa.org/packages/flycheck-objc-clang-badge.svg)](https://stable.melpa.org/#/flycheck-objc-clang)
[![Build Status](https://api.travis-ci.com/GyazSquare/flycheck-objc-clang.svg?branch=master)](https://travis-ci.com/GyazSquare/flycheck-objc-clang)

An Objective-C syntax checker using Clang.

## Requirements

* [Flycheck](http://www.flycheck.org/)

## Installation

You can install `flycheck-objc-clang.el` from the [MELPA](https://melpa.org/) or the [MELPA Stable](https://stable.melpa.org/) repository.

In your `init.el`:

```elisp
(require 'flycheck-objc-clang) ; Not necessary if using ELPA package
(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-objc-clang-setup))
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
