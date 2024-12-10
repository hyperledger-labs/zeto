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

    
    uint256 constant IC0x = 7758301571899264877858754209612844662929165192234301276158382789434660892099;
    uint256 constant IC0y = 20632936968362880899162931340576490861576728872145653907427377112607300400193;
    
    uint256 constant IC1x = 11615633327966345713615297610659165892904591672955619465704759244989408557001;
    uint256 constant IC1y = 11186083397042268510557524401993206529996465593457554173588486016199204963108;
    
    uint256 constant IC2x = 8348765224084098251357619259739427533816923339846196710158525531859046678780;
    uint256 constant IC2y = 13275877206982799746427248891798232762186295800333350577705405457097216734459;
    
    uint256 constant IC3x = 6746129276191106098256682894727980301235667747387375602345851232220273184371;
    uint256 constant IC3y = 14163114090067731644944353946434704913998144273454075038752642892877528059742;
    
    uint256 constant IC4x = 17375983988601669407845120504503759147294838178582839613615315961449819607570;
    uint256 constant IC4y = 20608650540530367815716369390757456255847070161889545613408042418171720449928;
    
    uint256 constant IC5x = 749245697896346907446760524347394022947856349424268788233876301031650409625;
    uint256 constant IC5y = 4684890715991811318708982639949298037366574514016217005572331962357269457587;
    
    uint256 constant IC6x = 7874899580488011619193479877107427619540065860386960382786115058214736472961;
    uint256 constant IC6y = 21059542981556940483486320687985908778783940542633255975679963765277339962530;
    
    uint256 constant IC7x = 18621252523739397617877641120503087117872370301811965092932817827739479796166;
    uint256 constant IC7y = 2404706837034131897192868270261182964291037415010772829788848732084770430933;
    
    uint256 constant IC8x = 19814455545966466244689909235181383129301797961567922579961058010657327968486;
    uint256 constant IC8y = 21732937296348543826379078094630887156087124289621375908739315093071402119752;
    
    uint256 constant IC9x = 3184933453132988447670846134646492920686989562672153511835240095854316620300;
    uint256 constant IC9y = 17413345587156768674470638887481028062872057504530236831890435886323321898876;
    
    uint256 constant IC10x = 5000106956091632287751063138709579166413938917310811757141112192144129568670;
    uint256 constant IC10y = 1880348007105019492687842362718936462113830541362164189075767828637837156158;
    
    uint256 constant IC11x = 8807954911100293836538771942181421664913270197244831130761279808674931518790;
    uint256 constant IC11y = 17508285927575586166782465486539407240181248723581605802158685783096894314205;
    
    uint256 constant IC12x = 3654376290557405870314166762121655305171208827771868156654718356459126930544;
    uint256 constant IC12y = 20239761678262685978011314532733399292107569046790346152735028075018156700430;
    
    uint256 constant IC13x = 13942381491409863805481129234212748957659615129674051368293399772120904898982;
    uint256 constant IC13y = 7198633752550957979404220877302240993107152862622048009001689469103843899379;
    
    uint256 constant IC14x = 3766314971418353237905318803668630234242341545507796164075802769154870704226;
    uint256 constant IC14y = 14974832509202270872448631093591036606262174404532714792580142674109071695963;
    
    uint256 constant IC15x = 20947173756075288500532552138514879254082296280245805744255404875099965748043;
    uint256 constant IC15y = 9331697681780124201113946858352287328081503582349105929394155825802825000361;
    
    uint256 constant IC16x = 7300226697596210203589783066188655095148224146210870452762470970590113642422;
    uint256 constant IC16y = 15434827597932208119730923859852051718913724437592285448477549023216201752648;
    
    uint256 constant IC17x = 5685940285584773620760683269200203911989978110659531751061416671909138714474;
    uint256 constant IC17y = 15785546174838346980960122130367445559612201196193666672728019685818460974515;
    
    uint256 constant IC18x = 3859778659788676546935882657936598886646060245911905264500747043376967810059;
    uint256 constant IC18y = 17039854261944757383765020449971388088475800222706489689867778970566740056221;
    
    uint256 constant IC19x = 5414480314443480403627606306388852112232833717157489873490336243185795801707;
    uint256 constant IC19y = 16921562134849518673444351383039591413750914511601115431854754554128317214351;
    
    uint256 constant IC20x = 15646585249462056626437462646343781302537700830271537725821045027953668154242;
    uint256 constant IC20y = 3913813741211312494939390488791420933329920903419211488786784367298336191807;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
