// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NftMarket is ER712URIStorage, Ownable{
    counter
    constructor() ERC721("WildLifeNFT", "WCT") {}


    function tokenURIExists(string memory _tokenURI) public view returns (bool) {
        return _usedTokensURIs[_tokenURI] == true;
    }
    

    function tokenOfOwnerByIndex() public view returns (uint) {

    }

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

    function placeNftOnsale(uint _tokenId, uint _newPrice) public payable {
        require(ERC721.ownerOf(tokenId) == msg.sender, "You are not the owner of this nft");
        require(_idToNftItem[_tokenId].isListed == false, "Item is already on sale");
        require(msg.value == listingPrice, "Price must be equal to listing");

        _idToNftItem[_tokenId].isListed = true;
        _idToNftItem[_tokenId].price = _newPrice;
        _listedItems.increment();
    }


    function _createNFTItem(uint _tokenId, uint _price) private {
        require(_price > 0, "Price must be at least 1 wei");
        _idVftItem[_tokenId] = NftItem(
            _tokenId,
            msg.sender,
            _price,
            true
        );

        emit NftItemCreated(_tokenId, msg.sender, _price, true);
    }
}
