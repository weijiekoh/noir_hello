pragma solidity ^0.8.17;

import "../circuits/contract/plonk_vk.sol";

contract Starter {
    UltraVerifier public verifier;

    constructor(UltraVerifier _verifier) {
        verifier = _verifier;
    }

    function verifyEqual(bytes calldata proof, bytes32[] calldata publicInputs) public view returns (bool) {
        bool proofResult = verifier.verify(proof, publicInputs);
        require(proofResult, "Proof is not valid");
        return proofResult;
    }
}
