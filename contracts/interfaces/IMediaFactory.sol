// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

interface IMediaFactory {

  struct MediaElementResourceSet {
        bytes32 id;
        address owner;
        address[] initialAuthors;
        address token;
        uint256 bucketId;
        uint256 subcribersGroupId;
        uint256 authorsGroupId;
        uint256 unspentEth;
        bool isBucketIdSet;
        bool isSubscribersGroupIdSet;
        bool isAuthorsGroupIdSetSet;
        bool isAuthorsAddedToGroup;
    }

  function resources(bytes32 mediaId) external view returns (MediaElementResourceSet memory);

  function addToGroup(address user, bytes32 mediaId) external;
  function mediaIds(string memory) external view returns (bytes32);
}
