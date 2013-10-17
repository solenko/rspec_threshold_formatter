require "rspec/core/formatters/progress_formatter"

module RSpec
  module Formatters
    class ThresholdFormatter < RSpec::Core::Formatters::ProgressFormatter
      attr_reader :thresholds

      def dump_profile
        super
        examples_over_threshold.each_pair do |type, examples|
          output.puts "\n#{type.to_s.capitalize} examples with execution time over threshold #{threshold(type)} seconds (#{examples.size} examples):\n"
          examples.each do |example|
            dump_example_over_threshold(example)
          end
        end
      end

      private

      def dump_example_over_threshold(example)
        output.puts "  #{example.full_description}"
        output.puts "    #{bold(format_seconds(example.execution_result[:run_time]))} #{bold("seconds")} #{format_caller(example.location)}"
      end

      def examples_over_threshold
        over_threshold = {}

        examples.each do |example|
          next unless example.metadata[:type]
          if example.execution_result[:run_time] > threshold(example.metadata[:type])
            over_threshold[example.metadata[:type]] ||= []
            over_threshold[example.metadata[:type]] << example
          end
        end

        over_threshold
      end

      def default_thresholds
        {
            :model => 0.5,
            :controller => 1,
            :feature => 3
        }
      end

      def threshold(type)
        thresholds.fetch(type.to_sym, Float::INFINITY)
      end

      def thresholds
        @thresholds ||= default_thresholds.merge(RSpec.configuration.thresholds).to_options
      end

    end
  end
end


RSpec.configure do |config|
  config.add_setting :thresholds
  config.thresholds = {}
end
