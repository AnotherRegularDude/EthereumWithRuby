require 'rubygems'
require 'bundler/setup'

# Require all gems in Gemfile with Bundler.
Bundler.require(:default)

dir_path = File.absolute_path(File.dirname(__FILE__))
solid_path = File.join(dir_path, 'solidity_scripts')

p 'Creating Greeter contract...'
contract_greeter = Ethereum::Contract.create(file: File.join(solid_path, 'greeter.sol'))
contract_greeter.deploy_and_wait("Oh, SHI~, it's working!")

p 'Creating Simple Storage contract...'
contract_simple_storage = Ethereum::Contract.create(file: File.join(solid_path, 'simple_storage.sol'))
contract_simple_storage.deploy_and_wait

random_number = rand(1..100)
p "Random number for storage is: #{random_number}"
contract_simple_storage.transact_and_wait.set_data(random_number)

# Show "Oh, SHI~, it's working!"
p contract_greeter.call.greet
p contract_simple_storage.call.get_data
