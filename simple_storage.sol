contract SimpleStorage {
    uint storedData;
    function setData(uint x) {
        storedData = x;
    }
    function getData() constant returns (uint retVal) {
        return storedData;
    }
}
