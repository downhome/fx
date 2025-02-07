module Fx
  # @api private
  class Definition
    def initialize(name:, version:, type: "function")
      @name = name
      @version = version
      @type = type
    end

    def to_sql
      ERB.new(File.read(find_file || full_path)).result.tap do |content|
        if content.empty?
          raise "Define #{@type} in #{path} before migrating."
        end
      end
    end

    def full_path
      Rails.root.join(path)
    end

    def path
      @_path ||= File.join("db", @type.pluralize, filename)
    end

    def version
      @version = latest_version if @version == :latest
      @version.to_i.to_s.rjust(2, "0")
    end

    private

    def filename
      @_filename ||= "#{@name}_v#{version}.sql"
    end

    def find_file
      migration_paths.lazy
        .map { |migration_path| File.expand_path(File.join("..", "..", path), migration_path) }
        .find { |definition_path| File.exist?(definition_path) }
    end

    def migration_paths
      Rails.application.config.paths["db/migrate"].expanded
    end

    def latest_version
      Dir.glob(Rails.root.join("db", @type.pluralize, "#{@name}*.sql")).max =~ /#{@name}_v(\d*).sql/i
      $1
    end
  end
end
