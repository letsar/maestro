## [0.7.0]
### Added
- A `onWrite` argument for `Maestro.readOnly` called when a descendants wants to write a new value.

### Changed
- `readAndWrite` methods renamed to `update`.
- `Maestro.initialValue` renamed to `value`.

## [0.6.0]
### Added
- A `readOnly` constructor on `Maestro` allowing a `Maestro` to be read but not updated by its descendants, and only updated by its parent.

## [0.5.0]
### Changed
- Revert the possibility to update `Maestro` value without setting a new key. 

## [0.4.0]
### Added
- A `remix` method on `Performer` called when a `Performer` instance changed and the new one need to be updated from the old one.
- The value held by a `Maestro` is now updated when the `value` changed, whether it's a `Performer` or not.

### Changed
- The `play` method is now on the `Performer`.
- `initialValue` of `Maestro` is renamed `value`.

## [0.3.0]
### Changed
- `MaestroInspector` can be used multiple times and can decide to bubble action to further ancestors.
- `OnAction` return type to bool, in order to continue/cancel bubbling.

## [0.2.0]
### Changed
- The value held by a `Maestro` is now updated when the `initialValue` changed and if it's not a `Performer`.

## [0.1.1]
### Fixed
- Make the action an `Object` everywhere.

## [0.1.0]
### Added
- An `Object` parameter to `write` and `readAndWrite` methods, in order to indicate what the action is.

### Changed
- The method in `MaestroInspector` from `onValueUpdated` to `onAction` along with the signature method.

## [0.0.1]
- Initial Open Source release.
