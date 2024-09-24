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

contract Groth16Verifier_AnonEncBatch {
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

    
    uint256 constant IC0x = 7189741265667894171386648378312185912800151749367063899439033842829619018531;
    uint256 constant IC0y = 17884484227326304060547068939975681487394009815094922588370149976422726273268;
    
    uint256 constant IC1x = 6976989834931789878418842558738463271861881797006171069806563232198951042869;
    uint256 constant IC1y = 4607620418496754938241282900428029803466093854317753547452611458077967907674;
    
    uint256 constant IC2x = 1104559830706076731296654664075637185187356334768646358777598477822609389028;
    uint256 constant IC2y = 3345550768796772178044166540721073265036018491137886953153002525534815362810;
    
    uint256 constant IC3x = 7339167904292788453737629411047095669569958420885203529836108618320029225321;
    uint256 constant IC3y = 10127811846629680704572895087773581197933131108027374452597163321161722356281;
    
    uint256 constant IC4x = 17995410030890053741976076817185127523995916552402057091226681421315541788709;
    uint256 constant IC4y = 14362557177387632374616439821157396761988637853842253785476976058551274774314;
    
    uint256 constant IC5x = 13293531195867414094312058265307495428535040802030900847168051381875064849320;
    uint256 constant IC5y = 20854607687676821128519061564661683540031633583994135645214015131023213236658;
    
    uint256 constant IC6x = 3806382113870713333535697141069048771701877301218229542219146213062636519118;
    uint256 constant IC6y = 968164612680877984576678128366936845032166057358019883376362869104455951991;
    
    uint256 constant IC7x = 7414361066968300446965646463524768189839597644475453090614884170383834231467;
    uint256 constant IC7y = 18871824017586458935577810902748110232038032948171198588195313828414014642834;
    
    uint256 constant IC8x = 2681577168042166677173735754938968405641600798435441472230369938066386631441;
    uint256 constant IC8y = 20989323624899116464465781536163070510329583651379897156356229335935295115550;
    
    uint256 constant IC9x = 837988643285174883060701192686929019767214369278310628575501631534377414317;
    uint256 constant IC9y = 1497027309281778698096450532537321682620096834272532975906513350631947481246;
    
    uint256 constant IC10x = 13846091047999257285561818943917831947161925448727251083606199040901309455483;
    uint256 constant IC10y = 21140858725718514275007364686974077359947858906470399301442263017523861516462;
    
    uint256 constant IC11x = 15327736368672693106243983767532414151733383231820598039546845408367990407510;
    uint256 constant IC11y = 8978233402234246206405919493829088814272806423483168479609950953091130281624;
    
    uint256 constant IC12x = 2808000964050401522326265944234314863481085671375895951164989497843153038972;
    uint256 constant IC12y = 11531380100407111226047699879374413435547572518965709942666525827464698301031;
    
    uint256 constant IC13x = 7703837959548087219235606509992045716672614065853991067483742493093046292830;
    uint256 constant IC13y = 2855993324665746281147411571159804015907170749504611606481193074879718553646;
    
    uint256 constant IC14x = 902373741697942289280883575614240691556745280904627931982629145867494138505;
    uint256 constant IC14y = 15733161533380354744692088486161623354470279164235678485868913277212174304447;
    
    uint256 constant IC15x = 10994298705029863992028152134353022932251042831787422154933994573982689419045;
    uint256 constant IC15y = 17398965607134011589197925374325765086901718241003855850730487379127452367799;
    
    uint256 constant IC16x = 11892951991080935208554921924154615154971175142927057562324705784166460551163;
    uint256 constant IC16y = 5691008018070641581295928491484464757049108925919901219628385025776797906143;
    
    uint256 constant IC17x = 16385349760746062660392139502252187515058108917152683574075970755109588098255;
    uint256 constant IC17y = 4006132200257192648446443543123854816490277008709107776860749056319583986723;
    
    uint256 constant IC18x = 15737238506544786286259248091214287531404595722259507957910389449246442985860;
    uint256 constant IC18y = 8774257820042718930005071001419692491634003552583131904074826546903152827936;
    
    uint256 constant IC19x = 5261338761583986889127298709462187597480484617121164266844247211605815308980;
    uint256 constant IC19y = 6461699773895519123933988281435508110784080627465540530243192163198806094903;
    
    uint256 constant IC20x = 13036766766347670871820341262760106552456337170159401152071561005164842009774;
    uint256 constant IC20y = 4274612413808318257961480446591695381400369399274465055760884716846613784526;
    
    uint256 constant IC21x = 18562363328719873772558553506930699000799009500209416935448544000103659611256;
    uint256 constant IC21y = 6385384130214162329638041686219155710711521598989619892924465023706403534836;
    
    uint256 constant IC22x = 17307502141503920070248089676990085687750784085011485656505049451549390745686;
    uint256 constant IC22y = 16334791657275865216071338891586271191049672233905856090086893120335561416428;
    
    uint256 constant IC23x = 2382115653931008587031786671517514604327077298833478735209768652527387951249;
    uint256 constant IC23y = 10812017646661427158453552758883333361569252034751344876291235951652181181624;
    
    uint256 constant IC24x = 21260776816977489464621013688132612122819671246444567586980092869722567001366;
    uint256 constant IC24y = 20734284890134842035357978897812101948609357231813112868709593640153549726412;
    
    uint256 constant IC25x = 6214032079313504274522884081468353949125435329668975592674808638707721409871;
    uint256 constant IC25y = 7937870012562608748137139051862521736631851938383982008246874681096560011742;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[25] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
