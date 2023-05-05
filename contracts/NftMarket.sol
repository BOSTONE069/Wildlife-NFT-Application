// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//Importing the ncessary libraries
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// This is the wildlife contract
contract NftMarket is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    //This is the struct data for the NFT
    struct NftItem {
        uint256 tokenId;
        address creator;
        uint256 price;
        bool isListed;
    }
    //listing price for the NFT
    uint public listingPrice = 0.025 ether;

    Counters.Counter private _listedItems;
    Counters.Counter private _tokenIds;

    mapping(string => bool) private _usedTokenURIs;
    mapping(uint => NftItem) private _idToNftItem;

    mapping(address => mapping(uint => uint)) private _ownedTokens;
    mapping(uint => uint) private _idToOwnedIndex;

    uint256[] private _allNfts;
    mapping(uint => uint) private _idToNftIndex;

    event NftItemCreated(
        uint indexed tokenId,
        address indexed creator,
        uint price,
        bool isListed
    );

     //This is the NFT Symbol
    constructor() ERC721("WildLifeNFT", "WLT") {}

    //function set listing price
    function setListingPrice(uint _newprice) external onlyOwner {
        require(_newprice >= 0, "Price must be least 1 wei");
        listingPrice - _newprice;
    }

    //function to get NFT item
    function getNftItem(uint _tokenId) public view returns (NftItem memory){
        return _idToNftItem[_tokenId];
    }

    //function for listed items count
    function getListedItemsCount() public view returns (uint count){
        return _listedItems.current();
    }
    function tokenURIExists(string memory _tokenURI) public view returns (bool) {
        return _usedTokenURIs[_tokenURI] == true;
    }

    //function for the getting the total supply of the NFT
    function totalSupply() public view returns (uint) {
        return _allNfts.length;
        }

    // function for getting token of owner by index
    function tokenOfOwnerByIndex(address owner, uint _index) public view returns (uint) {
        require(_index < ERC721.balanceOf(owner), 'Index out of bound');
        return _ownedTokens[owner][_index];
    }

    function getAllNftsOnSale() public view returns(NftItem[] memory){
        uint allItemsCounts = totalSupply();
        uint currentIndex = 0;
        NftItem[] memory items = new NftItem[](allItemsCounts);

        for (uint i = 0; i < allItemsCounts; i++) {
            uint tokenId = tokenByIndex(i);
            NftItem storage item = _idToNftIndex[tokenId];

            if (item.isListed) {
                items[currentIndex] = item;
                currentIndex++;
            }
        }

        return items;

    }

    //This is for getting owned NFT
    function getOwnedNfts() public view returns (NftItem[] memory) {
        uint totalNftsOwned = ERC721.balanceOf(msg.sender);
        NftItem[] memory items = new NftItem[](totalNftsOwned);

        for (uint i = 0; i < totalNftsOwned; i++) {
            uint _tokenId = tokenOfOwnerByIndex(msg.sender, i);
            NftItem storage item = _idToNftItem[_tokenId];

            items[i] = item;
        }

        return items;
    }

    // This is function for minting tokens
    function mintToken(string memory _tokenURI, uint _price) public payable returns (uint) {
        require(!tokenURIExists (_tokenURI),"Token URL already exists");
        require(msg.value == listingPrice, "Price must be equal to listing");

        _tokenIds.increment();
        _listedItems.increment();

        uint newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        _createNftItem(newTokenId, _price);
        _usedTokenURIs[_tokenId] = true;

        return newTokenId;
    }

    //Thi is function for buying the NFT
    function buyNft(uint _tokenId) public payable {
        uint price =_idToNftItem[_tokenId].price;
        address owner = ERC721.ownerOf(_tokenId);

        require(msg.sender != owner, "You are the owner of the item");
        require(msg.value == price, "Price must be equal to listing");

        _idToNftItem[_tokenId].isListed = false;
        _listedItems.decrement();

        _transfer(owner, msg.sender, _tokenId);
        payable(owner).transfer(msg.value);
    }

    //This is a function for placing the NFT on sale
    function placeNftOnsale(uint _tokenId, uint _newPrice) public payable {
        require(ERC721.ownerOf(_tokenId) == msg.sender, "You are not the owner of this nft");
        require(_idToNftItem[_tokenId].isListed == false, "Item is already on sale");
        require(msg.value == listingPrice, "Price must be equal to listing");

        _idToNftItem[_tokenId].isListed = true;
        _idToNftItem[_tokenId].price = _newPrice;
        _listedItems.increment();
    }


    //This is function for creating NFT within the contract
    function _createNftItem(uint _tokenId, uint _price) private {
        require(_price > 0, "Price must be at least 1 wei");
        _idToNftItem[_tokenId] = NftItem(
            _tokenId,
            msg.sender,
            _price,
            true
        );

        emit NftItemCreated(_tokenId, msg.sender, _price, true);
    }

    function _beforeTokenTransfer(address from, address to, uint _tokenId) internal virtual override {
        super. _beforeTokenTransfer(from, to, _tokenId);

        if (from == address(0)) {
            _addTokensToAllTokensEnumeration(_tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, _tokenId);
        }

        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(_tokenId);
        } else if (to != from) {
            _addTokensToAllTokensEnumeration(to, _tokenId);
        }
    }

    function _addTokensToAllTokensEnumeration(uint _tokenId) private {
        _idToNftIndex[_tokenId] = _allNfts.length;
        _allNfts.push(_tokenId);
    }

    function _addTokenToOwnerEnumeration(address to, uint _tokenid) private {
        uint length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = _tokenId;
        _idToOwnedIndex[_tokenId] = length;

    }

    function _removeTokenFromOwnerEnumeration(address from, uint _tokenId) private {
        uint lastTokenIndex = ERC721.balanceOf(from);
        uint tokenIndex = _idToOwnedIndex[_tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint lastTokenId = _ownedTokens[form][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;
            _idToOwnedIndex[lastTokenId] = tokenIndex;
        }

        delete _idToOwnedIndex[_tokenId];
        delete _ownedTokens[from][lastTokenIndex];

    }

    //function to remove NFT from sale
    function _removeTokenFromAllTokensEnumeration(uint _tokenId) private {
        uint lastTokenIndex = _allNfts.length - 1;
        uint tokenIndex = _idToNftIndex[_tokenId];
        uint lastTokenId = _allNfts[lastTokenIndex];

        _allNfts[tokenIndex] = lastTokenId;
        _idToNftIndex[lastTokenId] = tokenIndex;

        delete _idToNftIndex[_tokenId];
        _allNfts.pop();
    }

}
