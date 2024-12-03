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

    
    uint256 constant IC0x = 14690425847737190490600050249813402456279799734650269027145261462844549991465;
    uint256 constant IC0y = 12355943016630694158348917747022006615202524659576950063254060333880897276360;
    
    uint256 constant IC1x = 973439626785668747061763033956563519440367005580176127380508848086894487413;
    uint256 constant IC1y = 15850514111119225793921755949261914011395006749480680308104108837250267282650;
    
    uint256 constant IC2x = 13155203050208195669156695648367713267389515134402590760248478617517686577972;
    uint256 constant IC2y = 20554844102160961562430053654277490524644994265293579484955811514772946178683;
    
    uint256 constant IC3x = 7387613039317590804009988013164857047469017666985496797462802705836796224199;
    uint256 constant IC3y = 7642394480405587447429853848799417236467104932175882049313138856438235924485;
    
    uint256 constant IC4x = 5312683905205363022462369392552008345825622357130101809067078816353415269757;
    uint256 constant IC4y = 14195412313555196958285044147142827788108766075255382554297553275404593989127;
    
    uint256 constant IC5x = 9288623343750131011592781037011999990000612499024586049986786574697554357733;
    uint256 constant IC5y = 11362006443624802817711331016260584967472494745582127886105019976867823145354;
    
    uint256 constant IC6x = 11578965381901395714203406075453776320272805420533478497669657733565305987793;
    uint256 constant IC6y = 10207336791172177164533565882598339843592087685535791920502230626224882182762;
    
    uint256 constant IC7x = 15808281792574842554259905197879576797250956578783592702638196207054415692304;
    uint256 constant IC7y = 10864196820924352020862261198905278706919705698335119502274306755004660689004;
    
    uint256 constant IC8x = 21007242079792335890065165743052917167387979047738498867462032770730808710002;
    uint256 constant IC8y = 428094048143102273316269247946342191367400687664515640929517084839224639138;
    
    uint256 constant IC9x = 3738851691266794001175198797223403425726775868750629039449393059460181722950;
    uint256 constant IC9y = 4939270018523610294481140167251229840060269577632945558071212610554537257062;
    
    uint256 constant IC10x = 1082423131062341268452908332023960162277056835086211595298432948133404783052;
    uint256 constant IC10y = 229864084259215928597335148113291835696982863337515784461446824589331628888;
    
    uint256 constant IC11x = 1341317534311890495862806725095733861559086694392409351535133016567521581300;
    uint256 constant IC11y = 15929087499972165447491837803548880552123398466833064130010491028076445776831;
    
    uint256 constant IC12x = 16483540421158004886702412011005278690315166478274709687432472246282659415995;
    uint256 constant IC12y = 19564739241656077917367650496489160194296949649697248375163415671850699328627;
    
    uint256 constant IC13x = 16104546169460564107741007286401970239350826268556769139029325575239586382698;
    uint256 constant IC13y = 13517999757390186397597605670674420190734881940683461897289604053325715836553;
    
    uint256 constant IC14x = 5353453675093419432863107854995069305147268033019719512610502047341154647830;
    uint256 constant IC14y = 3252634932089237054650711722047195033191911371039012174381950637388774057516;
    
    uint256 constant IC15x = 10857066642674603938827131152375591808325640388334826700338961056548535156531;
    uint256 constant IC15y = 6543347057749764408058890158655489700352531787298568537495865248965746262053;
    
    uint256 constant IC16x = 5554695372166954876322098202748619376439653430027691495614539440724382377225;
    uint256 constant IC16y = 12824754595919557394401232006722068103218385747303769220848114775762248656114;
    
    uint256 constant IC17x = 2897194952360748964001216023312869631418699951253972532284970980501560310284;
    uint256 constant IC17y = 17869432893494988290097519261337840470629337589566014523017404245207234666653;
    
    uint256 constant IC18x = 1877445382493035121296381810528414270692189580836525490558367440493138548254;
    uint256 constant IC18y = 9302698438617044942198763308107474165630382718709126154778797907945709504422;
    
    uint256 constant IC19x = 12719638026257757169103735364490395527920872538259246035205426207516439117186;
    uint256 constant IC19y = 15659847361301868818525762703953196476523328902107738173324073752615684359466;
    
    uint256 constant IC20x = 21379260891305341512198597450588670395584255109028387829669698539335326839399;
    uint256 constant IC20y = 17722834605715418760616536025948138190765108727399536971614174237326172494252;
    
    uint256 constant IC21x = 4938717796933361424513195707162235071113768980929136385813547798734552041205;
    uint256 constant IC21y = 3117258020212823158357400262823825559154139599011927310689753352783945664762;
    
    uint256 constant IC22x = 20407280859881149731270203000708436098839340720789188118741495262693344235848;
    uint256 constant IC22y = 8116406100602395577318380789343563839030476181735774007770067063140002361239;
    
    uint256 constant IC23x = 8394416751860763835715540777793815552800805927981961817300267287832845564153;
    uint256 constant IC23y = 20602001104727375343732975807642593092086912579174726400547925692479336382280;
    
    uint256 constant IC24x = 3807389008641049643153457068711041475953442325051941994946756771009815070746;
    uint256 constant IC24y = 17238922584425250182361555037290613213557480732552513226535537244934379444094;
    
    uint256 constant IC25x = 9512884880721072336763991784432320781570665332909354721898443957947318440113;
    uint256 constant IC25y = 3228978241035529797350196821091339457671005447319564922021800553842067740684;
    
    uint256 constant IC26x = 7431465475683419725459015250386300451327128713538171557994539840682629851856;
    uint256 constant IC26y = 12442479355705915307933125864371393083910309134935925393653030404790229633619;
    
    uint256 constant IC27x = 10156016800424647673552003993687020229906070700081453017445343460249018650881;
    uint256 constant IC27y = 4518851793924376352110648082167183190010585298730345169476637640855632518146;
    
    uint256 constant IC28x = 15892549484204945508692176817293608064781942552954879658724896127227239668867;
    uint256 constant IC28y = 18511944036213151754591118324685592475901456447057959793385354191402442026421;
    
    uint256 constant IC29x = 8412782548750992651107079179280549637477812989063803930397021437216171679498;
    uint256 constant IC29y = 7252527078520558148796384236322319137623616461000603349054594769114760455303;
    
    uint256 constant IC30x = 16071214977548414533811649470014994518862502423293204796699102887139111597255;
    uint256 constant IC30y = 8231756121387009610914645315378989643033237103714992735838851431652342012368;
    
    uint256 constant IC31x = 20707079280093901951291875046505694374940268614290532793311819195705337262532;
    uint256 constant IC31y = 15889403409602591365301308819954060279825745787110811345161780014062126948317;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
