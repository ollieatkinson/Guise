debug:
	- swift build --verbose

release:
	- swift build -Xswiftc -O --configuration release --static-swift-stdlib
	- mkdir -p bin && cp .build/release/guise bin

project:
	- swift package generate-xcodeproj

integration-test: release
	- cd Fixtures/CommandLineFixture && xcodebuild -scheme CommandLineFixture -configuration release > /dev/null
	- diff Fixtures/CommandLineFixture/Expected.swift Fixtures/CommandLineFixture/Generated.swift
