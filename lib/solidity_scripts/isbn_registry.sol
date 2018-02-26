pragma solidity ^0.4.2;

contract IsbnRegistry {
  enum EditionType { Reprint, Slp, Special, Rehearsal, ScriptEd, Anniversary, Reissue, Unabridged }
  enum BindingBookType { Hardcover, Paperbound, VHS, Laserdisc, EBook }

  struct IsbnEntity {
    string fullTitle;
    bytes32 isbn10;
    bytes32 isbn13;
    uint publisher;
    uint edition;
    uint publishDate;
    uint bindingWithBook;
    uint width;
    uint height;
    uint depth;
    string overview;
  }

  address public owner;
  uint public indexId;
  uint public itemsCount;

  mapping(bytes32 => IsbnEntity) public entityMapping;
  mapping(uint => bytes32) public isbnIndexMapping;
  mapping(address => bool) public editorMapping;

  function IsbnRegistry() public {
    owner = msg.sender;
    indexId = 0;
    itemsCount = 0;

    editorMapping[owner] = true;
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

  // Manage registry items.
  function addBookToRegistry(
    string fullTitle,
    string isbn10,
    string isbn13,
    uint publisher,
    EditionType edition,
    uint publishDate,
    BindingBookType bindingWithBook,
    uint width,
    uint height,
    uint depth,
    string overview) public
  {
    require(editorMapping[msg.sender]);
    require(bytes(isbn10).length == 10 && bytes(isbn13).length == 13);

    bytes32 isbn10b;
    bytes32 isbn13b;

    assembly {
      isbn10b := mload(add(isbn10, 32))
      isbn13b := mload(add(isbn13, 32))
    }

    require(entityMapping[isbn13b].isbn13 == 0x0);

    IsbnEntity memory newBook = IsbnEntity({
      fullTitle: fullTitle,
      isbn10: isbn10b,
      isbn13: isbn13b,
      publisher: publisher,
      edition: uint(edition),
      publishDate: publishDate,
      bindingWithBook: uint(bindingWithBook),
      width: width,
      height: height,
      depth: depth,
      overview: overview
    });

    isbnIndexMapping[indexId] = isbn13b;
    entityMapping[isbn13b] = newBook;

    indexId += 1;
    itemsCount += 1;
  }

  function deleteBookFromRegistry(bytes32 isbn13) public {
    require(editorMapping[msg.sender]);

    if (itemsCount == 0) {
      return;
    }

    for (uint i = 0; i < indexId; i++) {
      if (isbnIndexMapping[i] == isbn13) {
        delete isbnIndexMapping[i];
        delete entityMapping[isbn13];
        itemsCount -= 1;

        break;
      }
    }
  }

  function getAllStoredIsbns() public view returns(bytes32[]) {
    bytes32[] memory result = new bytes32[](itemsCount);

    for (uint i = 0; i < indexId; i++) {
      if (isbnIndexMapping[i] != 0x0) {
        result[i] = isbnIndexMapping[i];
      }
    }

    return result;
  }
}
