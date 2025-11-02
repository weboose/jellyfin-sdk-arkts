<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.13.0] - 2025-10-28

### Changed

* Ensure `Authorization` header is sent for all requests ([#948](https://github.com/jellyfin/jellyfin-sdk-typescript/pull/948)).

### Deprecated

* Deprecate authentication helper methods in `Api` class ([#949](https://github.com/jellyfin/jellyfin-sdk-typescript/pull/948)).
  Updating the `accessToken` is now handled transparently in `getUserApi` and `getSessionApi`. If you need to handle
  authentication manually, then you should manually create `UserApi` and `SessionApi` instances.
