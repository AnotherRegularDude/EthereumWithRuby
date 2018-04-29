pragma solidity ^0.4.2;

contract BookInstanceRegistry {
  enum EventType { Added, Changed }
  enum BookState { Returned, Taken, Lost }

  struct BookInstance {
    bytes32 isbn10;
    bytes32 isbn13;
    bytes32 ownerInn;
    bytes32 holderInn;
    uint state;
    uint timeToReturn;
  }

  address public owner;
  BookInstance[] public bookInstances;
  mapping(address => bool) public editorMapping;

  event RegistryChanged(uint id, EventType action, address changer);

  constructor() public {
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
    require(stringArgs.length == 4 && intArgs.length == 1);
    require(getLengthOfBytesLine(stringArgs[2]) == 12 && getLengthOfBytesLine(stringArgs[3]) == 12);

    bookInstances.push(BookInstance({
      isbn10: stringArgs[0],
      isbn13: stringArgs[1],
      ownerInn: stringArgs[2],
      holderInn: stringArgs[3],
      state: uint(BookState.Returned),
      timeToReturn: intArgs[1]
    }));

    emit RegistryChanged(bookInstances.length - 1, EventType.Added, msg.sender);
  }

  function setBookReturned(uint id) public {
    require(editorMapping[msg.sender]);
    require(id < bookInstances.length);
    require(bookInstances[id].state != uint(BookState.Lost));

    bookInstances[id].holderInn = bookInstances[id].ownerInn;
    bookInstances[id].timeToReturn = 0;
    bookInstances[id].state = uint(BookState.Returned);

    emit RegistryChanged(id, EventType.Changed, msg.sender);
  }

  function setBookTaken(uint id, bytes32 holderInn, uint timeToReturn) public {
    require(editorMapping[msg.sender]);
    require(id < bookInstances.length);
    require(bookInstances[id].state != uint(BookState.Lost));
    require(getLengthOfBytesLine(holderInn) == 12);

    bookInstances[id].holderInn = holderInn;
    bookInstances[id].timeToReturn = timeToReturn;
    bookInstances[id].state = uint(BookState.Taken);

    emit RegistryChanged(id, EventType.Changed, msg.sender);
  }

  function setBookLost(uint id) public {
    require(editorMapping[msg.sender]);
    require(id < bookInstances.length);
    require(bookInstances[id].state != uint(BookState.Lost));

    bookInstances[id].timeToReturn = 0;
    bookInstances[id].state = uint(BookState.Lost);

    emit RegistryChanged(id, EventType.Changed, msg.sender);
  }

  function getLengthOfBytesLine(bytes32 line) private pure returns(uint result) {
    result = 0;

    for (uint i = 0; i < 32; i++) {
      if (line[i] == 0) return;

      result++;
    }
  }
}
