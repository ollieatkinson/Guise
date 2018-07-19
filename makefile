debug:
	- swift build --verbose

release:
	- swift build -Xswiftc -O --configuration release --static-swift-stdlib
	- cp .build/release/public-api-generator ./
