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
  uint public indexCounter;

  mapping(bytes32 => IsbnEntity) public entityMapping;
  mapping(uint => bytes32) public isbnIndexMapping;

  function IsbnRegistry() public {
    owner = msg.sender;
    indexCounter = 0;
  }

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
    require(owner == msg.sender);
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

    isbnIndexMapping[indexCounter] = isbn13b;
    entityMapping[isbn13b] = newBook;
    indexCounter += 1;
  }

  function getAllStoredIsbns() public view returns(bytes32[]) {
    bytes32[] memory result = new bytes32[](indexCounter);

    for(uint i = 0; i < indexCounter; i++) {
      result[i] = (isbnIndexMapping[i]);
    }

    return result;
  }
}
