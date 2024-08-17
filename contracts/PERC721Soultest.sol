// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PERC721Soultest is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    uint256 public constant MAX_SUPPLY = 100;

    // Маппинг для хранения URI токенов
    mapping(uint256 => string) private _tokenURIs;

    constructor(address initialOwner)
        ERC721("PERC721Soultest", "PSTT")
        Ownable(initialOwner)
    {}

    function safeMint(address to) public {
        require(_nextTokenId < MAX_SUPPLY, "Max supply reached");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(msg.sender == ownerOf(tokenId), "PERC721Soultest: caller is not token owner");
        return _tokenURIs[tokenId];
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(msg.sender == ownerOf(tokenId), "PERC721Soultest: caller is not token owner");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function balanceOf(address owner) public view override(ERC721, IERC721) returns (uint256) {
        require(msg.sender == owner, "PERC721Soultest: caller is not owner");
        return super.balanceOf(owner);
    }

    function ownerOf(uint256 tokenId) public view override(ERC721, IERC721) returns (address) {
        require(msg.sender == super.ownerOf(tokenId), "PERC721Soultest: caller is not token owner");
        return super.ownerOf(tokenId);
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    // Необходимые переопределения
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}