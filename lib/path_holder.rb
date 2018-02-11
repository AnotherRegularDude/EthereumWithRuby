class PathHolder
  ROOT_PATH = File.absolute_path(File.dirname('..')).freeze
  SOLID_PATH = File.join(ROOT_PATH, 'solidity_scripts').freeze

  class << self
    def root_join(*path)
      File.join(ROOT_PATH, path)
    end

    def solid_script_path(script_name)
      File.join(SOLID_PATH, "#{script_name}.sol")
    end
  end
end
