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

contract Groth16Verifier_CheckNullifierValueBatch {
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

    
    uint256 constant IC0x = 11332262655457564488215352194263941940249209328623124797393919256476590972862;
    uint256 constant IC0y = 4900880651391780606336256601053557828390770262532918224586781153427378547477;
    
    uint256 constant IC1x = 19764974095674511560923287907127523150479355145780561208635140699348386214188;
    uint256 constant IC1y = 17536120915643984432351384491688090328877096865896996929244000025273419951311;
    
    uint256 constant IC2x = 5862785380913709201569576321806315831598079242322585366849667558813158467226;
    uint256 constant IC2y = 7176431903440258728881149127393026388839961578517526943322352403456753929543;
    
    uint256 constant IC3x = 19601866242669930681089112810893189743503554557635123534736632851812019922261;
    uint256 constant IC3y = 7229696478669038914748129287736922632548567140154168848696488073653729403012;
    
    uint256 constant IC4x = 3842701843123219048245871259893258387551961896998680218209452967593722505872;
    uint256 constant IC4y = 4414244370236867878046819529820595682756950706732256495477999839610084801559;
    
    uint256 constant IC5x = 13523532989905337665650556996036671939166207661519913956317319172290919062932;
    uint256 constant IC5y = 8659049534196593657934690960753666055885294120691833498653473149479002235431;
    
    uint256 constant IC6x = 16503061515348536031537040435367952074924216947098922976845892505795680013452;
    uint256 constant IC6y = 2590319973485803466579974747106248679041609895826484812451054625217654664369;
    
    uint256 constant IC7x = 16852410738143175293023201453119415431000330740981676385742144927722964051371;
    uint256 constant IC7y = 14730741280952430805590227736786560963580680416288028446215801992573033455393;
    
    uint256 constant IC8x = 12353857760322355073030427842075936034632144455505024951816883772481509614273;
    uint256 constant IC8y = 20004153023103783331721566880174771045943192552869180004933196394155384682592;
    
    uint256 constant IC9x = 3985090338452943970228685360585906445709572097185972606565595280311104162572;
    uint256 constant IC9y = 5072296814457654407170084856773114115102376152728165404330736617578797740898;
    
    uint256 constant IC10x = 8065880497464495069538816641425002299299026349070045025086297139538875841660;
    uint256 constant IC10y = 7634941391505082093874126190775565930485198981023614290637106077899427283258;
    
    uint256 constant IC11x = 14059912125912787846249805542843067789210373484394469361050627212862695490029;
    uint256 constant IC11y = 9110781980596716013090127749809844845409555206274486001944490667425094371968;
    
    uint256 constant IC12x = 18308387470671049265758121371006545548210054578011400378181046122608315829341;
    uint256 constant IC12y = 6584036067541894901494775112464948138972213950441793282647805506759201152310;
    
    uint256 constant IC13x = 9861441120301186407183308294644130001308440175708575647183726134031891733895;
    uint256 constant IC13y = 9978607070670422786597808110531010608629963315607365532167006095509714923354;
    
    uint256 constant IC14x = 20748342223653845270413345876318798317457146605437938206711709989519299596015;
    uint256 constant IC14y = 9131245610772098279282035940823090378873522784486866662649195784040799666562;
    
    uint256 constant IC15x = 14031089639670846946837875549470994747244435063273148894003543740960624330741;
    uint256 constant IC15y = 4306219088861679414126214077542902025145618292982544695729676778145721285636;
    
    uint256 constant IC16x = 2769852039634326825876357013965975482038063214744632352558176145395177582986;
    uint256 constant IC16y = 17293718424260149429332707823461490446131047056346552367454939830999995689810;
    
    uint256 constant IC17x = 18928430312906036443881890498807964700665356899959064573418618875675282944461;
    uint256 constant IC17y = 21068626857657091741528559750741149708936240504177106087865279231403661389929;
    
    uint256 constant IC18x = 12757617453367508347053333332646859574198171490460390112327169995775597991534;
    uint256 constant IC18y = 17377240265716167554220072709133750271741708447351041298794588819709338674159;
    
    uint256 constant IC19x = 1888001506248988313143395598400467721812882721120368269401349801819330717172;
    uint256 constant IC19y = 1395886082412535800597604228407431388907461598711527207281347491300615884495;
    
    uint256 constant IC20x = 18043400030696868162476381940210335886935248784307972055789448396741996126667;
    uint256 constant IC20y = 17686628380575800965498850373365234336161593937196869259542653293051408185988;
    
    uint256 constant IC21x = 9265988206741312573612001783264787547913985645850125326230310896343722354314;
    uint256 constant IC21y = 6830049788135298888417065481411071101207083933360285369351972409750760387174;
    
    uint256 constant IC22x = 14216941408774843437720093305572230365011189853993453546069176827983160967597;
    uint256 constant IC22y = 11223923790481299954099192811839949196639893528082798946591557600404880623659;
    
    uint256 constant IC23x = 7828825250567961932377425131615925660642586675407421691734481138952914491575;
    uint256 constant IC23y = 20680934470258301810835562635111614279835182202130353226085715129345125470259;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[23] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                

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
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
