task :environment do
  require_relative 'lib/initializer'
end

namespace :node do
  desc 'Start parity node in development mode with unlocked wallet'
  task start: :environment do
    if File.exist? PathHolder.parity_pid_path
      puts 'Node already running.'
    else
      address = '0x00a329c0648769a73afac7f9381e08fb43dbea72'
      pass = PathHolder.root_join('password')

      pid = Process.spawn "parity --config dev --unlock #{address} --password #{pass} > /dev/null 2>&1"
      Process.detach(pid)

      File.write(PathHolder.parity_pid_path, pid + 2)
      puts 'Started.'
    end
  end

  desc 'Stop started parity node'
  task stop: :environment do
    if File.exist? PathHolder.parity_pid_path
      path_to_pid = PathHolder.parity_pid_path

      pid = File.read(path_to_pid).to_i
      File.delete(path_to_pid)

      Process.kill('TERM', pid)
      puts 'Stopped.'
    else
      puts 'No node running.'
    end
  end

  desc 'Clear pid file in tmp'
  task clear_pid: :environment do
    FileUtils.rm_f(PathHolder.parity_pid_path)
  end
end

namespace :contract do
  desc 'Create contract'
  task :create, [:file_name] => :environment do |_, args|
    path_to = PathHolder.solid_script_path(args.file_name)
    contract = ContractCreationService.create_and_wait(file_path: path_to)

    puts 'Done'
    puts "Address of contract: #{contract.address}"
  end
end
