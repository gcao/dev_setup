module Spec
  module Mate
    class Runner
      def run_files(stdout, options={})
        files = ENV['TM_SELECTED_FILES'].split(" ").map do |path|
          File.expand_path(path[1..-2])
        end
        options.merge!({:files => files})
        run(stdout, options)
      end

      def run_file(stdout, options={})
        run(stdout, merge_options(options))
      end

      def run_focussed(stdout, options={})
        run(stdout, merge_options(options, true))
      end

      def run_file_drb(stdout, options={})
        run(stdout, merge_options(options, false, true))
      end

      def run_focussed_drb(stdout, options={})
        run(stdout, merge_options(options, true, true))
      end

      def run(stdout, options)
        argv = options[:files].dup
        argv << '--drb' if options[:drb]
        argv << '--format'
        argv << 'textmate'
        if options[:line]
          argv << '--line'
          argv << options[:line]
        end
        argv += ENV['TM_RSPEC_OPTS'].split(" ") if ENV['TM_RSPEC_OPTS']
        Dir.chdir(project_directory) do
          ::Spec::Runner::CommandLine.run(::Spec::Runner::OptionParser.parse(argv, STDERR, stdout))
        end
      end

      protected
      
      def merge_options options, with_line_number = false, drb = false
        temp_file   = "/tmp/textmate_rspec_location"
        file_name   = single_file
        line_number = ENV['TM_LINE_NUMBER']
        
        if single_file =~ /spec\.rb/
          File.open(temp_file, 'w') do |f| 
            f.puts file_name
            f.puts line_number
          end
        else
          if File.file? temp_file
            File.open(temp_file) do |f| 
              file_name   = f.gets.chomp
              line_number = f.gets.chomp
            end
          end
        end
        
        options.merge! :files => [file_name]
        options.merge! :line  => line_number  if with_line_number
        options.merge! :drb   => true         if drb
        options
      end
        
      
      def single_file
        File.expand_path(ENV['TM_FILEPATH'])
      end

      def project_directory
        File.expand_path(ENV['TM_PROJECT_DIRECTORY'])
      end
    end
  end
end
