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

contract Verifier_AnonEncNullifierKyc {
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

    
    uint256 constant IC0x = 1756793878055123379168044018943396809667198960592968240590805396529528873117;
    uint256 constant IC0y = 4291079449450624785600558038291150617078688451401746923664404908017601322339;
    
    uint256 constant IC1x = 8481925476642146712888142175173488046715701960522759359876187338114732220402;
    uint256 constant IC1y = 12857924925652873553679959471248854378120885328657592788804610724817682944648;
    
    uint256 constant IC2x = 4563174662418725670035745701309462968424033742924748835096267726739052533850;
    uint256 constant IC2y = 20223658107054323243018126766587911986628772117016193666085058182946988620636;
    
    uint256 constant IC3x = 3882409934648845289559724267467551293451559840865405753808442723582076849829;
    uint256 constant IC3y = 6624616256638068976697569539689061756581509378406906646074536443072436651099;
    
    uint256 constant IC4x = 19600262003329083273501492310044155808299999897157946831045313062147476151078;
    uint256 constant IC4y = 20928864166080934218119179400043999982496551394369015407135476483689751932891;
    
    uint256 constant IC5x = 5291941321185600115200046690671775215173929473559584931701304835645113470312;
    uint256 constant IC5y = 5224297015574246347587003466060331289453175304445114699940270736394792321816;
    
    uint256 constant IC6x = 12041233158631978177523314319164934844246647636186712675092111756503016898520;
    uint256 constant IC6y = 8699650569678490411089476960397439607800888619265891116096074391985995432278;
    
    uint256 constant IC7x = 13699251434792901656145241358997431875250913834141834701076153966137734329456;
    uint256 constant IC7y = 21689687216413842940615148368423025629700180320378376926676174025887003782198;
    
    uint256 constant IC8x = 17133370363295445787362145919908764502493153288324336512516126651282259820226;
    uint256 constant IC8y = 2090085550512161532831594274693040201107568533500026171288317598484490126385;
    
    uint256 constant IC9x = 18985411607946093469144431737843800604443373003578077192806407610592228725502;
    uint256 constant IC9y = 2450482589246813744539306934062981840082015509029701045525338951682983399567;
    
    uint256 constant IC10x = 20192459924079506933356330458625454865793778560378822869473439558205113567852;
    uint256 constant IC10y = 4031636154978088018358974181760738624792010928117611872820497119456745510074;
    
    uint256 constant IC11x = 20023988085804745873319574498904451232040410334746787691821245177327840260758;
    uint256 constant IC11y = 17888126148683479994023042555468688472782979374952738510283386786510977130993;
    
    uint256 constant IC12x = 20548108131859253454679433089076063330024688895914684615748949791618771880602;
    uint256 constant IC12y = 9267672697092934078802480939291086749108891950976138625217034578584237286319;
    
    uint256 constant IC13x = 17553634357712576051481752708850406963241686788268218273761317001526226569678;
    uint256 constant IC13y = 13497713745001028608408657332671687603536186588800918250081595099572788867890;
    
    uint256 constant IC14x = 9879732966748533852121871697358557954853717947751692175033344396955604214519;
    uint256 constant IC14y = 11009259099240107068822009648173504017574841772627392276985966071114131149769;
    
    uint256 constant IC15x = 8991398416019457947729045529500319455049170200830441415392410023922665666407;
    uint256 constant IC15y = 16808001173411455809205813126187252968222605899465557823719506900565518411993;
    
    uint256 constant IC16x = 11250271367074345226689057187667299437018266462039414810131506282915491872247;
    uint256 constant IC16y = 1148696596163422804934884255805304582595259377678190732913760405905884082339;
    
    uint256 constant IC17x = 14531607385450580335333241325184466650466536872487633143534724961256234909049;
    uint256 constant IC17y = 16312692978133826432469318937643069847542454091517189556293178192278852718477;
    
    uint256 constant IC18x = 10259817857433930577762608382054488139375238883098957099051274782499987571410;
    uint256 constant IC18y = 6708479302664059454519246890926788451865980347591451403529826371907216550542;
    
    uint256 constant IC19x = 10256450496383126775190266092458464257804947518224010634382547171649791276197;
    uint256 constant IC19y = 1045753710813622727398856194754334239244492764981597247464690237380057177453;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[19] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
