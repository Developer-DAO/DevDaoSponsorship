import { ethers } from "hardhat";
import { DevDaoSponsorship__factory } from "../typechain";
import { root, tree } from "./createMerkleRoot";
import { solidityKeccak256 } from "ethers/lib/utils";

const execute = async () => {
  const signers = await ethers.getSigners();
  const DDSFactory = new DevDaoSponsorship__factory(signers[0]);
  const DDS = await DDSFactory.deploy(root);
  await DDS.deployed();

  const proofForMint = tree.getHexProof(
    solidityKeccak256(["address"], [signers[0].address])
  );

  const mintSponsor = await DDS.sponsor(signers[1].address, proofForMint);
  await mintSponsor.wait();

  const ownedToken = await DDS.ownedToken(signers[1].address);
  console.log(ownedToken);

  const expiryTime = await DDS.scholarshipExpires(ownedToken);
  console.log(expiryTime);

  const uri = await DDS.tokenURI(ownedToken);
  console.log(uri);
};

execute();
