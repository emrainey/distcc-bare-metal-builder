.PHONY: all build run catalog versions clean

DOCKER:=$(firstword $(shell which docker) $(shell which finch))

REGISTRY:=ghcr.io/emrainey
IMAGE:=distcc-bare-metal-builder

all: build

build/build_stamp.txt: Dockerfile
	mkdir -p build
	$(DOCKER) build . --tag $(IMAGE) --tag $(REGISTRY)/$(IMAGE)
	$(DOCKER) inspect $(IMAGE) > build/image_inspect.txt
	scripts/tag-with-versions.sh $(DOCKER) $(IMAGE) build/versions.txt
	touch $@

build: build/build_stamp.txt

build/run_output.txt: build/build_stamp.txt
	mkdir -p build
	$(DOCKER) run --rm $(IMAGE) distccd --version > build/run_output.txt

run: build/run_output.txt

build/catalog.txt: build/build_stamp.txt
	mkdir -p build
	$(DOCKER) run --rm $(IMAGE) cat /etc/image-catalog.txt > build/catalog.txt 2>/dev/null || true

catalog: build/catalog.txt

versions: build/build_stamp.txt

clean:
	-$(DOCKER) rmi $(IMAGE) $(REGISTRY)/$(IMAGE) 2>/dev/null || true
	-rm -rf build/