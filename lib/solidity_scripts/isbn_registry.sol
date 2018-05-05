pragma solidity ^0.4.2;

contract IsbnRegistry {
  enum EventType { Added, Removed }

  struct BookEdition {
    bytes32 title;
    bytes32 author;
    bytes32 isbn10;
    bytes32 isbn13;
    uint publishDate;
    uint edition;
    uint binding;
    uint price;
    uint width;
    uint height;
    uint depth;
    string description;
    bool removed;
  }

  address public owner;
  BookEdition[] public bookEditions;
  mapping(address => bool) public editorMapping;

  event RegistryChanged(uint id, EventType action, address changer);

  constructor() public {
    owner = msg.sender;

    editorMapping[owner] = true;
  }

  function bookEditionsCount() public view returns(uint) {
    return bookEditions.length;
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

  function addBookEdition(bytes32[] stringArgs, uint[] intArgs, string description) public {
    require(editorMapping[msg.sender]);
    require(stringArgs.length == 4 && intArgs.length == 7);

    require(getLengthOfBytesLine(stringArgs[0]) != 0);
    require(checkIsbn10(stringArgs[2]));
    require(checkIsbn13(stringArgs[3]));

    bookEditions.push(BookEdition({
      title: stringArgs[0],
      author: stringArgs[1],
      isbn10: stringArgs[2],
      isbn13: stringArgs[3],
      publishDate: intArgs[0],
      edition: intArgs[1],
      binding: intArgs[2],
      price: intArgs[3],
      width: intArgs[4],
      height: intArgs[5],
      depth: intArgs[6],
      description: description,
      removed: false
    }));

    emit RegistryChanged(bookEditions.length - 1, EventType.Added, msg.sender);
  }

  function markRemovedBookEdition(uint index) public {
    require(editorMapping[msg.sender]);
    require(bookEditions.length > index);
    require(!bookEditions[index].removed);

    bookEditions[index].removed = true;

    emit RegistryChanged(index, EventType.Removed, msg.sender);
  }

  function checkIsbn10(bytes32 isbn10) public pure returns(bool) {
    if (getLengthOfBytesLine(isbn10) != 10) return false;

    uint finalSum = 0;
    for (uint i = 0; i < 10; i++) {
      finalSum += getNumberFromByte(isbn10[i]) * (10 - i);
    }

    return (finalSum % 11 == 0);
  }

  function checkIsbn13(bytes32 isbn13) public pure returns(bool) {
    if (getLengthOfBytesLine(isbn13) != 13) return false;

    uint finalSum = 0;
    for (uint i = 0; i < 13; i++) {
      if ((i + 1) % 2 == 0) {
        finalSum += getNumberFromByte(isbn13[i]) * 3;
      } else {
        finalSum += getNumberFromByte(isbn13[i]);
      }
    }

    return (finalSum % 10 == 0);
  }

  function getNumberFromByte(bytes1 numberInLine) public pure returns(uint) {
    bytes1 zeroInLine = "0";

    return uint(numberInLine[0]) - uint(zeroInLine[0]);
  }

  function getLengthOfBytesLine(bytes32 line) private pure returns(uint result) {
    result = 0;

    for (uint i = 0; i < 32; i++) {
      if (line[i] == 0) return;

      result++;
    }
  }
}
