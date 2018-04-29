require 'rspec'
require 'rspec/core/formatters/html_formatter'
require 'rspec/core/formatters'

# Overrides functionality from base class to generate separate html files for each test suite
# https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/formatters/html_formatter.rb

class ParallelFormatter < RSpec::Core::Formatters::HtmlFormatter
  RSpec::Core::Formatters.register self

  def initialize(param=nil)
    output_dir = File.join(File.dirname(File.expand_path("..", __FILE__)),"reports")
    if !Dir.exist?(output_dir)
      Dir.mkdir(output_dir)
    end
    output_file = File.join(output_dir, "parallel_results"+Time.now.strftime("%Y%m%d%H%M%L%12N")+generate_random_string+".html")

    begin
      if !(File.exists?(output_file))
        opened_file = File.open(output_file, 'a')
      end
    rescue Exception => e
        puts e.message
        raise "...not able to create file"
    end

    if output_file.include? "/home/jenkins/workspace/"
      output_file.gsub! '/home/jenkins/workspace/', 'http://ci.gallerydev.net:8080/job/'
      output_file.gsub! '/spec', '/ws/spec'
    end

    if output_file.include? "/vol/jenkins/jobs/"
        output_file.gsub! '/vol/jenkins/jobs/', 'http://ci.gallerydev.net:8080/job/'
        output_file.gsub! '/workspace/spec', '/ws/spec'
    end

    if output_file.include? "/var/lib/jenkins/workspace/"
      output_file.gsub! '/var/lib/jenkins/workspace/', 'http://smithers.vidmark.local/job'
      output_file.gsub! '/spec', '/ws/spec'
    end

    puts "Parallel Process Results: #{output_file}"
    super(opened_file)
  end
end
