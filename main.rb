require_relative 'lib/initializer'

puts 'Creating Greeter contract...'
contract_greeter = ContractCreationService.from_address(
  file_path: PathHolder.solid_script_path('greeter'),
  address: '0x731a10897d267e19b34503ad902d0a29173ba4b1'
)

puts 'Creating Simple Storage contract...'
contract_simple_storage = ContractCreationService.from_address(
  file_path: PathHolder.solid_script_path('simple_storage'),
  address: '0xb4c79dab8f259c7aee6e5b2aa729821864227e84'
)

# Show "Oh, SHI~, it's working!"
p contract_greeter
p contract_simple_storage.call.get_data
