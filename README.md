# Разработка на Ethereum
## Установка клиента
Выбор пал на популярный клиент, написанный на Rust, **Parity**.
Для его установки идем на сайт [Parity.io](https://www.parity.io/) и качаем предложенную версию.
В моем случае это deb пакет.


После установки, запускаем клиент Parity коммандой:
```bash
parity --chain ropsten
```

Пока ждем синхронизацию клиента с сеткой, заводим аккаунт на тестовой ветке:
```bash
# Создаем акк.
parity --chain ropsten account new
# Проверяем, что создался.
parity --chain ropsten account list
```

## Как намайнить Ethereum, если у вас не amdgpu.
Качаем нужную версию **Ethminer** с [GitHub](https://github.com/ethereum-mining/ethminer/releases).
Для *Linux*:
```bash
wget https://github.com/ethereum-mining/ethminer/releases/download/v0.14.0.dev1/ethminer-0.14.0.dev1-Linux.tar.gz
tar -xzvf ethminer-0.14.0.dev1-Linux.tar.gz bin/ethminer
sudo mv bin/ethminer /usr/local/bin
rm -rf ethminer-0.14.0.dev1-Linux.tar.gz bin
```

Теперь запускаем клиент Parity на **Ropsten** созданным аккаунтом и майним на него:
```bash
ethminer -F http://localhost:8545
```

Или майним через клиент **geth**:
```bash
geth --mine --minerthreads=4 --etherbase 'parity --chain ropsten account list [0]' --testnet
```
