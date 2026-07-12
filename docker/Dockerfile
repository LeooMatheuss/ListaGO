# Pin to a specific Flutter version for reproducible builds.
# Update manually when upgrading Flutter (e.g. ghcr.io/cirruslabs/flutter:3.32.0).
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build apk --release

FROM alpine:3.20 AS artifact
COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /out/app-release.apk
