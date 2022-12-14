# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: janetad android ios janetad-cross swarm evm all test clean
.PHONY: janetad-linux janetad-linux-386 janetad-linux-amd64 janetad-linux-mips64 janetad-linux-mips64le
.PHONY: janetad-linux-arm janetad-linux-arm-5 janetad-linux-arm-6 janetad-linux-arm-7 janetad-linux-arm64
.PHONY: janetad-darwin janetad-darwin-386 janetad-darwin-amd64
.PHONY: janetad-windows janetad-windows-386 janetad-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

janetad:
	build/env.sh go run build/ci.go install ./cmd/janetad
	@echo "Done building."
	@echo "Run \"$(GOBIN)/janetad\" to launch janetad."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/janetad.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/JANETAD.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

janetad-cross: janetad-linux janetad-darwin janetad-windows janetad-android janetad-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/janetad-*

janetad-linux: janetad-linux-386 janetad-linux-amd64 janetad-linux-arm janetad-linux-mips64 janetad-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-*

janetad-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/janetad
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep 386

janetad-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/janetad
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep amd64

janetad-linux-arm: janetad-linux-arm-5 janetad-linux-arm-6 janetad-linux-arm-7 janetad-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep arm

janetad-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/janetad
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep arm-5

janetad-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/janetad
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep arm-6

janetad-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/janetad
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep arm-7

janetad-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/janetad
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep arm64

janetad-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/janetad
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep mips

janetad-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/janetad
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep mipsle

janetad-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/janetad
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep mips64

janetad-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/janetad
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/janetad-linux-* | grep mips64le

janetad-darwin: janetad-darwin-386 janetad-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/janetad-darwin-*

janetad-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/janetad
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-darwin-* | grep 386

janetad-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/janetad
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-darwin-* | grep amd64

janetad-windows: janetad-windows-386 janetad-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/janetad-windows-*

janetad-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/janetad
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-windows-* | grep 386

janetad-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/janetad
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/janetad-windows-* | grep amd64
