EMACS ?= emacs
EMACSFLAGS += -L .
CASK ?= cask

PKGDIR := $(shell EMACS=$(EMACS) $(CASK) package-directory)
DESTDIR ?= dist
EMACSBATCH := $(EMACS) --no-site-file --no-site-lisp --quick --batch $(EMACSFLAGS)

# Export Emacs to goals, mainly for CASK
CASK_EMACS := $(EMACS)
export EMACS
export CASK_EMACS

SRCS := flycheck-objc-clang.el
OBJECTS := $(SRCS:.el=.elc)
TEST_DIR := test
TEST_SRCS := flycheck-objc-clang-test.el

.PHONY: all
all : $(OBJECTS)

.PHONY: clean
clean :
	rm -rf $(OBJECTS)

.PHONY: distclean
distclean : clean
	rm -rf $(DESTDIR)
	rm -rf .cask

.PHONY: dist
dist :
	$(CASK) package $(DESTDIR)

.PHONY: test
test: $(PKGDIR)
	$(CASK) exec $(EMACSBATCH) \
		$(SRCS:%=--load %) \
		$(TEST_SRCS:%=--load $(TEST_DIR)/%) \
		--funcall ert-run-tests-batch-and-exit

$(PKGDIR) : Cask
	$(CASK) install
	$(CASK) update

%.elc : %.el $(PKGDIR)
	$(CASK) exec $(EMACSBATCH) \
	-f batch-byte-compile $<
