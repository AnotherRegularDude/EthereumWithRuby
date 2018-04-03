pragma solidity ^0.4.2;

contract IsbnRegistry {
  struct IsbnNumber {
    uint16 ean;
    uint16 group;
    uint16 publisher;
    uint16 title;
    uint16 checkDigit;
  }

  struct BookEdition {
    bytes32 title;
    bytes32 author;
    bytes32 publishDate;
    uint isbn10;
    uint isbn13;
    uint8 edition;
    uint8 binding;
    uint price;
    uint width;
    uint height;
    uint depth;
    string description;
    bool removed;
  }

  IsbnNumber[] private isbnNumbers;

  address public owner;
  BookEdition[] public bookEditions;
  mapping(address => bool) public editorMapping;

  event BookEditionChanged(uint id, address changer);

  function IsbnRegistry() public {
    owner = msg.sender;

    editorMapping[owner] = true;
  }

  function bookEditionsCount() public view returns(uint) {
    return isbnNumbers.length;
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

  function addIsbnItem(uint16[] isbnArgs) public {
    require(checkIsbn(isbnArgs));

    isbnNumbers.push(IsbnNumber({
      ean: isbnArgs[0],
      group: 0,
      publisher: 0,
      title: 0,
      checkDigit: 0
    }));
  }

  function checkIsbn(uint16[] isbnArgs) private pure returns(bool result) {
    result = true;
    if (isbnArgs.length != 4 && isbnArgs.length != 5)
      return false;

    uint numbersCount = 0;
    uint resultSum = 0;

    uint i;
    uint16 tempNumber;

    if (isbnArgs.length == 4) {
      for(i = isbnArgs.length - 1; i >= 0; i--) {
        tempNumber = isbnArgs[i];
        while (tempNumber > 0) {
          numbersCount += 1;
          resultSum += numbersCount * (tempNumber % 10);
          tempNumber /= 10;
        }
      }

      if (numbersCount != 10 || resultSum % 11 != 0)
        result = false;
    } else {
      for(i = isbnArgs.length - 1; i >= 0; i--) {
        tempNumber = isbnArgs[i];
        while (tempNumber > 0) {
          numbersCount += 1;

          if (numbersCount % 2 == 0) {
            resultSum += 3 * (tempNumber % 10);
          } else {
            resultSum += tempNumber % 10;
          }

          tempNumber /= 10;
        }
      }

      if (numbersCount != 13 || resultSum % 10 != 0)
        result = false;
    }
  }
  // Create
  // function addBookEdition(bytes32 title, string isbn10, string isbn13) public {
  //   require(editorMapping[msg.sender]);
  //   require(bytes(isbn10).length == 10 && bytes(isbn13).length == 13);
  //   require(title != 0x0);

  //   bookEditions[index].title = title;
  //   bookEditions[index].isbn10 = stringToBytes32(isbn10);
  //   bookEditions[index].isbn13 = stringToBytes32(isbn13);
  //   bookEditions[index].deleted = false;

  //   index += 1;
  // }

  // // Full Update, will remove soon.
  // function updateBookEdition(
  //   uint id,
  //   bytes32 author,
  //   bytes32 publishDate,
  //   uint8 edition,
  //   uint8 binding,
  //   uint price,
  //   uint width,
  //   uint height,
  //   uint depth,
  //   string description) public
  // {
  //   require(editorMapping[msg.sender]);
  //   require(bookEditions[id].isbn13 != 0x0);
  //   require(bookEditions[id].deleted == false);

  //   bookEditions[id].author = author;
  //   bookEditions[id].publishDate = publishDate;
  //   bookEditions[id].edition = edition;
  //   bookEditions[id].binding = binding;
  //   bookEditions[id].price = price;
  //   bookEditions[id].width = width;
  //   bookEditions[id].height = height;
  //   bookEditions[id].depth = depth;
  //   bookEditions[id].description = description;

  //   BookEditionChanged(id, msg.sender);
  // }

  // function updateIsbnInfoInBook(uint id, string isbn10, string isbn13) public {
  //   require(editorMapping[msg.sender]);
  //   require(bookEditions[id].isbn13 != 0x0);
  //   require(bookEditions[id].deleted == false);
  //   require(bytes(isbn10).length == 10 && bytes(isbn13).length == 13);

  //   bookEditions[id].isbn10 = stringToBytes32(isbn10);
  //   bookEditions[id].isbn13 = stringToBytes32(isbn13);

  //   BookEditionChanged(id, msg.sender);
  // }

  // function updateTitleInBook(uint id, bytes32 title) public {
  //   require(editorMapping[msg.sender]);
  //   require(bookEditions[id].isbn13 != 0x0);
  //   require(bookEditions[id].deleted == false);

  //   bookEditions[id].title = title;

  //   BookEditionChanged(id, msg.sender);
  // }

  // // Delete
  // function deleteBookEdition(uint id) public {
  //   require(editorMapping[msg.sender]);
  //   require(bookEditions[id].isbn13 != 0x0);

  //   bookEditions[id].deleted = true;

  //   BookEditionChanged(id, msg.sender);
  // }

  // function stringToBytes32(string source) private pure returns(bytes32 result) {
  //   assembly {
  //     result := mload(add(source, 32))
  //   }
  // }
}
