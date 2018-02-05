require 'rubygems'
require 'bundler/setup'

# Require all gems in Gemfile with Bundler.
Bundler.require(:default)

contract = Ethereum::Contract.create(file: "greeter.sol")
contract.deploy_and_wait("Oh, SHI~, it's working!")

# Show "Oh, SHI~, it's working!"
contract.call.greet
