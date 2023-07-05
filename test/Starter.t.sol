pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contract/Starter.sol";
import "../circuits/contract/plonk_vk.sol";

contract StarterTest is Test {
    Starter public starter;
    UltraVerifier public verifier;

    bytes32[] public dynamicCorrect = new bytes32[](0);
    bytes32[] public correct = new bytes32[](0);
    bytes32[] public wrong = new bytes32[](0);
    

    function setUp() public {
        verifier = new UltraVerifier();
        starter = new Starter(verifier);

        //correct[0] = bytes32(0x000000000000000000000000000000000000000000000000000000000000007b);
        //wrong[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000004);
    }

    function testVerifyProof() public {
        string memory proof = vm.readLine("./circuits/proofs/p.proof");
        bytes memory proofBytes = vm.parseBytes(proof);
        starter.verifyEqual(proofBytes, correct);
    }

    function test_dynamicProof() public {
        string[] memory _fieldNames = new string[](1);
        string[] memory _fieldValues = new string[](1);

        _fieldNames[0] = "x";
        _fieldValues[0] = "123";

        // Set expected dynamic proof outcome
        bytes memory proofBytes = generateDynamicProof("test1",_fieldNames,_fieldValues);
        starter.verifyEqual(proofBytes, dynamicCorrect);
    }

    function test_dynamicProofSecondTest() public {
        string[] memory _fieldNames = new string[](1);
        string[] memory _fieldValues = new string[](1);

        _fieldNames[0] = "x";
        _fieldValues[0] = "789";

        // Set expected dynamic proof outcome
        bytes memory proofBytes = generateDynamicProof("test2",_fieldNames,_fieldValues);
        starter.verifyEqual(proofBytes, dynamicCorrect);
    }

    /// @dev This function generates dynamic proofs using 2 scripts in the /script directory
    /// 
    /// @param _testName a random string to identify the test by, this is used to create a unique folder name in the /tmp directory
    /// @param _fields The field names within the Prover.toml file
    /// @param _fieldValues The field values associated with fields names within the Prover.toml file
    function generateDynamicProof(string memory _testName,string[] memory _fields, string[] memory _fieldValues) public returns (bytes memory) {
        require(_fields.length == _fieldValues.length,"generateProof: Input arrays not the same length");
        
        // Copy files and create Prover.toml in /tmp directory
        string[] memory filecreateCommand = new string[] (2);
        filecreateCommand[0] = "./script/createFile.sh";
        filecreateCommand[1] = _testName;
        bytes memory fileCreateResponse = vm.ffi(filecreateCommand);
        console.log(string(fileCreateResponse));
        
        string memory _file = string.concat("/tmp/",_testName,"/Prover.toml");
        vm.writeFile(_file,"");
        for(uint256 i; i < _fields.length; i++)
        {
            vm.writeLine(_file, string.concat( _fields[i] , " = " , _fieldValues[i]));
        }

        // now generate the proof by calling the script using ffi
        string[] memory ffi_command = new string[] (2);
        ffi_command[0] = "./script/prove.sh";
        ffi_command[1] = _testName;
        bytes memory commandResponse = vm.ffi(ffi_command);
        console.log(string(commandResponse));
        string memory _newProof = vm.readLine(string.concat("/tmp/",_testName,"/proofs/d.proof"));
        return vm.parseBytes(_newProof);

    }
}
