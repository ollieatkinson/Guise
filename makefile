debug:
	- swift build --verbose

release:
	- swift build -Xswiftc -O --configuration release --static-swift-stdlib
	- mkdir -p bin && cp .build/release/guise bin

project:
	- swift package generate-xcodeproj
