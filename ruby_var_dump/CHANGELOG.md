# Change Log

All notable changes to this project will be documented in this file.

## [0.4.0] - 2026-07-12
### Changed
- The gem now automatically includes `RubyVarDump` into `Object` when required. You no longer need to create `config/initializers/setup_ruby_var_dump.rb` or write `Object.include RubyVarDump` manually — just requiring the gem (e.g. adding it to your `Gemfile`) makes `vdump` / `vpp` available on all objects.

> **Note:** Requiring the gem now automatically includes `RubyVarDump` into `Object`. If you previously relied on `require` NOT modifying `Object`, be aware of this behavior change.

### Added
- Added a global setting `RubyVarDump.assoc` to toggle Active Record association output. Defaults to `1` (ON). Set `RubyVarDump.assoc = 0` to hide associations (`belongs_to` / `has_one` / `has_many` / `has_and_belongs_to_many`), and `RubyVarDump.assoc = 1` to show them again.

## [0.3.0] - 2025-05-07
### Added
- Added header at the beginning of output and footer at the end of output

## [0.2.0] - 2025-05-07
### Added
- Modified to pick up belongs_to and has_one

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
