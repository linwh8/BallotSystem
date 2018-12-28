import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

import voting_artifacts from '../../build/contracts/Ballot.json'
import migration_artifacts from '../../build/contracts/Migrations.json'

let Voting = contract(voting_artifacts);
let Migrations = contract(migration_artifacts);

let candidates = {}
let voterInfo = {}
let candidateResult = {}
let ticketPerPerson;
let totalTicket;
let balanceTickets;
let voteToSamePersonLimit;

function calculateTickets() {
    let candidateNames = Object.keys(candidates);
    for (var i = 0; i < candidateNames.length; i++) {
        let name = candidateNames[i];
        Voting.deployed().then(function(contractInstance) {
            contractInstance.totalVotesFor.call(name).then(function(v) {
                $("#" + candidates[name]).html(v.toString());
            });
        });
    }
}

$( document ).ready(function() {
    if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from Ganarache")
        window.web3 = new Web3(web3.currentProvider);
    } else {
        window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
    }
    ticketPerPerson = 2;
    totalTicket = 100;
    balanceTickets = 100;
    voteToSamePersonLimit = 100;

    $(".a1") = totalTicket;
    $(".a2") = balanceTickets;
    $(".a3") = "";
    $(".a4") = "";
    $(".vote-btn").click(function(){
        $("#candidate"+id).value += 1;
    });
    $("#add_candidate_btn").click(function(){
        $("#candidate"+candidates.size()+"_name").value = text;
        $("#candidate-"+id).value = 0;
        candidate[id] = text;
        candidate_result = 0;
        Voting.deployed().then((contractInstance) => {
            contractInstance.allCandidates.call().then((candidateArray) => {
              for(let i=0; i < candidateArray.length; i++) {
                candidates[web3.toUtf8(candidateArray[i])] = "candidate-" + i;
              }
            });
         });
    });
    $("#add_voter_btn").click(function(){
        $("#candidate"+id).value += 1;
        voterInfo[id] = {address: address, name: name, balanceTickets: balanceTickets};
        balanceTickets -= 2;
        Voting.deployed().then((contractInstance) => {
            //查询所有候选人
            contractInstance.allCandidates.call().then((voterInfoArray) => {
              for(let i=0; i < voterInfoArray.length; i++) {
                voterInfoArray[web3.toUtf8(VoterInfo[i])] = "voter-" + i;
              }
            });
         });
    });
});