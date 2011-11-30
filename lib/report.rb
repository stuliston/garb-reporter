require "garb-reporter/version"

module GarbReporter

	class Report

		def initialize(profile)
			@profile = profile
		end

		def method_missing(method, *args)
			
			method_name = method.to_s
			super unless valid_method_name?(method_name)

			class_name = build_class_name(method_name)
			klass = existing_report_class(class_name) || build_new_report_class(method_name, class_name)
			klass.results(@profile)
		end

		private

		def valid_method_name?(method_name)
			(!method_name.empty? && method_name.scan('_by_').count <= 1 && !method_name.start_with?('_', 'by_', 'and_') && !method_name.end_with?('_', '_by', '_and'))
		end

		def existing_report_class(class_name)
			class_exists?(class_name) ? GarbReporter.const_get(class_name) : nil
		end

		def class_exists?(class_name)
		  GarbReporter.const_defined?(class_name)
		rescue NameError
		  return false
		end

		def build_new_report_class(method_name, class_name)
			klass = GarbReporter.const_set(class_name, Class.new(GarbReporter::BaseGarbReport))
			klass.extend Garb::Model
			klass.metrics << extract_metrics(method_name)
			klass.dimensions << extract_dimensions(method_name)
			return klass
		end

		def build_class_name(method_name)
			method_name.split('_').collect { |w| w.capitalize! }.join
		end

		def extract_metrics(method_name)
			build_metrics_and_dimensions(method_name).first || []
		end

		def extract_dimensions(method_name)
			return [] unless method_name.include?('_by_')

			build_metrics_and_dimensions(method_name).last || []
		end

		def build_metrics_and_dimensions(method_name)
			(metrics, dimensions) =  method_name.split('_by_').collect { |part| part.split('_and_').collect(&:to_sym) }
		end

	end
end