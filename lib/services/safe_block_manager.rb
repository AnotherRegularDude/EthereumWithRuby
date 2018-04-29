class SafeBlockManager
  def self.call(contract)
    from_block = Rails.cache.read(contract.address) || 0
    to_block = Ethereum::Singleton.instance.eth_block_number['result'].to_i(16)

    return if to_block < from_block

    Rails.cache.write(contract.address, to_block + 1)
    { from_block: '0x' + from_block.to_s(16), to_block: '0x' + to_block.to_s(16) }
  end
end
