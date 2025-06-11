# Immich tvOS

A native tvOS client for [Immich](https://github.com/immich-app/immich) - a self-hosted photo and video backup solution.

## Features

- Browse your photo library on your Apple TV
- View photos organized by time buckets (months)
- Support for albums
- High-quality image loading with WebP support
- Native tvOS interface optimized for TV viewing

## Requirements

- tvOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- An Immich server instance

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/immich-tvos.git
cd immich-tvos
```

2. Open the project in Xcode:
```bash
open Immich.xcodeproj
```

3. Build and run the project on your Apple TV or tvOS simulator.

## Configuration

1. Launch the app on your Apple TV
2. Enter your Immich server URL (e.g., `https://your-immich-server.com`)
3. Log in with your Immich credentials

## Development

The project uses:
- SwiftUI for the user interface
- OpenAPI for API communication
- SDWebImage for image loading and caching
- WebP support for efficient image loading

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Immich](https://github.com/immich-app/immich) for the amazing self-hosted photo backup solution
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) for image loading and caching
