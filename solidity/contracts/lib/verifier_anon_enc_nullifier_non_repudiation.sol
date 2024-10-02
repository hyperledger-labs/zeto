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

contract Groth16Verifier_AnonEncNullifierNonRepudiation {
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

    
    uint256 constant IC0x = 8057537538640622222416842419905762659147748243137900544099061706952707594111;
    uint256 constant IC0y = 8731981744072173739134934379536464047347956448625887529218395527245367273442;
    
    uint256 constant IC1x = 13250391499801206058752325385748725651438580685948497755705985174286533588176;
    uint256 constant IC1y = 17376470924583594134721848963606099909955670274886726224341736312004090778629;
    
    uint256 constant IC2x = 4137078207367155783079430878165837975928656616188358222976908119972289100967;
    uint256 constant IC2y = 7570425245107981847428823663996045482214847700032537926709137463962373297602;
    
    uint256 constant IC3x = 21875113754814476717668388767642541716892288132274022391202777610333680464764;
    uint256 constant IC3y = 12358447610442788224082654939901986616533104883915337902865169052070517094957;
    
    uint256 constant IC4x = 19543922092817287680456874357828139195532654968788246826589202752488873066566;
    uint256 constant IC4y = 3949253493376987346277103901185964169916249223261456862684099340595712357824;
    
    uint256 constant IC5x = 18181183110903921590699007561097924430913394008585648794852924143528933317932;
    uint256 constant IC5y = 7711997087094892385912414244603757930043066139296400501341180882618675044246;
    
    uint256 constant IC6x = 7137240539141442440306085053950553675579764927177162142043064175086488616780;
    uint256 constant IC6y = 13363847928672326829000387655005462347075172449243251119285639834404359501314;
    
    uint256 constant IC7x = 20400880282477659913345317263705469474333828382164139098386218289000985798631;
    uint256 constant IC7y = 763738122430876330371552476723707061095772018063988184775433489234424052612;
    
    uint256 constant IC8x = 4166322176734392072842315361421643372713101222189854399845407462320580945822;
    uint256 constant IC8y = 16072436503992646710546099300833223000623825738116507083014812241765619517875;
    
    uint256 constant IC9x = 7833725746847772776634744179268022000383759178460763840791500002087723139959;
    uint256 constant IC9y = 8720331182270406067524683394619402841532011768113389600538851900450934116244;
    
    uint256 constant IC10x = 7280060257745141941819875132568570724442349310306473121796057502123483619837;
    uint256 constant IC10y = 6157960360053732092509642253477838513518372592938360299331275658930593155992;
    
    uint256 constant IC11x = 4147125947775185370048279958510311467897346628909911162589227793729272699941;
    uint256 constant IC11y = 6385255516740552331279616186006407767930976562596172178800449481815679614189;
    
    uint256 constant IC12x = 19512803346925299194089641114698441080391067211653901079526218381910339362615;
    uint256 constant IC12y = 1077393081416496492374337174355906633090027938414245040846552073346429490004;
    
    uint256 constant IC13x = 8288309408330054258706642124434496564250798247092038321284502176065274287111;
    uint256 constant IC13y = 15774239590024844214954064732913336305140370560987618725127870868208160316000;
    
    uint256 constant IC14x = 7763864224858668678007706065940863845505863544445877259652697857428903176596;
    uint256 constant IC14y = 18292989255066937731812120268099855796553812277847905572179855877951257017601;
    
    uint256 constant IC15x = 20582272086549854424081011194499750419105220032803672952534340036444858290005;
    uint256 constant IC15y = 20268844482500338925780686491633355490444398814210728177154239785898937375496;
    
    uint256 constant IC16x = 5748393047160856405557773130679523497468090997757160771324565428255710804847;
    uint256 constant IC16y = 9464996734470477384083865916038743513254986113834694214831418118029501282513;
    
    uint256 constant IC17x = 9246205565618104342527441892676735883227622284119896042327539766513771757202;
    uint256 constant IC17y = 7187654057470465243751261967375429066647706637695188481506184754688400552256;
    
    uint256 constant IC18x = 10455404062726226538852275103735270618305762523504725899233869182243063857892;
    uint256 constant IC18y = 15517918059300133828049839803926827669133981093252379216282186241401266257106;
    
    uint256 constant IC19x = 13781805865764836090949734383455291109646254739313063778322202270505178610719;
    uint256 constant IC19y = 9002822957910944113691141310480041966388279251077131182922138764866310746713;
    
    uint256 constant IC20x = 14629587080912681942215665474406962843231080153632578489134578391948234384917;
    uint256 constant IC20y = 21808106686097193916122767901122335566291811157316898737919422793938241016546;
    
    uint256 constant IC21x = 15458646090990733073323203799822737864385159154151596332678685424418420425918;
    uint256 constant IC21y = 20359449070594312493099965412567742849787647653500202318295353190027762143564;
    
    uint256 constant IC22x = 20365589441307811528415601606888599278790688702492960299677322513209526781056;
    uint256 constant IC22y = 8605995224572415081065664334094954398042581697973971225355905086529911883496;
    
    uint256 constant IC23x = 9773510918620729430022724361175086296911938510940606450766632356578777247687;
    uint256 constant IC23y = 18392220924417089279289379557542870300445626974450017375088588516448912432947;
    
    uint256 constant IC24x = 12394317554620290098380173183959711433787736169529947043524250984119931647901;
    uint256 constant IC24y = 5954730513003767902550957708981427941847291659362695245891325167921616407393;
    
    uint256 constant IC25x = 9344483116155935090722478842314215558341324408206736944158461545892279711092;
    uint256 constant IC25y = 15977810123771960746078592838158738183755117702131086632455579237796573683261;
    
    uint256 constant IC26x = 21540423779951349572776927011475865857287597230133117454929577622460757864735;
    uint256 constant IC26y = 983205674124325573706331337505266116328986466725444047565878194955651523018;
    
    uint256 constant IC27x = 3738268915452992697603501468711653590373945891871834180066062737506839529633;
    uint256 constant IC27y = 13350967605928813139833286596664924446762134116431553239287290595160461990965;
    
    uint256 constant IC28x = 15880715580764459524149770440034460363689191149222477279742596724990156952476;
    uint256 constant IC28y = 13920684666632138498656410468121341557706020986822863920213756409596323160523;
    
    uint256 constant IC29x = 8741275422291842973138788483122014694985039241198758071551440280432629368411;
    uint256 constant IC29y = 2869672824790805893309668534807018825898201984368792567655749361464837748469;
    
    uint256 constant IC30x = 10954960864649307953546188158188183555194502885417120292979417202628775017044;
    uint256 constant IC30y = 8182360700621865929408839976584474523934429158017169686152062618186891541874;
    
    uint256 constant IC31x = 13273218044875262256464456783575476773524247410752443820505518400030695612322;
    uint256 constant IC31y = 10387476507610691933717235597861716820258047612961953162690006133386990638;
    
    uint256 constant IC32x = 16552876838752962003299213508027232691202796779255527364177740353755993125446;
    uint256 constant IC32y = 19357411399326439227805433938647951397066922097652071065227301312334948320287;
    
    uint256 constant IC33x = 4128603196778452665350779980852390500008719336175099687613529178840682261522;
    uint256 constant IC33y = 11406474965025065501393523817421409021371000580693836259572627358610624875352;
    
    uint256 constant IC34x = 4678386423393258668536460102234876985486640647220281736104506526514272827829;
    uint256 constant IC34y = 3697705148227107432461547780846151198382979667185773502461490419125913561334;
    
    uint256 constant IC35x = 17180456370675229549227047775199150143955525246378786394260153405900240729964;
    uint256 constant IC35y = 15567888362324569160588361337798916873071625105048435214001594968701253855975;
    
    uint256 constant IC36x = 2073635269098804184389993890844562692137535644326662953482800651583784760087;
    uint256 constant IC36y = 20671782324713030553032672627143393683592164401889452812172378477284127169433;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[36] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                

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
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
