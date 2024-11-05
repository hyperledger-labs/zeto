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

    
    uint256 constant IC0x = 7350704524928688275292840025124065423740063008800895120525087407994752877201;
    uint256 constant IC0y = 2799126510591142173363017397720516529394924864315551143867807018421626690119;
    
    uint256 constant IC1x = 15114426819216201179872908092779017267381626760685787377067219151816946668652;
    uint256 constant IC1y = 14838074688889382104234389353861310342101008292329117062017984254049923814567;
    
    uint256 constant IC2x = 730339637320572287782154794373845462390183137415643273893913142940971480827;
    uint256 constant IC2y = 19985499776670900046058141562265498153194098786416301295749136204157143223257;
    
    uint256 constant IC3x = 9288139911866100824798052123452797946689070588016735822932030258103315149401;
    uint256 constant IC3y = 16977250707758369783496569651353493853376997801050995881185421156748434466112;
    
    uint256 constant IC4x = 21510548625929410705790577208028337997806497327590548181858615339378132408637;
    uint256 constant IC4y = 3128887610074880752216864118368626601909966489390261420893039641632285348662;
    
    uint256 constant IC5x = 2361488310513536785687009709084938913997548752815455418762779361014568173520;
    uint256 constant IC5y = 13064109709118668398319496370144322446834954821774816697768219563719250168349;
    
    uint256 constant IC6x = 21741423469437839061841808146523619080128207788113423296935124975483247508524;
    uint256 constant IC6y = 18529865771178923498390020744089890179100271666005560576880042925185095150796;
    
    uint256 constant IC7x = 11716063437444665329534450300340853360047012717360647680536852931180756322691;
    uint256 constant IC7y = 13954938730266059993129237217568930694055393902398630589007640179821232776471;
    
    uint256 constant IC8x = 18539559570765334761569967454539119188781496123683317380886819179820750135048;
    uint256 constant IC8y = 1483429005281923495773016521713883280913961201691552702249885389478804186825;
    
    uint256 constant IC9x = 20285495211995559572269870221492706959016981268896437450344735235620123723655;
    uint256 constant IC9y = 6752334852699479365814827613653118536864386885890891616534513343873157237627;
    
    uint256 constant IC10x = 499733066798987642797898596902737884227228799269010229470629826857301398382;
    uint256 constant IC10y = 15539873607166155350908234290005251689258814640931878010822879323585218295253;
    
    uint256 constant IC11x = 14930084334244027775740030172875333009547849405540674149093528597500172682264;
    uint256 constant IC11y = 16031096719063780066038712493256021950493445187501019225557322455675638312312;
    
    uint256 constant IC12x = 6930962007199462838250740922397839173312453564335400737449304292728948783789;
    uint256 constant IC12y = 16346148217738032915228412851186792388219205265009907670473983861216251226700;
    
    uint256 constant IC13x = 9287437502652310030364103755261068142532329727588192042484528210346407028717;
    uint256 constant IC13y = 10794968646463009884004236152576271915074358785469677937139140234440868974660;
    
    uint256 constant IC14x = 8642192551833486309442810432407204382142862801515472400962676449719624895869;
    uint256 constant IC14y = 4332840556069660127909924749213870708387611051261894964111742875494185381254;
    
    uint256 constant IC15x = 14067924916167871162655244922817653716539707386728077576851376753722366021529;
    uint256 constant IC15y = 14550114442576756814639260074491842266739552217696789898458344525407905929187;
    
    uint256 constant IC16x = 857685849844171065596763211033783999825532174706327764798436830629594817956;
    uint256 constant IC16y = 1806650528151069748359044935863429380424562852004122550972004167352156895294;
    
    uint256 constant IC17x = 6579597513808886576406099469755577551041805432889990719580240981271077896359;
    uint256 constant IC17y = 710420057294757587910020146667270882809600269535553928956263589284791937083;
    
    uint256 constant IC18x = 11601578039573676772840572687707180388906572122494709390061757932977931982868;
    uint256 constant IC18y = 7211311325685441076944820285599089955580368690880374995924683333150557101184;
    
    uint256 constant IC19x = 20231546290866664701331485462044304003843557412739655597831229162580880981510;
    uint256 constant IC19y = 876382137719899827148465359455799570987326687830025736167684593436185681270;
    
    uint256 constant IC20x = 14850885628527218757662473212989221130196138052975444666446471458588122224774;
    uint256 constant IC20y = 12708590969663513735666954823403671843557581713214725762521430223488205347685;
    
 
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
