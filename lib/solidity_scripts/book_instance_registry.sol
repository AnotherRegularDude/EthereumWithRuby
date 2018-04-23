pragma solidity ^0.4.2;

contract BookInstanceRegistry {
  enum EventType { Added, Changed }

  struct BookInstance {
    bytes32 isbn10;
    bytes32 isbn13;
    bytes32 owner;
    bytes32 holder;
    uint state;
    uint timeToReturn;
  }

  address public owner;
  BookInstance[] public bookInstances;
  mapping(address => bool) public editorMapping;

  event RegistryChanged(uint id, EventType action, address changer);

  function BookInstanceRegistry() public {
    owner = msg.sender;

    editorMapping[owner] = true;
  }

  function bookInstancesCount() public view returns(uint) {
    return bookInstances.length;
  }

  // Manage addresses, that cat edit registry items.
  function addEditorAddress(address newEditor) public {
    require(owner == msg.sender);

    editorMapping[newEditor] = true;
  }

  function deleteEditorAddress(address deletedEditor) public {
    require(owner == msg.sender);

    delete editorMapping[deletedEditor];
  }

  function addBookInstance(bytes32[] stringArgs, uint[] intArgs) public {
    require(editorMapping[msg.sender]);
    require(stringArgs.length == 4 && intArgs.length == 2);

    bookInstances.push(BookInstance({
      isbn10: stringArgs[0],
      isbn13: stringArgs[1],
      owner: stringArgs[2],
      holder: stringArgs[3],
      state: intArgs[0],
      timeToReturn: intArgs[1]
    }));

    emit RegistryChanged(bookInstances.length - 1, EventType.Added, msg.sender);
  }

  function setBookReturned(uint id) public {
    require(editorMapping[msg.sender]);
    require(id < bookInstances.length);
    require(bookInstances[id].state != 2);

    bookInstances[id].holder = bookInstances[id].owner;
    bookInstances[id].timeToReturn = 0;

    emit RegistryChanged(id, EventType.Changed, msg.sender);
  }

  function setBookTaken(uint id, bytes32 holder, uint timeToReturn) public {
    require(editorMapping[msg.sender]);
    require(id < bookInstances.length);
    require(bookInstances[id].state != 2);

    bookInstances[id].holder = holder;
    bookInstances[id].timeToReturn = timeToReturn;
    emit RegistryChanged(id, EventType.Changed, msg.sender);
  }

  function setBookLost(uint id) public {
    require(editorMapping[msg.sender]);
    require(id < bookInstances.length);
    require(bookInstances[id].state != 2);

    bookInstances[id].state = 2;

    emit RegistryChanged(id, EventType.Changed, msg.sender);
  }
}
