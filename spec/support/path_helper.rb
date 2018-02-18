module PathHelper
  def path_to_script(script_name)
    Rails.root.join('lib', 'solidity_scripts', "#{script_name}.sol")
  end
end
