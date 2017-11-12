BIN = http-rs
TARGET_ARCH ?= x86_64-unknown-linux-musl
TARGET = target/$(TARGET_ARCH)/release/$(BIN)

.PHONY: build-run compile run target

$(TARGET): src/main.rs Cargo.toml Cargo.lock
	$(MAKE) compile

target: $(TARGET)

build-compile:
	docker build --rm -t rustup-build -f Dockerfile.compile .

compile: build-compile
	docker run -ti --rm -u 0 -v $(PWD):/root/build_dir:z \
		-e CARGO_HOME="/root/build_dir/.cargo" \
		-e RUSTUP_HOME="/root/.rustup" \
		-w /root/build_dir -t rustup-build \
		sh -c "mkdir -p /root/build_dir/.cargo && ln -sf /root/.cargo/config /root/build_dir/.cargo/config && ln -s /root/.cargo/bin /root/build_dir/.cargo/bin && rustup update && rustup run nightly cargo build --release && strip -s $(TARGET) && chown -R $(shell id -u):$(shell id -g) target .cargo"

build-run: $(TARGET)
	docker build -t rustup-run .

run: build-run
	docker run --rm -ti -P rustup-run
