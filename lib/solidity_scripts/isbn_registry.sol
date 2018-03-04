pragma solidity ^0.4.2;

contract IsbnRegistry {
  enum EditionType { Reprint, Slp, Special, Rehearsal, ScriptEd, Anniversary, Reissue, Unabridged }
  enum BindingBookType { Hardcover, Paperbound, VHS, Laserdisc, EBook }

  struct IsbnEntity {
    bytes32 title;
    bytes32 isbn10;
    bytes32 isbn13;
    uint edition;
    uint binding;
    bool deleted;
  }

  struct Dimensions {
    uint width;
    uint height;
    uint depth;
  }

  struct AdditionalInfo {
    bytes32 author;
    string description;
    bytes32 publishDate;
    uint priceInRubles;
  }

  address public owner;
  uint public commonIndexId;

  mapping(uint => IsbnEntity) public entityMapping;
  mapping(uint => Dimensions) public dimensionsMapping;
  mapping(uint => AdditionalInfo) public additionalInfoMapping;

  mapping(address => bool) public editorMapping;

  function IsbnRegistry() public {
    owner = msg.sender;
    commonIndexId = 0;

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
  function addBook(
    bytes32 title,
    string isbn10,
    string isbn13,
    EditionType edition,
    BindingBookType binding) public
  {
    require(editorMapping[msg.sender]);
    require(bytes(isbn10).length == 10 && bytes(isbn13).length == 13);
    require(title != 0x0);

    IsbnEntity memory newBook = IsbnEntity({
      title: title,
      isbn10: stringToBytes32(isbn10),
      isbn13: stringToBytes32(isbn13),
      edition: uint(edition),
      binding: uint(binding),
      deleted: false
    });

    entityMapping[commonIndexId] = newBook;

    commonIndexId += 1;
  }

  function setBookDimensions(uint id, uint height, uint width, uint depth) public {
    require(editorMapping[msg.sender]);
    require(entityMapping[id].isbn13 != 0x0);
    require(width > 0 && height > 0 && depth > 0);

    Dimensions memory newDimensions = Dimensions({
      width: width,
      height: height,
      depth: depth
    });

    dimensionsMapping[id] = newDimensions;
  }

  function setBookAdditionalInfo(
    uint id, bytes32 author, bytes32 publishDate, uint priceInRubles, string description) public
  {
    require(editorMapping[msg.sender]);
    require(entityMapping[id].isbn13 != 0x0);
    require(priceInRubles > 0);

    AdditionalInfo memory newInfo = AdditionalInfo({
      author: author,
      publishDate: publishDate,
      priceInRubles: priceInRubles,
      description: description
    });

    additionalInfoMapping[id] = newInfo;
  }

  function updateBook(
    uint id,
    bytes32 title,
    string isbn10,
    string isbn13,
    EditionType edition,
    BindingBookType binding) public
  {
    require(editorMapping[msg.sender]);

    IsbnEntity memory changedBook = entityMapping[id];

    require(changedBook.isbn13 != 0x0);
    require(bytes(isbn10).length == 10 && bytes(isbn13).length == 13);
    require(title != 0x0);

    IsbnEntity memory newBook = IsbnEntity({
      title: title,
      isbn10: stringToBytes32(isbn10),
      isbn13: stringToBytes32(isbn13),
      edition: uint(edition),
      binding: uint(binding),
      deleted: changedBook.deleted
    });

    entityMapping[id] = newBook;
  }

  function deleteBookFromRegistry(uint id) public {
    require(editorMapping[msg.sender]);
    require(entityMapping[id].isbn13 != 0x0);

    entityMapping[id].deleted = true;
  }

  function getAllIsbn13() public view returns(bytes32[]) {
    bytes32[] memory result = new bytes32[](commonIndexId);

    for(uint i = 0; i < commonIndexId; i++) {
      result[i] = entityMapping[i].isbn13;
    }

    return result;
  }

  function stringToBytes32(string source) private pure returns(bytes32 result) {
    assembly {
      result := mload(add(source, 32))
    }
  }
}
