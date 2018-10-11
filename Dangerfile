require 'yaml'

touched_files = git.modified_files + git.added_files

has_source_changes = !touched_files.grep(/Sources/).empty?
has_test_changes = !touched_files.grep(/Tests/).empty?

if git.lines_of_code > 50 && has_source_changes && !has_test_changes
	warn("These changes may need unit tests.")
end

swiftlint.config_file = File.join(Dir.pwd, '.swiftlint.yml')
swiftlint.lint_files
