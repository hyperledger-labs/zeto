// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier_BurnNullifierBatch {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant deltax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant deltay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant deltay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;

    
    uint256 constant IC0x = 11463950993074153749575049610707907209480801116862470885219165756782983817519;
    uint256 constant IC0y = 19318628081611739393252381916790599938497535416374015217150458670939974772835;
    
    uint256 constant IC1x = 2514273621792690091840549941102798338297842599480099159395005721572109843488;
    uint256 constant IC1y = 5163012941449573447942951838811571535049690420194258340383309451793915364243;
    
    uint256 constant IC2x = 11242491670602876445274432483176783532058887526565218767674873350461168772157;
    uint256 constant IC2y = 15339689062503404160920997858391174100777933161108265716557252004512626265807;
    
    uint256 constant IC3x = 20086082117230546237344565834277543698987632581100099764862328827409696364202;
    uint256 constant IC3y = 17667030720441799305581051124567395142404755115218951564757085499206300362492;
    
    uint256 constant IC4x = 3081321381050475388045347375808222505067353073775458499291356199173961199156;
    uint256 constant IC4y = 12755669645793876711824116483415049359921396971237294635869499513256828396314;
    
    uint256 constant IC5x = 2581400028816469567812375514667475393774962378888324936129079972931945853451;
    uint256 constant IC5y = 8357275568639158095453706418922594156076483004498699636619276421512633225145;
    
    uint256 constant IC6x = 15002132315091743471025653998784682757584994431602727315720472344613379366549;
    uint256 constant IC6y = 10137323688484497873114775313978942048127547097415100811891333605342146560876;
    
    uint256 constant IC7x = 12553083513573011049381104208474344831797458519755089705971363433602451099921;
    uint256 constant IC7y = 9787971502904579635367329092404472226332087790379036516298142362052250320515;
    
    uint256 constant IC8x = 17890376929412104025163408503091686275581546048219404707722986406220824007733;
    uint256 constant IC8y = 4744131411146207675967600649400130883962554961623960729120670630073759845819;
    
    uint256 constant IC9x = 7798830325105661483306239056331119335167232525414976001123362949339941115422;
    uint256 constant IC9y = 7314901152334930133102363869072038118225799785743527353001412538130257001253;
    
    uint256 constant IC10x = 16730990016576816375514004949533783631694891233318204878015072473557276794000;
    uint256 constant IC10y = 21526000906914409486900562320190325771916547371800250211559255801097772848071;
    
    uint256 constant IC11x = 17897916659362274663778126227004266273350686020784213673175172287247327194959;
    uint256 constant IC11y = 4597291684452868675889288404105200228836682628969712724266501641160233638870;
    
    uint256 constant IC12x = 4935124229744719193608990180358695041946023103274194519176564316730168753359;
    uint256 constant IC12y = 16991379752101779651043860275942079435307225593528987930330837680964695436328;
    
    uint256 constant IC13x = 3578325436671275171991706908325498296788409559974034404654874574274289542361;
    uint256 constant IC13y = 5750505547982065686812310279503495129623620552718205192667816997757608052772;
    
    uint256 constant IC14x = 2690447567962162881419213676842655059046472982061538428942690560794872170218;
    uint256 constant IC14y = 18785508530929105180161355794238072736906979885265661602177863383232323554875;
    
    uint256 constant IC15x = 16035298354228007724380135288348268828053441823060842063629932192050558165204;
    uint256 constant IC15y = 13787203970508773909005263834502377763988856008600149998318609396245056012155;
    
    uint256 constant IC16x = 13641824043647747730704473087324889318259286212057852916821683830261507664275;
    uint256 constant IC16y = 4008622039704915824788368579427326040348109987981208247936621878420087766691;
    
    uint256 constant IC17x = 1947919100515543204795352485791800855783719749316258235811867163762302004490;
    uint256 constant IC17y = 18320511897929218827903214514465560401411015375076732679783232179256518247755;
    
    uint256 constant IC18x = 21207754012072393720989935140241648519791091954114870672285912937029960931966;
    uint256 constant IC18y = 9586805356915801782151693279898898546766601830384211147282400925529332276007;
    
    uint256 constant IC19x = 15910485925631319510465883987253295734632370093247716472352841201021447520827;
    uint256 constant IC19y = 14457740473470702028396423358554856687614884125469912583561779145571030249227;
    
    uint256 constant IC20x = 20626409191341394498541474339123381232951326013373130112999970968168512668769;
    uint256 constant IC20y = 4134852425623161645597203532731290210648550668860870549500192716665346667686;
    
    uint256 constant IC21x = 6799489586390146255335698298045616080225596527090201397922767147253181675479;
    uint256 constant IC21y = 2670765047977856263832823642890660342089364945255856716385340213340077386928;
    
    uint256 constant IC22x = 8286143196511372726575446676857839257770072524577171556412325183797222223456;
    uint256 constant IC22y = 7982655480235258236618720431077996960631463769336956037595032709956985916162;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[22] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
