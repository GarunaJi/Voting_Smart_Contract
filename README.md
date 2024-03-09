# Voting_Smart_Contract
This repository contains a Solidity smart contract for conducting electronic voting. The contract is designed to be deployed on a blockchain network, providing a transparent and tamper-proof platform for organizing elections


Features ✨
Candidate Registration: Candidates can register themselves by providing their details such as name, party affiliation, age, and gender. Duplicate registrations are prevented.
Voter Registration: Eligible voters can register by providing their name, age, and gender. Each voter is assigned a unique voter ID.
Voting Process: Registered voters can cast their votes for their preferred candidate. Once a vote is cast, it cannot be changed.
Voting Time Management: The contract allows the election commissioner to set the start and end times for voting. Once the voting period ends, the results can be viewed.
Emergency Stop: The election commissioner has the authority to stop the voting process in case of emergencies.
Usage 🚀
Deploy the smart contract on a compatible blockchain network.
Candidates and voters register using the provided functions.
The election commissioner sets the voting time using the voteTime function.
Voters cast their votes using the vote function during the specified voting period.
The election commissioner can view the voting status and declare the election results using the votingStatus and result functions respectively.
In case of emergencies, the commissioner can stop the voting process using the emergency function.
