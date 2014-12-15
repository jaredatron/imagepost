require 'tilt'

# This was taken from the react-rails gem
module React
  module JSX

    def self.context
      contents =
        # If execjs uses therubyracer, there is no 'global'. Make sure
        # we have it so JSX script can work properly.
        'var global = global || this;' +
        File.read(React::Source.bundled_path_for('JSXTransformer.js'))
      @context ||= ExecJS.compile(contents)
    end

    def self.transform(code)
      result = context.call('JSXTransformer.transform', code)
      return result['code']
    end

    class Template < Tilt::Template
      self.default_mime_type = 'application/javascript'

      TransformationError = Class.new(StandardError)

      def prepare
      end

      def evaluate(scope, locals, &block)
        @output ||= JSX::transform(data)
      rescue ExecJS::ProgramError => error
        lines_of_code = data.split("\n").each_with_index.map{|c,n| "#{n}: #{c}" }
        if line = error.message[%r{Line (\d+)}, 1]
          line = line.to_i
          lines_of_code = lines_of_code.slice(line-10, 20)
        end

        error = TransformationError.new(error.message)
        error.set_backtrace lines_of_code
        raise error
      end
    end
  end
end
