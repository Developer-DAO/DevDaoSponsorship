pragma solidity 0.8.4;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./MerkleProof.sol";
import "./Base64.sol";

contract DevDaoSponsorship is Ownable, ERC721 {

    bytes32 public CURRENT_MERKLE_ROOT;
    uint256 public SCHOLARSHIP_TIME = 5184000; //60 days in seconds
    mapping(uint256 => uint256) public scholarshipExpires;
    mapping(address => uint256) public sponsorTimeLock;
    mapping(uint256 => address) public sponsoredBy;
    mapping(address => uint256) public ownedToken;
    uint256 public currentTokenId;

    constructor (bytes32 _merkleRoot) ERC721("DevDaoSponsorship", "DDS") {
        CURRENT_MERKLE_ROOT = _merkleRoot;
    }

    function sponsor(address _receiver, bytes32[] calldata _proof) external {
        require(block.timestamp > sponsorTimeLock[msg.sender], "DDS: Still on cooldown for sponsorship");
        require(block.timestamp > scholarshipExpires[ownedToken[_receiver]], "DDS: receiver already has active sponsorship");
        (bool valid, ) = MerkleProof.verify(_proof, CURRENT_MERKLE_ROOT, keccak256(abi.encodePacked(msg.sender)));
        require(valid, "DDS: Not a valid sponsor");
        if (ownedToken[_receiver] == 0) {
            unchecked {
                currentTokenId++;
            }
            _safeMint(_receiver, currentTokenId);
            scholarshipExpires[currentTokenId] = block.timestamp + SCHOLARSHIP_TIME;
            sponsoredBy[currentTokenId] = msg.sender;
            ownedToken[_receiver] = currentTokenId;
            sponsorTimeLock[msg.sender] = block.timestamp + SCHOLARSHIP_TIME;
        } else {
            scholarshipExpires[ownedToken[_receiver]] = block.timestamp + SCHOLARSHIP_TIME;
            sponsoredBy[currentTokenId] = msg.sender;
            sponsorTimeLock[msg.sender] = block.timestamp + SCHOLARSHIP_TIME;
        }
    }

    function isSponsored(address _who) external view returns (bool) {
        return scholarshipExpires[ownedToken[_who]] > block.timestamp;
    }

    string[] private osses = [
        "Kali Linux",
        "Ubuntu",
        "Windows 1.0",
        "Android Marshmallow",
        "Windows 95",
        "FreeBSD",
        "Slackware Linux",
        "Chromium OS",
        "Windows Vista",
        "Google Chrome OS",
        "macOS",
        "DOS",
        "Linux Mint",
        "GM-NAA I/O"
    ];
    
    string[] private texteditors = [
        "VS Code",
        "Brackets",
        "VIM",
        "Emacs",
        "Brackets",
        "Atom",
        "Notepad++",
        "Pen & Paper",
        "Visual Studio",
        "Sand and Stick",
        "Mental Telepathy",
        "Bluefish",
        "Sublime Text",
        "Dreamweaver",
        "Coda"
    ];
    
    string[] private clothing = [
        "Black Hoodie",
        "White Tanktop",
        "Patagonia Vest",
        "Conference T",
        "Blacked Out",
        "Bulls Jersey",
        "Pink Hoodie",
        "Purple Turtleneck",
        "Bra",
        "Navy Suit",
        "Purple Dress",
        "Platinum Trenchcoat",
        "Bubble Gum Wrapper",
        "Sweat"
    ];
    
    string[] private languages = [
        "TypeScript",
        "JavaScript",
        "Python",
        "Fortran",
        "COBOL",
        "Go",
        "Rust",
        "Swift",
        "PHP",
        "Haskell",
        "Scala",
        "Dart",
        "Java",
        "Julia",
        "C",
        "Kotlin",
        "Velato",
        "ArnoldC",
        "Shakespeare",
        "Piet",
        "Brainfuck",
        "Chicken",
        "Legit",
        "Whitespace"
    ];
    
    string[] private industries = [
        "Government",
        "Black Hat",
        "White Hat",
        "Nonprofit",
        "Money Laundering",
        "Crypto",
        "FAANG",
        "AI Startup",
        "VR",
        "Traveling Consultant",
        "Undercover",
        "Farming",
        "Environmental",
        "Hollywood",
        "Influencer"
    ];
    
    string[] private locations = [
        "Bucharest",
        "Hong Kong",
        "Jackson",
        "Budapest",
        "Sao Palo",
        "Lagos",
        "Omaha",
        "Gold Coast",
        "Paris",
        "Tokyo",
        "Shenzhen",
        "Saint Petersburg",
        "Buenos Aires",
        "Kisumu",
        "Ramallah",
        "Goa",
        "London",
        "Pyongyang"
    ];
    
    string[] private minds = [
        "Abstract",
        "Analytical",
        "Creative",
        "Concrete",
        "Critical",
        "Convergent",
        "Divergent",
        "Anarchist"
    ];
    
    string[] private vibes = [
        "Optimist",
        "Cosmic",
        "Chill",
        "Hyper",
        "Kind",
        "Hater",
        "Phobia",
        "Generous",
        "JonGold"
    ];

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getOS(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "OS", osses);
    }
    
    function getTextEditor(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "TEXTEDITOR", texteditors);
    }
    
    function getClothing(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "CLOTHING", clothing);
    }
    
    function getLanguage(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "LANGUAGE", languages);
    }

    function getIndustry(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "INDUSTRY", industries);
    }
    
    function getLocation(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "LOCATION", locations);
    }
    
    function getMind(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "MIND", minds);
    }
    
    function getVibe(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "VIBE", vibes);
    }
    
    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        require(from == address(0), "DDS: Cannot transfer sponsorship tokens");
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
        CURRENT_MERKLE_ROOT = _merkleRoot;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[21] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="white" /><text x="10" y="20" class="base">';
        parts[1] = 'DEV DAO SPONSORSHIP';
        parts[2] = '</text><text x="10" y="40" class="base">';
        parts[3] = getOS(tokenId);
        parts[4] = '</text><text x="10" y="60" class="base">';
        parts[5] = getTextEditor(tokenId);
        parts[6] = '</text><text x="10" y="80" class="base">';
        parts[7] = getClothing(tokenId);
        parts[8] = '</text><text x="10" y="100" class="base">';
        parts[9] = getLanguage(tokenId);
        parts[10] = '</text><text x="10" y="120" class="base">';
        parts[11] = getIndustry(tokenId);
        parts[12] = '</text><text x="10" y="140" class="base">';
        parts[13] = getLocation(tokenId);
        parts[14] = '</text><text x="10" y="160" class="base">';
        parts[15] = getMind(tokenId);
        parts[16] = '</text><text x="10" y="180" class="base">';
        parts[17] = getVibe(tokenId);
        parts[18] = '</text><text x="10" y="200" class="base">';
        parts[19] = string(abi.encodePacked("Scholarship Expires: ", toString(scholarshipExpires[tokenId])));
        parts[20] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8], parts[9]));
        output = string(abi.encodePacked(output, parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16], parts[17], parts[18], parts[19], parts[20]));
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Dev Sponsorship #', toString(tokenId), '", "description": "A sponorship token for entry into Developer DAO! ", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output; 
    }

}