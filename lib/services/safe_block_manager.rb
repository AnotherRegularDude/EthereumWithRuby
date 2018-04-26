class SafeBlockManager
  def self.call(contract)
    first_block = Rails.cache.read(contract.address) || 0
    last_block = Ethereum::Singleton.instance.eth_block_number['result'].to_i(16)

    return if last_block <= first_block

    Rails.cache.write(contract.address, last_block)
    { first_block: '0x' + first_block.to_s(16), last_block: '0x' + last_block.to_s(16) }
  end
end
