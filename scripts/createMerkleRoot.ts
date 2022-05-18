import { rawSnapshot } from "../data/owners";
import MerkleTree from "merkletreejs";
import { solidityKeccak256, keccak256 } from "ethers/lib/utils";

const uniqueOwners = [...new Set(rawSnapshot)];
const leaves = uniqueOwners.map((addr) =>
  solidityKeccak256(["address"], [addr])
);
const tree = new MerkleTree(leaves, keccak256, { sort: true });
const root = tree.getHexRoot();

export { root, tree };
