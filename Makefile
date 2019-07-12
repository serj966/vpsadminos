BUILD_ID := $(shell date +%Y%m%d%H%M%S)
VERSION := $(shell cat .version)
RELEASE_DATE := $(shell date +%Y-%m-%d)

build: gems
	$(MAKE) -C os build

qemu:
	$(MAKE) -C os qemu

toplevel:
	$(MAKE) -C os toplevel

gems:
	./tools/with_geminabox.sh $(MAKE) -f Makefile.gems all BUILD_ID=$(BUILD_ID)
	echo "$(VERSION).build$(BUILD_ID)" > .build_id

osctl-env-exec:
	./tools/with_geminabox.sh $(MAKE) -f Makefile.gems osctl-env-exec BUILD_ID=$(BUILD_ID)

doc:
	mkdocs build

doc_serve:
	mkdocs serve

version:
	@echo "$(VERSION)" > .version
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" osctld/lib/osctld/version.rb
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" osctl/lib/osctl/version.rb
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" libosctl/lib/libosctl/version.rb
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" converter/lib/vpsadminos-converter/version.rb
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" osctl-repo/lib/osctl/repo/version.rb
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" osctl-image/lib/osctl/template/version.rb
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" osup/lib/osup/version.rb
	@sed -ri "s/ VERSION = '[^']+'/ VERSION = '$(VERSION)'/" svctl/lib/svctl/version.rb
	@sed -ri "s/VERSION = '[^']+'/VERSION = '$(VERSION)'/" tools/osctl-env-exec/osctl-env-exec.gemspec
	@sed -ri '1!b;s/[0-9]+\.[0-9]+\.[0-9]+$\/$(VERSION)/' osctl/man/man8/osctl.8.md
	@sed -ri '1!b;s/[0-9]+\.[0-9]+\.[0-9]+$\/$(VERSION)/' osup/man/man8/osup.8.md
	@sed -ri '1!b;s/[0-9]+\.[0-9]+\.[0-9]+$\/$(VERSION)/' converter/man/man8/vpsadminos-convert.8.md
	@sed -ri '1!b;s/[0-9]+\.[0-9]+\.[0-9]+$\/$(VERSION)/' svctl/man/man8/svctl.8.md
	@sed -ri '1!b;s/ [0-9]{4}-[0-9]{1,2}-[0-9]{1,2} / $(RELEASE_DATE) /' osctl/man/man8/osctl.8.md
	@sed -ri '1!b;s/ [0-9]{4}-[0-9]{1,2}-[0-9]{1,2} / $(RELEASE_DATE) /' osctl-image/man/man8/osctl-image.8.md
	@sed -ri '1!b;s/ [0-9]{4}-[0-9]{1,2}-[0-9]{1,2} / $(RELEASE_DATE) /' osup/man/man8/osup.8.md
	@sed -ri '1!b;s/ [0-9]{4}-[0-9]{1,2}-[0-9]{1,2} / $(RELEASE_DATE) /' converter/man/man8/vpsadminos-convert.8.md
	@sed -ri '1!b;s/ [0-9]{4}-[0-9]{1,2}-[0-9]{1,2} / $(RELEASE_DATE) /' svctl/man/man8/svctl.8.md

migration:
	$(MAKE) -C osup migration

.PHONY: build doc doc_serve qemu gems osctl-env-exec
.PHONY: version migration
