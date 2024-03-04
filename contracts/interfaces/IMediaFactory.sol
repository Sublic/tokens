// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

interface IMediaFactory {
  function addToGroup(address user, bytes32 mediaId) external;
  function mediaIds(string memory) external view returns (bytes32);
  function mediaTokens(string memory) external view returns (address);
}
