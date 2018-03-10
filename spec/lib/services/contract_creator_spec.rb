require 'spec_helper'

describe ContractCreator do
  include PathHelper

  subject { ContractCreator }
  let(:greeter_message) { 'Message' }
  let(:greeter_contract) do
    subject.call(
      path_to_contract: path_to_script('greeter'),
      args_for_contract: greeter_message
    )
  end

  let(:storage_number) { rand(1..100) }
  let(:storage_contract) do
    subject.call(path_to_contract: path_to_script('simple_storage'))
  end

  before do
    storage_contract.transact_and_wait.set_data(storage_number)
  end

  context 'when use new greeter contract' do
    it { expect(greeter_contract.address).to be_an_instance_of(String) }
    it { expect(greeter_contract.call.greet).to eq(greeter_message) }
  end

  context 'when use new storage contract' do
    it { expect(storage_contract.address).to be_an_instance_of(String) }
    it { expect(storage_contract.call.get_data).to eq(storage_number) }
  end
end
