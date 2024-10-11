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

contract Groth16Verifier_AnonBatch {
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

    
    uint256 constant IC0x = 5861890033538026212667750668572473120788004819983455742285567105342353828661;
    uint256 constant IC0y = 14554943693784272414673670067771585529532330995100148763403115114448877035365;
    
    uint256 constant IC1x = 4739729125948578143112487239601694156755949850082652619305531308271151884771;
    uint256 constant IC1y = 17749371344655824264585964787550860034959402409108396453133976804583835130552;
    
    uint256 constant IC2x = 14013416492351286258930685726812465840700541217811991086500109772059195611474;
    uint256 constant IC2y = 17341037787926101776428292785405504332612709297224939583579473367142427226146;
    
    uint256 constant IC3x = 16336125231474892941667849003611054653113378791694063869451412356483463985561;
    uint256 constant IC3y = 16709372045210908645558210606323811804038958109984713200681465725462349228313;
    
    uint256 constant IC4x = 1350933976763269071586957867294447937413800700092037844783181601781418103174;
    uint256 constant IC4y = 20750311635827819546297608986632539297126216889087963597245665338649882002531;
    
    uint256 constant IC5x = 18501231329275950544200822436029438898273816039878357368580284740930603918349;
    uint256 constant IC5y = 16510519818898985288434662540928597848930750415753674143154410631185500112194;
    
    uint256 constant IC6x = 427412941873824848381412611056494125871790409703845220166618687524391209220;
    uint256 constant IC6y = 10167070060121087105778748574545912745978987835036254100788097410173501412000;
    
    uint256 constant IC7x = 21680316401697530387659464976920243382540489663483955131578556609062302835516;
    uint256 constant IC7y = 2771032069976544571540203366171061199405282280032342847790829625616631647712;
    
    uint256 constant IC8x = 1589311253286323023458190860456307249957732223306580780846961205512934847218;
    uint256 constant IC8y = 15833650494813701499577469336077389128198297210161519294143908475223515119621;
    
    uint256 constant IC9x = 21638568856698830240031070255671678582986420697404695863717930104267814161320;
    uint256 constant IC9y = 6975344041422413085553707201542268576262375864550055884252037251260047316151;
    
    uint256 constant IC10x = 15566951744091774571845346864625632071562245268051450620323746657341194468372;
    uint256 constant IC10y = 15914767178458871606751985281168248486865781320875596838197186668380476371625;
    
    uint256 constant IC11x = 8870987399617616621565790607227519512363052138281107719713711770259195535562;
    uint256 constant IC11y = 16576269088408263050408687625313770698422473413425428513433714723321646898172;
    
    uint256 constant IC12x = 4302631833151351458482421257465143931437663458677202329023634462155064365599;
    uint256 constant IC12y = 10473604306887315063978965617794993524128852056520678852181652265045583989925;
    
    uint256 constant IC13x = 10582158030205725561097015536549835398898162476729099047306076287629106871344;
    uint256 constant IC13y = 14682837745334444080673007316454703694306486261985003264248721319007334479744;
    
    uint256 constant IC14x = 11029547759155411999286197812647814990318800254899998378660231932754125196682;
    uint256 constant IC14y = 16084428567867324049086244023860598710803653871684454604196448361202927418469;
    
    uint256 constant IC15x = 1131984867972909408440829748802232780744768465826965195607437394686286413627;
    uint256 constant IC15y = 1027448343262935656852093908415087517053342078127862257282557746183650002095;
    
    uint256 constant IC16x = 13773651067643441656258855495261241624865695567386017806188387539831324444653;
    uint256 constant IC16y = 10099048929651180856696561584499995020406508763374700440471459482571469923244;
    
    uint256 constant IC17x = 7261522173107989025754700034160229984396817947135820259206143417601541759243;
    uint256 constant IC17y = 14197346282964216302960496946080841539639325641322779752411061233650174236593;
    
    uint256 constant IC18x = 16804288461152811240273272526375896569268609716294064392984996572956810172145;
    uint256 constant IC18y = 4263264235883275783920963131811238561265613954374210889318327987454695983008;
    
    uint256 constant IC19x = 595455057683637626512977674120429818667714277492803563528527493388253182962;
    uint256 constant IC19y = 6206917820423018505484295069638549645856906308850248630512399872229440772926;
    
    uint256 constant IC20x = 11593280811993289290352475831100253791227442039341254544883515411103749159202;
    uint256 constant IC20y = 19908836799588537779624973978158215794141858934866399503207571702467035492203;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[20] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
