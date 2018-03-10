pragma solidity ^0.4.2;

contract IsbnRegistry {
  struct BookEdition {
    bytes32 title;
    bytes32 isbn10;
    bytes32 isbn13;
    bytes32 author;
    bytes32 publishDate;
    uint8 edition;
    uint8 binding;
    uint price;
    uint width;
    uint height;
    uint depth;
    string description;
    bool deleted;
  }

  address public owner;
  uint public index;

  // Show
  mapping(uint => BookEdition) public bookEditions;
  mapping(address => bool) public editorMapping;

  function IsbnRegistry() public {
    owner = msg.sender;
    index = 0;

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

  // Create
  function addBookEdition(bytes32 title, string isbn10, string isbn13) public {
    require(editorMapping[msg.sender]);
    require(bytes(isbn10).length == 10 && bytes(isbn13).length == 13);
    require(title != 0x0);

    bookEditions[index].title = title;
    bookEditions[index].isbn10 = stringToBytes32(isbn10);
    bookEditions[index].isbn13 = stringToBytes32(isbn13);
    bookEditions[index].deleted = false;

    index += 1;
  }

  // Full Update.
  function updateBookEdition(
    uint id,
    bytes32 author,
    bytes32 publishDate,
    uint8 edition,
    uint8 binding,
    uint price,
    uint width,
    uint height,
    uint depth,
    string description) public
  {
    require(editorMapping[msg.sender]);
    require(bookEditions[id].isbn13 != 0x0);
    require(bookEditions[id].deleted == false);

    bookEditions[id].author = author;
    bookEditions[id].publishDate = publishDate;
    bookEditions[id].edition = edition;
    bookEditions[id].binding = binding;
    bookEditions[id].price = price;
    bookEditions[id].width = width;
    bookEditions[id].height = height;
    bookEditions[id].depth = depth;
    bookEditions[id].description = description;
  }

  function updateIsbnInfoInBook(uint id, string isbn10, string isbn13) public {
    require(editorMapping[msg.sender]);
    require(bookEditions[id].isbn13 != 0x0);
    require(bookEditions[id].deleted == false);
    require(bytes(isbn10).length == 10 && bytes(isbn13).length == 13);

    bookEditions[id].isbn10 = stringToBytes32(isbn10);
    bookEditions[id].isbn13 = stringToBytes32(isbn13);
  }

  function updateTitleInBook(uint id, bytes32 title) public {
    require(editorMapping[msg.sender]);
    require(bookEditions[id].isbn13 != 0x0);
    require(bookEditions[id].deleted == false);

    bookEditions[id].title = title;
  }

  // Delete
  function deleteBookEdition(uint id) public {
    require(editorMapping[msg.sender]);
    require(bookEditions[id].isbn13 != 0x0);

    bookEditions[id].deleted = true;
  }

  function stringToBytes32(string source) private pure returns(bytes32 result) {
    assembly {
      result := mload(add(source, 32))
    }
  }
}
