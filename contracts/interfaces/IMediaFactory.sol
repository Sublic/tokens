// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

interface IMediaFactory {

  function getSubscriptionToken(bytes32 mediaId) external view returns(address);
  function addToGroup(address user, bytes32 mediaId) external;
  function mediaIds(string memory) external view returns (bytes32);
}
