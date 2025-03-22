# Change Log

All notable changes to this project will be documented in this file.

## [Unreleased]
- Nothing

## [0.1.6] - 2025-03-22
### Added
- I introduced `vpp` as an alias for `vdump`, where vpp stands for visual pretty print. It performs the same function as vdump, enhancing the usability and accessibility of the visual debugging features.

- Enhanced color coding for output to improve readability and debugging experience:
  - Numbers are now displayed in blue, making it easier to distinguish numeric data.
  - Strings are highlighted in salmon pink, helping them stand out in the output.
  - Active Record relations are shown in red and orange, aiding in differentiation of nested structures within database relationships.
  - Class objects are represented in green, clarifying type information at a glance.

## [0.1.5] - 2025-02-27
### Added
- Changed the method name from dump to vdump.

## [0.1.4] - 2024-05-17
### Added
- Added Active Record relation output.

## [0.1.3] - 2024-04-20
### Added
- Fixed the implementation of adding a newline at the end.

## [0.1.2] - 2024-04-14
### Added
- Add a newline at the end.

## [0.1.1] - 2024-04-14
### Added
- `RubyVarDump` module's method added to `Object` class to enhance accessibility.

## [0.1.0] - 2024-04-14
### Added
- Initial release of the `ruby_var_dump` gem.
- Implemented the core functionality for dumping object details.
