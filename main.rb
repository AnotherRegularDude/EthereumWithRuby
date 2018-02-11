require_relative 'lib/initializer'

puts 'Creating Greeter contract...'
contract_greeter = ContractCreationService.from_address(
  file_path: PathHolder.solid_script_path('greeter'),
  address: '0xf9edd91fc3db8f943cbea1fc56287262e9f26d88'
)

puts 'Creating Simple Storage contract...'
contract_simple_storage = ContractCreationService.from_address(
  file_path: PathHolder.solid_script_path('simple_storage'),
  address: '0x85ae1e5291a86dfc12d867f5ff040c82efb9135d'
)

# Show "Oh, SHI~, it's working!"
p contract_greeter.call.greet
p contract_simple_storage.call.get_data

puts "Address of greeter: #{contract_greeter.address}"
puts "Address of contract_simple_storage: #{contract_simple_storage.address}"
