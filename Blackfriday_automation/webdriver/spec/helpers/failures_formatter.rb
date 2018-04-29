# inspired by https://github.com/rspec/rspec-core/pull/596
require 'rspec/core/formatters/base_formatter'

class FailuresFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self

  def dump_failures
    return if failed_examples.empty?
    f = File.new("rspec.failures", "w+")
    failed_examples.each do |example|
      f.puts retry_command(example)
    end
    f.close
  end

  def retry_command(example)
    example_name = example.full_description.gsub("\"", "\\\"")
    "-e \"#{example_name}\""
  end

end
