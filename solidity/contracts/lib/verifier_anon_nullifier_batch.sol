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

contract Groth16Verifier_AnonNullifierBatch {
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

    
    uint256 constant IC0x = 19587821606915970862618164870263474527824624840516387050350574629332298149104;
    uint256 constant IC0y = 12516658397345478170897389273463286096192372064526437761690827507375976321954;
    
    uint256 constant IC1x = 16981621129924165151050821099922903115153021312848299676360295379100569716030;
    uint256 constant IC1y = 16136072280113831715053737019647310411579275425847449447569977633116344059329;
    
    uint256 constant IC2x = 12066061978110509089307547970524001305662299491212080327472635040271732639012;
    uint256 constant IC2y = 17510449103236216006448693381289206424553047450624918004363870355180987174165;
    
    uint256 constant IC3x = 12130609149476401549852689697813884338023869790523900760858735100930272132449;
    uint256 constant IC3y = 17800507313578546274924048514126144531868970073683804209060470744632725658810;
    
    uint256 constant IC4x = 6305854821565471964025783579108537928438604540053205844007619941386508187001;
    uint256 constant IC4y = 17361632757273560168345079617732063366500601783647831084263964978779619560080;
    
    uint256 constant IC5x = 1027305245501128982642713179116254978978361036363851191970498759003563189083;
    uint256 constant IC5y = 12545844693170743449393218917740623497170800080542702755997296210784849182795;
    
    uint256 constant IC6x = 5956345636122088290987521591263635126287793499449239362871002461202364520344;
    uint256 constant IC6y = 703290006327833885872540706766026058937841750513854249480231586103994803375;
    
    uint256 constant IC7x = 825065871960223444665328185260563082553079847634427049761622977548285426200;
    uint256 constant IC7y = 12797256227330138165169601116095976903657483792046690027315666313416937819384;
    
    uint256 constant IC8x = 7030373916777840601366172942241773730637677416014446307293816671994044907574;
    uint256 constant IC8y = 1845466669966157080218959902015651614579529630939968642923932042338973006479;
    
    uint256 constant IC9x = 8532553306246268765167521876444884767617189258276115651992424490225441989486;
    uint256 constant IC9y = 2848427766974865830629805139610849643606077825780685522004862886382522293609;
    
    uint256 constant IC10x = 6432533666444474115138656891431639523272709482301253656123362352286162299845;
    uint256 constant IC10y = 9470172584526666217580270758187396550945479099905000655644021939273811404736;
    
    uint256 constant IC11x = 4768614604548606341190313829646046453553247827909445373653907024632972024239;
    uint256 constant IC11y = 20160864221741898031928189052515195595542842578857188127167736568593502343606;
    
    uint256 constant IC12x = 9489007876212332375872989450041452476052592546497807953478852860385450706236;
    uint256 constant IC12y = 14168911504126936908387130703530724716827592189970322125888660112124190651178;
    
    uint256 constant IC13x = 704069654676268564359213364058157075821176257629275711905854874765804325979;
    uint256 constant IC13y = 12844580913162081106152311973293228038197394027679345952130534159321220015376;
    
    uint256 constant IC14x = 13552897642741968666662344412514372393692309179802594400466735291466621736363;
    uint256 constant IC14y = 21276814415453803084882659304463141726900483647803896397397113073962811353624;
    
    uint256 constant IC15x = 11234370911514868396176692789531234034514401021906955154286034689313637516195;
    uint256 constant IC15y = 18393239210794061490244141756894464721210082309051783680022690717123998536184;
    
    uint256 constant IC16x = 1801755298088264955343427365612017643044827097495997513929782501541954519187;
    uint256 constant IC16y = 6726099558951969068848667472250837367480975810359213326453222823037379393700;
    
    uint256 constant IC17x = 20379554378283953361374492640996583725146015047559821472032177602322970473764;
    uint256 constant IC17y = 1239396669518756491774791139298995169194013575244501425273448026148873175874;
    
    uint256 constant IC18x = 16009842491094353645466596594458042088802347092939596329925468597529615238316;
    uint256 constant IC18y = 1132795734450589743458042146840326078995806470800017120583065295063820547737;
    
    uint256 constant IC19x = 17974219947753223546183978297650824420677037203836680654497700002648738300424;
    uint256 constant IC19y = 6879985582234965908545924316328370330809317033354440536016137936788199353147;
    
    uint256 constant IC20x = 3558272464080940176815697615378195722021648872189350348597400269717467622800;
    uint256 constant IC20y = 8233010798013604400971081969711923627897832003090164489361391838439952098255;
    
    uint256 constant IC21x = 17499824046709803763941451091950412143548179984624079405067131622333652870134;
    uint256 constant IC21y = 11760873687084919825179257164589242271740163051214945638351507285819730921551;
    
    uint256 constant IC22x = 12442089851841614036160572255781270082025405368305196434106429696092784316210;
    uint256 constant IC22y = 8318420662338711375627449466098698740275613994793984017621210331110210947060;
    
    uint256 constant IC23x = 13772494608798483687433026966666368508406325625057684611507284835769768951806;
    uint256 constant IC23y = 8542625159871642935805647872759866697810028015676122255736621276118789213545;
    
    uint256 constant IC24x = 1847914904992150413049205424580314914199911440369356891218819190840804620817;
    uint256 constant IC24y = 8705302895321158150451557564914815426637267574325521351735312369543625172447;
    
    uint256 constant IC25x = 1015201369193666896852797874153283482080507710554065558402282342255318530461;
    uint256 constant IC25y = 13266082683105554117564203481375680130255467526636324229720176864314882876685;
    
    uint256 constant IC26x = 3514545872499504183608853311155942268371047471634215910974493208308427807162;
    uint256 constant IC26y = 9352791444564468747363251138586475523312909840779658680484496628234046487424;
    
    uint256 constant IC27x = 4085864851309578023289679055049192024671993174246083440927058258079332566910;
    uint256 constant IC27y = 2760144108066512852276993514229231371417323855390429465976428638422886874025;
    
    uint256 constant IC28x = 2457782115220767177669331863101889548298373777837472605054351813751751753668;
    uint256 constant IC28y = 9240011943142283474085019923938273212477171544191648681516746350830087634003;
    
    uint256 constant IC29x = 20873166056006531455992593386797266717489141372658475286367523383755511209413;
    uint256 constant IC29y = 18049159861531545255982229259643006253333013506770903936141022172253810766809;
    
    uint256 constant IC30x = 10716950565190260544266456862848359197500422261278466900889335081115973979688;
    uint256 constant IC30y = 7794360952812280093833806570194931537760764326939490029977449203544157172192;
    
    uint256 constant IC31x = 9927855799433500460327060816297572695834481212298801761780771856698755245235;
    uint256 constant IC31y = 15400439729157243262439858823993417903898618555759696042149069354567900531170;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[31] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                

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
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
