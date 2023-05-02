// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//Importing the ncessary libraries
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// This is the wildlife contract
contract NftMarket is ER712URIStorage, Ownable {
    using Counters for Counters.counter;

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
    mapping(unit => uint) private _idToOwnedIndex;

    unit256[] private _allNfts;
    mapping(unit => uint) private _idToNftIndex;

    event NftItemCreated(
        uint indexed tokenId,
        address indexed creator,
        uint price,
        bool isListed
    );

     //This is the NFT Symbol
    constructor() ERC721("WildLifeNFT", "WLT") {}


    function tokenURIExists(string memory _tokenURI) public view returns (bool) {
        return _usedTokensURIs[_tokenURI] == true;
    }


    function tokenOfOwnerByIndex() public view returns (uint) {

    }

    //This is for getting owned NFT
    function getOwnedNfts() public view returns (NftItems [] memory) {
        uint totalNftsOwned = ERC721.balanceOf(msg.sender);
        NFTItem[] memory items = new NftItem[](totalNftsOwned);

        for (uint i = 0; i < totalNftsOwned; i++) {
            uint _tokenId = tokenOfOwnerByIndex(msg.sender, i);
            NftItem storage item = _idToNftItem[_tokenId];

            items[i] = item;
        }

        return items;
    }

    // This is function for minting tokens
    function mintToken(string memory _tokenURI, uint _price) public payable returns (uint) {
        require(tokenURIExists _tokenURI,"Token URL already exists");
        require(msg.value == listingPrice, "Price must be equal to listing");

        _tokenIds.increment();
        _listedItems.increment();

        uint newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _price);
        _createNftIten(newTokenId, _price);
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
        payable(owner).transfer(masg.value);
    }

    //This is a function for placing the NFT on sale
    function placeNftOnsale(uint _tokenId, uint _newPrice) public payable {
        require(ERC721.ownerOf(tokenId) == msg.sender, "You are not the owner of this nft");
        require(_idToNftItem[_tokenId].isListed == false, "Item is already on sale");
        require(msg.value == listingPrice, "Price must be equal to listing");

        _idToNftItem[_tokenId].isListed = true;
        _idToNftItem[_tokenId].price = _newPrice;
        _listedItems.increment();
    }


    //This is function for craeting NFT within the contract
    function _createNFTItem(uint _tokenId, uint _price) private {
        require(_price > 0, "Price must be at least 1 wei");
        _idToNftItem[_tokenId] = NftItem(
            _tokenId,
            msg.sender,
            _price,
            true
        );

        emit NftItemCreated(_tokenId, msg.sender, _price, true);
    }
}
