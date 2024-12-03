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

contract Groth16Verifier_AnonEncNullifier {
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

    
    uint256 constant IC0x = 19876750659126084648781916267169952039898085452793506656455360629047775833084;
    uint256 constant IC0y = 10157630826254470353592493547211159375103615251420332486004982741410889391859;
    
    uint256 constant IC1x = 1006419871379194227645853228058342790633803257715100685836501427758792979718;
    uint256 constant IC1y = 13679553887979892686379890265371954685898253143000822089264094714043237252505;
    
    uint256 constant IC2x = 3715728704259722993638903237986848760512440720041106088435520362949498063590;
    uint256 constant IC2y = 8391552203277376498738529495525939133072398798850813999514972446995794089460;
    
    uint256 constant IC3x = 5031826911441025949291520009973483009524287753952139587396797636282286891244;
    uint256 constant IC3y = 20579087454021924361114885033880187179171289198562214730578278826911706970910;
    
    uint256 constant IC4x = 15815995414752784966273617997528858494841241711794753514570134184286924819262;
    uint256 constant IC4y = 11375983276465989338201518952970544302185922017641036134919019359457487991111;
    
    uint256 constant IC5x = 7518674256187085253307353359020854137408714360645900035693036183007512483329;
    uint256 constant IC5y = 11995938012397982601418225280628342446621544366858946027840346934499404102632;
    
    uint256 constant IC6x = 15267374712417307293040940994030902104959977118650909337663099566364626518072;
    uint256 constant IC6y = 5530990323343555014269262862257996754924002498968209622354556585950187481843;
    
    uint256 constant IC7x = 21023255143348233142500714355446951501540115801774857194977224041618458264188;
    uint256 constant IC7y = 472927785540481717106345971778958190234217026786776559831791237013589093735;
    
    uint256 constant IC8x = 17825919756494338352176536684358621929760494758008587254717725749503135478308;
    uint256 constant IC8y = 17068224520116873027698813365878576588002459283548668758602176285663561662029;
    
    uint256 constant IC9x = 9288340017635717823974105519466830937027590535672869512830371680650438882883;
    uint256 constant IC9y = 13498219009840384105182320344308054758257473214160879680243446950578858396027;
    
    uint256 constant IC10x = 10825805175323743955259462349719064635903791539136337995876363102780409208827;
    uint256 constant IC10y = 1115504305836721936075079105116529305538449162664295634073062821015745088090;
    
    uint256 constant IC11x = 11669813518107266838225949957024795758089449338058567689706264445951118380514;
    uint256 constant IC11y = 19311572555190098865151809991755342479851287912918808422593052690140358084385;
    
    uint256 constant IC12x = 21683312098808000171240657259566619722289832612554258742888436811569815040989;
    uint256 constant IC12y = 13777530128943642245662042630547869743512576001282756663023877807803685507403;
    
    uint256 constant IC13x = 20156597179843111967026721274386866765737696155720692112461739507711012810100;
    uint256 constant IC13y = 10907371635030104915567475668490816721583549559437093210216617280595829192040;
    
    uint256 constant IC14x = 4692594447702510658546900259188561388604882931717359330989201667570735328686;
    uint256 constant IC14y = 1284708522029385151074943772571615337152095962882580914473267923470779211000;
    
    uint256 constant IC15x = 4409581048357818185214443303715108952889625783089488762783573602156065109832;
    uint256 constant IC15y = 11439409580504544242238613785228385917166255947401354456819136268098590113178;
    
    uint256 constant IC16x = 10083443781280644917399985313779247136250342774052861677887555888187879416054;
    uint256 constant IC16y = 20118894154839101543157744291472024541467090297460046537117806913364727496094;
    
    uint256 constant IC17x = 557787694688969716784460976822327229535335668870777823826839775158554547824;
    uint256 constant IC17y = 758367154990127281411051038369275611551408244159114882061221660753636478055;
    
    uint256 constant IC18x = 4926367635472940276029209160780064453495162488033051992210935046978208551129;
    uint256 constant IC18y = 17450687001922454375745873524743702054821633833645906243064145565845267231029;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[18] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
