.PHONY: default
default: image

.DELETE_ON_ERROR:

SHELL = /bin/bash

$(shell mkdir -p .build)

######################################################################
# Image build targets.

build_scripts := \
  config/nsswitch.conf \
  scripts/apt-install.sh \
  scripts/firefox \
  scripts/setup-autofirma.sh

image := .build/image-id
deb := .build/AutoFirma_1_6_5.deb

$(image): Dockerfile $(build_scripts)
	docker build --iidfile=$@ --tag=autofirma --file=$< .

$(deb): $(image)
	docker run --rm --entrypoint=/bin/cat $$(< $<) /tmp/AutoFirma_1_6_5.deb > $@

.PHONY: image
image: $(image)

.PHONY: deb
deb: $(deb)

######################################################################
# Manual test targets.

.PHONY: test-setup
test-setup: $(image)
	./firefox-autofirma setup ~/Desktop/cert.pfx

.PHONY: test-shell
test-shell: $(image)
	./firefox-autofirma shell

.PHONY: test-run
test-run: $(image)
	./firefox-autofirma run https://httpbin.org
