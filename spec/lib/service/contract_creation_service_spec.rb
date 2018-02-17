require 'spec_helper'

describe ContractCreationService do
  subject { ContractCreationService }
  let(:greeter_message) { 'Message' }
  let(:greeter_contract) do
    subject.create_and_wait(
      file_path: PathHolder.solid_script_path('greeter'),
      contract_args: greeter_message
    )
  end

  let(:storage_number) { rand(1..100) }
  let(:storage_contract) do
    subject.create_and_wait(
      file_path: PathHolder.solid_script_path('simple_storage')
    )
  end

  before do
    storage_contract.transact_and_wait.set_data(storage_number)
  end

  context 'when use new greeter contract' do
    it { expect(greeter_contract.address).to be_an_instance_of(String) }
    it { expect(greeter_contract.call.greet).to eq(greeter_message) }
  end
  context 'when use deployed greeter from address' do
    let(:contract_from_address) do
      subject.from_address(
        file_path: PathHolder.solid_script_path('greeter'),
        address: greeter_contract.address
      )
    end

    it { expect(contract_from_address.address).to eq(greeter_contract.address) }
    it { expect(contract_from_address.call.greet).to eq(greeter_message) }
  end

  context 'when use new storage contract' do
    it { expect(storage_contract.address).to be_an_instance_of(String) }
    it { expect(storage_contract.call.get_data).to eq(storage_number) }
  end

  context 'when use deployed storage contract from address' do
    let(:contract_from_address) do
      subject.from_address(
        file_path: PathHolder.solid_script_path('simple_storage'),
        address: storage_contract.address
      )
    end

    it { expect(storage_contract.address).to eq(contract_from_address.address) }
    it { expect(contract_from_address.call.get_data).to eq(storage_number) }
  end

  context 'when storage contract from address change value' do
    let(:new_storage_number) { rand(1..100) }
    let(:contract_from_abi) do
      subject.from_abi(
        name: 'StorageContract',
        address: storage_contract.address,
        abi: storage_contract.abi
      )
    end
    let(:contract_from_address) do
      subject.from_address(
        file_path: PathHolder.solid_script_path('simple_storage'),
        address: storage_contract.address
      )
    end

    before do
      contract_from_address.transact_and_wait.set_data(new_storage_number)
    end

    it { expect(contract_from_address.call.get_data).to eq(new_storage_number) }
    it { expect(storage_contract.address).to eq(contract_from_address.address) }
    it { expect(storage_contract.call.get_data).to eq(contract_from_address.call.get_data) }
    it { expect(contract_from_abi.call.get_data).to eq(storage_contract.call.get_data) }
  end
end
